//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "ADMaterial.h"
// #include "DerivativeMaterialInterface.h"

// Forward Declarations
// class ADInterfaceOrientationMultiphaseMaterial2;
//
// template <>
// InputParameters validParams<ADInterfaceOrientationMultiphaseMaterial2>();

/**
 * Material to compute the angular orientation of order parameter interfaces.
 */
class ADInterfaceOrientationMultiphaseMaterial2 : public ADMaterial
{
public:
  static InputParameters validParams();

  ADInterfaceOrientationMultiphaseMaterial2(const InputParameters & parameters);

protected:
  virtual void computeQpProperties();

private:
  MaterialPropertyName _kappa_name;
  MaterialPropertyName _dkappadgrad_etaa_name;
  MaterialPropertyName _d2kappadgrad_etaa_name;
  Real _delta;
  unsigned int _j;
  Real _theta0;
  Real _kappa_bar;

  MaterialProperty<Real> & _kappa;
  MaterialProperty<Real> & _nd;
  MaterialProperty<Real> & _ndt;
  MaterialProperty<RealGradient> & _dkappadgrad_etaa;
  MaterialProperty<RealTensorValue> & _d2kappadgrad_etaa;

  const VariableValue & _etaa;
  const VariableGradient & _grad_etaa;
  const unsigned int _op_num;

  const NonlinearVariableName _etaa_name;
  // MaterialProperty<Real> & _dkappadetaa;
  // MaterialProperty<Real> & _d2kappadetaa;
  //
  // MaterialProperty<RealGradient> & _d2kappadgradetaadetaa;

  std::vector<const VariableValue *> _etab;
  std::vector<const VariableGradient *> _grad_etab;
  std::vector<NonlinearVariableName> _etab_name;
  // std::vector<MaterialProperty<Real> *> _dkappadetab;
  // std::vector<MaterialProperty<Real> *> _d2kappadetaadetab;
  // std::vector<MaterialProperty<RealGradient> *> _d2kappadgradetaadetab;

  // const VariableValue & _etab;
  // const VariableGradient & _grad_etab;
};
