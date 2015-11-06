/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#include "ComputeGrainForceAndTorque.h"
#include "ComputeGrainCenterUserObject.h"

// libmesh includes
#include "libmesh/quadrature.h"

template<>
InputParameters validParams<ComputeGrainForceAndTorque>()
{
  InputParameters params = validParams<ShapeElementUserObject>();
  params.addClassDescription("Userobject for calculating force and torque acting on a grain");
  params.addParam<MaterialPropertyName>("force_density", "force_density", "Force density material");
  params.addParam<UserObjectName>("grain_data", "grain_data", "center of mass of grains");
  params.addCoupledVar("c", "Concentration field");
  return params;
}

ComputeGrainForceAndTorque::ComputeGrainForceAndTorque(const InputParameters & parameters) :
    ShapeElementUserObject(parameters),
    GrainForceAndTorqueInterface(),
    _c(getVar("c", 0)),
    _c_name(getVar("c", 0)->name()),
    _c_var(getVar("c", 0)->number()),
    _dF(getMaterialProperty<std::vector<RealGradient> >("force_density")),
    _dF_name(getParam<MaterialPropertyName>("force_density")),
    _dFdc(getMaterialPropertyByName<std::vector<RealGradient> >(propertyNameFirst(_dF_name, _c_name))),
    _grain_data(getUserObject<ComputeGrainCenterUserObject>("grain_data")),
    _grain_volumes(_grain_data.getGrainVolumes()),
    _grain_centers(_grain_data.getGrainCenters()),
    _ncrys(_grain_volumes.size()),
    _ncomp(6*_ncrys),
    _force_values(_ncrys),
    _torque_values(_ncrys),
    _force_derivatives(_ncrys),
    _torque_derivatives(_ncrys),
    _force_derivatives_jac(_ncrys),
    _torque_derivatives_jac(_ncrys),
    _force_torque_store(_ncomp),
    _force_torque_derivative_store(_ncomp),
    _phi(_assembly.phi()),
    _dof_indices(_c->dofIndices())
  {
  }

void
ComputeGrainForceAndTorque::initialSetup()
{
  _total_num_dofs = _subproblem.es().n_dofs();
  _force_torque_jacobian_store.resize(_ncomp*_total_num_dofs);

  for (unsigned int i=0; i<_ncrys; ++i)
  {
    _force_derivatives_jac[i].resize(_total_num_dofs);
    _torque_derivatives_jac[i].resize(_total_num_dofs);
  }
}

void
ComputeGrainForceAndTorque::initialize()
{
  std::fill(_force_torque_store.begin(), _force_torque_store.end(), 0);
  std::fill(_force_torque_derivative_store.begin(), _force_torque_derivative_store.end(), 0);
  std::fill(_force_torque_jacobian_store.begin(), _force_torque_jacobian_store.end(), 0);
}

void
ComputeGrainForceAndTorque::execute()
{
  for (unsigned int i = 0; i < _ncrys; ++i)
    for (_qp=0; _qp<_qrule->n_points(); ++_qp)
    {
      const RealGradient compute_torque = _JxW[_qp] * _coord[_qp]
                                          * (_q_point[_qp] - _grain_centers[i]).cross(_dF[_qp][i]);
      _force_torque_store[6*i+0] += _JxW[_qp] * _coord[_qp] * _dF[_qp][i](0);
      _force_torque_store[6*i+1] += _JxW[_qp] * _coord[_qp] * _dF[_qp][i](1);
      _force_torque_store[6*i+2] += _JxW[_qp] * _coord[_qp] * _dF[_qp][i](2);
      _force_torque_store[6*i+3] += compute_torque(0);
      _force_torque_store[6*i+4] += compute_torque(1);
      _force_torque_store[6*i+5] += compute_torque(2);
    }

      // executeJacobian(_c_var);
}

