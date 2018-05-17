//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "PolycrystalWeldingIC.h"
#include "ColumnMajorMatrix.h"
#include "BilinearInterpolation.h"

#include <fstream>

registerMooseObject("MooseApp", PolycrystalWeldingIC);

template <>
InputParameters
validParams<PolycrystalWeldingIC>()
{
  InputParameters params = validParams<Function>();
  params.addClassDescription("Position dependent mobility canculation");
  params.addRequiredParam<Real>("x1", "The x coordinate of the initial center");
  params.addRequiredParam<Real>("y1", "The y coordinate of the initial center");
  params.addParam<Real>("z1", 0.0, "The z coordinate of the initial center");
  params.addRequiredParam<Real>("vp", "Welding speed");
  params.addParam<Real>("r1", 0.0, "Radious of the weld pool");
  params.addParam<Real>("factor", 1.0, "Factor to multiply mobility");
  MooseEnum shape("circular elliptical", "circular");
  params.addParam<MooseEnum>("weldpool_shape", shape, "Provide the shape of the weld pool");
  params.addParam<Real>("a", 0.0, "Semiaxis a of the superellipsoid");
  params.addParam<Real>("b", 0.0, "Semiaxis b of the superellipsoid");
  params.addParam<Real>("c", 1.0, "Semiaxis c of the superellipsoid");
  params.addRequiredParam<Real>("invalue", "The variable value inside the weldpool");
  params.addRequiredParam<Real>("outvalue", "The variable value outside the haz");
  return params;
}

PolycrystalWeldingIC::PolycrystalWeldingIC(const InputParameters & parameters)
  : Function(parameters),
    _x1(parameters.get<Real>("x1")),
    _y1(parameters.get<Real>("y1")),
    _z1(parameters.get<Real>("z1")),
    _vp(getParam<Real>("vp")),
    _haz(getParam<Real>("haz")),
    _r1(getParam<Real>("r1")),
    _factor(getParam<Real>("factor")),
    _shape(getParam<MooseEnum>("weldpool_shape")),
    _a(parameters.get<Real>("a")),
    _b(parameters.get<Real>("b")),
    _c(parameters.get<Real>("c")),
    _invalue(parameters.get<Real>("invalue")),
    _outvalue(parameters.get<Real>("outvalue"))
{
}

Real
PolycrystalWeldingIC::value(Real t, const Point & p)
{
  Point center;
  center(0) = _x1 + _vp * t;
  center(1) = _y1;
  center(2) = _z1;

  Point dist_vec = p - center;
  Real dist = dist_vec.norm();

  Real r2 = r + _haz;
  Real haz_value = (1.0 - (dist - _r1) / _haz) * _factor;

  if (dist < r)
    return _invalue;
  else if ((dist >= r && dist < r2))
    return haz_value;
  else
    return _outvalue;
}
