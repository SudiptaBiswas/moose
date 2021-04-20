//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ADAnisotropicReturnPlasticityStressUpdateBase.h"

InputParameters
ADAnisotropicReturnPlasticityStressUpdateBase::validParams()
{
  InputParameters params = ADGeneralizedRadialReturnStressUpdate::validParams();
  params.set<std::string>("effective_inelastic_strain_name") = "effective_creep_strain";
  params.set<std::string>("inelastic_strain_rate_name") = "creep_strain_rate";
  // params.addParam<Real>(
  //     "orientation_angle",
  //     0.0,
  //     "Provide the orientation angle of the principal material axis with respect to y-axis");
  return params;
}

ADAnisotropicReturnPlasticityStressUpdateBase::ADAnisotropicReturnPlasticityStressUpdateBase(
    const InputParameters & parameters)
  : ADGeneralizedRadialReturnStressUpdate(parameters),
    _plasticity_strain(declareADProperty<RankTwoTensor>(_base_name + "plastic_strain")),
    _plasticity_strain_old(getMaterialPropertyOld<RankTwoTensor>(_base_name + "plastic_strain"))
// _angle(getParam<Real>("orientation_angle")),
// _transformation_tensor(6, 6)
{
}

void
ADAnisotropicReturnPlasticityStressUpdateBase::initQpStatefulProperties()
{
  _plasticity_strain[_qp].zero();

  ADGeneralizedRadialReturnStressUpdate::initQpStatefulProperties();
}

void
ADAnisotropicReturnPlasticityStressUpdateBase::propagateQpStatefulProperties()
{
  _plasticity_strain[_qp] = _plasticity_strain_old[_qp];

  propagateQpStatefulPropertiesRadialReturn();
}

void
ADAnisotropicReturnPlasticityStressUpdateBase::computeStrainFinalize(
    ADRankTwoTensor & inelasticStrainIncrement,
    const ADRankTwoTensor & /*stress*/,
    const ADDenseVector & /*stress_dev*/,
    const ADReal & /*delta_gamma*/)
{
  _plasticity_strain[_qp] = _plasticity_strain_old[_qp] + inelasticStrainIncrement;
}

// void
// ADAnisotropicReturnPlasticityStressUpdateBase::rotateHillTensor(ADDenseMatrix & hill_tensor)
// {
//   _transformation_tensor.zero();
//
//   const Real s = std::sin(_angle * libMesh::pi / 180.0);
//   const Real c = std::cos(_angle * libMesh::pi / 180.0);
//
//   // the matrix is filled in rowwise
//   _transformation_tensor(0, 0) = 1.0;
//
//   _transformation_tensor(1, 1) = c * c;
//   _transformation_tensor(1, 2) = s * s;
//   _transformation_tensor(1, 5) = c * s;
//
//   _transformation_tensor(2, 1) = s * s;
//   _transformation_tensor(2, 2) = c * c;
//   _transformation_tensor(2, 5) = -c * s;
//
//   _transformation_tensor(3, 3) = c;
//   _transformation_tensor(3, 4) = -s;
//
//   _transformation_tensor(4, 3) = s;
//   _transformation_tensor(4, 4) = c;
//
//   _transformation_tensor(5, 1) = -2.0 * c * s;
//   _transformation_tensor(5, 2) = 2.0 * c * s;
//   _transformation_tensor(5, 5) = c * c - s * s;
//
//   hill_tensor.right_multiply_transpose(_transformation_tensor);
//   hill_tensor.left_multiply(_transformation_tensor);
// }
