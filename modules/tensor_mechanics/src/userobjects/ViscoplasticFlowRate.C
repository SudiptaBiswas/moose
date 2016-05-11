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
  params.addParam<UserObjectName>("cumulative_strain_rate", "Reference flow rate for rate dependent flow");
  params.addClassDescription("User object to evaluate power law flow rate and flow direction based on J2");

  return params;
}

ViscoplasticFlowRate::ViscoplasticFlowRate(const InputParameters & parameters) :
    HEVPFlowRateUOBase(parameters),
    _vp_strain_rate_uo_name(getUserObject("cumulative_strain_rate")),
    _ref_flow_rate(getParam<Real>("reference_flow_rate")),
    _flow_rate_exponent(getParam<Real>("flow_rate_exponent")),
    _flow_rate_tol(getParam<Real>("flow_rate_tol"))
{
}

bool
ViscoplasticFlowRate::computeValue(unsigned int qp, Real & val) const
{
  RankTwoTensor pk2_dev = computePK2Deviatoric(_pk2[qp], _ce[qp]);
  Real eqv_stress = computeEqvStress(pk2_dev, _ce[qp]);
  val = std::pow(eqv_stress/_strength[qp], _flow_rate_exponent) * _ref_flow_rate;

  if (val > _flow_rate_tol)
  {
#ifdef DEBUG
    mooseWarning("Flow rate greater than " << _flow_rate_tol << " " << val << " " << eqv_stress << " " << _strength[qp]);
#endif
    return false;
  }
  return true;
}

bool
ViscoplasticFlowRate::computeDirection(unsigned int qp, RankTwoTensor & val) const
{
  RankTwoTensor pk2_dev = computePK2Deviatoric(_pk2[qp], _ce[qp]);
  Real eqv_stress = computeEqvStress(pk2_dev, _ce[qp]);

  val.zero();
  if (eqv_stress > 0.0)
    val = 1.5/eqv_stress * _ce[qp] * pk2_dev * _ce[qp];

  return true;
}

bool
ViscoplasticFlowRate::computeDerivative(unsigned int qp, const std::string & coupled_var_name, Real & val) const
{
  val = 0.0;

  if (_strength_prop_name == coupled_var_name)
  {
    RankTwoTensor pk2_dev = computePK2Deviatoric(_pk2[qp], _ce[qp]);
    Real eqv_stress = computeEqvStress(pk2_dev, _ce[qp]);
    val = - _ref_flow_rate * _flow_rate_exponent * std::pow(eqv_stress/_strength[qp],_flow_rate_exponent)/_strength[qp];
  }

  return true;
}

bool
ViscoplasticFlowRate::computeTensorDerivative(unsigned int qp, const std::string & coupled_var_name, RankTwoTensor & val) const
{
  val.zero();

  if (_pk2_prop_name == coupled_var_name)
  {
    RankTwoTensor pk2_dev = computePK2Deviatoric(_pk2[qp], _ce[qp]);
    Real eqv_stress = computeEqvStress(pk2_dev, _ce[qp]);
    Real dflowrate_dseqv = _ref_flow_rate * _flow_rate_exponent * std::pow(eqv_stress/_strength[qp],_flow_rate_exponent-1.0)/_strength[qp];

    RankTwoTensor tau = pk2_dev * _ce[qp];
    RankTwoTensor dseqv_dpk2dev;

    dseqv_dpk2dev.zero();
    if (eqv_stress > 0.0)
      dseqv_dpk2dev = 1.5/eqv_stress * tau * _ce[qp];

    RankTwoTensor ce_inv = _ce[qp].inverse();

    RankFourTensor dpk2dev_dpk2;
    for (unsigned int i = 0; i < LIBMESH_DIM; ++i)
      for (unsigned int j = 0; j < LIBMESH_DIM; ++j)
        for (unsigned int k = 0; k < LIBMESH_DIM; ++k)
          for (unsigned int l = 0; l < LIBMESH_DIM; ++l)
          {
            dpk2dev_dpk2(i, j, k, l) = 0.0;
            if (i==k && j==l)
              dpk2dev_dpk2(i, j, k, l) = 1.0;
            dpk2dev_dpk2(i, j, k, l) -= ce_inv(i, j) * _ce[qp](k, l)/3.0;
          }
    val = dflowrate_dseqv * dpk2dev_dpk2.transposeMajor() * dseqv_dpk2dev;
  }
  return true;
}

RankTwoTensor
ViscoplasticFlowRate::computePK2Deviatoric(const RankTwoTensor & pk2, const RankTwoTensor & ce) const
{
  return pk2 - (pk2.doubleContraction(ce) * ce.inverse())/3.0;
}

Real
ViscoplasticFlowRate::computeEqvStress(const RankTwoTensor & pk2_dev, const RankTwoTensor & ce) const
{
  RankTwoTensor sdev = pk2_dev * ce;
  Real val = sdev.doubleContraction(sdev.transpose());
  return std::pow(1.5 * val, 0.5);
}
