/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef MULTIGRAINRIGIDBODYMOTION_H
#define MULTIGRAINRIGIDBODYMOTION_H

#include "GrainRigidBodyMotionBase.h"

//Forward Declarations
class MultiGrainRigidBodyMotion;

template<>
InputParameters validParams<MultiGrainRigidBodyMotion>();

class MultiGrainRigidBodyMotion : public GrainRigidBodyMotionBase
{
public:
  MultiGrainRigidBodyMotion(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  virtual Real computeQpNonlocalJacobian(dof_id_type dof_index);
  virtual Real computeQpNonlocalOffDiagJacobian(unsigned int jvar, dof_id_type dof_index);

  virtual void calculateAdvectionVelocity();
  virtual void getUserObjectJacobian(unsigned int jvar, dof_id_type dof_index);

  RealGradient _velocity_advection;
  RealGradient _velocity_advection_jacobian_c;
  RealGradient _velocity_advection_jacobian_eta;
};

#endif //MULTIGRAINRIGIDBODYMOTION_H
