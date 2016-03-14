/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "VPHardening.h"

template<>
InputParameters validParams<VPHardening>()
{
  InputParameters params = validParams<VPHardeningBase>();
  params.addClassDescription("User Object to compute material resistance");
  return params;
}

VPHardening::VPHardening(const InputParameters & parameters) :
    VPHardeningBase(parameters),
    _intvar_rate(getMaterialPropertyByName<Real>(_base_name + "flow_rate_prop_name")),
    _this_old(getMaterialPropertyOldByName<Real>(_name))
{
}

bool
VPHardening::computeValue(unsigned int qp, Real dt, Real & val) const
{
  val = _this_old[qp] + _intvar_rate[qp] * dt;
  return true;
}

bool
VPHardening::computeDerivative(unsigned int qp, Real dt, const std::string & coupled_var_name, Real & val) const
{
  val = 0;

  if (_intvar_rate_prop_name == coupled_var_name)
      val = dt;

  return true;
}
