//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ADCoupledSusceptibilityTimeDerivative.h"

registerMooseObject("PhaseFieldApp", ADCoupledSusceptibilityTimeDerivative);

InputParameters
ADCoupledSusceptibilityTimeDerivative::validParams()
{
  InputParameters params = ADCoupledTimeDerivative::validParams();
  params.addClassDescription("A modified coupled time derivative Kernel that multiplies the time "
                             "derivative of a coupled variable by a generalized susceptibility");
  params.addRequiredParam<MaterialPropertyName>(
      "f_name", "Susceptibility function F defined in a FunctionMaterial");
  return params;
}

ADCoupledSusceptibilityTimeDerivative::ADCoupledSusceptibilityTimeDerivative(
    const InputParameters & parameters)
  : ADCoupledTimeDerivative(parameters), _F(getADMaterialProperty<Real>("f_name"))
{
}

ADReal
ADCoupledSusceptibilityTimeDerivative::precomputeQpResidual()
{
  return _v_dot[_qp] * _F[_qp];
}
