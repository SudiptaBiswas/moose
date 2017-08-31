/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "PlasticEnergyMaterial.h"
#include "RankTwoTensor.h"
#include "RankFourTensor.h"

template<>
InputParameters validParams<PlasticEnergyMaterial>()
{
  InputParameters params = validParams<DerivativeFunctionMaterialBase>();
  params.addClassDescription("Free energy material for the plastic energy contributions.");
  params.addParam<std::string>("base_name", "Material property base name");
  params.addRequiredCoupledVar("args", "Arguments of F() - use vector coupling");
  params.addCoupledVar("displacement_gradients", "Vector of displacement gradient variables (see Modules/PhaseField/DisplacementGradients action)");
  params.addParam<MaterialPropertyName>("plastic_energy", "plastic_energy", "plastic energy material");
  return params;
}

PlasticEnergyMaterial::PlasticEnergyMaterial(const InputParameters & parameters) :
    DerivativeFunctionMaterialBase(parameters),
    _base_name(isParamValid("base_name") ? getParam<std::string>("base_name") + "_" : "" ),
    _stress(getMaterialPropertyByName<RankTwoTensor>(_base_name + "stress")),
    _elasticity_tensor(getMaterialPropertyByName<RankFourTensor>(_base_name + "elasticity_tensor")),
    _elastic_strain(getMaterialPropertyByName<RankTwoTensor>(_base_name + "mechanical_strain")),
    _total_strain(getMaterialPropertyByName<RankTwoTensor>(_base_name + "total_strain")),
    _plastic_strain(getMaterialPropertyByName<RankTwoTensor>(_base_name + "plastic_strain")),
    // _plastic_energy_name(_base_name + "elasticity_tensor"),
    _plastic_energy(declareProperty<Real>(_base_name + "plastic_energy")),
    _plastic_energy_old(getMaterialPropertyOldByName<Real>(_base_name + "plastic_energy"))
{
}

void
PlasticEnergyMaterial::initQpStatefulProperties()
{
  _plastic_energy[_qp] = 0.0;
}

Real
PlasticEnergyMaterial::computeF()
{
  // _plastic_energy[_qp] = _plastic_energy_old[_qp] + _stress[_qp].doubleContraction(_total_strain[_qp] - _elastic_strain[_qp]);
  _plastic_energy[_qp] = _plastic_energy_old[_qp] + _stress[_qp].doubleContraction(_plastic_strain[_qp]);

  return _plastic_energy[_qp];
}

Real
PlasticEnergyMaterial::computeDF(unsigned int /*i_var*/)
{
  return 0.0;
}

Real
PlasticEnergyMaterial::computeD2F(unsigned int /*i_var*/, unsigned int /*j_var*/)
{
  return 0.0;
}
