//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "VariableCoefTimeDerivative.h"

registerMooseObject("MooseApp", VariableCoefTimeDerivative);

template <>
InputParameters
validParams<VariableCoefTimeDerivative>()
{
  InputParameters params = validParams<TimeDerivative>();
  params.addClassDescription("Time derivative Kernel adds a coupled variable as coefficient to the "
                             "time derivative.");
  params.addRequiredCoupledVar("v", "Coupled variable");
  params.addParam<Real>("coefficient", 1, "The coefficient for the time derivative kernel");
  return params;
}

VariableCoefTimeDerivative::VariableCoefTimeDerivative(const InputParameters & parameters)
  : TimeDerivative(parameters),
    _coef(getParam<Real>("coefficient")),
    _v(coupledValue("v")),
    // _dv_dot(coupledDotDu("v")),
    _v_var(coupled("v"))
{
}

Real
VariableCoefTimeDerivative::computeQpResidual()
{
  return _coef * _v[_qp] * _v[_qp] * TimeDerivative::computeQpResidual();
}

Real
VariableCoefTimeDerivative::computeQpJacobian()
{
  return _coef * _v[_qp] * _v[_qp] * TimeDerivative::computeQpJacobian();
}

Real
VariableCoefTimeDerivative::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (jvar == _v_var)
    return 2 * _coef * _v[_qp] * TimeDerivative::computeQpResidual();

  return 0.0;
}
