/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef OLDMULTIGRAINRIGIDBODYMOTION_H
#define OLDMULTIGRAINRIGIDBODYMOTION_H

#include "OldGrainRigidBodyMotionBase.h"

//Forward Declarations
class OldMultiGrainRigidBodyMotion;

template<>
InputParameters validParams<OldMultiGrainRigidBodyMotion>();

class OldMultiGrainRigidBodyMotion : public OldGrainRigidBodyMotionBase
{
public:
  OldMultiGrainRigidBodyMotion(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int /*jvar*/);

  virtual void calculateAdvectionVelocity();
};

#endif //OLDMULTIGRAINRIGIDBODYMOTION_H