void
ComputeGrainForceAndTorque::executeJacobian( unsigned int jvar)
{
  if (jvar == _c_var)
  {
    // ShapeElementUserObject::requestJacobian(_c_name);

    for (unsigned int i = 0; i < _ncrys; ++i)
      for (_j=0; _j < _phi.size(); ++_j)
        for (_qp=0; _qp < _qrule->n_points(); ++_qp)
        {
          unsigned int k = _dof_indices[_j];
          const RealGradient compute_torque_derivative_c = _JxW[_qp] * _coord[_qp]
                                                           * (_q_point[_qp] - _grain_centers[i]).cross(_dFdc[_qp][i]);
          _force_torque_jacobian_store[(6*i+0)*_total_num_dofs+k] += _JxW[_qp] * _coord[_qp] * _dFdc[_qp][i](0) * _phi[_j][_qp];
          _force_torque_jacobian_store[(6*i+0)*_total_num_dofs+k] += _JxW[_qp] * _coord[_qp] * _dFdc[_qp][i](1) * _phi[_j][_qp];
          _force_torque_jacobian_store[(6*i+0)*_total_num_dofs+k] += _JxW[_qp] * _coord[_qp] * _dFdc[_qp][i](2) * _phi[_j][_qp];
          _force_torque_jacobian_store[(6*i+0)*_total_num_dofs+k] += compute_torque_derivative_c(0) * _phi[_j][_qp];
          _force_torque_jacobian_store[(6*i+0)*_total_num_dofs+k] += compute_torque_derivative_c(1) * _phi[_j][_qp];
          _force_torque_jacobian_store[(6*i+0)*_total_num_dofs+k] += compute_torque_derivative_c(2) * _phi[_j][_qp];
        }
  }
}

void
ComputeGrainForceAndTorque::finalize()
{
  gatherSum(_force_torque_store);
  gatherSum(_force_torque_derivative_store);
  gatherSum(_force_torque_jacobian_store);

  for (unsigned int i = 0; i < _ncrys; ++i)
  {
    _force_values[i](0)  = _force_torque_store[6*i+0];
    _force_values[i](1)  = _force_torque_store[6*i+1];
    _force_values[i](2)  = _force_torque_store[6*i+2];
    _torque_values[i](0) = _force_torque_store[6*i+3];
    _torque_values[i](1) = _force_torque_store[6*i+4];
    _torque_values[i](2) = _force_torque_store[6*i+5];

    _force_derivatives[i](0)  = _force_torque_derivative_store[6*i+0];
    _force_derivatives[i](1)  = _force_torque_derivative_store[6*i+1];
    _force_derivatives[i](2)  = _force_torque_derivative_store[6*i+2];
    _torque_derivatives[i](0) = _force_torque_derivative_store[6*i+3];
    _torque_derivatives[i](1) = _force_torque_derivative_store[6*i+4];
    _torque_derivatives[i](2) = _force_torque_derivative_store[6*i+5];

    for (unsigned int j=0; j < _total_num_dofs; ++j)
    {
      _force_derivatives_jac[i][j](0)  = _force_torque_jacobian_store[(6*i+0)*_total_num_dofs+j];
      _force_derivatives_jac[i][j](1)  = _force_torque_jacobian_store[(6*i+1)*_total_num_dofs+j];
      _force_derivatives_jac[i][j](2)  = _force_torque_jacobian_store[(6*i+2)*_total_num_dofs+j];
      _torque_derivatives_jac[i][j](0) = _force_torque_jacobian_store[(6*i+3)*_total_num_dofs+j];
      _torque_derivatives_jac[i][j](1) = _force_torque_jacobian_store[(6*i+4)*_total_num_dofs+j];
      _torque_derivatives_jac[i][j](2) = _force_torque_jacobian_store[(6*i+5)*_total_num_dofs+j];
    }
  }
}

void
ComputeGrainForceAndTorque::threadJoin(const UserObject & y)
{
  const ComputeGrainForceAndTorque & pps = static_cast<const ComputeGrainForceAndTorque &>(y);
  for (unsigned int i = 0; i < _ncomp; ++i)
  {
    _force_torque_store[i] += pps._force_torque_store[i];
    _force_torque_derivative_store[i] += pps._force_torque_derivative_store[i];
  }
  for (unsigned int i=0; i < (_total_num_dofs*_ncomp); ++i)
    _force_torque_jacobian_store[i] += pps._force_torque_jacobian_store[i];
}

const std::vector<RealGradient> &
ComputeGrainForceAndTorque::getForceValues() const
{
  return _force_values;
}

const std::vector<RealGradient> &
ComputeGrainForceAndTorque::getTorqueValues() const
{
  return _torque_values;
}

const std::vector<RealGradient> &
ComputeGrainForceAndTorque::getForceDerivatives() const
{
  return _force_derivatives;
}

const std::vector<RealGradient> &
ComputeGrainForceAndTorque::getTorqueDerivatives() const
{
  return _torque_derivatives;
}

const std::vector<std::vector<RealGradient> > &
ComputeGrainForceAndTorque::getForceDerivativesJacobian() const
{
  return _force_derivatives_jac;
}

const std::vector<std::vector<RealGradient> > &
ComputeGrainForceAndTorque::getTorqueDerivativesJacobian() const
{
  return _torque_derivatives_jac;
}
