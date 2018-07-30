//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "HigherCoupledACInterface.h"

registerMooseObject("PhaseFieldApp", HigherCoupledACInterface);

template <>
InputParameters
validParams<HigherCoupledACInterface>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription(
      "A modified ACInterface Kernel that multiplies the ACInterface residual  "
      " by a generalized susceptibility");
  params.addRequiredParam<MaterialPropertyName>(
      "f_name", "Susceptibility function F defined in a FunctionMaterial that provides h(phi)");
  params.addRequiredCoupledVar("v", "Coupled variable");
  params.addParam<MaterialPropertyName>("mob_name", "L", "The mobility used with the kernel");
  params.addParam<MaterialPropertyName>(
      "kappa_name", "kappa_op", "The mobility used with the kernel");
  params.addCoupledVar("args", "Vector of nonlinear variable arguments this object depends on");
  return params;
}

HigherCoupledACInterface::HigherCoupledACInterface(const InputParameters & parameters)
  // : ACInterface(parameters),
  : DerivativeMaterialInterface<JvarMapKernelInterface<Kernel>>(parameters),
    _nvar(_coupled_moose_vars.size()),
    _v(coupledValue("v")),
    _grad_v(coupledGradient("v")),
    _v_var(coupled("v")),
    _L(getMaterialProperty<Real>("mob_name")),
    _kappa(getMaterialProperty<Real>("kappa_name")),
    _dLdu(getMaterialPropertyDerivative<Real>("mob_name", _var.name())),
    _dkappadu(getMaterialPropertyDerivative<Real>("kappa_name", _var.name())),
    _dChidu(getMaterialPropertyDerivative<Real>("f_name", _var.name())),
    _d2Chidu2(getMaterialPropertyDerivative<Real>("f_name", _var.name(), _var.name())),
    _d2Chidargdu(_nvar),
    _dLdarg(_nvar),
    _dkappadarg(_nvar)
{
  // fetch derivatives
  for (unsigned int i = 0; i < _nvar; ++i)
  {
    const VariableName iname = _coupled_moose_vars[i]->name();
    _d2Chidargdu[i] = &getMaterialPropertyDerivative<Real>("f_name", iname, _var.name());
    _dLdarg[i] = &getMaterialPropertyDerivative<Real>("mob_name", iname);
    _dkappadarg[i] = &getMaterialPropertyDerivative<Real>("kappa_name", iname);
  }
}

void
HigherCoupledACInterface::initialSetup()
{
  validateCoupling<Real>("f_name");
  validateCoupling<Real>("mob_name");
  validateCoupling<Real>("kappa_name");
}

Real
HigherCoupledACInterface::computeQpResidual()
{
  return 0.5 * _L[_qp] * _kappa[_qp] * _dChidu[_qp] * _grad_v[_qp].norm_sq() * _test[_i][_qp];
}

Real
HigherCoupledACInterface::computeQpJacobian()
{
  return 0.5 * _L[_qp] * _kappa[_qp] * _d2Chidu2[_qp] * _grad_v[_qp].norm_sq() * _phi[_j][_qp] *
             _test[_i][_qp] +
         0.5 * _dLdu[_qp] * _kappa[_qp] * _dChidu[_qp] * _grad_v[_qp].norm_sq() * _phi[_j][_qp] *
             _test[_i][_qp] +
         0.5 * _L[_qp] * _dkappadu[_qp] * _dChidu[_qp] * _grad_v[_qp].norm_sq() * _phi[_j][_qp] *
             _test[_i][_qp];
}

Real
HigherCoupledACInterface::computeQpOffDiagJacobian(unsigned int jvar)
{
  const unsigned int cvar = mapJvarToCvar(jvar);

  Real jac = 0.5 * _L[_qp] * _kappa[_qp] * (*_d2Chidargdu[cvar])[_qp] * _grad_v[_qp].norm_sq() *
                 _phi[_j][_qp] * _test[_i][_qp] +
             0.5 * (*_dLdarg[cvar])[_qp] * _kappa[_qp] * _dChidu[_qp] * _grad_v[_qp].norm_sq() *
                 _phi[_j][_qp] * _test[_i][_qp] +
             0.5 * _L[_qp] * (*_dkappadarg[cvar])[_qp] * _dChidu[_qp] * _grad_v[_qp].norm_sq() *
                 _phi[_j][_qp] * _test[_i][_qp];

  if (jvar == _v_var)
    jac +=
        _L[_qp] * _kappa[_qp] * _dChidu[_qp] * _grad_phi[_j][_qp] * _grad_v[_qp] * _test[_i][_qp];

  return jac;
}
