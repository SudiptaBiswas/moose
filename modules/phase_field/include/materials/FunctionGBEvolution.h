//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef FUNCTIONGBEVOLUTION_H
#define FUNCTIONGBEVOLUTION_H

#include "GBEvolutionBase.h"
#include "DerivativeMaterialInterface.h"

// Forward Declarations
class FunctionGBEvolution;

template <>
InputParameters validParams<FunctionGBEvolution>();

/**
 * Grain boundary energy parameters for isotropic uniform grain boundary energies
 */
class FunctionGBEvolution : public DerivativeMaterialInterface<Material>
{
public:
  FunctionGBEvolution(const InputParameters & parameters);

protected:
  virtual void computeQpProperties();

  Real _f0s;
  Real _wGB;
  Real _length_scale;
  Real _time_scale;
  const Function & _GBMobility;

  Real _GBEnergy;
  Real _molar_vol;

  MaterialProperty<Real> & _sigma;
  MaterialProperty<Real> & _M_GB;
  MaterialProperty<Real> & _kappa;
  MaterialProperty<Real> & _gamma;
  MaterialProperty<Real> & _L;
  MaterialProperty<Real> * _dLdT;
  MaterialProperty<Real> & _l_GB;
  MaterialProperty<Real> & _mu;
  MaterialProperty<Real> & _entropy_diff;
  MaterialProperty<Real> & _molar_volume;
  MaterialProperty<Real> & _act_wGB;

  const Real _kb;
  const Real _JtoeV;
};

#endif // FUNCTIONGBEVOLUTION_H
