//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef PeriodicStrainUserObject_H
#define PeriodicStrainUserObject_H

#include "ElementUserObject.h"
#include "SubblockIndexProvider.h"

class PeriodicStrainUserObject;
class RankTwoTensor;
class RankFourTensor;
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
  virtual Real returnResidual(unsigned int scalar_var_id = 0) const;
  virtual Real returnReferenceResidual(unsigned int scalar_var_id = 0) const;
  virtual Real returnJacobian(unsigned int scalar_var_id = 0) const;

protected:
  std::string _base_name;

  const MaterialProperty<RankFourTensor> & _Cijkl;
  const MaterialProperty<RankTwoTensor> & _periodic_strain;

  const SubblockIndexProvider * _subblock_id_provider;

  const Real _factor;
  std::vector<RankTwoTensor> _residual;
  std::vector<RankFourTensor> _jacobian;
};

#endif // PeriodicStrainUserObject_H
