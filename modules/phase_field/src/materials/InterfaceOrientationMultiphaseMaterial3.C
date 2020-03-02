//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "InterfaceOrientationMultiphaseMaterial3.h"
#include "MooseMesh.h"
#include "MathUtils.h"

registerMooseObject("PhaseFieldApp", InterfaceOrientationMultiphaseMaterial3);

template <>
InputParameters
validParams<InterfaceOrientationMultiphaseMaterial3>()
{
  InputParameters params = validParams<Material>();
  params.addClassDescription(
      "This Material accounts for the the orientation dependence "
      "of interfacial energy for multi-phase multi-order parameter phase-field model.");
  params.addRequiredParam<MaterialPropertyName>("kappa_name",
                                                "Name of the kappa for the given phase");
  params.addRequiredParam<MaterialPropertyName>(
      "dkappadgrad_etaa_name", "Name of the derivative of kappa w.r.t. the gradient of eta");
  params.addRequiredParam<MaterialPropertyName>(
      "d2kappadgrad_etaa_name",
      "Name of the second derivative of kappa w.r.t. the gradient of eta");
  params.addParam<Real>(
      "anisotropy_strength", 0.04, "Strength of the anisotropy (typically < 0.05)");
  params.addParam<unsigned int>("mode_number", 4, "Mode number for anisotropy");
  params.addParam<Real>(
      "reference_angle", 90, "Reference angle for defining anisotropy in degrees");
  params.addParam<Real>("kappa_bar", 0.1125, "Average value of the interface parameter kappa");
  params.addRequiredCoupledVar("etaa", "Order parameter for the current phase alpha");
  params.addRequiredCoupledVar("etab",
                               "Array of order parameter for the neighboring phase or grains. "
                               "Array of order parameter names except the current one");
  return params;
}

InterfaceOrientationMultiphaseMaterial3::InterfaceOrientationMultiphaseMaterial3(
    const InputParameters & parameters)
  : DerivativeMaterialInterface<Material>(parameters),
    _kappa_name(getParam<MaterialPropertyName>("kappa_name")),
    _dkappadgrad_etaa_name(getParam<MaterialPropertyName>("dkappadgrad_etaa_name")),
    _d2kappadgrad_etaa_name(getParam<MaterialPropertyName>("d2kappadgrad_etaa_name")),
    _delta(getParam<Real>("anisotropy_strength")),
    _j(getParam<unsigned int>("mode_number")),
    _theta0(getParam<Real>("reference_angle")),
    _kappa_bar(getParam<Real>("kappa_bar")),
    _kappa(declareProperty<Real>(_kappa_name)),
    _nd(declareProperty<Real>(_kappa_name + "_normal")),
    _dkappadgrad_etaa(declareProperty<RealGradient>(_dkappadgrad_etaa_name)),
    _d2kappadgrad_etaa(declareProperty<RealTensorValue>(_d2kappadgrad_etaa_name)),
    _etaa(coupledValue("etaa")),
    _grad_etaa(coupledGradient("etaa")),
    _op_num(coupledComponents("etab")),
    _etaa_name(getVar("etaa", 0)->name()),
    _dkappadetaa(declarePropertyDerivative<Real>(_kappa_name, _etaa_name)),
    _d2kappadetaa(declarePropertyDerivative<Real>(_kappa_name, _etaa_name, _etaa_name)),
    _d2kappadgradetaadetaa(
        declarePropertyDerivative<RealGradient>(_dkappadgrad_etaa_name, _etaa_name)),
    _etab(_op_num),
    _grad_etab(_op_num),
    _etab_name(_op_num),
    _dkappadetab(_op_num),
    _d2kappadetaadetab(_op_num),
    _d2kappadgradetaadetab(_op_num)
{
  // this currently only works in 2D simulations
  if (_mesh.dimension() != 2)
    mooseError("InterfaceOrientationMultiphaseMaterial3 requires a two-dimensional mesh.");

  for (unsigned int i = 0; i < _op_num; ++i)
  {
    // Loop through grains and load coupled variables into the arrays
    _etab[i] = &coupledValue("etab", i);
    _grad_etab[i] = &coupledGradient("etab", i);
    _etab_name[i] = getVar("etab", i)->name();

    _dkappadetab[i] = &declarePropertyDerivative<Real>(_kappa_name, _etab_name[i]);
    _d2kappadetaadetab[i] =
        &declarePropertyDerivative<Real>(_kappa_name, _etaa_name, _etab_name[i]);
    _d2kappadgradetaadetab[i] =
        &declarePropertyDerivative<RealGradient>(_dkappadgrad_etaa_name, _etab_name[i]);
  }
}

