//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "CoupledAnisotropicInterfaceEnergy.h"

registerMooseObject("PhaseFieldApp", CoupledAnisotropicInterfaceEnergy);

template <>
InputParameters
validParams<CoupledAnisotropicInterfaceEnergy>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("Anisotropic gradient energy Allen-Cahn Kernel Part 1");
  params.addParam<MaterialPropertyName>("mob_name", "L", "The mobility used with the kernel");
  params.addParam<MaterialPropertyName>("eps_name", "eps", "The anisotropic interface parameter");
  params.addParam<MaterialPropertyName>(
      "deps_name",
      "deps",
      "The derivative of the anisotropic interface parameter with respect to angle");
  params.addParam<MaterialPropertyName>(
      "depsdtheta_name",
      "depsdtheta",
      "The derivative of the anisotropic interface parameter with respect to angle");
  params.addParam<MaterialPropertyName>(
      "depsdgrad_op_name",
      "depsdgrad_op",
      "The derivative of the anisotropic interface parameter eps with respect to grad_op");
  params.addParam<MaterialPropertyName>(
      "ddepsdgrad_op_name", "ddepsdgrad_op", "The derivative of deps with respect to grad_op");
  params.addParam<MaterialPropertyName>(
      "d2epsdtheta2_name", "d2epsdtheta2", "The derivative of deps with respect to grad_op");
  params.addParam<MaterialPropertyName>("ddepsdthetadgrad_op_name",
                                        "ddepsdthetadgrad_op",
                                        "The derivative of deps with respect to grad_op");
  params.addRequiredCoupledVar("v", "Coupled variable");
  params.addCoupledVar("args", "Vector of nonlinear variable arguments this object depends on");
  return params;
}

CoupledAnisotropicInterfaceEnergy::CoupledAnisotropicInterfaceEnergy(
    const InputParameters & parameters)
  : DerivativeMaterialInterface<JvarMapKernelInterface<Kernel>>(parameters),
    _v(coupledValue("v")),
    _grad_v(coupledGradient("v")),
    _v_var(coupled("v")),
    _L(getMaterialProperty<Real>("mob_name")),
    _dLdop(getMaterialPropertyDerivative<Real>("mob_name", _var.name())),
    _eps(getMaterialProperty<Real>("eps_name")),
    _deps(getMaterialProperty<Real>("deps_name")),
    _depsdtheta(getMaterialProperty<Real>("depsdtheta_name")),
    _d2epsdtheta2(getMaterialProperty<Real>("d2epsdtheta2_name")),
    _depsdgrad_op(getMaterialProperty<RealGradient>("depsdgrad_op_name")),
    _ddepsdgrad_op(getMaterialProperty<RealGradient>("ddepsdgrad_op_name")),
    _ddepsdthetadgrad_op(getMaterialProperty<RealGradient>("ddepsdthetadgrad_op_name"))
{
  // Get number of coupled variables
  unsigned int nvar = _coupled_moose_vars.size();

  // reserve space for derivatives
  _dLdarg.resize(nvar);
  _depsdarg.resize(nvar);
  _ddepsdarg.resize(nvar);
  _ddepsdthetadarg.resize(nvar);

  // Iterate over all coupled variables
  for (unsigned int i = 0; i < nvar; ++i)
  {
    const VariableName iname = _coupled_moose_vars[i]->name();
    _dLdarg[i] = &getMaterialPropertyDerivative<Real>("mob_name", iname);
    _depsdarg[i] = &getMaterialPropertyDerivative<Real>("eps_name", iname);
    _ddepsdarg[i] = &getMaterialPropertyDerivative<Real>("deps_name", iname);
    _ddepsdthetadarg[i] = &getMaterialPropertyDerivative<Real>("depsdtheta_name", iname);
  }
}

Real
CoupledAnisotropicInterfaceEnergy::computeQpResidual()
{
  // Define anisotropic interface residual
  return _eps[_qp] * _depsdtheta[_qp] * _L[_qp] * _grad_v[_qp].norm_sq() * _test[_i][_qp];
}

Real
CoupledAnisotropicInterfaceEnergy::computeQpJacobian()
{
  // Set the Jacobian
  Real jac1 = _eps[_qp] * _depsdtheta[_qp] * _dLdop[_qp] * _grad_v[_qp].norm_sq();
  Real jac2 = _depsdtheta[_qp] * _depsdtheta[_qp] * _grad_v[_qp].norm_sq();
  Real jac3 = _eps[_qp] * _d2epsdtheta2[_qp] * _grad_v[_qp].norm_sq();

  return (jac1 + _L[_qp] * (jac2 + jac3)) * _phi[_j][_qp] * _test[_i][_qp];
}

Real
CoupledAnisotropicInterfaceEnergy::computeQpOffDiagJacobian(unsigned int jvar)
{
  // get the coupled variable jvar is referring to
  const unsigned int cvar = mapJvarToCvar(jvar);

  // Set off-diagonal jaocbian terms from mobility dependence
  Real dsum = _L[_qp] * (_depsdtheta[_qp] * (*_depsdarg[cvar])[_qp] * _phi[_j][_qp] *
                         _grad_v[_qp].norm_sq() * _test[_i][_qp]);
  dsum += _L[_qp] * (_eps[_qp] * (*_ddepsdthetadarg[cvar])[_qp] * _phi[_j][_qp] *
                     _grad_v[_qp].norm_sq() * _test[_i][_qp]);
  dsum += (*_dLdarg[cvar])[_qp] * _phi[_j][_qp] * _eps[_qp] * _depsdtheta[_qp] *
          _grad_v[_qp].norm_sq() * _test[_i][_qp];

  if (jvar == _v_var)
  {
    Real depsdop_i = _depsdgrad_op[_qp] * _grad_phi[_j][_qp];
    Real ddepsdop_i = _ddepsdgrad_op[_qp] * _grad_phi[_j][_qp];

    dsum += depsdop_i * _depsdtheta[_qp] * _L[_qp] * _grad_v[_qp].norm_sq() * _test[_i][_qp];
    dsum += _eps[_qp] * ddepsdop_i * _L[_qp] * _grad_v[_qp].norm_sq() * _test[_i][_qp];

    dsum += 2 * _eps[_qp] * _depsdtheta[_qp] * _L[_qp] * _grad_v[_qp] * _grad_phi[_j][_qp] *
            _test[_i][_qp];
  }

  return dsum;
}
