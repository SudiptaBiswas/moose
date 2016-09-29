/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef GRAINADVECTIONVELOCITYAUX_H
#define GRAINADVECTIONVELOCITYAUX_H

#include "AuxKernel.h"
#include "GrainTrackerInterface.h"
#include "GrainForceAndTorqueInterface.h"
// #include "DerivativeMaterialInterface.h"

//Forward Declarations
class GrainAdvectionVelocityAux;

template<>
InputParameters validParams<GrainAdvectionVelocityAux>();

/**
 * This Material calculates the advection velocity, it's divergence and
 * derivatives acting on a particle/grain
 */
class GrainAdvectionVelocityAux : public AuxKernel
{
public:
  GrainAdvectionVelocityAux(const InputParameters & parameters);

protected:
  virtual void precalculateValue();
  /// obtain total no. of grains from GrainTracker
  virtual Real computeValue();

  /// getting userobject for calculating grain centers and volumes
  const GrainTrackerInterface & _grain_tracker;

  /// getting userobject for calculating grain forces and torques
  const GrainForceAndTorqueInterface & _grain_force_torque;
  const std::vector<RealGradient> & _grain_forces;
  const std::vector<RealGradient> & _grain_torques;

private:
  /// constant value corresponding to grain translation
  Real _mt;

  /// constant value corresponding to grain rotation
  Real _mr;

  RealGradient _velocity_advection;
  MooseEnum _component;
};

#endif //GRAINADVECTIONVELOCITYAUXAUX_H
