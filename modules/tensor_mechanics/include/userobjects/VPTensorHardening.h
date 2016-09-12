/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef VPTENSORHARDENING_H
#define VPTENSORHARDENING_H

#include "VPHardeningBase.h"
#include "RankTwoTensor.h"

class VPTensorHardening;

template<>
InputParameters validParams<VPTensorHardening>();

/**
 * This user object calculates the internal variables from
 * hardening and flow rates
 */
class VPTensorHardening : public VPHardeningBase

{
public:
  VPTensorHardening(const InputParameters & parameters);

  virtual bool computeTensorValue(unsigned int, Real, RankTwoTensor &) const;
  virtual bool computeRankFourTensorDerivative(unsigned int, Real, const std::string &, RankFourTensor &) const;

protected:
  const MaterialProperty<RankTwoTensor> & _intvar_rate;
  const MaterialProperty<RankTwoTensor> & _this_old;
};

#endif //VPTENSORHARDENING_H
