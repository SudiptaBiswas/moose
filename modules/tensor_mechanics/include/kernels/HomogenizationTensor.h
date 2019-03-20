//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef HOMOGENIZATIONTENSOR_H
#define HOMOGENIZATIONTENSOR_H

#include "ALEKernel.h"
#include "RankFourTensor.h"
#include "RankTwoTensor.h"
// Forward Declarations
class HomogenizationTensor;

template <>
InputParameters validParams<HomogenizationTensor>();

class HomogenizationTensor : public ALEKernel
{
public:
  HomogenizationTensor(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();

  std::string _base_name;
  const MaterialProperty<RankFourTensor> & _elasticity_tensor;

private:
  const unsigned int _component;
  const unsigned int _k;
  const unsigned int _l;
};
#endif // HOMOGENIZATIONTENSOR_H
