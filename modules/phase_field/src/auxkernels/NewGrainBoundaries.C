//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "NewGrainBoundaries.h"
// #include "BndsCalculator.h"
#include "GrainTrackerInterface.h"
registerMooseObject("PhaseFieldApp", NewGrainBoundaries);

InputParameters
NewGrainBoundaries::validParams()
{
  InputParameters params = BndsCalcAux::validParams();
  params.addClassDescription("Calculate location of new grain boundaries in a polycrystalline "
                             "sample with recrystallization");
  params.addParam<Real>(
      "initial_grains", 0.0, "Equilibrium volume fraction of 2nd phase for Avrami analysis");
  params.addRequiredParam<UserObjectName>("grain_tracker",
                                          "The GrainTracker UserObject to get values from.");

  return params;
}

NewGrainBoundaries::NewGrainBoundaries(const InputParameters & parameters)
  : BndsCalcAux(parameters),
    _initial_grains(getParam<Real>("initial_grains")),
    _grain_tracker(getUserObject<GrainTrackerInterface>("grain_tracker"))
{
}

Real
NewGrainBoundaries::computeValue()
{
  // Get list of active order parameters from grain tracker
  const auto & op_to_grains = _grain_tracker.getVarToFeatureVector(_current_elem->id());
  for (auto op_index = beginIndex(op_to_grains); op_index < op_to_grains.size(); ++op_index)
  {
    if (op_to_grains[op_index] != FeatureFloodCount::invalid_id &&
        op_to_grains[op_index] < (_initial_grains - 1))
    {
      return FeatureFloodCount::invalid_id;
      continue;
    }
  }
  return BndsCalcAux::computeValue();
}
