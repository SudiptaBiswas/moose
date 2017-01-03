/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef OLDSINGLEGRAINRIGIDBODYMOTION_H
#define OLDSINGLEGRAINRIGIDBODYMOTION_H

#include "OldGrainRigidBodyMotionBase.h"

//Forward Declarations
class OldSingleGrainRigidBodyMotion;

template<>
InputParameters validParams<OldSingleGrainRigidBodyMotion>();

class OldSingleGrainRigidBodyMotion : public OldGrainRigidBodyMotionBase
{
public:
  OldSingleGrainRigidBodyMotion(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  virtual void calculateAdvectionVelocity();

  /// Grain number for the kernel to be applied
  unsigned int _op_index;
};

#endif //OLDSINGLEGRAINRIGIDBODYMOTION_H
