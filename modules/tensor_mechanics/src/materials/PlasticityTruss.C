//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "PlasticityTruss.h"

registerMooseObject("TensorMechanicsApp", PlasticityTruss);

template <>
InputParameters
validParams<PlasticityTruss>()
{
  InputParameters params = validParams<LinearElasticTruss>();
  params.addRequiredParam<Real>("yield_strength", "Input data for yield stress");
  // params.addRequiredParam<std::vector<Real>>("yield_stress", "Input data for yield stress");
  // params.addRequiredParam<std::vector<Real>>("equivalent_plastic_strain",
  // "Input data for equivalent plastic strain");
  params.addCoupledVar(
      "poissons_ratio",
      0.0,
      "Poisson's ratio of the material. Can be supplied as either a number or a variable name.");
  params.addCoupledVar("hardening_constant", 0.0, "Hardening slope");
  params.addParam<Real>(
      "absolute_tolerance", 1e-11, "Absolute convergence tolerance for Newton iteration");
  params.addParam<Real>(
      "relative_tolerance", 1e-8, "Relative convergence tolerance for Newton iteration");
  return params;
}

PlasticityTruss::PlasticityTruss(const InputParameters & parameters)
  : LinearElasticTruss(parameters),
    _yield_stress(getParam<Real>("yield_strength")), // Read from input file
    _poissons_ratio(coupledValue("poissons_ratio")),
    _hardening_constant(coupledValue("hardening_constant")),
    _absolute_tolerance(parameters.get<Real>("absolute_tolerance")),
    _relative_tolerance(parameters.get<Real>("relative_tolerance")),
    // _yield_stress_vector(getParam<std::vector<Real>>("yield_stress")), // Read from input file
    // _eqv_plastic_strain_input(
    //     getParam<std::vector<Real>>("equivalent_plastic_strain")), // Read from input file
    _total_stretch_old(getMaterialPropertyOld<Real>(_base_name + "total_stretch")),
    _plastic_strain(declareProperty<Real>(_base_name + "plastic_strain")),
    _plastic_strain_old(getMaterialPropertyOld<Real>(_base_name + "plastic_strain")),
    _eqv_plastic_strain(declareProperty<Real>(_base_name + "eqv_plastic_strain")),
    _eqv_plastic_strain_old(getMaterialPropertyOld<Real>(_base_name + "eqv_plastic_strain")),
    _elastic_strain_old(getMaterialPropertyOld<Real>(_base_name + "elastic_stretch")),
    _stress_old(getMaterialPropertyOld<Real>(_base_name + "axial_stress")),
    _strain_increment(declareProperty<Real>(_base_name + "strain_increment_truss")),
    _hardening_variable(declareProperty<Real>(_base_name + "hardening_variable")),
    _hardening_variable_old(getMaterialPropertyOld<Real>(_base_name + "hardening_variable")),
    _max_its(1000),
    _iteration(0),
    _residual(0.0)
{
}

void
PlasticityTruss::initQpStatefulProperties()
{
  LinearElasticTruss::initQpStatefulProperties();
  _plastic_strain[_qp] = 0.0;
  _eqv_plastic_strain[_qp] = 0.0;
  _hardening_variable[_qp] = 0.0;
}

void
PlasticityTruss::computeQpStrain()
{
  _total_stretch[_qp] = _current_length / _origin_length - 1.0;
  _strain_increment[_qp] = _total_stretch[_qp] - _total_stretch_old[_qp];
}

