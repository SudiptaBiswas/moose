//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "RosenthalHeatSource.h"

#include "Function.h"

registerMooseObject("HeatConductionApp", RosenthalHeatSource);

InputParameters
RosenthalHeatSource::validParams()
{
  InputParameters params = Material::validParams();
  params.addClassDescription("Computes the thermal profile following the Rosenthal equation");
  params.addParam<MaterialPropertyName>(
      "thermal_conductivity", "thermal_conductivity", "Property name of the thermal conductivity");
  params.addParam<MaterialPropertyName>(
      "thermal_diffusivity", "thermal_diffusivity", "Property name of the thermal diffusivity");
  params.addParam<MaterialPropertyName>(
      "absorptivity", "absorptivity", "Property name of the power absorption coefficient");
  params.addParam<Real>("power", 50, "Laser power");
  params.addParam<Real>("velocity", 1, "Scanning velocity");
  params.addParam<Real>(
      "ambient_temperature", 300, "Ambibient temparature faar away from the surface");
  return params;
}

RosenthalHeatSource::RosenthalHeatSource(const InputParameters & parameters)
  : Material(parameters),
    _P(getParam<Real>("power")),
    _V(getParam<Real>("velocity")),
    _T0(getParam<Real>("ambient_temperature")),
    _thermal_conductivity(getMaterialProperty<Real>("thermal_conductivity")),
    _thermal_diffusivity(getMaterialProperty<Real>("thermal_diffusivity")),
    _absorptivity(getMaterialProperty<Real>("absorptivity")),
    _heat_source(declareADProperty<Real>("heat_source"))
{
}

void
RosenthalHeatSource::computeQpProperties()
{
  const Real & x = _q_point[_qp](0);
  const Real & y = _q_point[_qp](1);
  const Real & z = _q_point[_qp](2);

  // Moving Hear source and distance
  Real x_t = x - _t * _V;
  Real r = std::sqrt(x_t * x_t + y * y + z * z);

  _heat_source[_qp] = _T0 + (_absorptivity[_qp] * _P) /
                                (2.0 * libMesh::pi * _thermal_conductivity[_qp] * r) *
                                std::exp(-_V / (2.0 * _thermal_diffusivity[_qp]) * (r + x_t));
}
