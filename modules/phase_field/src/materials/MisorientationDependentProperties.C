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
registerMooseObject("PhaseFieldApp", ADMisorientationDependentProperties);

template <bool is_ad>
InputParameters
MisorientationDependentPropertiesTempl<is_ad>::validParams()
{
  InputParameters params = Material::validParams();
  params.addClassDescription("Calculate grain boundary energies and mobilities for different "
                             "misorienattion within a polycrystalline sample");
  params.addRequiredParam<Real>("gb_energy_isotropic", "The average grain boundary energy");
  params.addParam<Real>("gb_mobility_isotropic", 1.0, "The average grain boundary mobility");

  params.addParam<MaterialPropertyName>(
      "gb_misorientation", "gb_misorientation", "The EBSDReader GeneralUserObject");
  params.addParam<Real>("angle_threshold", 15, "Max LAGB Misorientation angle");
  // params.addRequiredCoupledVarWithAutoBuild(
  //     "v", "var_name_base", "op_num", "Array of coupled variables");
  // params.addRequiredParam<UserObjectName>("grain_tracker",
  // "the GrainTracker UserObject to get values from");
  return params;
}

template <bool is_ad>
MisorientationDependentPropertiesTempl<is_ad>::MisorientationDependentPropertiesTempl(
    const InputParameters & parameters)
  : Material(parameters),
    _sigma0(this->template getParam<Real>("gb_energy_isotropic")),
    _M0(this->template getParam<Real>("gb_mobility_isotropic")),
    _gb_misorientation(this->template getGenericMaterialProperty<Real, is_ad>("gb_misorientation")),
    _angle_threshold(this->template getParam<Real>("angle_threshold")),
    _sigma(declareGenericProperty<Real, is_ad>("GBEnergy")),
    _M_GB(declareGenericProperty<Real, is_ad>("M_GB_avg"))
// _op_num(coupledComponents("v")),
// _vals(_op_num),
// _grain_tracker(getUserObject<GrainTracker>("grain_tracker"))

{
  // Loop over variables
  // for (auto op_index = decltype(_op_num)(0); op_index < _op_num; ++op_index)
  // {
  //   // Initialize variables
  //   _vals[op_index] = &coupledValue("v", op_index);
  // }
}

template <bool is_ad>
void
MisorientationDependentPropertiesTempl<is_ad>::computeQpProperties()
{
  // // get the vector that maps active order parameters to grain ids
  // const auto & op_to_grains = _grain_tracker.getVarToFeatureVector(_current_elem->id());

  // // loop over the active OPs
  // for (auto op_index = beginIndex(op_to_grains); op_index < op_to_grains.size(); ++op_index)
  // {
  //   auto grain_id = op_to_grains[op_index];
  //   if (grain_id == FeatureFloodCount::invalid_id)
  //     continue;

  //   // Interpolation factor for the dislocation density - this goes between 0 and 1 if eta is 0 or 1
  //   Real n = (*_vals[op_index])[_qp];
  //   Real h = n * n;

  //   _gb_misorientation[_qp] += _gb_misorientation[_qp] * h;

  //   sum_h += h;
  // }

  // // Normalize the sum of order parameters = 1
  // const Real tol = 1.0e-5;
  // sum_h = std::max(sum_h, tol);
  // _gb_misorientation[_qp] /= sum_h;

  GenericReal<is_ad> lagb = _gb_misorientation[_qp] / _angle_threshold;
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

// explicit instantiation
template class MisorientationDependentPropertiesTempl<true>;
template class MisorientationDependentPropertiesTempl<false>;
