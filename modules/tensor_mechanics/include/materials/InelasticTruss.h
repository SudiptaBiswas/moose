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
#include "LinearInterpolation.h"

class InelasticTruss;

template <>
InputParameters validParams<InelasticTruss>();

class InelasticTruss : public LinearElasticTruss
{
public:
  InelasticTruss(const InputParameters & parameters);

protected:
  virtual void computeQpStrain();
  virtual void computeQpStress();
  virtual void initQpStatefulProperties();

  Real _yield_strain;
  std::vector<Real> _strain_input;
  std::vector<Real> _stress_output;

  MaterialProperty<Real> & _plastic_stretch;

  MooseSharedPointer<LinearInterpolation> _interp_stress;
};
