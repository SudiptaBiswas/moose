//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "MisorientationDependentProperties.h"

registerMooseObject("PhaseFieldApp", MisorientationDependentProperties);

InputParameters
MisorientationDependentProperties::validParams()
{
  InputParameters params = Material::validParams();
  params.addClassDescription("Calculate grain boundary energies and mobilities for different "
                             "misorienattion within a polycrystalline sample");
  params.addRequiredParam<Real>("gb_energy_isotropic", "The average grain boundary energy");
  params.addParam<Real>("gb_mobility_isotropic", 1.0, "The average grain boundary mobility");

  params.addParam<MaterialPropertyName>(
      "gb_misorientation", "gb_misorientation", "The EBSDReader GeneralUserObject");
  params.addParam<Real>("angle_threshold", 15, "Max LAGB Misorientation angle");
  return params;
}

MisorientationDependentProperties::MisorientationDependentProperties(
    const InputParameters & parameters)
  : Material(parameters),
    _sigma0(getParam<Real>("gb_energy_isotropic")),
    _M0(getParam<Real>("gb_mobility_isotropic")),
    _gb_misorientation(getADMaterialProperty<Real>("gb_misorientation")),
    _angle_threshold(getParam<Real>("angle_threshold")),
    _sigma(declareADProperty<Real>("GBEnergy")),
    _M_GB(declareADProperty<Real>("M_GB_avg"))
{
}

void
MisorientationDependentProperties::computeQpProperties()
{
  ADReal lagb = _gb_misorientation[_qp] / _angle_threshold;
  if (lagb < 0)
    mooseWarning(
        "GB misorientation angle is negetive, please ensure nothing unphysical is happenning");
  if (lagb > 0 && lagb <= 1.0)
  {
    _sigma[_qp] = _sigma0 * lagb * (1 - std::log(lagb));
    _M_GB[_qp] = _M0 * lagb * (1 - std::exp(-5 * std::pow(lagb, 4)));
  }
  else
  {
    _sigma[_qp] = _sigma0;
    _M_GB[_qp] = _M0;
  }
}
