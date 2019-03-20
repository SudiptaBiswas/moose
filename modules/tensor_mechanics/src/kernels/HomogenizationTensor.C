//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "HomogenizationTensor.h"

registerMooseObject("TensorMechanicsApp", HomogenizationTensor);

template <>
InputParameters
validParams<HomogenizationTensor>()
{
  InputParameters params = validParams<ALEKernel>();
  params.addRequiredRangeCheckedParam<unsigned int>("component",
                                                    "component >= 0 & component < 3",
                                                    "An integer corresponding to the direction "
                                                    "the variable this kernel acts in. (0 for x, "
                                                    "1 for y, 2 for z)");
  params.addRequiredRangeCheckedParam<unsigned int>(
      "index_k",
      "index_k >= 0 & index_k <= 2",
      "The index k of ijkl for the tensor to output (0, 1, 2)");
  params.addRequiredRangeCheckedParam<unsigned int>(
      "index_l",
      "index_l >= 0 & index_l <= 2",
      "The index l of ijkl for the tensor to output (0, 1, 2)");
  params.addParam<std::string>("base_name", "Material property base name");
  params.set<bool>("use_displaced_mesh") = false;

  return params;
}

HomogenizationTensor::HomogenizationTensor(const InputParameters & parameters)
  : ALEKernel(parameters),
    _base_name(isParamValid("base_name") ? getParam<std::string>("base_name") + "_" : ""),
    _elasticity_tensor(getMaterialPropertyByName<RankFourTensor>(_base_name + "elasticity_tensor")),
    _component(getParam<unsigned int>("component")),
    _k(getParam<unsigned int>("index_k")),
    _l(getParam<unsigned int>("index_l"))
{
}

Real
HomogenizationTensor::computeQpResidual()
{
  Real value(0);

  // Compute positive value since we are computing a residual not a rhs
  for (unsigned j = 0; j < 3; j++)
    value += _elasticity_tensor[_qp](_component, j, _k, _l) * _grad_test[_i][_qp](j);

  return value;
}
