//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "BndsCalcAux.h"

// Forward Declarations

/**
 * Visualize the location of grain boundaries in a polycrystalline simulation.
 */
class NewGrainBoundaries : public BndsCalcAux
{
public:
  static InputParameters validParams();

  NewGrainBoundaries(const InputParameters & parameters);

protected:
  virtual Real computeValue();

  const unsigned int _initial_grains;

  const GrainTrackerInterface & _grain_tracker;
};
