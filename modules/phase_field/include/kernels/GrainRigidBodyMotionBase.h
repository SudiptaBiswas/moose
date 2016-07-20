/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef GRAINRIGIDBODYMOTIONBASE_H
#define GRAINRIGIDBODYMOTIONBASE_H

#include "NonlocalKernel.h"
// #include "ComputeGrainCenterUserObject.h"
#include "GrainForceAndTorqueInterface.h"

//Forward Declarations
class GrainRigidBodyMotionBase;
class GrainTrackerInterface;

template<>
InputParameters validParams<GrainRigidBodyMotionBase>();

class GrainRigidBodyMotionBase :
    public NonlocalKernel

{
public:
  GrainRigidBodyMotionBase(const InputParameters & parameters);

  virtual void timestepSetup();

protected:
  virtual Real computeQpResidual() { return 0.0; }
  virtual Real computeQpJacobian() { return 0.0; }
  virtual Real computeQpOffDiagJacobian(unsigned int /* jvar */ ) { return 0.0; }
  /// jacobian calculation corresponding to non-local dofs
  virtual Real computeQpNonlocalJacobian(dof_id_type /* dof_index */) { return 0.0; }
  virtual Real computeQpNonlocalOffDiagJacobian(unsigned int /* jvar */, dof_id_type /* dof_index */) { return 0.0; }

  void getUserObjectCJacobians(dof_id_type dof_index, unsigned int grain_index);
  void getUserObjectEtaJacobians(dof_id_type dof_index, unsigned int jvar_index, unsigned int grain_index);

  /// int label for the Concentration
  unsigned int _c_var;

  /// Variable value for the concentration
  const VariableValue & _c;

  /// Variable gradient for the concentration
  const VariableGradient & _grad_c;

  VariableName _c_name;
  unsigned int _op_num;
  /// Variable value for the order parameters
  std::vector<const VariableValue *> _vals;
  std::vector<unsigned int> _vals_var;
  std::vector<const VariableGradient *> _grad_vals;

  /// type of force density material
  std::string _base_name;

  /// getting userobject for calculating grain forces and torques
  const GrainForceAndTorqueInterface & _grain_force_torque;
  const std::vector<RealGradient> & _grain_forces;
  const std::vector<RealGradient> & _grain_torques;
  const std::vector<Real> & _grain_force_c_jacobians;
  const std::vector<std::vector<Real> > & _grain_force_eta_jacobians;

  /// constant value corresponding to grain translation
  Real _mt;

  /// constant value corresponding to grain rotation
  Real _mr;
  const GrainTrackerInterface & _grain_tracker;
  unsigned int _grain_num;

  RealGradient _force_c_jacobian;
  RealGradient _torque_c_jacobian;
  RealGradient _force_eta_jacobian;
  RealGradient _torque_eta_jacobian;
};

#endif //GRAINRIGIDBODYMOTIONBASE_H
