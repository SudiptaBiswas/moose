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

/**
 * Visualize the location of grain boundaries in a polycrystalline simulation.
 */
class MisorientationDependentProperties : public Material
{
public:
  static InputParameters validParams();

  MisorientationDependentProperties(const InputParameters & parameters);

protected:
  /// Necessary override. This is where the property values are set.
  virtual void computeQpProperties() override;
  const Real _sigma0;
  const Real _M0;
  const ADMaterialProperty<Real> & _gb_misorientation;

  /// the max value of LAGB
  const Real _angle_threshold;

  ADMaterialProperty<Real> & _sigma;
  ADMaterialProperty<Real> & _M_GB;
};
