//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "GrainMisorientation.h"
#include "GrainTrackerInterface.h"
#include "GrainForceAndTorqueInterface.h"
#include "RotationTensor.h"
#include "SystemBase.h"

registerMooseObject("PhaseFieldApp", GrainMisorientation);

InputParameters
GrainMisorientation::validParams()
{
  InputParameters params = GeneralUserObject::validParams();
  params.addClassDescription(
      "calculates the misorientation angle between grains, based on the euler angles");
  params.addRequiredParam<UserObjectName>("grain_tracker_object",
                                          "The FeatureFloodCount UserObject to get values from.");
  params.addRequiredParam<UserObjectName>("euler_angle_provider",
                                          "Name of Euler angle provider user object");
  return params;
}

GrainMisorientation::GrainMisorientation(const InputParameters & params)
  : GeneralUserObject(params),
    _grain_tracker(getUserObject<GrainTrackerInterface>("grain_tracker_object")),
    _euler(getUserObject<EulerAngleProvider>("euler_angle_provider")),
    _first_time(true)
{
}

void
GrainMisorientation::initialize()
{
  const auto grain_num = _grain_tracker.getTotalFeatureCount();

  if (_first_time)
  {
    _angles.resize(grain_num);
    for (unsigned int i = 0; i < grain_num; ++i)
      _angles[i] = _euler.getEulerAngles(i); // Read initial euler angles
  }

  unsigned int angle_size = _angles.size();
  for (unsigned int i = angle_size; i < grain_num; ++i) // if new grains are created
    _angles.push_back(_euler.getEulerAngles(i));        // Assign initial euler angles

  for (unsigned int i = 0; i < grain_num; ++i)
    for (unsigned int j = i + 1; j < grain_num; ++j)
    {
      auto rot1 = RotationTensor(RealVectorValue(_angles[i]));
      auto rot2 = RotationTensor(RealVectorValue(_angles[j]));

      // RotationTensor rot = rot2 * rot1.inverse()
      RotationTensor rot = rot2;
    }

  _first_time = false;
}

unsigned int
GrainMisorientation::getGrainNum() const
{
  return _angles.size();
}

const EulerAngles &
GrainMisorientation::getEulerAngles(unsigned int i) const
{
  mooseAssert(i < getGrainNum(), "Requesting Euler angles for an invalid grain id");
  return _angles[i];
}
