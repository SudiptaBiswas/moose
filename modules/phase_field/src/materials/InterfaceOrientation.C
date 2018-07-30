//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "InterfaceOrientation.h"
#include "MooseMesh.h"
#include "MathUtils.h"

registerMooseObject("PhaseFieldApp", InterfaceOrientation);

template <>
InputParameters
validParams<InterfaceOrientation>()
{
  InputParameters params = validParams<Material>();
  params.addParam<Real>(
      "anisotropy_strength", 0.04, "Strength of the anisotropy (typically < 0.05)");
  params.addParam<unsigned int>("mode_number", 6, "Mode number for anisotropy");
  params.addParam<Real>("reference_angle", 90, "Reference angle for defining anistropy in degrees");
  params.addParam<Real>("eps_bar", 0.01, "Average value of the interface parameter epsilon");
  params.addRequiredCoupledVar("op", "Order parameter defining the solid phase");
  params.addRequiredCoupledVar("orientation", "Order parameter defining the orientation");
  // params.addParam<std::vector<PostprocessorName>>(
  //     "max_orientation", "Maximum value of the order parameter defining the orientation");
  return params;
}

InterfaceOrientation::InterfaceOrientation(const InputParameters & parameters)
  : Material(parameters),
    _delta(getParam<Real>("anisotropy_strength")),
    _j(getParam<unsigned int>("mode_number")),
    _eps_bar(getParam<Real>("eps_bar")),
    _eps(declareProperty<Real>("eps")),
    _deps(declareProperty<Real>("deps")),
    _depsdtheta(declareProperty<Real>("depsdtheta")),
    _d2epsdtheta2(declareProperty<Real>("d2epsdtheta2")),
    _depsdgrad_op(declareProperty<RealGradient>("depsdgrad_op")),
    _ddepsdgrad_op(declareProperty<RealGradient>("ddepsdgrad_op")),
    _ddepsdthetadgrad_op(declareProperty<RealGradient>("ddepsdthetadgrad_op")),
    _theta_num(coupledComponents("orientation")),
    _theta(_theta_num),
    _grad_theta(_theta_num),
    _op(coupledValue("op")),
    _grad_op(coupledGradient("op"))
// _max_orientation()
{
  // this currently only works in 2D simulations
  if (_mesh.dimension() != 2)
    mooseError("InterfaceOrientation requires a two-dimensional mesh.");
  for (unsigned int i = 0; i < _theta_num; ++i)
  {
    _theta[i] = &coupledValue("orientation", i);
    _grad_theta[i] = &coupledGradient("orientation", i);
  }

  // std::vector<PostprocessorName> ppn =
  //     parameters.get<std::vector<PostprocessorName>>("max_orientation");
  // for (unsigned int i = 0; i < ppn.size(); ++i)
  //   _max_orientation.push_back(&getPostprocessorValueByName(ppn[i]));

  // if (ppn.size() != _theta_num)
  //   paramError("max_orientation",
  //              "Please provide maximum orientation value for all the orientation variables.");
}

void
InterfaceOrientation::computeQpProperties()
{
  const Real tol = 1e-8;
  const Real cutoff = 1.0 - tol;

  // cosine of the gradient orientation angle
  Real n = 0.0;
  const Real nsq = _grad_op[_qp].norm_sq();
  if (nsq > tol)
    n = _grad_op[_qp](0) / std::sqrt(nsq);

  if (n > cutoff)
    n = cutoff;

  if (n < -cutoff)
    n = -cutoff;

  const Real angle = std::acos(n) * MathUtils::sign(_grad_op[_qp](1));

  // Compute derivative of angle wrt n
  const Real dangledn = -MathUtils::sign(_grad_op[_qp](1)) / std::sqrt(1.0 - n * n);

  // Compute derivative of n with respect to grad_op
  RealGradient dndgrad_op;
  if (nsq > tol)
  {
    dndgrad_op(0) = _grad_op[_qp](1) * _grad_op[_qp](1);
    dndgrad_op(1) = -_grad_op[_qp](0) * _grad_op[_qp](1);
    dndgrad_op /= (_grad_op[_qp].norm_sq() * _grad_op[_qp].norm());
  }

  // std::vector<Real> theta0;
  // theta0.resize(_theta_num);
  Real theta0 = 0.0;
  for (unsigned int i = 0; i < _theta_num; ++i)
  {
    theta0 = std::max(theta0, abs((*_theta[i])[_qp]));
    // if (abs((*_theta[i])[_qp]) > theta0)
    //   theta0 = (*_theta[i])[_qp];

    // Real gtheta = (*_grad_theta[i])[_qp].norm_sq();
    // if (abs((*_theta[i])[_qp]) > tol)
    //   theta0 = *_max_orientation[i];
    // else
    //   temp = theta1;
  }

  // Calculate interfacial parameter epsilon and its derivatives
  _eps[_qp] = _eps_bar * (_delta * std::cos(_j * (angle - theta0 * 2 * libMesh::pi / _j)) + 1.0);
  _deps[_qp] = -_eps_bar * _delta * _j * std::sin(_j * (angle - theta0 * 2 * libMesh::pi / _j));
  _depsdtheta[_qp] = 2.0 * _eps_bar * _delta * libMesh::pi *
                     std::sin(_j * (angle - theta0 * 2 * libMesh::pi / _j));
  Real d2eps =
      -_eps_bar * _delta * _j * _j * std::cos(_j * (angle - theta0 * 2 * libMesh::pi / _j));
  Real d2epsdtheta = 2.0 * _eps_bar * _delta * libMesh::pi * _j *
                     std::cos(_j * (angle - theta0 * 2 * libMesh::pi / _j));
  _d2epsdtheta2[_qp] = 4.0 * _eps_bar * _delta * libMesh::pi * libMesh::pi *
                       std::cos(_j * (angle - theta0 * 2 * libMesh::pi / _j));

  // Compute derivatives of epsilon and its derivative wrt grad_op
  _depsdgrad_op[_qp] = _deps[_qp] * dangledn * dndgrad_op;
  _ddepsdgrad_op[_qp] = d2eps * dangledn * dndgrad_op;
  _ddepsdthetadgrad_op[_qp] = d2epsdtheta * dangledn * dndgrad_op;
}
