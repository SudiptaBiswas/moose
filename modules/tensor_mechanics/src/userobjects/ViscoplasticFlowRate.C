/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "ViscoplasticFlowRate.h"

template<>
InputParameters validParams<ViscoplasticFlowRate>()
{
  InputParameters params = validParams<VPHardeningRateBase>();
  params.addClassDescription("User object to evaluate power law flow rate and flow direction based on J2");
  // params.addParam<UserObjectName>("cumulative_strain_rate", "Reference flow rate for rate dependent flow");
  params.addParam<Real>("flow_rate_tol", 1e3, "Tolerance for flow rate");
  params.addParam<Real>("hardening_multiplier", 1.0, "The multiplier used in back stress calculation");
  return params;
}

ViscoplasticFlowRate::ViscoplasticFlowRate(const InputParameters & parameters) :
    VPHardeningRateBase(parameters),
    // _vp_strain_rate_uo_name(getParam<UserObjectName>("cumulative_strain_rate")),
    // _vp_strain_rate_uo(getUserObjectByName<VPHardeningRateBase>(_vp_strain_rate_uo_name)),
    _C(getParam<Real>("hardening_multiplier")),
    _flow_rate_tol(getParam<Real>("flow_rate_tol"))
{
}

bool
ViscoplasticFlowRate::computeValue(unsigned int qp, Real & val) const
{
  val = _intvar_rate[qp];

  if (val > _flow_rate_tol)
  {
#ifdef DEBUG
    RankTwoTensor back_stress = 2/3 * _C * _intvar_tensor[qp];
    RankTwoTensor sdiff = _pk2[qp] - back_stress;
    RankTwoTensor sdev = computeDeviatoricStress(sdiff, _ce[qp]);
    Real eqv_stress = computeEqvStress(sdev, _ce[qp]);

    mooseWarning("Flow rate greater than " << _flow_rate_tol << " " << val << " " << eqv_stress << " " << _strength[qp]);
#endif
    return false;
  }
  return true;
}

bool
ViscoplasticFlowRate::computeDirection(unsigned int qp, RankTwoTensor & val) const
{
  RankTwoTensor back_stress = 2/3 * _C * _intvar_tensor[qp];
  RankTwoTensor sdiff = _pk2[qp] - back_stress;
  RankTwoTensor sdev = computeDeviatoricStress(sdiff, _ce[qp]);
  Real eqv_stress = computeEqvStress(sdev, _ce[qp]);

  val.zero();
  if (eqv_stress > 0.0)
    val = 1.5/eqv_stress * _ce[qp] * sdev * _ce[qp];

  return true;
}

bool
ViscoplasticFlowRate::computeDerivative(unsigned int qp, const std::string & coupled_var_name, Real & val) const
{
  // val = 0.0;
  // if (_strength_prop_name == coupled_var_name)
  //   _vp_strain_rate_uo.computeDerivative(qp, _strength_prop_name, val);

  return true;
}

bool
ViscoplasticFlowRate::computeTensorDerivative(unsigned int qp, const std::string & coupled_var_name, RankTwoTensor & val) const
{
  // val.zero();
  // if (_pk2_prop_name == coupled_var_name)
  //   _vp_strain_rate_uo.computeTensorDerivative(qp, _pk2_prop_name, val);
  //
  // if (_intvar_prop_name == coupled_var_name)
  //   _vp_strain_rate_uo.computeTensorDerivative(qp, _intvar_prop_name, val);

  return true;
}
