//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "PeriodicStrain.h"

// MOOSE includes
#include "Assembly.h"
#include "PeriodicStrainUserObject.h"
#include "MooseVariableScalar.h"
#include "SystemBase.h"

registerMooseObject("TensorMechanicsApp", PeriodicStrain);

template <>
InputParameters
validParams<PeriodicStrain>()
{
  InputParameters params = validParams<ScalarKernel>();
  params.addClassDescription("Periodic Strain Scalar Kernel");
  params.addRequiredParam<UserObjectName>("periodic_strain",
                                          "The name of the PeriodicStrainUserObject");
  params.addParam<unsigned int>(
      "scalar_out_of_plane_strain_index",
      "The index number of scalar_out_of_plane_strain this kernel acts on");

  return params;
}

PeriodicStrain::PeriodicStrain(const InputParameters & parameters)
  : ScalarKernel(parameters),
    _pst(getUserObject<PeriodicStrainUserObject>("periodic_strain")),
    _pst_residual(_pst.getResidual()),
    _pst_jacobian(_pst.getJacobian()),
    _components(_var.order())
{
  computeComponentIndex(_var.order());
}

void
PeriodicStrain::computeResidual()
{
  DenseVector<Number> & re = _assembly.residualBlock(_var.number());
  for (_i = 0; _i < re.size(); ++_i)
    re(_i) += _pst_residual(_components[_i].first,_components[_i].second);
}

void
PeriodicStrain::computeJacobian()
{
  DenseMatrix<Number> & ke = _assembly.jacobianBlock(_var.number(), _var.number());
  for (_i = 0; _i < ke.m(); ++_i)
    ke(_i, _i) += _pst_jacobian(_components[_i].first,_components[_i].second);
}

void
PeriodicStrain::computeComponentIndex(Order var_order)
{
  if (var_order == 1)
  {
    _components[0].first = 0;
    _components[0].second = 0;
  }
  else if (var_order == 3)
  {
    _components[0].first = 0;
    _components[0].second = 0;
    _components[1].first = 1;
    _components[1].second = 1;
    _components[2].first = 0;
    _components[2].second = 1;
  }
  else if (var_order == 6)
  {
    _components[0].first = 0;
    _components[0].second = 0;
    _components[1].first = 1;
    _components[1].second = 1;
    _components[2].first = 2;
    _components[2].second = 2;
    _components[3].first = 1;
    _components[3].second = 2;
    _components[4].first = 0;
    _components[4].second = 2;
    _components[5].first = 0;
    _components[5].second = 1;
  }
  else if (var_order == 9)
  {
    _components[0].first = 0;
    _components[0].second = 0;
    _components[1].first = 1;
    _components[1].second = 0;
    _components[2].first = 2;
    _components[2].second = 0;
    _components[3].first = 0;
    _components[3].second = 1;
    _components[4].first = 1;
    _components[4].second = 1;
    _components[5].first = 2;
    _components[5].second = 1;
    _components[6].first = 0;
    _components[6].second = 2;
    _components[7].first = 1;
    _components[7].second = 2;
    _components[8].first = 2;
    _components[8].second = 2;
  }
  else
    mooseError("PerdiodicStrain ScalarKernel is only compatible with variables of order 1, 3, 6, and 9. Please change order of the scalar variable.");
}
