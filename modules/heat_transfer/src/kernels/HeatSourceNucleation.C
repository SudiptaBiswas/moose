//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "HeatSourceNucleation.h"
#include "DiscreteNucleationMap.h"

registerMooseObject("HeatConductionApp", HeatSourceNucleation);

InputParameters
HeatSourceNucleation::validParams()
{
  InputParameters params = HeatSource::validParams();

  // Override defaults and documentation, weak form is identical to HeatSource in MOOSE
  params.addParam<Real>("value", 1.0, "Value of heat source. Multiplied by function if present.");
  params.addParam<FunctionName>("function", "1", "Function describing the volumetric heat source");
  params.addParam<MaterialPropertyName>(
      "material_property", 1.0, "Material property describing the body force");
  params.addRequiredParam<UserObjectName>("map", "DiscreteNucleationMap user object");
  return params;
}

HeatSourceNucleation::HeatSourceNucleation(const InputParameters & parameters)
  : HeatSource(parameters),
    _map(getUserObject<DiscreteNucleationMap>("map")),
    _material_property(getMaterialProperty<Real>("material_property"))
{
}

void
HeatSourceNucleation::precalculateResidual()
{
  // check if a nucleation event list is available for the current element
  _nucleus = &_map.nuclei(_current_elem);
}

Real
HeatSourceNucleation::computeQpResidual()
{
  // return -_scalar * _material_property[_qp] * _test[_i][_qp];
  return (*_nucleus)[_qp] * _material_property[_qp] * HeatSource::computeQpResidual();
}
