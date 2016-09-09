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
  virtual bool computeTensorValue(unsigned int, Real &) const = 0;
  virtual bool computeDerivative(unsigned int, const std::string &, Real &) const = 0;
  virtual bool computeTensorDerivative(unsigned int, const std::string &, RankTwoTensor &) const = 0;
  virtual bool computeDirection(unsigned int, RankTwoTensor &) const = 0;


  // Use this if the hardening rate or flow rate is a tensor
  // virtual bool computeValueT(unsigned int, RankTwoTensor &) const = 0;
  // virtual bool computeDerivativeT(unsigned int, const std::string &, RankTwoTensor &) const = 0;
  // virtual bool computeStressDerivativeT(unsigned int, RankTwoTensor &) const = 0;


protected:
  std::string _base_name;

  std::string _intvar_prop_name;
  std::string _intvar_rate_prop_name;
  std::string _intvar_prop_tensor_name;
  std::string _intvar_rate_prop_tensor_name;
  const MaterialProperty<Real> & _intvar;
  const MaterialProperty<Real> & _intvar_rate;
  const MaterialProperty<RankTwoTensor> & _intvar_tensor;
  const MaterialProperty<RankTwoTensor> & _intvar_rate_tensor;

  std::string _strength_prop_name;
  const MaterialProperty<Real> & _strength;
  std::string _pk2_prop_name;
  const MaterialProperty<RankTwoTensor> & _pk2;
  const MaterialProperty<RankTwoTensor> & _ce;

};

#endif //VPHARDENINGRATEBASE_H
