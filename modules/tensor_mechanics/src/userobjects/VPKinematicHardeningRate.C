/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "VPKinematicHardeningRate.h"

template<>
InputParameters validParams<VPKinematicHardeningRate>()
{
  InputParameters params = validParams<VPHardeningRateBase>();
  params.addParam<std::string>("flow_rate_prop_name", "Name of internal variable property to calculate plastic strain rate: Same as plastic strain rate user object");
  params.addParam<Real>("hardening_multiplier", 1.0, "Material parameter used in hardening rule");
  params.addClassDescription("User Object to compute material resistance");
  return params;
}

VPKinematicHardeningRate::VPKinematicHardeningRate(const InputParameters & parameters) :
    VPHardeningRateBase(parameters),
    _intvar(getMaterialPropertyByName<std::vector<RankTwoTensor> >(_base_name + "intvar_prop_names")),
    _intvar_rate(getMaterialPropertyByName<std::vector<RankTwoTensor> >(_base_name + "intvar_prop_rate_names")),
    _flow_rate_prop_name(getParam<std::string>(_base_name + "flow_rate_prop_name")),
    _flow_rate(getMaterialPropertyByName<RankTwoTensor>(_base_name + "flow_rate_prop_name")),
    _D(getParam<Real>("hardening_multiplier"))
{
}

bool
VPKinematicHardeningRate::computeValueT(unsigned int qp, RankTwoTensor & val) const
{
  val = _flow_rate[qp] - _D * _intvar[0][qp] * _intvar_rate[1][qp];

  return true;
}

bool
VPKinematicHardeningRate::computeDerivativeT(unsigned int qp, const std::vector<std::string> & coupled_var_names, RankTwoTensor & val) const
{
  val.zero();

  for (unsigned int i=0; i<coupled_var_names.size(); ++i)
  {
    if (_intvar_prop_names[0] == coupled_var_names[i])
      val = - _D * _intvar_rate[1][qp];

    if (_intvar_rate_prop_names[1] == coupled_var_names[i])
      val = - _D * _intvar[0][qp];

    if (_flow_rate_prop_name == coupled_var_names[i])
      val.addIa(1);
  }
  return true;
}
