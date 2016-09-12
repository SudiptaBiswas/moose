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
  virtual bool computeDerivative(unsigned int, const std::string &, Real &) const;
  virtual bool computeTensorDerivative(unsigned int, const std::string &, RankTwoTensor &) const;

protected:
  /// Isotropic hardening exponent for Chaboche's Viscoplasticity Model
  const Real _exponent;

  Real macaulayBracket(Real) const;
};

#endif//VPISOTROPICHARDENINGRATE_H
