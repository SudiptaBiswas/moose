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
#include "DerivativeMaterialInterface.h"

// Forward Declarations
class MultiphaseInterfaceProperties;

template <>
InputParameters validParams<MultiphaseInterfaceProperties>();

/**
 * Material to compute the angular orientation of order parameter interfaces.
 */
class MultiphaseInterfaceProperties : public DerivativeMaterialInterface<Material>
{
public:
  MultiphaseInterfaceProperties(const InputParameters & parameters);

protected:
  virtual void computeQpProperties();

  std::string _output_prop_name;

  MaterialProperty<Real> & _output_prop;

  MaterialProperty<RealGradient> & _dprop_dgradeta;
  MaterialProperty<RealTensorValue> & _d2prop_dgradeta;

  std::vector<MaterialPropertyName> _input_prop_names;
  std::vector<MaterialPropertyName> _dpropdgrad_etaa_names;
  std::vector<MaterialPropertyName> _d2propdgrad_etaa_names;

  unsigned int _prop_num;

  /// Function value of the i phase.
  std::vector<const MaterialProperty<Real> *> _input_prop;

  /// Derivatives of Fi w.r.t. arg[i]
  std::vector<const MaterialProperty<RealGradient> *> _input_dprop;

  /// Second derivatives of Fi.
  std::vector<const MaterialProperty<RealTensorValue> *> _input_d2prop;

  /// name of the order parameter variable
  unsigned int _etaa_num;
  unsigned int _etab_num;
  std::vector<const VariableValue *> _etaa;
  std::vector<VariableName> _etaa_names;
  std::vector<unsigned int> _etaa_vars;

  std::vector<const VariableValue *> _etab;
  std::vector<VariableName> _etab_names;
  std::vector<unsigned int> _etab_vars;

  std::vector<MaterialProperty<Real> *> _dprop_detaa, _dprop_detab, _d2prop_detaa2,
      _d2prop_detaadetab;
  std::vector<MaterialProperty<RealGradient> *> _d2prop_dgradetadetaa;

private:
  // MaterialPropertyName _kappa_name;
  // MaterialPropertyName _dkappadgrad_etaa_name;
  // MaterialPropertyName _d2kappadgrad_etaa_name;
  // Real _delta;
  // unsigned int _j;
  // Real _theta0;
  // Real _kappa_bar;
  //
  // MaterialProperty<Real> & _kappa;
  // MaterialProperty<RealGradient> & _dkappadgrad_etaa;
  // MaterialProperty<RealTensorValue> & _d2kappadgrad_etaa;
  //
  // const VariableValue & _etaa;
  // const VariableGradient & _grad_etaa;
  // const unsigned int _op_num;
  //
  // const NonlinearVariableName _etaa_name;
  // MaterialProperty<Real> & _dkappadetaa;
  // MaterialProperty<Real> & _d2kappadetaa;
  //
  // MaterialProperty<RealGradient> & _d2kappadgradetaadetaa;
  //
  // std::vector<const VariableValue *> _etab;
  // std::vector<const VariableGradient *> _grad_etab;
  // std::vector<NonlinearVariableName> _etab_name;
  // std::vector<MaterialProperty<Real> *> _dkappadetab;
  // std::vector<MaterialProperty<Real> *> _d2kappadetaadetab;
  // std::vector<MaterialProperty<RealGradient> *> _d2kappadgradetaadetab;

  // const VariableValue & _etab;
  // const VariableGradient & _grad_etab;
};
