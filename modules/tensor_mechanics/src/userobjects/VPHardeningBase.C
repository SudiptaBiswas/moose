/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "VPHardeningBase.h"

template<>
InputParameters validParams<VPHardeningBase>()
{
  InputParameters params = validParams<DiscreteElementUserObject>();
  params.addClassDescription("Base class for computing the flow rate and hardening rate.");
  params.addParam<std::string>("base_name", "Optional parameter that allows the user to define multiple mechanics material systems on the same block, i.e. for multiple phases");
  params.addParam<std::string>("intvar_rate_prop_name", "Names of internal variable property to calculate inetrnal variable rate: Same as internal variable rate user object");
  return params;
}

VPHardeningBase::VPHardeningBase(const InputParameters & parameters) :
    DiscreteElementUserObject(parameters),
    _base_name(isParamValid("base_name") ? getParam<std::string>("base_name") + "_" : "" ),
    _intvar_rate_prop_name(getParam<std::string>(_base_name + "intvar_rate_prop_name"))
{
}
