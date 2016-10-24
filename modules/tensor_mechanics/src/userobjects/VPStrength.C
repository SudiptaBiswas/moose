/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "VPStrength.h"

template<>
InputParameters validParams<VPStrength>()
{
  InputParameters params = validParams<HEVPStrengthUOBase>();
  params.addParam<MaterialPropertyName>("yield", "yield", "Yield strength");
  params.addParam<Real>("slope", "Hardening rate co-efficient");
  params.addClassDescription("User Object for linear hardening");
  return params;
}

VPStrength::VPStrength(const InputParameters & parameters) :
    HEVPStrengthUOBase(parameters),
    _yield(getMaterialProperty<Real>("yield")),
    _slope(getParam<Real>("slope")),
    _intvar_old(getMaterialPropertyOld<Real>(_intvar_prop_name))
{
}

bool
VPStrength::computeValue(unsigned int qp, Real & val) const
{
  val =  _yield[qp] + _slope * _intvar[qp];
  return true;
}

bool
VPStrength::computeDerivative(unsigned int /*qp*/, const std::string & coupled_var_name, Real & val) const
{
  val = 0;

  if (_intvar_prop_name == coupled_var_name)
    val = _slope;

  return true;
}
