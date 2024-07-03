//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "GrainTrackerEulerAngles.h"
#include "EulerAngleProvider.h"

registerMooseObject("PhaseFieldApp", GrainTrackerEulerAngles);

InputParameters
GrainTrackerEulerAngles::validParams()
{
  InputParameters params = GrainTracker::validParams();
  params.addParam<bool>("random_rotations",
                        true,
                        "Generate random rotations when the Euler Angle "
                        "provider runs out of data (otherwise error "
                        "out)");
  params.addRequiredParam<UserObjectName>("euler_angle_provider",
                                          "Name of Euler angle provider user object");
  params.addCoupledVar("euler_angle_variables",
                       "Vector of coupled variables representing the Euler angles' components.");
  return params;
}

GrainTrackerEulerAngles::GrainTrackerEulerAngles(const InputParameters & parameters)
  : GrainDataTracker<EulerAngles>(parameters),
    _random_rotations(getParam<bool>("random_rotations")),
    _euler(getUserObject<EulerAngleProvider>("euler_angle_provider")),
    // _n_euler_angle_vars(coupledComponents("euler_angle_variables")),
    // _euler_angle_vars(coupledValues("euler_angle_variables")),
    _first_time(true)
{
}

EulerAngles
GrainTrackerEulerAngles::newGrain(unsigned int new_grain_id)
{
  EulerAngles angles;
  if (_first_time)
  {
    if (new_grain_id < _euler.getGrainNum())
      angles = _euler.getEulerAngles(new_grain_id);
    else
    {
      if (_random_rotations)
        angles.random();
      else
        mooseError("GrainTrackerEulerAngles has run out of grain orientation data.");
    }
  }
  _first_time = false;
  return angles;
}
