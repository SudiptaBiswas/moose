/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef VPPLASTICSTRAINRATE_H
#define VPPLASTICSTRAINRATE_H

#include "VPHardeningRateBase.h"
#include "RankTwoTensor.h"

class VPPlasticStrainRate;

template<>
InputParameters validParams<VPPlasticStrainRate>();

/**
 * This user object calculates the plastic strain rate
 * for Chaboche's rate dependent viscoplastic model
 */
class VPPlasticStrainRate : public VPHardeningRateBase
{
public:
  VPPlasticStrainRate(const InputParameters & parameters);

  virtual bool computeValueT(unsigned int, RankTwoTensor &) const;
  virtual bool computeDerivativeT(unsigned int, const std::vector<std::string> &, RankTwoTensor &) const;

  virtual bool computeDirection(unsigned int, RankTwoTensor &) const;
protected:
  const MaterialProperty<std::vector<RankTwoTensor> > & _intvar;
  const MaterialProperty<std::vector<Real> > & _intvar_rate;
  const MaterialProperty<RankTwoTensor> & _stress;
  Real _C;

  RankFourTensor dDevStress_dStress(RankFourTensor) const;

};

#endif //VPPLASTICSTRAINRATE_H
