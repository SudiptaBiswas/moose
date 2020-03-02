//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "PolycrystalBndsCalcIC.h"
#include "IndirectSort.h"
#include "MooseMesh.h"
#include "MooseRandom.h"
#include "NonlinearSystemBase.h"
#include "GrainTrackerInterface.h"
#include "PolycrystalUserObjectBase.h"

registerMooseObject("PhaseFieldApp", PolycrystalBndsCalcIC);

template <>
InputParameters
validParams<PolycrystalBndsCalcIC>()
{
  InputParameters params = validParams<InitialCondition>();
  params.addClassDescription(
      "Random Voronoi tesselation polycrystal (used by PolycrystalVoronoiICAction)");
  params.addRequiredParam<UserObjectName>("polycrystal_ic_uo",
                                          "User object generating a point to grain number mapping");
  params.addRequiredParam<unsigned int>("op_num", "The index for the current order parameter");

  return params;
}

PolycrystalBndsCalcIC::PolycrystalBndsCalcIC(const InputParameters & parameters)
  : InitialCondition(parameters),
    _op_num(getParam<unsigned int>("op_num")),
    _poly_ic_uo(getUserObject<PolycrystalUserObjectBase>("polycrystal_ic_uo"))
{
}

Real
PolycrystalBndsCalcIC::value(const Point & p)
{
  Real value = 0.0;
  Real var = 0.0;
  for (unsigned int i = 0; i < _op_num; ++i)
  {
    if (_current_node)
      var = _poly_ic_uo.getNodalVariableValue(i, *_current_node);
    else
      var = _poly_ic_uo.getVariableValue(i, p);

    value += var * var;
  }

  return value;
}
