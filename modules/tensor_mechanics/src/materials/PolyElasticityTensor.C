/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "PolyElasticityTensor.h"
#include "RotationTensor.h"

template<>
InputParameters validParams<PolyElasticityTensor>()
{
  InputParameters params = validParams<ComputeRotatedElasticityTensorBase>();
  params.addClassDescription("Compute elasticity tensor for poycrystalline.");
  params.addCoupledVar("v", "Order parameters");
  params.addRequiredParam<std::vector<Real> >("C_ijkl", "Stiffness tensor for material");
  params.addParam<MooseEnum>("fill_method", RankFourTensor::fillMethodEnum() = "symmetric9", "The fill method");
  params.addRequiredParam<std::vector<Real> >("C_ijkl_GB", "Stiffness tensor for GB");
  params.addParam<MooseEnum>("fill_method_GB", RankFourTensor::fillMethodEnum() = "symmetric9", "The fill method");
  return params;
}

PolyElasticityTensor::PolyElasticityTensor(const InputParameters & parameters) :
    ComputeRotatedElasticityTensorBase(parameters),
    _Cijkl(getParam<std::vector<Real> >("C_ijkl"), (RankFourTensor::FillMethod)(int)getParam<MooseEnum>("fill_method")),
    _Cijkl_GB(getParam<std::vector<Real> >("C_ijkl_GB"), (RankFourTensor::FillMethod)(int)getParam<MooseEnum>("fill_method_GB"))
{
  // Define a rotation according to Euler angle parameters
  RotationTensor R(_Euler_angles); // R type: RealTensorValue

  // rotate elasticity tensor
  _Cijkl.rotate(R);
  _Cijkl_GB.rotate(R);

  // Assign grain order parameters
  _n = coupledComponents("v");
  _vals.resize(_n);

  for (unsigned int i = 0; i < _n; ++i)
    _vals[i] = &coupledValue("v", i);
}

void
PolyElasticityTensor::computeQpElasticityTensor()
{
  Real bnds = 0.0;
  for (unsigned int i = 0; i < _n; ++i)
    bnds += (*_vals[i])[_qp] * (*_vals[i])[_qp];

  //Assign elasticity tensor at a given quad point
  if (bnds > 0.999)
    _elasticity_tensor[_qp] = _Cijkl;
  else
    _elasticity_tensor[_qp] = _Cijkl_GB;
}
