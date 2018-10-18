//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef GLOBALSTRAINUSEROBJECT2_H
#define GLOBALSTRAINUSEROBJECT2_H

#include "GlobalStrainUserObject2.h"
// #include "GlobalStrainUserObjectInterface.h"

#include "RankTwoTensor.h"
#include "RankFourTensor.h"

class GlobalStrainUserObject;

template <>
InputParameters validParams<GlobalStrainUserObject>();

class GlobalStrainUserObject2 : public GlobalStrainUserObject
// public GlobalStrainUserObjectInterface
{
public:
  GlobalStrainUserObject2(const InputParameters & parameters);

  // void initialize() override;
  // void execute() override;
  // void threadJoin(const UserObject & uo) override;
  // void finalize() override;
  // virtual const RankTwoTensor & getResidual() const override;
  // virtual const RankFourTensor & getJacobian() const override;
  // virtual const VectorValue<bool> & getPeriodicDirections() const override;

  /**
   * Calculate additional applied stresses
   */
  virtual void computeAdditionalStress(unsigned int qp);

protected:
  std::string _base_name;

  const MaterialProperty<RankFourTensor> & _elasticity_tensor;
  // const MaterialProperty<RankTwoTensor> & _stress;

  RankTwoTensor _applied_strain_tensor;
  // RankTwoTensor _residual;
  // RankFourTensor _jacobian;
  //
  // const unsigned int _dim;
  // const unsigned int _ndisp;
  // std::vector<unsigned int> _disp_var;
  // VectorValue<bool> _periodic_dir;
};

#endif // GLOBALSTRAINUSEROBJECT2_H
