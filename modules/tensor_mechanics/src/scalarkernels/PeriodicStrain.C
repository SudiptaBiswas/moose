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
    _pst(getUserObject<PeriodicStrainUserObject>("periodic_strain"))
{
}

void
PeriodicStrain::computeResidual()
{
  DenseVector<Number> & re = _assembly.residualBlock(_var.number());
  for (_i = 0; _i < re.size(); ++_i)
    re(_i) += _pst.returnResidual(_i);
}

/**
 * method to provide the diagonal jacobian term for scalar variable using value
 * returned from Postprocessor, off diagonal terms are computed by computeOffDiagJacobianScalar
 * in the kernel of nonlinear variables which needs to couple with the scalar variable
 */
void
PeriodicStrain::computeJacobian()
{
  DenseMatrix<Number> & ke = _assembly.jacobianBlock(_var.number(), _var.number());
  for (_i = 0; _i < ke.m(); ++_i)
    ke(_i, _i) += _pst.returnJacobian(_i);
}
