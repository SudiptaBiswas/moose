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
template <bool is_ad>
class MisorientationDependentPropertiesTempl : public Material
{
public:
  static InputParameters validParams();

  MisorientationDependentPropertiesTempl(const InputParameters & parameters);

protected:
  /// Necessary override. This is where the property values are set.
  virtual void computeQpProperties() override;

  const GenericReal<is_ad> _sigma0;
  const GenericReal<is_ad> _M0;
  const GenericMaterialProperty<Real, is_ad> & _gb_misorientation;

  /// the max value of LAGB
  const GenericReal<is_ad> _angle_threshold;

  GenericMaterialProperty<Real, is_ad> & _sigma;
  GenericMaterialProperty<Real, is_ad> & _M_GB;
};

typedef MisorientationDependentPropertiesTempl<false> MisorientationDependentProperties;
typedef MisorientationDependentPropertiesTempl<true> ADMisorientationDependentProperties;
