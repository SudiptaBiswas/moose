//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ADGrandPotentialAnisoInterface.h"
// #include "Conversion.h"
// #include "IndirectSort.h"
// #include "libmesh/utility.h"

registerMooseObject("PhaseFieldApp", ADGrandPotentialAnisoInterface);

InputParameters
ADGrandPotentialAnisoInterface::validParams()
{
  InputParameters params = ADMaterial::validParams();
  params.addClassDescription("Calculate Grand Potential interface parameters for a specified "
                             "interfacial free energy and width");
  params.addRequiredCoupledVar("etas", "Vector of order parameters for the given phase");
  // params.addParam<bool>("use_tolerance", true, "Average value of the interface parameter kappa");
  // params.addParam<>("tolerance_type", true, "Average value of the interface parameter kappa");

  return params;
}

ADGrandPotentialAnisoInterface::ADGrandPotentialAnisoInterface(const InputParameters & parameters)
  : ADMaterial(parameters),
    DerivativeMaterialPropertyNameInterface(),
    _num_eta(coupledComponents("etas")),
    _eta(_num_eta),
    _eta_names(_num_eta),
    _kappa(declareADProperty<Real>("kappa_op")),
    _dkappadgrad_etaa(declareADProperty<RealGradient>("dkappadgrad_etaa")),
    _dkappadeta(_num_eta),
    _kappa_comp(_num_eta),
    _dkappadgrad_etaa_comp(_num_eta)
{
  for (unsigned int i = 0; i < _num_eta; ++i)
  {
    _eta[i] = &adCoupledValue("etas", i);
    _eta_names[i] = getVar("etas", i)->name();

    _dkappadeta[i] =
        &declareADProperty<Real>(derivativePropertyNameFirst("kappa_op", _eta_names[i]));
  }

  for (unsigned int i = 0; i < _num_eta; ++i)
  {
    _kappa_comp[i].resize(_num_eta);
    _dkappadgrad_etaa_comp[i].resize(_num_eta);
    for (unsigned int j = 0; j < _num_eta; ++j)
      if (j != i)
      {
        _kappa_comp[i][j] =
            &getADMaterialProperty<Real>("kappa_" + _eta_names[i] + "_" + _eta_names[j]);
        _dkappadgrad_etaa_comp[i][j] = &getADMaterialProperty<RealGradient>(
            "dkappadgrad_" + _eta_names[i] + "_" + _eta_names[j]);
      }
  }
}

void
ADGrandPotentialAnisoInterface::computeQpProperties()
{
  ADReal Val = 0.0;
  ADReal dvaldetam = 0.0;
  ADReal dvaldetan = 0.0;
  ADReal sum_val = 0.0;

  std::vector<ADReal> sum_dvaldeta(_num_eta);
  std::vector<ADReal> sum_kappa_dvaldeta(_num_eta);

  ADReal sum_kappa = 0.0;
  ADRealGradient sum_dkappadgrad_etaa;

  for (unsigned int m = 0; m < _num_eta - 1; ++m)
    for (unsigned int n = m + 1; n < _num_eta; ++n)
    {
      Val = (1000000.0 * (*_eta[m])[_qp] * (*_eta[m])[_qp] + 0.01) *
            (1000000.0 * (*_eta[n])[_qp] * (*_eta[n])[_qp] + 0.01);
      // Val = (100000.0 * (*_eta[m])[_qp] * (*_eta[m])[_qp] + libMesh::TOLERANCE) *
      //       (1000000.0 * (*_eta[n])[_qp] * (*_eta[n])[_qp] + libMesh::TOLERANCE);

      dvaldetam = (1000000.0 * ((*_eta[n])[_qp]) * ((*_eta[n])[_qp]) + 0.01);
      dvaldetan = (1000000.0 * ((*_eta[m])[_qp]) * ((*_eta[m])[_qp]) + 0.01);
      // dvaldeta = (1000000.0 * ((*_eta[n])[_qp]) * ((*_eta[n])[_qp]) + libMesh::TOLERANCE);

      sum_val += 2.0 * Val;
      sum_dvaldeta[m] += 4.0 * 1000000.0 * (*_eta[m])[_qp] * dvaldetam;
      sum_dvaldeta[n] += 4.0 * 1000000.0 * (*_eta[n])[_qp] * dvaldetan;

      sum_kappa += Val * ((*_kappa_comp[m][n])[_qp] + (*_kappa_comp[n][m])[_qp]);
      sum_kappa_dvaldeta[m] += 2.0 * 1000000.0 * (*_eta[m])[_qp] * dvaldetam *
                               ((*_kappa_comp[m][n])[_qp] + (*_kappa_comp[n][m])[_qp]);
      sum_kappa_dvaldeta[n] += 2.0 * 1000000.0 * (*_eta[n])[_qp] * dvaldetan *
                               ((*_kappa_comp[m][n])[_qp] + (*_kappa_comp[n][m])[_qp]);

      sum_dkappadgrad_etaa +=
          Val * ((*_dkappadgrad_etaa_comp[m][n])[_qp] + (*_dkappadgrad_etaa_comp[n][m])[_qp]);
    }

  // if (sum_val > libMesh::TOLERANCE)
  {
    _kappa[_qp] = sum_kappa / sum_val;
    _dkappadgrad_etaa[_qp] = sum_dkappadgrad_etaa / sum_val;
  }

  for (unsigned int i = 0; i < _num_eta; ++i)
    (*_dkappadeta[i])[_qp] =
        (sum_kappa_dvaldeta[i] * sum_val - sum_kappa * sum_dvaldeta[i]) / (sum_val * sum_val);
}