void
InterfaceOrientationMultiphaseMaterial3::computeQpProperties()
{
  const Real tol = libMesh::TOLERANCE;
  const Real cutoff = 1.0 - tol;

  // Normal direction of the interface
  Real n = 0.0;
  Real Val = 0.0;
  Real dvaldetaa = 0.0;
  Real d2valdetaa = 0.0;
  Real sum_val = 0.0;
  Real sum_nd = 0.0;
  Real sum_kappa = 0.0;
  Real sum_dvaldetaa = 0.0;
  Real sum_d2valdetaa = 0.0;
  Real sum_dkappadetaa = 0.0;
  Real sum_d2kappadetaa = 0.0;
  // Real sum_d2kappadetaadetab;
  // Real dkappadetab;
  RealGradient sum_dkappadgrad_etaa;
  RealGradient sum_d2kappadgradetaadetaa;
  RealTensorValue sum_d2kappadgrad_etaa;

  std::vector<Real> dvaldetab(_op_num);
  std::vector<Real> d2valdetaadetab(_op_num);
  std::vector<Real> kappa_dvaldetab(_op_num);
  std::vector<Real> kappa_d2valdetaadetab(_op_num);
  std::vector<RealGradient> d2kappadgradetaadetab(_op_num);

  // for (unsigned int m = 0; m < _op_num - 1; ++m)
  //   for (unsigned int n = m + 1; n < _op_num; ++n) // m<n
  //   {
  //     Val = (100000.0 * ((*_etab[m])[_qp]) * ((*_etab[m])[_qp]) + 0.01) *
  //           (100000.0 * ((*_etab[n])[_qp]) * ((*_etab[n])[_qp]) + 0.01);
  //     sum_val += Val;
  //   }

  for (unsigned int m = 0; m < _op_num; ++m)
  {
    RealGradient nd;
    if (_grad_etaa[_qp].norm() > libMesh::TOLERANCE &&
        (*_grad_etab[m])[_qp].norm() > libMesh::TOLERANCE)
      nd = _grad_etaa[_qp] - (*_grad_etab[m])[_qp];

    Real nx = nd(0);
    Real ny = nd(1);
    const Real n2x = nd(0) * nd(0);
    const Real n2y = nd(1) * nd(1);
    const Real nsq = nd.norm_sq();
    const Real n2sq = nsq * nsq;
    // if (nsq > tol)
    //   n = nx / std::sqrt(nsq);
    //
    // if (nx < tol && ny < tol)
    // {
    //   nx = tol;
    //   ny = tol;
    // }
    //
    // if (nx < tol && ny > -tol)
    // {
    //   nx = tol;
    //   ny = -tol;
    // }
    // if (nx > -tol && ny < tol)
    // {
    //   nx = -tol;
    //   ny = tol;
    // }
    // if (nx > -tol && ny > -tol)
    // {
    //   nx = -tol;
    //   ny = -tol;
    // }
    // Calculate the orientation angle
    // const Real angle = std::acos(n) * MathUtils::sign(ny);
    const Real angle = std::atan2(ny, nx);
    // const Real angle2 = std::atan2(nd(1), nd(0));

    // Compute derivatives of the angle wrt n
    // const Real dangledn = MathUtils::sign(ny) * nx * n;
    // const Real d2angledn2 = -MathUtils::sign(ny) * n / (1.0 - n * n) / std::sqrt(1.0 - n * n);

    // Compute derivative of n wrt grad_eta
    RealGradient dndgrad_etaa;
    if (nsq > tol)
    {
      dndgrad_etaa(0) = -ny;
      dndgrad_etaa(1) = nx;
      dndgrad_etaa *= (MathUtils::sign(nd(1)) / nsq);
    }

    // Calculate interfacial coefficient kappa and its derivatives wrt the angle
    Real anglediff = _j * (angle - _theta0 * libMesh::pi / 180.0);

    Real kappa =
        _kappa_bar * (1.0 + _delta * std::cos(anglediff)) * (1.0 + _delta * std::cos(anglediff));
    Real dkappadangle = -2.0 * _kappa_bar * _delta * _j * (1.0 + _delta * std::cos(anglediff)) *
                        std::sin(anglediff);
    Real d2kappadangle =
        2.0 * _kappa_bar * _delta * _delta * _j * _j * std::sin(anglediff) * std::sin(anglediff) -
        2.0 * _kappa_bar * _delta * _j * _j * (1.0 + _delta * std::cos(anglediff)) *
            std::cos(anglediff);

    // Compute the square of dndgrad_etaa
    RealTensorValue dndgrad_etaa_sq;
    if (nsq > tol)
    {
      dndgrad_etaa_sq(0, 0) = n2y;
      dndgrad_etaa_sq(0, 1) = -(nx * ny);
      dndgrad_etaa_sq(1, 0) = -(nx * ny);
      dndgrad_etaa_sq(1, 1) = n2x;
      dndgrad_etaa_sq /= n2sq;
    }

    // Compute the second derivative of n wrt grad_eta
    RealTensorValue d2ndgrad_etaa2;
    if (nsq > tol)
    {
      d2ndgrad_etaa2(0, 0) = 2.0 * nx * ny;
      d2ndgrad_etaa2(0, 1) = n2y - n2x;
      d2ndgrad_etaa2(1, 0) = n2y - n2x;
      d2ndgrad_etaa2(1, 1) = -2.0 * nx * ny;
      d2ndgrad_etaa2 *= (MathUtils::sign(nd(1)) / n2sq);
    }

    // Compute derivatives of kappa wrt grad_eta
    RealGradient dkappadgrad_etaa = dkappadangle * dndgrad_etaa;
    RealTensorValue d2kappadgrad_etaa =
        d2kappadangle * dndgrad_etaa_sq + dkappadangle * d2ndgrad_etaa2;

    Val = (100000.0 * _etaa[_qp] * _etaa[_qp] + 0.01) *
          (100000.0 * ((*_etab[m])[_qp]) * ((*_etab[m])[_qp]) +
           0.01); // the factor are used for the ease of numerical convergence
    dvaldetaa =
        2.0 * 100000.0 * (100000.0 * ((*_etab[m])[_qp]) * ((*_etab[m])[_qp]) + 0.01) * _etaa[_qp];
    d2valdetaa = 2.0 * 100000.0 * (100000.0 * ((*_etab[m])[_qp]) * ((*_etab[m])[_qp]) + 0.01);
    dvaldetab[m] =
        2.0 * 100000.0 * (100000.0 * _etaa[_qp] * _etaa[_qp] + 0.01) * ((*_etab[m])[_qp]);
    d2valdetaadetab[m] = 4.0 * 100000.0 * 100000.0 * ((*_etab[m])[_qp]) * _etaa[_qp];

    sum_val += Val;
    sum_kappa += kappa * Val;
    sum_nd += angle * Val;
    sum_dkappadgrad_etaa += dkappadgrad_etaa * Val;
    sum_d2kappadgrad_etaa += d2kappadgrad_etaa * Val;
    sum_dvaldetaa += dvaldetaa;
    sum_d2valdetaa += d2valdetaa;
    sum_dkappadetaa += kappa * dvaldetaa;
    sum_d2kappadetaa += kappa * d2valdetaa;
    sum_d2kappadgradetaadetaa += dkappadgrad_etaa * dvaldetaa;

    // dvaldetab[m] = dvaldetab[m];
    kappa_dvaldetab[m] = kappa * dvaldetab[m];
    kappa_d2valdetaadetab[m] = kappa * d2valdetaadetab[m];
    d2kappadgradetaadetab[m] = dkappadgrad_etaa * dvaldetab[m];
  }
  _kappa[_qp] = sum_kappa / sum_val;
  _nd[_qp] = sum_nd / sum_val;
  _dkappadgrad_etaa[_qp] = sum_dkappadgrad_etaa / sum_val;
  _d2kappadgrad_etaa[_qp] = sum_d2kappadgrad_etaa / sum_val;
  _dkappadetaa[_qp] = (sum_dkappadetaa * sum_val - sum_kappa * sum_dvaldetaa) / (sum_val * sum_val);
  _d2kappadetaa[_qp] =
      ((sum_val * sum_val *
        (sum_d2kappadetaa * sum_val + sum_dkappadetaa * sum_dvaldetaa -
         sum_dkappadetaa * sum_dvaldetaa - sum_kappa * sum_d2valdetaa)) -
       ((sum_dkappadetaa * sum_val - sum_kappa * sum_dvaldetaa) * 2 * sum_val * sum_dvaldetaa)) /
      (sum_val * sum_val * sum_val * sum_val);
  _d2kappadgradetaadetaa[_qp] =
      (sum_d2kappadgradetaadetaa * sum_val - sum_dkappadgrad_etaa * sum_dvaldetaa) /
      (sum_val * sum_val);

  for (unsigned int i = 0; i < _op_num; ++i)
  {
    (*_dkappadetab[i])[_qp] =
        (kappa_dvaldetab[i] * sum_val - sum_kappa * dvaldetab[i]) / (sum_val * sum_val);
    (*_d2kappadetaadetab[i])[_qp] =
        (sum_val * sum_val *
             (kappa_d2valdetaadetab[i] * sum_val + sum_dkappadetaa * dvaldetab[i] -
              kappa_dvaldetab[i] * sum_dvaldetaa - sum_kappa * d2valdetaadetab[i]) -
         (sum_dkappadetaa * sum_val - sum_kappa * sum_dvaldetaa) * 2 * sum_val * dvaldetab[i]) /
        (sum_val * sum_val * sum_val * sum_val);
    (*_d2kappadgradetaadetab[i])[_qp] =
        (d2kappadgradetaadetab[i] * sum_val - sum_dkappadgrad_etaa * dvaldetab[i]) /
        (sum_val * sum_val);
  }
}
