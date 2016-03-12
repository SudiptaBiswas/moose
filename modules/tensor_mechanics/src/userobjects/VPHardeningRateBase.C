/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "VPHardeningRateBase.h"

template<>
InputParameters validParams<VPHardeningRateBase>()
{
  InputParameters params = validParams<DiscreteElementUserObject>();
  params.addClassDescription("Base class for computing the flow rate and hardening rate.");
  params.addParam<std::string>("base_name", "Optional parameter that allows the user to define multiple mechanics material systems on the same block, i.e. for multiple phases");
  params.addParam<std::vector<std::string> >("intvar_prop_names", "Names of internal variable property to calculate material resistance: Same as internal variable user object");
  params.addParam<std::vector<std::string> >("intvar_rate_prop_names", "Names of internal variable property to calculate plastic strain rate: Same as plastic strain rate user object");
  return params;
}

VPHardeningRateBase::VPHardeningRateBase(const InputParameters & parameters) :
    DiscreteElementUserObject(parameters),
    _base_name(isParamValid("base_name") ? getParam<std::string>("base_name") + "_" : "" ),
    _intvar_prop_names(getParam<std::vector<std::string> >(_base_name + "intvar_prop_names")),
    _intvar_rate_prop_names(getParam<std::vector<std::string> >(_base_name + "intvar_rate_prop_names"))
{
}
