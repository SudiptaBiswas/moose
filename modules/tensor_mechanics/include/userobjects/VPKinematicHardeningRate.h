/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef VPKINEMATICHARDENINGRATE_H
#define VPKINEMATICHARDENINGRATE_H

#include "VPHardeningRateBase.h"
#include "RankTwoTensor.h"

class VPKinematicHardeningRate;

template<>
InputParameters validParams<VPKinematicHardeningRate>();

/// This user object calculates the rate of isotropic hardening
class VPKinematicHardeningRate : public VPHardeningRateBase
{
public:
  VPKinematicHardeningRate(const InputParameters & parameters);

  virtual bool computeValueT(unsigned int, RankTwoTensor &) const;
  virtual bool computeDerivativeT(unsigned int, const std::vector<std::string> &, RankTwoTensor &) const;

protected:
  const MaterialProperty<std::vector<RankTwoTensor> > & _intvar;
  const MaterialProperty<std::vector<RankTwoTensor> > & _intvar_rate;
  std::string _flow_rate_prop_name;
  const MaterialProperty<RankTwoTensor> & _flow_rate;
  Real _D;

};

#endif //VPKINEMATICHARDENINGRATE_H
