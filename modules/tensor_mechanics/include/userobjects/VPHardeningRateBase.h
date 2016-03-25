/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef VPHARDENINGRATEBASE_H
#define VPHARDENINGRATEBASE_H

#include "DiscreteElementUserObject.h"
#include "RankTwoTensor.h"

class VPHardeningRateBase;

template<>
InputParameters validParams<VPHardeningRateBase>();

/**
 * This user object is a pure virtual base classs
 * Derived classes computes hardening rate or flow rate and derivatives
 */
class VPHardeningRateBase : public DiscreteElementUserObject
{
public:
  VPHardeningRateBase(const InputParameters & parameters);

  virtual bool computeValue(unsigned int, Real &) const = 0;
  virtual bool computeDerivative(unsigned int, const std::vector<std::string> &, Real &) const = 0;
  virtual bool computeStressDerivative(unsigned int, Real &) const = 0;


  // Use this if the hardening rate or flow rate is a tensor
  virtual bool computeValueT(unsigned int, RankTwoTensor &) const = 0;
  virtual bool computeDerivativeT(unsigned int, const std::vector<std::string> &, RankTwoTensor &) const = 0;
  virtual bool computeStressDerivativeT(unsigned int, RankTwoTensor &) const = 0;


protected:
  std::string _base_name;

  std::vector<std::string> _intvar_prop_names;
  std::vector<std::string> _intvar_rate_prop_names;

};

#endif //VPHARDENINGRATEBASE_H
