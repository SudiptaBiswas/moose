/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "GrainTrackerInterface.h"
#include "OldMultiGrainRigidBodyMotion.h"

template <>
InputParameters validParams<OldMultiGrainRigidBodyMotion>()
{
  InputParameters params = validParams<OldGrainRigidBodyMotionBase>();
  params.addClassDescription("Adds rigid mody motion to grains");
  return params;
}

OldMultiGrainRigidBodyMotion::OldMultiGrainRigidBodyMotion(const InputParameters & parameters) :
    OldGrainRigidBodyMotionBase(parameters)
{
}

Real
OldMultiGrainRigidBodyMotion::computeQpResidual()
{
  return _velocity_advection * _grad_c[_qp] * _test[_i][_qp];
}

Real
OldMultiGrainRigidBodyMotion::computeQpJacobian()
{
  if (_var.number() == _c_var) //Requires c jacobian
    return _velocity_advection * _grad_phi[_j][_qp] * _test[_i][_qp] + _velocity_advection_derivative_c * _grad_c[_qp] * _phi[_j][_qp] * _test[_i][_qp];

  return 0.0;
}

Real
OldMultiGrainRigidBodyMotion::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (jvar == _c_var) //Requires c jacobian
    return _velocity_advection * _grad_phi[_j][_qp] * _test[_i][_qp] + _velocity_advection_derivative_c * _grad_c[_qp] * _phi[_j][_qp] * _test[_i][_qp];

  for (unsigned int jvar_index = 0; jvar_index < _op_num; ++jvar_index)
    if (jvar == _vals_var[jvar_index])
      // return _velocity_advection_derivative_eta[jvar_index].cross(_grad_phi[_j][_qp]) * _grad_c[_qp] * _test[_i][_qp];
      return _velocity_advection_derivative_eta[jvar_index] * _phi[_j][_qp] * _grad_c[_qp] * _test[_i][_qp];

  return 0.0;
}

void
OldMultiGrainRigidBodyMotion::calculateAdvectionVelocity()
{
  _velocity_advection = 0.0;
  _velocity_advection_derivative_c = 0.0;
  _velocity_advection_derivative_eta.assign(_op_num, 0.0);
  _grain_ids = _grain_tracker.getVarToFeatureVector(_current_elem->id());

  for (auto i = beginIndex(_grain_ids); i < _grain_ids.size(); ++i)
  {
    auto grain_id = _grain_ids[i];
    if (grain_id != FeatureFloodCount::invalid_id)
    {
      mooseAssert(grain_id < _grain_volumes.size(), "grain_id out of bounds");
      const auto volume = _grain_volumes[grain_id];
      const auto centroid = _grain_tracker.getGrainCentroid(grain_id);
      const auto force = _mt / volume * _grain_forces[grain_id];
      const auto torque = _mr / volume * (_grain_torques[grain_id].cross(_current_elem->centroid() - centroid));
      const auto velocity_translation_derivative_c = _mt / volume * _grain_force_c_derivatives[grain_id];
      const auto velocity_rotation_derivative_c = _mr / volume * (_grain_torque_c_derivatives[grain_id].cross(_current_elem->centroid() - centroid));

      for (unsigned int i = 0; i < _op_num; ++i)
      {
        const auto velocity_translation_derivative_eta = _mt / volume * _grain_force_eta_derivatives[i][grain_id];
        const auto velocity_rotation_derivative_eta = _mr / volume * (_grain_torque_eta_derivatives[i][grain_id].cross(_current_elem->centroid() - centroid));
        _velocity_advection_derivative_eta[i] += velocity_translation_derivative_eta + velocity_rotation_derivative_eta;
      }
      _velocity_advection += (force + torque);
      _velocity_advection_derivative_c += (velocity_translation_derivative_c + velocity_rotation_derivative_c);
    }
  }
}
