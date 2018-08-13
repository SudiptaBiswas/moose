//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ComputeIncrementalEigenstrain.h"

registerMooseObject("TensorMechanicsApp", ComputeIncrementalEigenstrain);

template <>
InputParameters
validParams<ComputeIncrementalEigenstrain>()
{
  InputParameters params = validParams<ComputeEigenstrainBase>();
  params.addClassDescription(
      "Computes eigenstrain and its increment based on the eigenstrain rate components "
      "provided as functions.");
  params.addRequiredParam<std::vector<FunctionName>>(
      "eigenstrain_rate_functions",
      "Name of the functions that define the eigenstrain rate components. "
      "It will be used to form the RankTwoTensor providing the eigenstrain rate");
  return params;
}

ComputeIncrementalEigenstrain::ComputeIncrementalEigenstrain(const InputParameters & parameters)
  : ComputeEigenstrainBase(parameters),
    _eigenstrain_rate_input(getParam<std::vector<FunctionName>>("eigenstrain_rate_functions")),
    _eigenstrain_old(getMaterialPropertyOld<RankTwoTensor>(_eigenstrain_name)),
    _eigenstrain_increment(declareProperty<RankTwoTensor>(_eigenstrain_name + "_increment")),
    _input_num(_eigenstrain_rate_input.size()),
    _eigenstrain_rate_functions(_input_num)
{
  for (unsigned int i = 0; i < _input_num; i++)
    _eigenstrain_rate_functions[i] = &getFunctionByName(_eigenstrain_rate_input[i]);
}

void
ComputeIncrementalEigenstrain::initQpStatefulProperties()
{
  ComputeEigenstrainBase::initQpStatefulProperties();
  _eigenstrain_increment[_qp].zero();
}

void
ComputeIncrementalEigenstrain::computeQpEigenstrain()
{
  std::vector<Real> eigenstrain_rate_values(_input_num);
  for (unsigned int i = 0; i < _input_num; i++)
    eigenstrain_rate_values[i] = (*_eigenstrain_rate_functions[i]).value(_t, _q_point[_qp]);

  RankTwoTensor eigenstrain_rate;
  eigenstrain_rate.fillFromInputVector(eigenstrain_rate_values);

  _eigenstrain_increment[_qp] = eigenstrain_rate * _dt;

  // Define Eigenstrain
  _eigenstrain[_qp] = _eigenstrain_old[_qp] + _eigenstrain_increment[_qp];
}
