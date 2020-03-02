//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "MultiphaseInterfaceProperties.h"
#include "MooseMesh.h"
#include "MathUtils.h"

registerMooseObject("PhaseFieldApp", MultiphaseInterfaceProperties);

template <>
InputParameters
validParams<MultiphaseInterfaceProperties>()
{
  InputParameters params = validParams<Material>();
  params.addClassDescription(
      "This Material accounts for the the orientation dependence "
      "of interfacial energy for multi-phase multi-order parameter phase-field model.");
  params.addRequiredParam<std::vector<MaterialPropertyName>>(
      "input_prop_names", "Name of the kappa for the given phase");
  params.addParam<std::vector<MaterialPropertyName>>(
      "dpropdgrad_etaa_names", "Name of the derivative of kappa w.r.t. the gradient of eta");
  params.addParam<std::vector<MaterialPropertyName>>(
      "d2propdgrad_etaa_names",
      "Name of the second derivative of kappa w.r.t. the gradient of eta");
  params.addRequiredCoupledVar("etaa", "Array of order parameter for the current phase alpha");
  params.addRequiredCoupledVar("etab",
                               "Array of order parameter for the neighboring phase or grains. "
                               "Array of order parameter names except the current one");
  params.addParam<std::string>(
      "output_prop_name",
      "F",
      "Base name of the free energy function (used to name the material properties)");
  // params.addRequiredParam<MaterialPropertyName>(
  //     "doutputprop_dgradetaa_name",
  //     "Name of the derivative of output property w.r.t. the gradient of eta");
  // params.addRequiredParam<MaterialPropertyName>(
  //     "d2outputprop_dgradetaa_name",
  //     "Name of the second derivative of output property w.r.t. the gradient of eta");
  return params;
}

MultiphaseInterfaceProperties::MultiphaseInterfaceProperties(const InputParameters & parameters)
  : DerivativeMaterialInterface<Material>(parameters),
    _output_prop_name(getParam<std::string>("output_prop_name")),
    _output_prop(declareProperty<Real>(_output_prop_name)),
    _dprop_dgradeta(declareProperty<RealGradient>("d" + _output_prop_name + "_dgradeta")),
    _d2prop_dgradeta(declareProperty<RealTensorValue>("d2" + _output_prop_name + "_dgradeta")),
    _input_prop_names(getParam<std::vector<MaterialPropertyName>>("input_prop_names")),
    _dpropdgrad_etaa_names(getParam<std::vector<MaterialPropertyName>>("dpropdgrad_etaa_names")),
    _d2propdgrad_etaa_names(getParam<std::vector<MaterialPropertyName>>("d2propdgrad_etaa_names")),
    // _kappa(declareProperty<Real>("kappa")),
    // _dkappadgrad_etaa(declareProperty<RealGradient>(_dkappadgrad_etaa_name)),
    // _d2kappadgrad_etaa(declareProperty<RealTensorValue>(_d2kappadgrad_etaa_name)),
    _prop_num(_input_prop_names.size()),
    _input_prop(_prop_num),
    _input_dprop(_prop_num),
    _input_d2prop(_prop_num),
    _etaa_num(coupledComponents("etaa")),
    _etab_num(coupledComponents("etab")),
    _etaa(_etaa_num),
    _etaa_names(_etaa_num),
    _etaa_vars(_etaa_num),
    _etab(_etab_num),
    _etab_names(_etab_num),
    _etab_vars(_etab_num),
    _dprop_detaa(_etaa_num),
    _dprop_detab(_etab_num),
    _d2prop_detaa2(_etaa_num),
    _d2prop_detaadetab(_etab_num),
    _d2prop_dgradetadetaa(_etaa_num)
