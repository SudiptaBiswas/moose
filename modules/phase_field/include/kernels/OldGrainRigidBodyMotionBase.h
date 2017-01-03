/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef OLDGRAINRIGIDBODYMOTIONBASE_H
#define OLDGRAINRIGIDBODYMOTIONBASE_H

#include "Kernel.h"
#include "OldComputeGrainForceAndTorque.h"

//Forward Declarations
class OldGrainRigidBodyMotionBase;
class GrainTrackerInterface;

template<>
InputParameters validParams<OldGrainRigidBodyMotionBase>();

class OldGrainRigidBodyMotionBase :
    public Kernel

{
public:
  OldGrainRigidBodyMotionBase(const InputParameters & parameters);

protected:
  virtual void precalculateResidual();
  virtual void precalculateJacobian();
  virtual void precalculateOffDiagJacobian(unsigned int jvar);

  virtual Real computeQpResidual() { return 0.0; }
  virtual Real computeQpJacobian() { return 0.0; }
  virtual Real computeQpOffDiagJacobian(unsigned int /* jvar */ ) { return 0.0; }

  virtual void calculateAdvectionVelocity() {}
  /// Variable's local dof indices
  // const std::vector<dof_id_type> & _var_dofs;

  /// int label for the Concentration
  unsigned int _c_var;
  /// Variable value for the concentration
  const VariableValue & _c;
  /// Variable gradient for the concentration
  const VariableGradient & _grad_c;
  /// local dof indices of variable c
  const std::vector<dof_id_type> & _c_dofs;

  /// no. of order parameters
  unsigned int _op_num;
  /// Variable value for the order parameters
  std::vector<const VariableValue *> _vals;
  std::vector<unsigned int> _vals_var;
  std::vector<const VariableGradient *> _grad_vals;

  /// base name specifying type of force density material
  std::string _base_name;

  /// getting userobject for calculating grain forces and torques
  const OldComputeGrainForceAndTorque & _grain_force_torque;
  const std::vector<RealGradient> & _grain_forces;
  const std::vector<RealGradient> & _grain_torques;
  const std::vector<RealGradient> & _grain_force_c_derivatives;
  const std::vector<RealGradient> & _grain_torque_c_derivatives;
  const std::vector<std::vector<RealGradient> > & _grain_force_eta_derivatives;
  const std::vector<std::vector<RealGradient> > & _grain_torque_eta_derivatives;

  /// constant value corresponding to grain translation
  const Real _mt;
  /// constant value corresponding to grain rotation
  const Real _mr;

  /// grain tracker object
  const GrainTrackerInterface & _grain_tracker;

  /// The grain volumes
  const VectorPostprocessorValue & _grain_volumes;

  /// get the total no. of dofs in the system
  // unsigned int _total_dofs;

  /// storing the advection velocity and corresponding jacobian entries calculated in userobjects
  RealGradient _velocity_advection;
  RealGradient _velocity_advection_derivative_c;
  std::vector<RealGradient> _velocity_advection_derivative_eta;
  /// obtain the active grain ids
  std::vector<unsigned int> _grain_ids;
};

#endif //OLDGRAINRIGIDBODYMOTIONBASE_H