// void
// PlasticityTruss::computeQpStress()
// {
//   const Real shear_modulus = _youngs_modulus[_qp] / (2.0 * (1.0 + _poissons_ratio[_qp]));
//
//   _iteration = 0.0;
//   _plastic_strain[_qp] = _plastic_strain_old[_qp];
//   _eqv_plastic_strain[_qp] = _eqv_plastic_strain_old[_qp];
//   // _hardening_variable[_qp] = _hardening_variable_old[_qp];
//   Real eqv_plastic_strain_increment = 0.0;
//
//   Real trial_stress = _stress_old[_qp] + _youngs_modulus[_qp] * _strain_increment[_qp];
//   _axial_stress[_qp] = trial_stress;
//   Real effective_trial_stress = std::sqrt(2.0 / 3.0 * _axial_stress[_qp] * _axial_stress[_qp]);
//
//   Real yield_condition = effective_trial_stress - _hardening_variable[_qp] - _yield_stress -
//                          (3 * shear_modulus * eqv_plastic_strain_increment);
//   Real residual;
//
//   do
//   {
//     _hardening_variable[_qp] =
//         _hardening_variable_old[_qp] + _hardening_constant[_qp] * eqv_plastic_strain_increment;
//
//     residual = (effective_trial_stress - _hardening_variable[_qp] - _yield_stress -
//                 3.0 * shear_modulus * eqv_plastic_strain_increment);
//     Real eqv_plastic_strain_increment_increase =
//         residual / (3.0 * shear_modulus + _hardening_constant[_qp]);
//
//     std::cout << "iteration = " << _iteration << " residual = " << residual
//               << " with eqv_plastic_strain_increment_increase = "
//               << eqv_plastic_strain_increment_increase
//               << " for axial_stress = " << _axial_stress[_qp] << ". \n";
//
//     eqv_plastic_strain_increment += eqv_plastic_strain_increment_increase;
//
//     // yield_condition = effective_trial_stress - _hardening_variable[_qp] - _yield_stress -
//     //                   (3 * shear_modulus * eqv_plastic_strain_increment);
//     ++_iteration;
//     if (_iteration > _max_its) // not converging
//       mooseError("Plasticity model did not converge.");
//
//   } while (std::abs(residual) > _absolute_tolerance);
//
//   _eqv_plastic_strain[_qp] += eqv_plastic_strain_increment;
//
//   Real plastic_strain_increment =
//       std::sqrt(3.0 / 2.0 * eqv_plastic_strain_increment * eqv_plastic_strain_increment);
//
//   _strain_increment[_qp] -= plastic_strain_increment;
//   _plastic_strain[_qp] += plastic_strain_increment;
//   _elastic_stretch[_qp] = _elastic_strain_old[_qp] + _strain_increment[_qp];
//   _axial_stress[_qp] = _stress_old[_qp] + _youngs_modulus[_qp] * _strain_increment[_qp];
// }

