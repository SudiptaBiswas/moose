/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "SingleGrainRigidBodyMotion.h"

template<>
InputParameters validParams<SingleGrainRigidBodyMotion>()
{
  InputParameters params = validParams<GrainRigidBodyMotionBase>();
  params.addClassDescription("Adds rigid mody motion to a single grain");
  params.addParam<unsigned int>("op_index",0, "Grain number for the kernel to be applied");
  return params;
}

SingleGrainRigidBodyMotion::SingleGrainRigidBodyMotion(const InputParameters & parameters) :
    GrainRigidBodyMotionBase(parameters),
    _op_index(getParam<unsigned int>("op_index"))
{
}

Real
SingleGrainRigidBodyMotion::computeQpResidual()
{
  return _velocity_advection[_qp][_op_index] * _grad_u[_qp] * _test[_i][_qp]
         + _div_velocity_advection[_qp][_op_index] * _u[_qp] * _test[_i][_qp];
}

Real
SingleGrainRigidBodyMotion::computeQpJacobian()
{
  std::vector<dof_id_type> vals_dof = getVar("v", _op_index)->dofIndices();

  return _velocity_advection[_qp][_op_index] * _grad_phi[_j][_qp] * _test[_i][_qp]
         + _velocity_advection_derivative_eta[_qp][_op_index] * _grad_u[_qp] * _phi[_j][_qp] *  _test[_i][_qp]
         + _div_velocity_advection[_qp][_op_index] * _phi[_j][_qp] * _test[_i][_qp]
         + _velocity_advection_derivative_eta[_qp][_op_index] * _u[_qp] * _grad_phi[_j][_qp] *  _test[_i][_qp]
        // + _velocity_advection[_qp][_op_index] / _u[_qp] * _grad_phi[_j][_qp] * _test[_i][_qp]
         + (*_velocity_advection_derivative_gradeta[_op_index])[_qp][_op_index][vals_dof[_j]] * _grad_u[_qp] * _test[_i][_qp]
         + (*_div_velocity_advection_derivative_gradeta[_op_index])[_qp][_op_index][vals_dof[_j]] * _u[_qp] * _test[_i][_qp];

}

Real
SingleGrainRigidBodyMotion::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (jvar == _c_var)
    return _velocity_advection_derivative_c[_qp][_op_index][_c_dof[_j]] * _grad_u[_qp] * _test[_i][_qp]
           + _div_velocity_advection_derivative_c[_qp][_op_index][_c_dof[_j]] * _u[_qp] * _test[_i][_qp];

  for (unsigned int i=0; i<_ncrys; ++i)
  {
    if (i != _op_index)
    {
      std::vector<dof_id_type> vals_dof = getVar("v", i)->dofIndices();

      if (jvar == _vals_var[i])
        return //_velocity_advection_derivative_eta[_qp][i] * _grad_u[_qp] * _phi[_j][_qp] * _test[_i][_qp]
               (*_velocity_advection_derivative_gradeta[i])[_qp][_op_index][vals_dof[_j]] * _grad_u[_qp] * _test[_i][_qp]
               + (*_div_velocity_advection_derivative_gradeta[i])[_qp][_op_index][vals_dof[_j]] * _u[_qp] * _test[_i][_qp];
    }
  }

  return 0.0;
}
