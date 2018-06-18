//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "SusceptibilityCoupledACInterface.h"

registerMooseObject("PhaseFieldApp", SusceptibilityCoupledACInterface);

template <>
InputParameters
validParams<SusceptibilityCoupledACInterface>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription(
      "A modified ACInterface Kernel that multiplies the ACInterface residual  "
      " by a generalized susceptibility");
  params.addRequiredParam<MaterialPropertyName>(
      "f_name", "Susceptibility function F defined in a FunctionMaterial that provides h(phi)");
  params.addRequiredCoupledVar("v", "Coupled variable");
  params.addParam<Real>("penalty", 1.0, "Penalty multiplier to the residual");
  params.addParam<MaterialPropertyName>("mob_name", "L", "The mobility used with the kernel");
  params.addCoupledVar("args", "Vector of nonlinear variable arguments this object depends on");
  return params;
}

SusceptibilityCoupledACInterface::SusceptibilityCoupledACInterface(
    const InputParameters & parameters)
  // : ACInterface(parameters),
  : DerivativeMaterialInterface<JvarMapKernelInterface<Kernel>>(parameters),
    _nvar(_coupled_moose_vars.size()),
    _v(coupledValue("v")),
    _grad_v(coupledGradient("v")),
    _v_var(coupled("v")),
    _penalty(getParam<Real>("penalty")),
    _L(getMaterialProperty<Real>("mob_name")),
    _dLdu(getMaterialPropertyDerivative<Real>("mob_name", _var.name())),
    _dChidu(getMaterialPropertyDerivative<Real>("f_name", _var.name())),
    _d2Chidu2(getMaterialPropertyDerivative<Real>("f_name", _var.name(), _var.name())),
    _d2Chidargdu(_nvar),
    _dLdarg(_nvar)
{
  // fetch derivatives
  for (unsigned int i = 0; i < _nvar; ++i)
  {
    const VariableName iname = _coupled_moose_vars[i]->name();
    _d2Chidargdu[i] = &getMaterialPropertyDerivative<Real>("f_name", iname, _var.name());
    _dLdarg[i] = &getMaterialPropertyDerivative<Real>("mob_name", iname);
  }
}

void
SusceptibilityCoupledACInterface::initialSetup()
{
  validateCoupling<Real>("f_name");
  validateCoupling<Real>("mob_name");
}

Real
SusceptibilityCoupledACInterface::computeQpResidual()
{
  return _penalty * _L[_qp] * _dChidu[_qp] * _grad_v[_qp].norm() * _test[_i][_qp];
}

Real
SusceptibilityCoupledACInterface::computeQpJacobian()
{
  return _penalty * _L[_qp] * _d2Chidu2[_qp] * _grad_v[_qp].norm() * _phi[_j][_qp] *
             _test[_i][_qp] +
         _penalty * _dLdu[_qp] * _dChidu[_qp] * _grad_v[_qp].norm() * _phi[_j][_qp] *
             _test[_i][_qp];
}

Real
SusceptibilityCoupledACInterface::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (jvar == _v_var)
  {
    Real deriv = 0.0;
    if (_grad_v[_qp].norm() > 1.0e-10)
      deriv = _grad_phi[_j][_qp] * _grad_v[_qp] / _grad_v[_qp].norm();

    return _penalty * _L[_qp] * _dChidu[_qp] * deriv * _test[_i][_qp];
  }
  else
  {
    const unsigned int cvar = mapJvarToCvar(jvar);

    return _penalty * _L[_qp] * (*_d2Chidargdu[cvar])[_qp] * _grad_v[_qp].norm() * _phi[_j][_qp] *
               _test[_i][_qp] +
           _penalty * (*_dLdarg[cvar])[_qp] * _dChidu[_qp] * _grad_v[_qp].norm() * _phi[_j][_qp] *
               _test[_i][_qp];
  }
}
