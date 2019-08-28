//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "LinearElasticTruss.h"

class PlasticityTruss;

template <>
InputParameters validParams<PlasticityTruss>();

class PlasticityTruss : public LinearElasticTruss
{
public:
  PlasticityTruss(const InputParameters & parameters);

protected:
  virtual void computeQpStrain();
  virtual void computeQpStress();
  virtual void initQpStatefulProperties();

  Real _yield_stress;
  const VariableValue & _poissons_ratio;

  const VariableValue & _hardening_constant;

  /// Convergence tolerance
  Real _absolute_tolerance;
  Real _relative_tolerance;

  // std::vector<Real> _yield_stress_vector;
  // std::vector<Real> _eqv_plastic_strain_input;
  MooseSharedPointer<LinearInterpolation> _interp_yield_stress;
  const MaterialProperty<Real> & _total_stretch_old;

  Real _yield_condition;
  MaterialProperty<Real> & _plastic_strain;
  const MaterialProperty<Real> & _plastic_strain_old;
  MaterialProperty<Real> & _eqv_plastic_strain;
  const MaterialProperty<Real> & _eqv_plastic_strain_old;
  const MaterialProperty<Real> & _elastic_strain_old;
  const MaterialProperty<Real> & _stress_old;
  MaterialProperty<Real> & _strain_increment;

  MaterialProperty<Real> & _hardening_variable;
  const MaterialProperty<Real> & _hardening_variable_old;

  /// maximum no. of iterations and iteration number
  const unsigned int _max_its;
  unsigned int _iteration;

  /// Residual values, kept as members to retain solver state for summary outputting
  Real _residual;

private:
};
