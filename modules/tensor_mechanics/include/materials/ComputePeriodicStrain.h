//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef COMPUTEPERIODICSTRAIN_H
#define COMPUTEPERIODICSTRAIN_H

#include "Material.h"

class ComputePeriodicStrain;
class RankTwoTensor;

template <>
InputParameters validParams<ComputePeriodicStrain>();

/**
 * ComputePeriodicStrain is the base class for strain tensors using incremental formulations
 */
class ComputePeriodicStrain : public Material
{
public:
  ComputePeriodicStrain(const InputParameters & parameters);

protected:
  virtual void initQpStatefulProperties();
  virtual void computeProperties();

  ///Base name prepended to material property name
  std::string _base_name;
  VariableValue & _scalar_periodic_strain;
  Order _scalar_periodic_strain_order;
  MaterialProperty<RankTwoTensor> & _periodic_strain;
};

#endif // COMPUTEPERIODICSTRAIN_H
