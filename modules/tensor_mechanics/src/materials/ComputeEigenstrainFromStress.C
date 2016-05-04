/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#include "ComputeEigenstrainFromStress.h"

template<>
InputParameters validParams<ComputeEigenstrainFromStress>()
{
  InputParameters params = validParams<ComputeStressFreeStrainBase>();
  params.addClassDescription("Computes a constant Eigenstrain");
  params.addRequiredParam<std::vector<Real> >("applied_stress", "Vector of values defining the constant base tensor for the Eigenstrain");
  params.addParam<MaterialPropertyName>("prefactor", 1.0, "Name of material defining the variable dependence");
  params.addRequiredParam<std::vector<Real> >("C_ijkl", "Stiffness tensor for material");
  params.addParam<MooseEnum>("fill_method", RankFourTensor::fillMethodEnum() = "symmetric9", "The fill method");
  return params;
}

ComputeEigenstrainFromStress::ComputeEigenstrainFromStress(const InputParameters & parameters) :
    ComputeStressFreeStrainBase(parameters),
    _prefactor(getMaterialProperty<Real>("prefactor")),
    _Cijkl(getParam<std::vector<Real> >("C_ijkl"), (RankFourTensor::FillMethod)(int)getParam<MooseEnum>("fill_method")),
    _applied_stress_tensor(getParam<std::vector<Real> >("applied_stress")),
    _eigen_strain(_Cijkl.invSymm()*_applied_stress_tensor)
{
}

void
ComputeEigenstrainFromStress::computeQpStressFreeStrain()
{
  // Define Eigenstrain
  _stress_free_strain[_qp] = _eigen_strain * _prefactor[_qp];
}
