//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "InelasticTruss.h"

registerMooseObject("TensorMechanicsApp", InelasticTruss);

template <>
InputParameters
validParams<InelasticTruss>()
{
  InputParameters params = validParams<LinearElasticTruss>();
  params.addParam<Real>(
      "yield_strain", 0.0, "The point at which plastic strain begins accumulating");
  params.addRequiredParam<std::vector<Real>>(
      "stress_output",
      "List of functions of true stress as function of plastic strain at different temperatures");
  params.addRequiredParam<std::vector<Real>>(
      "strain_input",
      "List of strain corresponding to the functions listed in 'hardening_functions'");

  return params;
}

InelasticTruss::InelasticTruss(const InputParameters & parameters)
  : LinearElasticTruss(parameters),
    _yield_strain(getParam<Real>("yield_strain")),
    _strain_input(getParam<std::vector<Real>>("strain_input")),
    _stress_output(getParam<std::vector<Real>>("stress_output")),
    _plastic_stretch(declareProperty<Real>(_base_name + "plastic_stretch"))
{
  if (_strain_input.size() != _stress_output.size())
    paramError("strain_input",
               "The vector strain input should have same length as the vector stress output.");

  _interp_stress = MooseSharedPointer<LinearInterpolation>(
      new LinearInterpolation(_strain_input, _stress_output));
}

void
InelasticTruss::initQpStatefulProperties()
{
  TrussMaterial::initQpStatefulProperties();
  _plastic_stretch[_qp] = 0.0;
}

void
InelasticTruss::computeQpStrain()
{
  _total_stretch[_qp] = _current_length / _origin_length - 1.0;
  Real elasto_plastic_stretch = _total_stretch[_qp] - _thermal_expansion_coeff * (_T[_qp] - _T0);
  if (elasto_plastic_stretch < _yield_strain)
    _elastic_stretch[_qp] = elasto_plastic_stretch;
  else
  {
    _elastic_stretch[_qp] = _yield_strain;
    _plastic_stretch[_qp] = elasto_plastic_stretch - _yield_strain;
  }
}

void
InelasticTruss::computeQpStress()
{
  _axial_stress[_qp] = _interp_stress->sample(_elastic_stretch[_qp] + _plastic_stretch[_qp]);
}
