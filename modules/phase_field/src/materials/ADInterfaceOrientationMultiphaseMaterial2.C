//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ADInterfaceOrientationMultiphaseMaterial2.h"
#include "MooseMesh.h"
#include "MathUtils.h"

registerMooseObject("PhaseFieldApp", ADInterfaceOrientationMultiphaseMaterial2);

InputParameters
ADInterfaceOrientationMultiphaseMaterial2::validParams()
{
  InputParameters params = ADMaterial::validParams();
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

ADInterfaceOrientationMultiphaseMaterial2::ADInterfaceOrientationMultiphaseMaterial2(
    const InputParameters & parameters)
  : ADMaterial(parameters),
    _kappa_name(getParam<MaterialPropertyName>("kappa_name")),
    _dkappadgrad_etaa_name(getParam<MaterialPropertyName>("dkappadgrad_etaa_name")),
    _d2kappadgrad_etaa_name(getParam<MaterialPropertyName>("d2kappadgrad_etaa_name")),
    _delta(getParam<Real>("anisotropy_strength")),
    _j(getParam<unsigned int>("mode_number")),
    _theta0(getParam<Real>("reference_angle")),
    _kappa_bar(getParam<Real>("kappa_bar")),
    _kappa(declareProperty<Real>(_kappa_name)),
    _nd(declareProperty<Real>(_kappa_name + "_normal")),
    _ndt(declareProperty<Real>(_kappa_name + "_norm_tan")),
    _dkappadgrad_etaa(declareProperty<RealGradient>(_dkappadgrad_etaa_name)),
    _d2kappadgrad_etaa(declareProperty<RealTensorValue>(_d2kappadgrad_etaa_name)),
    _etaa(coupledValue("etaa")),
    _grad_etaa(coupledGradient("etaa")),
    _op_num(coupledComponents("etab")),
    _etaa_name(getVar("etaa", 0)->name()),
    // _dkappadetaa(declarePropertyDerivative<Real>(_kappa_name, _etaa_name)),
    // _d2kappadetaa(declarePropertyDerivative<Real>(_kappa_name, _etaa_name, _etaa_name)),
    // _d2kappadgradetaadetaa(
    //     declarePropertyDerivative<RealGradient>(_dkappadgrad_etaa_name, _etaa_name)),
    _etab(_op_num),
    _grad_etab(_op_num),
    _etab_name(_op_num)
// _dkappadetab(_op_num),
// _d2kappadetaadetab(_op_num),
// _d2kappadgradetaadetab(_op_num)
{
  // this currently only works in 2D simulations
  if (_mesh.dimension() != 2)
    mooseError("ADInterfaceOrientationMultiphaseMaterial2 requires a two-dimensional mesh.");

  for (unsigned int i = 0; i < _op_num; ++i)
  {
    // Loop through grains and load coupled variables into the arrays
    _etab[i] = &coupledValue("etab", i);
    _grad_etab[i] = &coupledGradient("etab", i);
    _etab_name[i] = getVar("etab", i)->name();

    // _dkappadetab[i] = &declarePropertyDerivative<Real>(_kappa_name, _etab_name[i]);
    // _d2kappadetaadetab[i] =
    //     &declarePropertyDerivative<Real>(_kappa_name, _etaa_name, _etab_name[i]);
    // _d2kappadgradetaadetab[i] =
    //     &declarePropertyDerivative<RealGradient>(_dkappadgrad_etaa_name, _etab_name[i]);
  }
}

void
ADInterfaceOrientationMultiphaseMaterial2::computeQpProperties()
{
  const Real tol = libMesh::TOLERANCE;
  const Real cutoff = 1.0 - tol;

  // for (unsigned int m = 0; m < _op_num - 1; ++m)
  //   for (unsigned int n = m + 1; n < _op_num; ++n) // m<n
  //   {
  //     Val = (100000.0 * ((*_etab[m])[_qp]) * ((*_etab[m])[_qp]) + 0.01) *
  //           (100000.0 * ((*_etab[n])[_qp]) * ((*_etab[n])[_qp]) + 0.01);
  //     sum_val += Val;
  //   }

  // _kappa[_qp] = 0.0;
  // Real kappa = 0.0;
  // if (_grad_etaa[_qp].norm() > tol)
  // {
  // Normal direction of the interface
  Real n = 0.0;
  Real Val = 0.0;
  Real dvaldetaa = 0.0;
  Real d2valdetaa = 0.0;
  Real sum_val = 0.0;
  Real sum_nd = 0.0;
  Real sum_ndt = 0.0;
  Real sum_kappa = 0.0;
  Real sum_dvaldetaa = 0.0;
  Real sum_d2valdetaa = 0.0;
  Real sum_dkappadetaa = 0.0;
  Real sum_d2kappadetaa = 0.0;
  // Real sum_d2kappadetaadetab;
  // Real dkappadetab;
  // RealGradient dkappadgrad_etaa;
  // RealTensorValue d2kappadgrad_etaa;
  RealGradient sum_dkappadgrad_etaa;
  RealGradient sum_d2kappadgradetaadetaa;
  RealTensorValue sum_d2kappadgrad_etaa;

  std::vector<Real> dvaldetab(_op_num);
  std::vector<Real> d2valdetaadetab(_op_num);
  std::vector<Real> kappa_dvaldetab(_op_num);
  std::vector<Real> kappa_d2valdetaadetab(_op_num);
  std::vector<RealGradient> d2kappadgradetaadetab(_op_num);

  // Real kappa = _kappa_bar;

  for (unsigned int m = 0; m < _op_num; ++m)
  {
    RealGradient nd;
    // if (_grad_etaa[_qp](0) != 0 || _grad_etaa[_qp](1) != 0 || _grad_etaa[_qp](2) != 0)
    // {
    // RealGradient nd = _grad_etaa[_qp];
    //   nd -= (*_grad_etab[m])[_qp];
    if (_grad_etaa[_qp].norm() > libMesh::TOLERANCE &&
        (*_grad_etab[m])[_qp].norm() > libMesh::TOLERANCE)
      nd = _grad_etaa[_qp] - (*_grad_etab[m])[_qp];

    const Real nx = nd(0);
    const Real ny = nd(1);
    const Real n2x = nd(0) * nd(0);
    const Real n2y = nd(1) * nd(1);
    const Real nsq = nd.norm_sq();
    const Real n2sq = nsq * nsq;
    if (nsq > tol)
      n = nx / std::sqrt(nsq);

    if (n > cutoff)
      n = cutoff;

    if (n < -cutoff)
      n = -cutoff;

    // Calculate the orientation angle
    const Real angle = std::acos(n) * MathUtils::sign(ny);
    const Real angle2 = std::atan2(ny, nx);

    // Compute derivatives of the angle wrt n
    const Real dangledn = -MathUtils::sign(ny) / std::sqrt(1.0 - n * n);
    const Real d2angledn2 = -MathUtils::sign(ny) * n / (1.0 - n * n) / std::sqrt(1.0 - n * n);

    // Compute derivative of n wrt grad_eta
    RealGradient dndgrad_etaa;
    if (nsq > tol)
    {
      dndgrad_etaa(0) = ny * ny;
      dndgrad_etaa(1) = -nx * ny;
      dndgrad_etaa /= nsq * std::sqrt(nsq);
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
      dndgrad_etaa_sq(0, 0) = n2y * n2y;
      dndgrad_etaa_sq(0, 1) = -(nx * ny * n2y);
      dndgrad_etaa_sq(1, 0) = -(nx * ny * n2y);
      dndgrad_etaa_sq(1, 1) = n2x * n2y;
      dndgrad_etaa_sq /= n2sq * nsq;
    }

    // Compute the second derivative of n wrt grad_eta
    RealTensorValue d2ndgrad_etaa2;
    if (nsq > tol)
    {
      d2ndgrad_etaa2(0, 0) = -3.0 * nx * ny * ny;
      d2ndgrad_etaa2(0, 1) = -ny * ny * ny + 2.0 * nx * nx * ny;
      d2ndgrad_etaa2(1, 0) = -ny * ny * ny + 2.0 * nx * nx * ny;
      d2ndgrad_etaa2(1, 1) = -nx * nx * nx + 2.0 * nx * ny * ny;
      d2ndgrad_etaa2 /= n2sq * std::sqrt(nsq);
    }

    // Compute derivatives of kappa wrt grad_eta
    RealGradient dkappadgrad_etaa = dkappadangle * dangledn * dndgrad_etaa;
    RealTensorValue d2kappadgrad_etaa = d2kappadangle * dangledn * dangledn * dndgrad_etaa_sq +
                                        dkappadangle * d2angledn2 * dndgrad_etaa_sq +
                                        dkappadangle * dangledn * d2ndgrad_etaa2;

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
    sum_nd += angle * Val;
    sum_ndt += angle2 * Val;
    sum_kappa += kappa * Val;
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
  _ndt[_qp] = sum_ndt / sum_val;
  // _kappa[_qp] = kappa;
  // if (_kappa_name == "kappaa")
  //   std::cout << _kappa_name << " = " << _kappa[_qp] << " at " << _q_point[_qp]
  //             << " where grad_var = " << _grad_etaa[_qp] << "\n";
  _dkappadgrad_etaa[_qp] = sum_dkappadgrad_etaa / sum_val;
  _d2kappadgrad_etaa[_qp] = sum_d2kappadgrad_etaa / sum_val;
  // _dkappadetaa[_qp] = (sum_dkappadetaa * sum_val - sum_kappa * sum_dvaldetaa) / (sum_val *
  // sum_val); _d2kappadetaa[_qp] =
  //     ((sum_val * sum_val *
  //       (sum_d2kappadetaa * sum_val + sum_dkappadetaa * sum_dvaldetaa -
  //        sum_dkappadetaa * sum_dvaldetaa - sum_kappa * sum_d2valdetaa)) -
  //      ((sum_dkappadetaa * sum_val - sum_kappa * sum_dvaldetaa) * 2 * sum_val * sum_dvaldetaa)) /
  //     (sum_val * sum_val * sum_val * sum_val);
  // _d2kappadgradetaadetaa[_qp] =
  //     (sum_d2kappadgradetaadetaa * sum_val - sum_dkappadgrad_etaa * sum_dvaldetaa) /
  //     (sum_val * sum_val);
  //
  // for (unsigned int i = 0; i < _op_num; ++i)
  // {
  //   (*_dkappadetab[i])[_qp] =
  //       (kappa_dvaldetab[i] * sum_val - sum_kappa * dvaldetab[i]) / (sum_val * sum_val);
  //   (*_d2kappadetaadetab[i])[_qp] =
  //       (sum_val * sum_val *
  //            (kappa_d2valdetaadetab[i] * sum_val + sum_dkappadetaa * dvaldetab[i] -
  //             kappa_dvaldetab[i] * sum_dvaldetaa - sum_kappa * d2valdetaadetab[i]) -
  //        (sum_dkappadetaa * sum_val - sum_kappa * sum_dvaldetaa) * 2 * sum_val * dvaldetab[i]) /
  //       (sum_val * sum_val * sum_val * sum_val);
  //   (*_d2kappadgradetaadetab[i])[_qp] =
  //       (d2kappadgradetaadetab[i] * sum_val - sum_dkappadgrad_etaa * dvaldetab[i]) /
  //       (sum_val * sum_val);
  // }
}
