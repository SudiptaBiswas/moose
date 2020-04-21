//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "GlobalStrainUserObject.h"
// #include "GlobalStrainLoadingUserObjectInterface.h"

#include "RankTwoTensor.h"
// #include "RankFourTensor.h"

class GlobalStrainLoadingUserObject;

template <>
InputParameters validParams<GlobalStrainLoadingUserObject>();

class GlobalStrainLoadingUserObject : public GlobalStrainUserObject
{
public:
  static InputParameters validParams();

  GlobalStrainLoadingUserObject(const InputParameters & parameters);

  /**
   * Calculate additional applied stresses
   */
  virtual void computeAdditionalStress(unsigned int qp);

protected:
  /// applied stress components
  std::vector<const Function *> _stress_fcn;

  // RankTwoTensor _applied_stress_tensor;
};
