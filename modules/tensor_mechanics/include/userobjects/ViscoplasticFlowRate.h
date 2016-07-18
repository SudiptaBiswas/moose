/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef VISCOPLASTICFLOWRATE_H
#define VISCOPLASTICFLOWRATE_H

#include "VPHardeningRateBase.h"
#include "VPIsotropicHardeningRate.h"
#include "RankTwoTensor.h"

class ViscoplasticFlowRate;

template<>
InputParameters validParams<ViscoplasticFlowRate>();

/**
 * This user object classs
 * Computes flow rate based on power law and
 * Direction based on J2
 */
class ViscoplasticFlowRate : public VPHardeningRateBase
{
public:
  ViscoplasticFlowRate(const InputParameters & parameters);

  virtual bool computeValue(unsigned int, Real &) const;
  virtual bool computeDirection(unsigned int, RankTwoTensor &) const;
  virtual bool computeDerivative(unsigned int, const std::string &, Real &) const;
  virtual bool computeTensorDerivative(unsigned int, const std::string &, RankTwoTensor &) const;

protected:
  UserObjectName _vp_strain_rate_uo_name;
  const VPIsotropicHardeningRate & _vp_strain_rate_uo;
  Real _C;
  Real _flow_rate_tol;

  RankTwoTensor computeDeviatoricStress(const RankTwoTensor &, const RankTwoTensor &) const;
  Real computeEqvStress(const RankTwoTensor &, const RankTwoTensor &, const RankTwoTensor &) const;

};

#endif //VISCOPLASTICFLOWRATE_H
