/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "UpdateEulerAngle.h"

template<>
InputParameters validParams<UpdateEulerAngle>()
{
  InputParameters params = validParams<EulerAngleProvider>();
  params.addRequiredParam<UserObjectName>("grain_tracker_object", "The FeatureFloodCount UserObject to get values from.");
  params.addRequiredParam<UserObjectName>("euler_angle_provider", "Name of Euler angle provider user object");
  params.addRequiredParam<UserObjectName>("grain_torques_object", "Name of Euler angle provider user object");
  params.addParam<VectorPostprocessorName>("grain_volumes", "The feature volume VectorPostprocessorValue.");
  params.addParam<Real>("rotation_constant", 1.0, "constant value characterizing grain rotation");
  params.addClassDescription("Update euler angles depending on the rigid body rotationn of grains.");
  return params;
}

UpdateEulerAngle::UpdateEulerAngle(const InputParameters & params) :
    EulerAngleProvider(params),
    _grain_tracker(getUserObject<GrainTrackerInterface>("grain_tracker_object")),
    _euler(getUserObject<EulerAngleProvider>("euler_angle_provider")),
    _grain_torque(getUserObject<GrainForceAndTorqueInterface>("grain_torques_object")),
    _grain_volumes(getVectorPostprocessorValue("grain_volumes", "feature_volumes")),
    _mr(getParam<Real>("rotation_constant")),
    _first_time(true)
{
}

void
UpdateEulerAngle::initialize()
{
  _grain_num = _grain_tracker.getTotalFeatureCount();
  _torque_old.assign(_grain_num, 0.0);
  _angles_old.resize(_grain_num);
  if (_first_time)
  {
    _angles.resize(_grain_num);
    _torque.assign(_grain_num, 0.0);
    for (unsigned int i = 0; i < _grain_num; ++i)
      _angles[i] = _euler.getEulerAngles(i);
  }

  for (unsigned int i = 0; i < _grain_num; ++i)
  {
    _torque_old[i] = _torque[i];
    _angles_old[i] = _angles[i];
    _torque[i] = _grain_torque.getTorqueValues()[i];
  }
}

void
UpdateEulerAngle::execute()
{
  std::vector<RealGradient> torque_change(_grain_num);
  for (unsigned int i = 0; i < _grain_num; ++i)
  {
    torque_change[i] = _torque[i] - _torque_old[i];
    const auto volume = _grain_volumes[i];
    EulerAngles angle_change;
    angle_change.phi1 = _mr / volume * torque_change[i](0) * _dt;
    angle_change.Phi = _mr / volume * torque_change[i](1) * _dt;
    angle_change.phi2 = _mr / volume * torque_change[i](2) * _dt;

    _angles[i].phi1 = _angles_old[i].phi1 + angle_change.phi1;
    _angles[i].Phi = _angles_old[i].Phi + angle_change.Phi;
    _angles[i].phi2 = _angles_old[i].phi2 + angle_change.phi2;
  }
}

void
UpdateEulerAngle::finalize()
{
  // _communicator.gather(_angles);
  _first_time = false;
}

unsigned int
UpdateEulerAngle::getGrainNum() const
{
  return _angles.size();
}

const EulerAngles &
UpdateEulerAngle::getEulerAngles(unsigned int i) const
{
  mooseAssert(i < getGrainNum(), "Requesting Euler angles for an invalid grain id");
  return _angles[i];
}
