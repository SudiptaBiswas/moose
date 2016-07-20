/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "SingleGrainRigidBodyMotion.h"
#include "GrainTrackerInterface.h"

template<>
InputParameters validParams<SingleGrainRigidBodyMotion>()
{
  InputParameters params = validParams<GrainRigidBodyMotionBase>();
  params.addClassDescription("Adds rigid mody motion to a single grain");
  params.addParam<unsigned int>("op_index", 0, "Grain number for the kernel to be applied");
  // params.addParam<UserObjectName>("grain_tracker_object", "The FeatureFloodCount UserObject to get values from.");
  return params;
}

SingleGrainRigidBodyMotion::SingleGrainRigidBodyMotion(const InputParameters & parameters) :
    GrainRigidBodyMotionBase(parameters),
    // _grain_tracker(getUserObject<GrainTrackerInterface>("grain_tracker_object")),
    _op_index(getParam<unsigned int>("op_index"))
{
}

Real
SingleGrainRigidBodyMotion::computeQpResidual()
{
  unsigned int grain_num = _grain_tracker.getOpToGrainsVector(_current_elem->id())[_op_index];
  if (grain_num != libMesh::invalid_uint)
    return _velocity_advection[_qp][grain_num] * _grad_u[_qp] * _test[_i][_qp]
           + _div_velocity_advection[_qp][grain_num] * _u[_qp] * _test[_i][_qp];

  return 0.0;
}

Real
SingleGrainRigidBodyMotion::computeQpJacobian()
{
  unsigned int grain_num = _grain_tracker.getOpToGrainsVector(_current_elem->id())[_op_index];
  if (grain_num != libMesh::invalid_uint)
    return _velocity_advection[_qp][grain_num] * _grad_phi[_j][_qp] * _test[_i][_qp]
           + _velocity_advection_derivative_eta[_qp][grain_num] * _grad_u[_qp] * _phi[_j][_qp] *  _test[_i][_qp]
           + _div_velocity_advection[_qp][grain_num] * _phi[_j][_qp] * _test[_i][_qp];

  return 0.0;
}

Real
SingleGrainRigidBodyMotion::computeQpOffDiagJacobian(unsigned int jvar)
{
  unsigned int grain_num = _grain_tracker.getOpToGrainsVector(_current_elem->id())[_op_index];
  if (grain_num != libMesh::invalid_uint)
  {
    if (jvar == _c_var)
      return _velocity_advection_derivative_c[_qp][grain_num] * _grad_u[_qp] * _phi[_j][_qp] * _test[_i][_qp]
             + _div_velocity_advection_derivative_c[_qp][grain_num] * _u[_qp] * _phi[_j][_qp] * _test[_i][_qp];

    for (unsigned int i=0; i<_ncrys; ++i)
    {
      if (i != grain_num)
      {
        if (jvar == _vals_var[i])
          return _velocity_advection_derivative_eta[_qp][grain_num] * _grad_u[_qp] * _phi[_j][_qp] * _test[_i][_qp];
      }
    }
  }

  return 0.0;
}
