//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef COMPUTEINCREMENTALEIGENSTRAIN_H
#define COMPUTEINCREMENTALEIGENSTRAIN_H

#include "ComputeEigenstrainBase.h"

#include "RankTwoTensor.h"

class ComputeIncrementalEigenstrain;

template <>
InputParameters validParams<ComputeIncrementalEigenstrain>();

/**
 * ComputeIncrementalEigenstrain computes an Eigenstrain that is a function of a single variable
 * defined by a base tensor and a scalar function defined in a Derivative Material.
 */
class ComputeIncrementalEigenstrain : public ComputeEigenstrainBase
{
public:
  ComputeIncrementalEigenstrain(const InputParameters & parameters);

protected:
  virtual void initQpStatefulProperties();
  virtual void computeQpEigenstrain();

  std::vector<FunctionName> _eigenstrain_rate_input;

  const MaterialProperty<RankTwoTensor> & _eigenstrain_old;
  MaterialProperty<RankTwoTensor> & _eigenstrain_increment;
  const unsigned int _input_num;

  std::vector<Function *> _eigenstrain_rate_functions;
};

#endif // COMPUTEINCREMENTALEIGENSTRAIN_H
