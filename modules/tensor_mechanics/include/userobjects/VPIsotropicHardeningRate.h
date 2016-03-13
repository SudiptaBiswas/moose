/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef VPISOTROPICHARDENINGRATE_H
#define VPISOTROPICHARDENINGRATE_H

#include "VPHardeningRateBase.h"
#include "RankTwoTensor.h"

class VPIsotropicHardeningRate;

template<>
InputParameters validParams<VPIsotropicHardeningRate>();

/// This user object calculates the rate of isotropic hardening
class VPIsotropicHardeningRate : public VPHardeningRateBase
{
public:
  VPIsotropicHardeningRate(const InputParameters & parameters);

  virtual bool computeValue(unsigned int, Real &) const;
  virtual bool computeDerivativeT(unsigned int, const std::vector<std::string> &, RankTwoTensor &) const;

protected:
  const MaterialProperty<std::vector<RankTwoTensor> > & _intvar;
  const MaterialProperty<RankTwoTensor> & _stress;

  Real _yield_stress;
  /// Isotropic hardening exponent for Chaboche's Viscoplasticity Model
  Real _exponent;
  /// The multiplier used in back stress calculation
  Real _C;

  Real macaulayBracket(Real) const;
  RankFourTensor dDevStress_dStress(RankFourTensor) const;

};

#endif//VPISOTROPICHARDENINGRATE_H
