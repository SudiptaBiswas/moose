//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "ADCoupledTimeDerivative.h"

/**
 * This calculates a modified coupled time derivative that multiplies the time derivative of a
 * coupled variable by a function of the variables
 */
class ADCoupledSusceptibilityTimeDerivative : public ADCoupledTimeDerivative
{
public:
  static InputParameters validParams();

  ADCoupledSusceptibilityTimeDerivative(const InputParameters & parameters);

protected:
  virtual ADReal precomputeQpResidual() override;

  /// The function multiplied by the coupled time derivative
  const ADMaterialProperty<Real> & _F;
};
