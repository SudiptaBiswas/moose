/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef VPHARDENING_H
#define VPHARDENING_H

#include "VPHardeningBase.h"
#include "RankTwoTensor.h"

class VPHardening;

template<>
InputParameters validParams<VPHardening>();

/**
 * This user object calculates the internal variables from
 * hardening and flow rates
 */
class VPHardening : public VPHardeningBase
{
public:
  VPHardening(const InputParameters & parameters);

  virtual bool computeValue(unsigned int, Real, Real &) const;
  virtual bool computeDerivative(unsigned int, Real, const std::string &, Real &) const;

protected:
  const MaterialProperty<Real> & _intvar_rate;
  const MaterialProperty<Real> & _this_old;

};

#endif //VPHARDENING_H
