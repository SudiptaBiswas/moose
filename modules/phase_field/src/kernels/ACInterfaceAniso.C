//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ACInterfaceAniso.h"

registerMooseObject("PhaseFieldApp", ACInterfaceAniso);

template <>
InputParameters
validParams<ACInterfaceAniso>()
{
  InputParameters params = validParams<SusceptibilityACInterface>();
  params.addClassDescription("Anisotropic gradient energy Allen-Cahn Kernel Part 1");
  // params.addParam<Real>(
  //     "anisotropy_strength", 0.04, "Strength of the anisotropy (typically < 0.05)");
  return params;
}

ACInterfaceAniso::ACInterfaceAniso(const InputParameters & parameters)
  : SusceptibilityACInterface(parameters) //_s(getParam<Real>("anisotropy_strength"))
{
}

Real
ACInterfaceAniso::computeQpResidual()
{
  if (_grad_u[_qp].norm() > 1.0e-6)
    return SusceptibilityACInterface::computeQpResidual() / _grad_u[_qp].norm();
  else
    return 0.0;
}

Real
ACInterfaceAniso::computeQpJacobian()
{
  if (_grad_u[_qp].norm() > 1.0e-6)
    return SusceptibilityACInterface::computeQpJacobian() / _grad_u[_qp].norm() -
           SusceptibilityACInterface::computeQpResidual() * _grad_phi[_j][_qp] * _grad_u[_qp] /
               (_grad_u[_qp].norm() * _grad_u[_qp].norm() * _grad_u[_qp].norm());
  else
    return 1e-3;
}

Real
ACInterfaceAniso::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (_grad_u[_qp].norm() > 1.0e-6)
    return SusceptibilityACInterface::computeQpOffDiagJacobian(jvar) / _grad_u[_qp].norm();
  else
    return 1e-3;
}