// _d2kappadgradetaadetab(_op_num)
{
  // this currently only works in 2D simulations
  if (_prop_num != _dpropdgrad_etaa_names.size() || _prop_num != _d2propdgrad_etaa_names.size())
    paramError("input_prop_names",
               "Need to pass in as many dpropdgrad_etaa_names and d2propdgrad_etaa_names as "
               "input_prop_names in MultiphaseInterfaceProperties");

  if (_prop_num != _etaa_num || _prop_num != _etab_num)
    paramError("input_prop_names",
               "Need to pass in as many etaas and etabs as input_prop_names in "
               "MultiphaseInterfaceProperties");

  if (_etaa_num != _etab_num)
    paramError("etaas",
               "Need to pass in as many etaas as etabs in "
               "MultiphaseInterfaceProperties");

  for (unsigned int i = 0; i < _etaa_num; ++i)
  {
    // Loop through grains and load coupled variables into the arrays
    _etaa[i] = &coupledValue("etaa", i);
    _etaa_names[i] = getVar("etaa", i)->name();
    _etaa_vars[i] = coupled("etaa", i);

    _etab[i] = &coupledValue("etab", i);
    _etab_names[i] = getVar("etab", i)->name();
    _etab_vars[i] = coupled("etab", i);

    _input_prop[i] = &getMaterialPropertyByName<Real>(_input_prop_names[i]);
    _input_dprop[i] = &getMaterialPropertyByName<RealGradient>(_dpropdgrad_etaa_names[i]);
    _input_d2prop[i] = &getMaterialPropertyByName<RealTensorValue>(_d2propdgrad_etaa_names[i]);

    _dprop_detaa[i] = &declarePropertyDerivative<Real>(_output_prop_name, _etaa_names[i]);
    _dprop_detab[i] = &declarePropertyDerivative<Real>(_output_prop_name, _etab_names[i]);
    _d2prop_dgradetadetaa[i] = &declarePropertyDerivative<RealGradient>(
        "d" + _output_prop_name + "_dgradeta", _etaa_names[i]);

    // _d2prop_detaa2[i].resize(_etaa_num);
    _d2prop_detaa2[i] =
        &declarePropertyDerivative<Real>(_output_prop_name, _etaa_names[i], _etaa_names[i]);

    // _d2prop_detaadetab[i].resize(_etab_num);
    _d2prop_detaadetab[i] =
        &declarePropertyDerivative<Real>(_output_prop_name, _etaa_names[i], _etab_names[i]);
  }
}

