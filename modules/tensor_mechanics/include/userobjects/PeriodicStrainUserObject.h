//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef PERIODICSTRAINUSEROBJECT_H
#define PERIODICSTRAINUSEROBJECT_H

#include "ElementUserObject.h"
#include "SubblockIndexProvider.h"
#include "RankTwoTensor.h"
#include "RankFourTensor.h"

class PeriodicStrainUserObject;
// class RankTwoTensor;
// class RankFourTensor;
class Function;

template <>
InputParameters validParams<PeriodicStrainUserObject>();

class PeriodicStrainUserObject : public ElementUserObject
{
public:
  PeriodicStrainUserObject(const InputParameters & parameters);

  void initialize() override;
  void execute() override;
  void threadJoin(const UserObject & uo) override;
  void finalize() override;
  virtual const RankTwoTensor & getResidual() const;
  virtual const RankTwoTensor & getJacobian() const;

protected:
  std::string _base_name;

  const MaterialProperty<RankFourTensor> & _Cijkl;
  const MaterialProperty<RankTwoTensor> & _periodic_strain;

  const SubblockIndexProvider * _subblock_id_provider;

  const Real _factor;
  RankTwoTensor _applied_stress_tensor;
  RankTwoTensor _residual;
  RankTwoTensor _jacobian;
};

#endif // PERIODICSTRAINUSEROBJECT_H
