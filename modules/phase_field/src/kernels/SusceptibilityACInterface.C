//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "SusceptibilityACInterface.h"

registerMooseObject("PhaseFieldApp", SusceptibilityACInterface);

template <>
InputParameters
validParams<SusceptibilityACInterface>()
{
  InputParameters params = validParams<ACInterface>();
  params.addClassDescription(
      "A modified ACInterface Kernel that multiplies the ACInterface residual  "
      " by a generalized susceptibility");
  params.addRequiredParam<MaterialPropertyName>(
      "f_name", "Susceptibility function F defined in a FunctionMaterial that provides h(phi)");
  return params;
}

SusceptibilityACInterface::SusceptibilityACInterface(const InputParameters & parameters)
  : ACInterface(parameters),
    _Chi(getMaterialProperty<Real>("f_name")),
    _dChidu(getMaterialPropertyDerivative<Real>("f_name", _var.name())),
    _dChidarg(_n_args)
{
  // fetch derivatives
  for (unsigned int i = 0; i < _n_args; ++i)
    _dChidarg[i] =
        &getMaterialPropertyDerivative<Real>("f_name", _coupled_standard_moose_vars[i]->name());
}

void
SusceptibilityACInterface::initialSetup()
{
  ACInterface::initialSetup();
  validateNonlinearCoupling<Real>("f_name");
}

Real
SusceptibilityACInterface::computeQpResidual()
{
  return _Chi[_qp] * ACInterface::computeQpResidual();
}

Real
SusceptibilityACInterface::computeQpJacobian()
{
  return ACInterface::computeQpJacobian() * _Chi[_qp] +
         ACInterface::computeQpResidual() * _dChidu[_qp] * _phi[_j][_qp];
}

Real
SusceptibilityACInterface::computeQpOffDiagJacobian(unsigned int jvar)
{
  const unsigned int cvar = mapJvarToCvar(jvar);

  Real jac1 = ACInterface::computeQpResidual() * (*_dChidarg[cvar])[_qp] * _phi[_j][_qp];
  Real jac2 = ACInterface::computeQpOffDiagJacobian(jvar) * _Chi[_qp];

  return jac1 + jac2;
}
