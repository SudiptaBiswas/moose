/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef UPDATEEULERANGLE_H
#define UPDATEEULERANGLE_H

#include "EulerAngleProvider.h"
#include "EulerAngles.h"
#include "GrainTrackerInterface.h"
#include "GrainForceAndTorqueInterface.h"

//Forward declaration
class UpdateEulerAngle;

template<>
InputParameters validParams<UpdateEulerAngle>();

/**
 * Assign random Euler angles to each grains
 */
class UpdateEulerAngle : public EulerAngleProvider
{
public:
  UpdateEulerAngle(const InputParameters & parameters);

  virtual void initialize() override;
  virtual void execute() override;
  virtual void finalize() override;

  virtual const EulerAngles & getEulerAngles(unsigned int) const override;
  virtual unsigned int getGrainNum() const override;

protected:
  const GrainTrackerInterface & _grain_tracker;
  const EulerAngleProvider & _euler;
  const GrainForceAndTorqueInterface & _grain_torque;
  const VectorPostprocessorValue & _grain_volumes;

  const Real _mr;
  bool _first_time;
  unsigned int _grain_num;

  std::vector<RealGradient> _torque;
  std::vector<RealGradient> _torque_old;
  std::vector<EulerAngles> _angles;
  std::vector<EulerAngles> _angles_old;
};

#endif //UPDATEEULERANGLE_H
