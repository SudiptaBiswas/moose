//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef PERIODICSTRAIN_H
#define PERIODICSTRAIN_H

#include "ScalarKernel.h"

// Forward Declarations
class PeriodicStrain;
class PeriodicStrainUserObject;

template <>
InputParameters validParams<PeriodicStrain>();

class PeriodicStrain : public ScalarKernel
{
public:
  PeriodicStrain(const InputParameters & parameters);

  virtual void reinit(){};
  virtual void computeResidual();
  virtual void computeJacobian();

protected:
  virtual void computeComponentIndex(Order var_order);

  const PeriodicStrainUserObject & _pst;
  const RankTwoTensor & _pst_residual;
  const RankTwoTensor & _pst_jacobian;
  std::vector<std::pair<unsigned int, unsigned int> > _components;
};
#endif // PERIODICSTRAIN_H
