//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ACInterface2DMultiPhase2.h"

registerMooseObject("PhaseFieldApp", ACInterface2DMultiPhase2);

InputParameters
ACInterface2DMultiPhase2::validParams()
{
  InputParameters params = ACInterface::validParams();
  params.addClassDescription(
      "Gradient energy Allen-Cahn Kernel where the interface parameter kappa is considered.");
  params.addParam<MaterialPropertyName>("dkappadgrad_etaa_name",
                                        "dkappadgrad_etaa",
                                        "The derivative of the kappa with respect to grad_etaa");
  return params;
}

ACInterface2DMultiPhase2::ACInterface2DMultiPhase2(const InputParameters & parameters)
  : ACInterface(parameters),
    _dkappadgrad_etaa(getMaterialProperty<RealGradient>("dkappadgrad_etaa_name"))
{
}

Real
ACInterface2DMultiPhase2::computeQpJacobian()
{
  RealGradient dsum =
      (_dkappadop[_qp] * _L[_qp] + _kappa[_qp] * _dLdop[_qp]) * _phi[_j][_qp] * _grad_test[_i][_qp];

  // compute the derivative of the gradient of the mobility
  if (_variable_L)
  {
    RealGradient dgradL =
        _grad_phi[_j][_qp] * _dLdop[_qp] + _grad_u[_qp] * _phi[_j][_qp] * _d2Ldop2[_qp];

    for (unsigned int i = 0; i < _n_args; ++i)
      dgradL += (*_gradarg[i])[_qp] * _phi[_j][_qp] * (*_d2Ldargdop[i])[_qp];

    dsum += (_kappa[_qp] * dgradL + _dkappadop[_qp] * _phi[_j][_qp] * gradL()) * _test[_i][_qp];
  }

  Real jac1 = dsum * _grad_u[_qp];
  Real jac2 = nablaLPsi() * _dkappadgrad_etaa[_qp] * _grad_phi[_j][_qp] * _grad_u[_qp];
  Real jac3 = nablaLPsi() * _kappa[_qp] * _grad_phi[_j][_qp];
  return jac1 + jac2 + jac3;
}

Real
ACInterface2DMultiPhase2::computeQpOffDiagJacobian(unsigned int jvar)
{
  // get the coupled variable jvar is referring to
  const unsigned int cvar = mapJvarToCvar(jvar);

  RealGradient dsum = ((*_dkappadarg[cvar])[_qp] * _L[_qp] + _kappa[_qp] * (*_dLdarg[cvar])[_qp]) *
                      _phi[_j][_qp] * _grad_test[_i][_qp];

  // compute the derivative of the gradient of the mobility
  if (_variable_L)
  {
    RealGradient dgradL = _grad_phi[_j][_qp] * (*_dLdarg[cvar])[_qp] +
                          _grad_u[_qp] * _phi[_j][_qp] * (*_d2Ldargdop[cvar])[_qp];

    for (unsigned int i = 0; i < _n_args; ++i)
      dgradL += (*_gradarg[i])[_qp] * _phi[_j][_qp] * (*_d2Ldarg2[cvar][i])[_qp];

    dsum += (_kappa[_qp] * dgradL + (*_dkappadarg[cvar])[_qp] * _phi[_j][_qp] * gradL()) *
            _test[_i][_qp];
  }

  Real jac1 = dsum * _grad_u[_qp];
  Real jac2 = 0;
  if ((*_gradarg[cvar])[_qp].norm_sq() > 1e-8)
    jac2 = -nablaLPsi() * _dkappadgrad_etaa[_qp] * _grad_phi[_j][_qp] * _grad_u[_qp];
  return jac1 + jac2;
}
