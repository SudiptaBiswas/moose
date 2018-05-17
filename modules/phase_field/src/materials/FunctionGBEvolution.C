//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "FunctionGBEvolution.h"

registerMooseObject("PhaseFieldApp", FunctionGBEvolution);

template <>
InputParameters
validParams<FunctionGBEvolution>()
{
  InputParameters params = validParams<Material>();
  params.addClassDescription("Computes necessary material properties for the isotropic grian "
                             "growth model where GB mobily is provided as a function");
  params.addParam<Real>("f0s", 0.125, "The GB energy constant ");
  params.addRequiredParam<Real>("wGB", "Diffuse GB width in the lengthscale of the model");
  params.addParam<Real>("length_scale", 1.0e-9, "Length scale in m, where default is nm");
  params.addParam<Real>("time_scale", 1.0e-9, "Time scale in s, where default is ns");
  params.addParam<Real>("GBenergy", 1, "Grain boundary energy in J/m^2");
  params.addParam<Real>("molar_volume",
                        24.62e-6,
                        "Molar volume in m^3/mol, needed for temperature gradient driving force");
  params.addRequiredParam<FunctionName>("GBMobility",
                                        "Function representing GB mobility input in m^4/(J*s)");
  params.addParam<Real>("t0", 1.0, "Initial time before initiating welding");
  return params;
}

FunctionGBEvolution::FunctionGBEvolution(const InputParameters & parameters)
  : DerivativeMaterialInterface<Material>(parameters),
    _f0s(getParam<Real>("f0s")),
    _wGB(getParam<Real>("wGB")),
    _length_scale(getParam<Real>("length_scale")),
    _time_scale(getParam<Real>("time_scale")),
    _GBMobility(getFunction("GBMobility")),
    _GBEnergy(getParam<Real>("GBenergy")),
    _molar_vol(getParam<Real>("molar_volume")),
    _sigma(declareProperty<Real>("sigma")),
    _M_GB(declareProperty<Real>("M_GB")),
    _kappa(declareProperty<Real>("kappa_op")),
    _gamma(declareProperty<Real>("gamma_asymm")),
    _L(declareProperty<Real>("L")),
    _l_GB(declareProperty<Real>("l_GB")),
    _mu(declareProperty<Real>("mu")),
    _entropy_diff(declareProperty<Real>("entropy_diff")),
    _molar_volume(declareProperty<Real>("molar_volume")),
    _act_wGB(declareProperty<Real>("act_wGB")),
    _t0(getParam<Real>("t0")),
    _kb(8.617343e-5),     // Boltzmann constant in eV/K
    _JtoeV(6.24150974e18) // Joule to eV conversion
{
}

void
FunctionGBEvolution::computeQpProperties()
{
  _M_GB[_qp] = _GBMobility.value(_t, _q_point[_qp]);

  _l_GB[_qp] = _wGB;

  if (_t < _t0)
    _L[_qp] = 1.0;
  else
    _L[_qp] = 4.0 / 3.0 * _M_GB[_qp] / _l_GB[_qp];

  // eV/nm^2
  _sigma[_qp] = _GBEnergy * _JtoeV * (_length_scale * _length_scale);

  _kappa[_qp] = 3.0 / 4.0 * _sigma[_qp] * _l_GB[_qp];
  _gamma[_qp] = 1.5;
  _mu[_qp] = 3.0 / 4.0 * 1.0 / _f0s * _sigma[_qp] / _l_GB[_qp];

  // J/(K mol) converted to eV(K mol)
  _entropy_diff[_qp] = 8.0e3 * _JtoeV;

  // m^3/mol converted to ls^3/mol
  _molar_volume[_qp] = _molar_vol / (_length_scale * _length_scale * _length_scale);
  _act_wGB[_qp] = 0.5e-9 / _length_scale;
}
