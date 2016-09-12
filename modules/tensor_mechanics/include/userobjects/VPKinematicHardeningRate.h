/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef VPKINEMATICHARDENINGRATE_H
#define VPKINEMATICHARDENINGRATE_H

#include "VPHardeningRateBase.h"
#include "VPHardeningBase.h"
#include "RankTwoTensor.h"

class VPKinematicHardeningRate;

template<>
InputParameters validParams<VPKinematicHardeningRate>();

/// This user object calculates the rate of isotropic hardening
class VPKinematicHardeningRate : public VPHardeningRateBase
{
public:
  VPKinematicHardeningRate(const InputParameters & parameters);

  virtual bool computeTensorValue(unsigned int, RankTwoTensor &) const;
  virtual bool computeTensorDerivative(unsigned int, const std::string &, RankTwoTensor &) const;
  virtual bool computeRankFourTensorDerivative(unsigned int, const std::string &, RankFourTensor &) const;

protected:
  UserObjectName _flow_rate_uo_name;
  const VPHardeningRateBase & _flow_rate_uo;

  Real _D;

};

#endif //VPKINEMATICHARDENINGRATE_H
