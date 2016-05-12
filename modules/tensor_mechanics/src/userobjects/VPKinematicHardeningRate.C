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
  // params.addParam<UserObjectName>("cumulative_strain_rate", "Reference flow rate for rate dependent flow");
  params.addParam<Real>("hardening_multiplier", 1.0, "Material parameter used in hardening rule");
  params.addClassDescription("User Object to compute material resistance");
  return params;
}

VPKinematicHardeningRate::VPKinematicHardeningRate(const InputParameters & parameters) :
    VPHardeningRateBase(parameters),
    _flow_rate_prop_name(getParam<std::string>(_base_name + "flow_rate_prop_name")),
    _flow_rate(getMaterialPropertyByName<RankTwoTensor>(_base_name + "flow_rate_prop_name")),
    _D(getParam<Real>("hardening_multiplier"))
{
}

bool
VPKinematicHardeningRate::computeTensorValue(unsigned int qp, RankTwoTensor & val) const
{
  val = _flow_rate[qp] - _D * _intvar_tensor[qp] * _intvar_rate[qp];

  return true;
}

bool
VPKinematicHardeningRate::computeDerivative(unsigned int qp, const std::string & coupled_var_name, Real & val) const
{
  val = 0.0;
  if (_intvar_prop_tensor_name == coupled_var_name)
    val = - _D * _intvar_rate[qp];

  if (_flow_rate_prop_name == coupled_var_name)
    val = 1.0;

  return true;
}
bool
VPKinematicHardeningRate::computeTensorDerivative(unsigned int qp, const std::string & coupled_var_name, RankTwoTensor & val) const
{
  val.zero();
  if (_intvar_rate_prop_name == coupled_var_name)
    val = - _D * _intvar_tensor[qp];

  return true;
}

// bool
// VPKinematicHardeningRate::computeStressDerivativeT(unsigned int qp, RankTwoTensor & val) const
// {
//   RankTwoTensor dintvarrate_dstress, dflowrate_dstress, dintvar_dstress;
//   // deriv.zero();
//   dintvarrate_dstress.zero();
//   dflowrate_dstress.zero();
//   dintvar_dstress.zero();
//   _intvar_uo->computeStressDerivativeT(qp, dintvar_dstress);
//   _vp_strain_rate_uo->computeStressDerivativeT(qp, dintvarrate_dstress);
//   _flow_rate_uo->computeStressDerivativeT(qp, dflowrate_dstress);
//
//   val = dflowrate_dstress - _D * _intvar[0][qp] * dintvarrate_dstress
//         - _D * dintvar_dstress * _intvar_rate[1][qp];
//
//   return true;
// }