void
PlasticityTruss::computeQpStress()
{
  const Real shear_modulus = _youngs_modulus[_qp] / (2.0 * (1.0 + _poissons_ratio[_qp]));

  Real trial_stress = _stress_old[_qp] + _youngs_modulus[_qp] * _strain_increment[_qp];
  _axial_stress[_qp] = trial_stress;
  Real effective_trial_stress = std::sqrt(2.0 / 3.0 * _axial_stress[_qp] * _axial_stress[_qp]);

  _hardening_variable[_qp] = _hardening_variable_old[_qp];
  _plastic_strain[_qp] = _plastic_strain_old[_qp];
  _eqv_plastic_strain[_qp] = _eqv_plastic_strain_old[_qp];

  // _hardening_variable[_qp] += _hardening_constant[_qp] * _eqv_plastic_strain[_qp];

  Real yield_condition = effective_trial_stress - _hardening_variable[_qp] - _yield_stress;
  _iteration = 0;
  Real eqv_plastic_strain_increment = 0.0;

  if (yield_condition > 0.0)
  {
    _residual = yield_condition - 3.0 * shear_modulus * eqv_plastic_strain_increment;

    // _residual = (effective_trial_stress - _hardening_variable[_qp] - _yield_stress) /
    //                 (3.0 * shear_modulus) -
    //             _eqv_plastic_strain[_qp];
    Real residual_old = _residual;
    Real reference_residual =
        effective_trial_stress - 3.0 * shear_modulus * _eqv_plastic_strain[_qp];

    // Real reference_residual =
    //     effective_trial_stress / (3.0 * shear_modulus) - _eqv_plastic_strain[_qp];
    // _residual = yield_condition / (3.0 * shear_modulus) - eqv_plastic_strain_increment;
    while (std::abs(_residual) > _absolute_tolerance ||
           std::abs(_residual / reference_residual) > _relative_tolerance)
    {
      _hardening_variable[_qp] =
          _hardening_variable_old[_qp] + _hardening_constant[_qp] * eqv_plastic_strain_increment;
      Real eqv_plastic_strain_increment_increase =
          (effective_trial_stress - _hardening_variable[_qp] - _yield_stress -
           3.0 * shear_modulus * eqv_plastic_strain_increment) /
          (3.0 * shear_modulus + _hardening_constant[_qp]);

      // eqv_plastic_strain_increment += _residual / (3.0 * shear_modulus +
      // _hardening_constant[_qp]);
      eqv_plastic_strain_increment += eqv_plastic_strain_increment_increase;
      // eqv_plastic_strain_increment += eqv_pla  stic_strain_increment_increase;
      // _eqv_plastic_strain[_qp] = _eqv_plastic_strain_old[_qp] + eqv_plastic_strain_increment;
      // _hardening_variable[_qp] =
      //     _hardening_variable_old[_qp] + _hardening_constant[_qp] * eqv_plastic_strain_increment;

      // _residual = (effective_trial_stress - _hardening_variable[_qp] - _yield_stress) /
      //                 (3.0 * shear_modulus) -
      //             _eqv_plastic_strain[_qp];
      _residual = effective_trial_stress - _hardening_variable[_qp] - _yield_stress -
                  3.0 * shear_modulus * eqv_plastic_strain_increment; // -
      // (3.0 * shear_modulus + _hardening_constant[_qp]) * eqv_plastic_strain_increment_increase;

      // std::cout << "iteration = " << _iteration << " residual = " << _residual
      //           << " with eqv_plastic_strain_increment_increase = "
      //           << eqv_plastic_strain_increment_increase
      //           << " for axial_stress = " << _axial_stress[_qp] << ". \n";
      // residual_old = _residual;
      reference_residual =
          effective_trial_stress - 3.0 * shear_modulus * eqv_plastic_strain_increment;
      // reference_residual =
      //     effective_trial_stress / (3.0 * shear_modulus) - _eqv_plastic_strain[_qp];
      ++_iteration;
      // residual_old = _residual;
      // _eqv_plastic_strain_old[_qp] = _eqv_plastic_strain[_qp];
      if (_iteration > _max_its) // not converging
                                 // mooseWarning("Plasticity model did not converge.");
        mooseError("Plasticity model did not converge.");
    }
    _eqv_plastic_strain[_qp] = _eqv_plastic_strain_old[_qp] + eqv_plastic_strain_increment;

    Real plastic_strain_increment =
        std::sqrt(3.0 / 2.0 * eqv_plastic_strain_increment * eqv_plastic_strain_increment);
    // std::cout << "plastic_strain_increment = " << plastic_strain_increment
    //           << " and eqv_plastic_strain_increment = " << eqv_plastic_strain_increment
    //           << " for axial_stress = " << _axial_stress[_qp] << ". \n";
    _strain_increment[_qp] -= plastic_strain_increment;
    _plastic_strain[_qp] += plastic_strain_increment;
    _elastic_stretch[_qp] = _elastic_strain_old[_qp] + _strain_increment[_qp];
    _axial_stress[_qp] = _stress_old[_qp] + _youngs_modulus[_qp] * _strain_increment[_qp];
  }

  // std::cout << " END: iteration = " << _iteration << " residual = " << _residual
  //           << " with plastic_strain = " << _plastic_strain[_qp]
  //           << " and elastic strain = " << _elastic_stretch[_qp]
  //           << " for axial_stress = " << _axial_stress[_qp] << ". \n";
}
