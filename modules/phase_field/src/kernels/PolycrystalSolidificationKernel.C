//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "PolycrystalSolidificationKernel.h"

registerMooseObject("PhaseFieldApp", PolycrystalSolidificationKernel);

template <>
InputParameters
validParams<PolycrystalSolidificationKernel>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("Allen-Cahn Kernel that uses a DerivativeMaterial Free Energy");
  params.addRequiredParam<MaterialPropertyName>(
      "h_name", "The switching function Materials that provides h(phi)");
  params.addRequiredCoupledVar("theta",
                               "Order parameter representing individual grain orienattion");
  params.addParam<Real>("penalty", 1.0, "Penalty scaling factor");
  params.addParam<MaterialPropertyName>("mob_name", "L", "The mobility used with the kernel");
  params.addParam<MaterialPropertyName>("kappa_name", "kappa_op", "The kappa used with the kernel");
  return params;
}

PolycrystalSolidificationKernel::PolycrystalSolidificationKernel(const InputParameters & parameters)
  : DerivativeMaterialInterface<JvarMapKernelInterface<Kernel>>(parameters),
    _nvar(_coupled_moose_vars.size()),
    _theta(coupledValue("theta")),
    _grad_theta(coupledGradient("theta")),
    _theta_var(coupled("theta")),
    _penalty(getParam<Real>("penalty")),
    _L(getMaterialProperty<Real>("mob_name")),
    _kappa(getMaterialProperty<Real>("kappa_name")),
    _dhdPhi(getMaterialPropertyDerivative<Real>("h_name", _var.name())),
    _d2hdPhi2(getMaterialPropertyDerivative<Real>("h_name", _var.name(), _var.name())),
    _d2hdPhidarg(_nvar),
    _dkappadarg(_nvar)
{
  // Iterate over all coupled variables
  for (unsigned int i = 0; i < _nvar; ++i)
  {
    _d2hdPhidarg[i] =
        &getMaterialPropertyDerivative<Real>("h_name", _var.name(), _coupled_moose_vars[i]->name());
    _dkappadarg[i] =
        &getMaterialPropertyDerivative<Real>("kappa_name", _coupled_moose_vars[i]->name());
  }
}

Real
PolycrystalSolidificationKernel::computeQpResidual()
{

  return 3 / 2 * _penalty * _L[_qp] * _u[_qp] * _u[_qp] * _grad_theta[_qp] * _grad_theta[_qp] *
         _test[_i][_qp];
}

Real
PolycrystalSolidificationKernel::computeQpJacobian()
{
  return 3.0 / 2 * _penalty * _L[_qp] * _u[_qp] * _grad_theta[_qp] * _grad_theta[_qp] *
         _phi[_j][_qp] * _test[_i][_qp];
}

Real
PolycrystalSolidificationKernel::computeQpOffDiagJacobian(unsigned int jvar)
{
  const unsigned int cvar = mapJvarToCvar(jvar);

  if (cvar == _theta_var)
    return 3.0 * _penalty * _L[_qp] * _u[_qp] * _u[_qp] * _grad_theta[_qp] * _grad_phi[_j][_qp] *
           _test[_i][_qp];
  // else
  // {
  //   // get the coupled variable jvar is referring to
  //   const unsigned int cvar = mapJvarToCvar(jvar);
  //
  //   return ACBulk<Real>::computeQpOffDiagJacobian(jvar) +
  //          _L[_qp] * (*_d2hdPhidarg[cvar])[_qp] * _phi[_j][_qp] * _test[_i][_qp] *
  //              (_penalty * _grad_theta[_qp].norm() +
  //               0.5 * _kappa[_qp] * _kappa[_qp] * _grad_theta[_qp] * _grad_theta[_qp]);
  // }

  return 0.0;
}
