//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "Material.h"

// class Function;

/**
 * Double ellipsoid heat source distribution.
 */
class RosenthalHeatSource : public Material
{
public:
  static InputParameters validParams();

  RosenthalHeatSource(const InputParameters & parameters);

protected:
  virtual void computeQpProperties() override;

  /// power
  const Real _P;
  /// process efficienty
  const Real _V;
  const Real _T0;
  const MaterialProperty<Real> & _thermal_conductivity;
  const MaterialProperty<Real> & _thermal_diffusivity;
  const MaterialProperty<Real> & _absorptivity;

  ADMaterialProperty<Real> & _heat_source;
};
