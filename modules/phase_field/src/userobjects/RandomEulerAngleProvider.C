/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "RandomEulerAngleProvider.h"

template<>
InputParameters validParams<RandomEulerAngleProvider>()
{
  InputParameters params = validParams<EulerAngleProvider>();
  params.addRequiredParam<UserObjectName>("grain_tracker_object", "The FeatureFloodCount UserObject to get values from.");
  params.addClassDescription("Assign random euler angles for each grain.");
  return params;
}

RandomEulerAngleProvider::RandomEulerAngleProvider(const InputParameters & params) :
    EulerAngleProvider(params),
    _grain_tracker(getUserObject<GrainTrackerInterface>("grain_tracker_object")),
    _first_time(true)
{
}

void
RandomEulerAngleProvider::initialize()
{
  EulerAngles angles;
  if (_first_time)
  {
    auto grain_num = _grain_tracker.getTotalFeatureCount();
    for (unsigned int i = 0; i < grain_num; ++i)
    {
      angles.random();
      _angles.push_back(angles);
    }
  }
  else
  {
    const auto & new_ids = _grain_tracker.getNewGrainIDs();
    if (new_ids.size() >= 1)
      for (unsigned int i = 0; i < new_ids.size(); ++i)
      {
        angles.random();
        _angles.push_back(angles);
      }
  }
}

void
RandomEulerAngleProvider::finalize()
{
  // _communicator.gather(_angles);
  _first_time = false;
}

unsigned int
RandomEulerAngleProvider::getGrainNum() const
{
  return _angles.size();
}

const EulerAngles &
RandomEulerAngleProvider::getEulerAngles(unsigned int i) const
{
  mooseAssert(i < getGrainNum(), "Requesting Euler angles for an invalid grain id");
  return _angles[i];
}
