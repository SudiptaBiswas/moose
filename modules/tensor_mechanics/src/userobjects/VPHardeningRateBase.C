/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "VPHardeningRateBase.h"
#include "libmesh/utility.h"

template<>
InputParameters validParams<VPHardeningRateBase>()
{
  InputParameters params = validParams<DiscreteElementUserObject>();
  params.addClassDescription("Base class for computing the flow rate and hardening rate.");
  params.addParam<std::string>("base_name", "Optional parameter that allows the user to define multiple mechanics material systems on the same block, i.e. for multiple phases");
  params.addParam<std::string>("intvar_prop_name", "Names of internal variable property to calculate material resistance: Same as internal variable user object");
  params.addParam<std::string>("intvar_rate_prop_name", "Names of internal variable property to calculate plastic strain rate: Same as plastic strain rate user object");
  params.addParam<std::string>("intvar_prop_tensor_name", "Names of internal variable property to calculate material resistance: Same as internal variable user object");
  params.addParam<std::string>("intvar_rate_prop_tensor_name", "Names of internal variable property to calculate plastic strain rate: Same as plastic strain rate user object");
  params.addParam<std::string>("strength_prop_name", "Name of strength property: Same as strength user object specified in input file");
  return params;
}

VPHardeningRateBase::VPHardeningRateBase(const InputParameters & parameters) :
    DiscreteElementUserObject(parameters),
    _base_name(isParamValid("base_name") ? getParam<std::string>("base_name") + "_" : "" ),
    _intvar_prop_name(isParamValid("intvar_prop_name") ? getParam<std::string>(_base_name + "intvar_prop_name") : ""),
    _intvar_rate_prop_name(isParamValid("intvar_rate_prop_name") ? getParam<std::string>(_base_name + "intvar_rate_prop_name") : ""),
    _intvar_prop_tensor_name(isParamValid("intvar_prop_tensor_name") ? getParam<std::string>(_base_name + "intvar_prop_tensor_name") : ""),
    _intvar_rate_prop_tensor_name(isParamValid("intvar_rate_prop_tensor_name") ? getParam<std::string>(_base_name + "intvar_rate_prop_tensor_name") : ""),
    _intvar(getMaterialPropertyByName<Real>(_base_name + _intvar_prop_name)),
    _intvar_rate(getMaterialPropertyByName<Real>(_base_name + _intvar_rate_prop_name)),
    _intvar_tensor(getMaterialPropertyByName<RankTwoTensor>(_base_name + _intvar_prop_tensor_name)),
    _intvar_rate_tensor(getMaterialPropertyByName<RankTwoTensor>(_base_name + _intvar_rate_prop_tensor_name)),
    _strength_prop_name(getParam<std::string>("strength_prop_name")),
    _strength(getMaterialPropertyByName<Real>(_strength_prop_name)),
    _pk2_prop_name(_base_name + "pk2"),
    _pk2(getMaterialPropertyByName<RankTwoTensor>(_pk2_prop_name)),
    _ce(getMaterialPropertyByName<RankTwoTensor>(_base_name + "ce"))
{
}