void
MultiphaseInterfaceProperties::computeQpProperties()
{
  // Normal direction of the interface
  Real Val = 0.0;
  Real dvaldetaa = 0.0;
  Real dvaldetab = 0.0;
  Real d2valdetaa = 0.0;
  Real d2valdetaadetab = 0.0;
  Real sum_val = 0.0;
  Real sum_prop = 0.0;
  RealGradient sum_dprop;
  RealTensorValue sum_d2prop;
  //
  Real sum_dvaldetaa = 0.0;
  Real sum_dvaldetab = 0.0;
  Real sum_d2valdetaa = 0.0;
  Real sum_d2valdetaadetab = 0.0;
  Real sum_dpropdetaa = 0.0;
  Real sum_d2propdetaa = 0.0;
  Real sum_d2propdetaadetab = 0.0;

  Real sum_dpropdetab = 0.0;

  // // Real sum_d2kappadetaadetab;
  // // Real dkappadetab;
  // RealGradient sum_dkappadgrad_etaa;
  // RealGradient sum_d2kappadgradetaadetaa;
  // RealTensorValue sum_d2kappadgrad_etaa;
  //
  // std::vector<Real> dvaldetab(_op_num);
  // std::vector<Real> d2valdetaadetab(_op_num);
  // std::vector<Real> kappa_dvaldetab(_op_num);
  // std::vector<Real> kappa_d2valdetaadetab(_op_num);
  // std::vector<RealGradient> d2kappadgradetaadetab(_op_num);
  //
  for (unsigned int m = 0; m < _etaa_num; ++m)
  // for (unsigned int n = m; n < _etab_num; ++n)
  {

    Val = (100000.0 * ((*_etaa[m])[_qp]) * ((*_etaa[m])[_qp]) + 0.01) *
          (100000.0 * ((*_etab[m])[_qp]) * ((*_etab[m])[_qp]) +
           0.01); // the factor are used for the ease of numerical convergence
    dvaldetaa = 2.0 * 100000.0 * (100000.0 * ((*_etab[m])[_qp]) * ((*_etab[m])[_qp]) + 0.01) *
                ((*_etaa[m])[_qp]);
    dvaldetab = 2.0 * 100000.0 * (100000.0 * ((*_etaa[m])[_qp]) * ((*_etaa[m])[_qp]) + 0.01) *
                ((*_etab[m])[_qp]);
    d2valdetaa = 2.0 * 100000.0 * (100000.0 * ((*_etab[m])[_qp]) * ((*_etab[m])[_qp]) + 0.01);
    d2valdetaadetab = 4.0 * 100000.0 * 100000.0 * ((*_etab[m])[_qp]) * ((*_etaa[m])[_qp]);

    sum_val += Val;
    sum_prop += (*_input_prop[m])[_qp] * Val;
    sum_dprop += (*_input_dprop[m])[_qp] * Val;
    sum_d2prop += (*_input_d2prop[m])[_qp] * Val;

    sum_dvaldetaa += dvaldetaa;
    sum_dvaldetab += dvaldetab;
    sum_d2valdetaa += d2valdetaa;
    sum_d2valdetaadetab += d2valdetaadetab;

    sum_dpropdetaa += (*_input_prop[m])[_qp] * dvaldetaa;
    sum_d2propdetaa += (*_input_prop[m])[_qp] * d2valdetaa;
    sum_d2propdetaadetab += (*_input_prop[m])[_qp] * d2valdetaadetab;

    // sum_d2propdgradetaadetaa += (*_input_dprop[m])[_qp] * dvaldetaa;

    sum_dpropdetab += (*_input_prop[m])[_qp] * dvaldetab;
    // sum_d2kappadetab += (*_input_prop[m])[_qp] * d2valdetaa;
    // sum_d2kappadgradetaadetaa += (*_input_dprop[m])[_qp] * dvaldetaa;

    // dvaldetab = dvaldetab[m];
    // kappa_dvaldetab[m] = kappa * dvaldetab[m];
    // kappa_d2valdetaadetab[m] = kappa * d2valdetaadetab[m];
    // d2kappadgradetaadetab[m] = dkappadgrad_etaa * dvaldetab[m];
  }
  _output_prop[_qp] = sum_prop / sum_val;
  _dprop_dgradeta[_qp] = sum_dprop / sum_val;
  _d2prop_dgradeta[_qp] = sum_d2prop / sum_val;

  for (unsigned int i = 0; i < _etaa_num; ++i)
  {
    (*_dprop_detaa[i])[_qp] =
        (sum_dpropdetaa * sum_val - sum_prop * sum_dvaldetaa) / (sum_val * sum_val);
    (*_d2prop_detaa2[i])[_qp] =
        (sum_val * sum_val * (sum_d2propdetaa * sum_val - sum_prop * sum_d2valdetaa) -
         (sum_dpropdetaa * sum_val - sum_prop * sum_dvaldetaa) * 2 * sum_val * sum_dvaldetaa) /
        (sum_val * sum_val * sum_val * sum_val);

    (*_d2prop_detaadetab[i])[_qp] =
        (sum_val * sum_val * (sum_d2propdetaa * sum_val - sum_prop * sum_d2valdetaa) -
         (sum_dpropdetaa * sum_val - sum_prop * sum_dvaldetaa) * 2 * sum_val * sum_dvaldetaa) /
        (sum_val * sum_val * sum_val * sum_val);

    // (*_dkappadetab[i])[_qp] =
    //     (kappa_dvaldetab[i] * sum_val - sum_kappa * dvaldetab[i]) / (sum_val * sum_val);
    // (*_d2kappadetaadetab[i])[_qp] =
    //     (sum_val * sum_val * (kappa_d2valdetaadetab[i] * sum_val - sum_kappa *
    //     d2valdetaadetab[i]) -
    //      (sum_dkappadetaa * sum_val - sum_kappa * sum_dvaldetaa) * 2 * sum_val * dvaldetab[i]) /
    //     (sum_val * sum_val * sum_val * sum_val);
    // (*_d2kappadgradetaadetab[i])[_qp] =
    //     (d2kappadgradetaadetab[i] * sum_val - sum_dkappadgrad_etaa * dvaldetab[i]) /
    //     (sum_val * sum_val);
  }
}
