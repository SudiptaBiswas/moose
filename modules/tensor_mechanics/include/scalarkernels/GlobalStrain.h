//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef GLOBALSTRAIN_H
#define GLOBALSTRAIN_H

#include "ScalarKernel.h"
#include "MultiMooseEnum.h"

// Forward Declarations
class GlobalStrain;
class GlobalStrainUserObject;
class RankTwoTensor;
class RankFourTensor;

template <>
InputParameters validParams<GlobalStrain>();

class GlobalStrain : public ScalarKernel
{
public:
  GlobalStrain(const InputParameters & parameters);

  virtual void reinit(){};
  virtual void computeResidual();
  virtual void computeJacobian();
  virtual void computeOffDiagJacobian(unsigned int /*jvar*/);

protected:
  virtual void assignComponentIndices(Order var_order);

  const GlobalStrainUserObject & _pst;
  const RankTwoTensor & _pst_residual;
  const RankFourTensor & _pst_jacobian;
  std::vector<std::pair<unsigned short, unsigned short>> _components;
  unsigned int _dim;

  MultiMooseEnum _periodic_dirs;
};
#endif // GLOBALSTRAIN_H
