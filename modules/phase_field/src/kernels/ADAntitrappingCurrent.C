//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ADAntitrappingCurrent.h"

registerMooseObject("PhaseFieldApp", ADAntitrappingCurrent);

InputParameters
ADAntitrappingCurrent::validParams()
{
  InputParameters params = ADTimeKernelGrad::validParams();
  params.addClassDescription(
      "Kernel that provides antitrapping current at the interface for alloy solidification");
  params.addRequiredCoupledVar("v", "Coupled variable");
  params.addRequiredParam<MaterialPropertyName>(
      "f_name", "Susceptibility function F defined in a FunctionMaterial");
  return params;
}

ADAntitrappingCurrent::ADAntitrappingCurrent(const InputParameters & parameters)
  : ADTimeKernelGrad(parameters),
    _v_dot(adCoupledDot("v")),
    _grad_v(adCoupledGradient("v")),
    _F(getADMaterialProperty<Real>("f_name"))
{
}

ADRealVectorValue
ADAntitrappingCurrent::precomputeQpResidual()
{
  const ADReal norm_sq = _grad_v[_qp].norm_sq();
  if (norm_sq < libMesh::TOLERANCE)
    return 0.0;

  return _F[_qp] * _v_dot[_qp] * _grad_v[_qp] / std::sqrt(norm_sq);
}
