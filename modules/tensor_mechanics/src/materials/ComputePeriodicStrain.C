//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ComputePeriodicStrain.h"
#include "RankTwoTensor.h"

template <>
InputParameters
validParams<ComputePeriodicStrain>()
{
  InputParameters params = validParams<Material>();
  params.addParam<std::string>("base_name",
                               "Optional parameter that allows the user to define "
                               "multiple mechanics material systems on the same "
                               "block, i.e. for multiple phases");
  params.addCoupledVar("scalar_periodic_strain",
                       "Scalar variable for periodic strain");
  return params;
}

ComputePeriodicStrain::ComputePeriodicStrain(const InputParameters & parameters)
  : Material(parameters),
    _base_name(isParamValid("base_name") ? getParam<std::string>("base_name") + "_" : ""),
    _scalar_periodic_strain(coupledScalarValue("scalar_periodic_strain")),
    _scalar_periodic_strain_order(coupledScalarOrder("scalar_periodic_strain")),
    _periodic_strain(declareProperty<RankTwoTensor>(_base_name + "periodic_strain"))
{
}

void
ComputePeriodicStrain::initQpStatefulProperties()
{
  _periodic_strain[_qp].zero();
}

void
ComputePeriodicStrain::computeProperties()
{
  std::vector<Real> periodic_strain;
  periodic_strain.assign(_scalar_periodic_strain_order, 0);
  for (unsigned int i = 0; i< _scalar_periodic_strain_order; ++i)
    periodic_strain[i] = _scalar_periodic_strain[i];

  _periodic_strain[_qp].fillFromInputVector(periodic_strain);
}
