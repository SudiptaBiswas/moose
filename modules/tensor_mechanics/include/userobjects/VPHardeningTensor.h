/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef VPHARDENINGTENSOR_H
#define VPHARDENINGTENSOR_H

#include "VPHardeningBase.h"
#include "RankTwoTensor.h"

class VPHardeningTensor;

template<>
InputParameters validParams<VPHardeningTensor>();

/**
 * This user object calculates the internal variables from
 * hardening and flow rates
 */
class VPHardeningTensor : public VPHardeningBase
{
public:
  VPHardeningTensor(const InputParameters & parameters);

  virtual bool computeValueT(unsigned int, Real, RankTwoTensor &) const;
  virtual bool computeDerivative(unsigned int, Real, const std::string &, Real &) const;

protected:
  const MaterialProperty<RankTwoTensor> & _intvar_rate;
  const MaterialProperty<RankTwoTensor> & _this_old;

};

#endif //VPHARDENINGTENSOR_H
