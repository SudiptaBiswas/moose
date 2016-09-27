/****************************************************************/
/*               DO NOT MODIFY THIS HEADER                      */
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*           (c) 2010 Battelle Energy Alliance, LLC             */
/*                   ALL RIGHTS RESERVED                        */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*            Under Contract No. DE-AC07-05ID14517              */
/*            With the U. S. Department of Energy               */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/

#include "IntegroDiffKernel.h"

template<>
InputParameters validParams<IntegroDiffKernel>()
{
  InputParameters params = validParams<NonlocalKernel>();
  params.addRequiredParam<UserObjectName>("user_object", "Name of a SimpleTestShapeElementUserObject");
  return params;
}

IntegroDiffKernel::IntegroDiffKernel(const InputParameters & parameters) :
    NonlocalKernel(parameters),
    _shp(getUserObject<ShapeElementUserObjectTest>("user_object")),
    _shp_integral(_shp.getIntegral()),
    _shp_jacobian(_shp.getJacobian()),
    _var_dofs(_var.dofIndices())
{
}

Real
IntegroDiffKernel::computeQpResidual()
{
  return _grad_test[_i][_qp] * _grad_u[_qp] * (1.0 + _shp_integral * _t);
}

Real
IntegroDiffKernel::computeQpJacobian()
{
  return _grad_test[_i][_qp] * _grad_phi[_j][_qp] * (1.0 + _shp_integral * _t)
         + _grad_test[_i][_qp] * _grad_u[_qp] * _shp_jacobian[_var_dofs[_j]] * _t;
}

Real
IntegroDiffKernel::computeQpNonlocalJacobian(dof_id_type dof_index)
{
  return _grad_test[_i][_qp] * _grad_u[_qp] * _shp_jacobian[dof_index] * _t;
}
