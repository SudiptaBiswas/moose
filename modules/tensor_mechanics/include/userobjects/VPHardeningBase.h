/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef VPHARDENINGBASE_H
#define VPHARDENINGBASE_H

#include "DiscreteElementUserObject.h"
#include "RankTwoTensor.h"

class VPHardeningBase;

template<>
InputParameters validParams<VPHardeningBase>();

/**
 * This user object is a pure virtual base classs
 * Derived classes computes material resistances and derivatives
 */
class VPHardeningBase : public DiscreteElementUserObject
{
public:
  VPHardeningBase(const InputParameters & parameters);

  virtual bool computeValue(unsigned int, Real, Real &) const = 0;
  virtual bool computeDerivative(unsigned int, Real, const std::vector<std::string> &, Real &) const = 0;

  // Use this if the hardening rate or flow rate is a tensor
  virtual bool computeValueT(unsigned int, Real, RankTwoTensor &) const = 0;
  virtual bool computeDerivativeT(unsigned int, Real, const std::vector<std::string> &, RankTwoTensor &) const = 0;

protected:
  std::string _base_name;
  std::string _intvar_rate_prop_name;

};

#endif //VPHARDENINGBASE_H
