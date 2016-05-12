/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "VPTensorHardening.h"

template<>
InputParameters validParams<VPTensorHardening>()
{
  InputParameters params = validParams<VPHardeningBase>();
  params.addClassDescription("User Object to compute material resistance");
  return params;
}

VPTensorHardening::VPTensorHardening(const InputParameters & parameters) :
    VPHardeningBase(parameters),
    _intvar_rate(getMaterialPropertyByName<RankTwoTensor>(_intvar_rate_prop_name)),
    _this_old(getMaterialPropertyOldByName<RankTwoTensor>(_name))
{
}

bool
VPTensorHardening::computeTensorValue(unsigned int qp, Real dt, RankTwoTensor & val) const
{
  val = _this_old[qp] + _intvar_rate[qp] * dt;
  return true;
}

bool
VPTensorHardening::computeDerivative(unsigned int qp, Real dt, const std::string & coupled_var_name, Real & val) const
{
  val = 0;
  if (_intvar_rate_prop_name == coupled_var_name)
      val = dt;

  return true;
}
