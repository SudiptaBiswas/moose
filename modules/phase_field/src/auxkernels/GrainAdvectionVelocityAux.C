/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "GrainAdvectionVelocityAux.h"

template<>
InputParameters validParams<GrainAdvectionVelocityAux>()
{
  InputParameters params = validParams<AuxKernel>();
  params.addClassDescription("Calculation the advection velocity of grain due to rigid vody translation and rotation");
  params.addParam<Real>("translation_constant", 500, "constant value characterizing grain translation");
  params.addParam<Real>("rotation_constant", 1.0, "constant value characterizing grain rotation");
  params.addParam<UserObjectName>("grain_data", "userobject for getting volume and center of mass of grains");
  params.addParam<UserObjectName>("grain_force", "userobject for getting force and torque acting on grains");
  MooseEnum component("x=0 y=1 z=2");
  params.addParam<MooseEnum>("component", component, "The gradient component to compute");
  return params;
}

GrainAdvectionVelocityAux::GrainAdvectionVelocityAux(const InputParameters & parameters) :
   AuxKernel(parameters),
   _grain_tracker(getUserObject<GrainTrackerInterface>("grain_data")),
   _grain_force_torque(getUserObject<GrainForceAndTorqueInterface>("grain_force")),
   _grain_forces(_grain_force_torque.getForceValues()),
   _grain_torques(_grain_force_torque.getTorqueValues()),
   _mt(getParam<Real>("translation_constant")),
   _mr(getParam<Real>("rotation_constant")),
   _component(getParam<MooseEnum>("component"))
{
}

void
GrainAdvectionVelocityAux::precalculateValue()
{
  // ID of unique grain at current point
  const int grain_id = _grain_tracker.getEntityValue((isNodal() ? _current_node->id() : _current_elem->id()),
                                                              FeatureFloodCount::FieldType::UNIQUE_REGION, 0);
  if (grain_id >= 0)
  {
    const auto volume = _grain_tracker.getGrainVolume(grain_id);
    const auto centroid = _grain_tracker.getGrainCentroid(grain_id);

    const RealGradient velocity_translation =  _grain_forces[grain_id] / volume;
    const RealGradient velocity_rotation = (_grain_torques[grain_id].cross(_current_elem->centroid() - centroid)) / volume;
    _velocity_advection = velocity_translation + velocity_rotation;
  }
  else
    _velocity_advection.zero();
}

Real
GrainAdvectionVelocityAux::computeValue()
{
  return _velocity_advection(_component);
}
