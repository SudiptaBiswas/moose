/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef COMPUTEGRAINFORCEANDTORQUE_H
#define COMPUTEGRAINFORCEANDTORQUE_H

#include "ShapeElementUserObject.h"
#include "GrainForceAndTorqueInterface.h"
#include "DerivativeMaterialInterface.h"

//Forward Declarations
class ComputeGrainForceAndTorque;
class ComputeGrainCenterUserObject;

template<>
InputParameters validParams<ComputeGrainForceAndTorque>();

/**
 * This class is here to get the force and torque acting on a grain
 */
class ComputeGrainForceAndTorque :
    public ShapeElementUserObject,
    public DerivativeMaterialPropertyNameInterface,
    public GrainForceAndTorqueInterface

{
public:
  ComputeGrainForceAndTorque(const InputParameters & parameters);

  virtual void initialSetup();

  virtual void initialize();
  virtual void execute();
  virtual void executeJacobian(unsigned int jvar);
  virtual void finalize();
  virtual void threadJoin(const UserObject & y);

  virtual const std::vector<RealGradient> & getForceValues() const;
  virtual const std::vector<RealGradient> & getTorqueValues() const;
  virtual const std::vector<RealGradient> & getForceDerivatives() const;
  virtual const std::vector<RealGradient> & getTorqueDerivatives() const;
  virtual const std::vector<std::vector<RealGradient> > & getForceDerivativesJacobian() const;
  virtual const std::vector<std::vector<RealGradient> > & getTorqueDerivativesJacobian() const;

protected:
  unsigned int _qp;
  unsigned int _j;
  unsigned int _execute_mask;

  VariableName _c_name;
  unsigned int _c_var;
  /// material property that provides force density
  const MaterialProperty<std::vector<RealGradient> > & _dF;
  MaterialPropertyName _dF_name;
  /// material property that provides derivative of force density with respect to c
  const MaterialProperty<std::vector<RealGradient> > & _dFdc;
  /// provide UserObject for calculating grain volumes and centers
  const ComputeGrainCenterUserObject & _grain_data;
  const std::vector<Real> & _grain_volumes;
  const std::vector<Point> & _grain_centers;
  unsigned int _ncrys;
  unsigned int _ncomp;
  ///@{ providing grain forces, torques and their derivatives w. r. t c
  std::vector<RealGradient> _force_values;
  std::vector<RealGradient> _torque_values;
  std::vector<RealGradient> _force_derivatives;
  std::vector<RealGradient> _torque_derivatives;
  std::vector<std::vector<RealGradient> > _force_derivatives_jac;
  std::vector<std::vector<RealGradient> > _torque_derivatives_jac;
  ///@}
  /// vector storing grain force and torque values
  std::vector<Real> _force_torque_store;
  std::vector<Real> _force_torque_derivative_store;

  /// Total DOF in the system
  dof_id_type _total_num_dofs;
  /// vector storing derivative of grain force and torque values
  std::vector<Real> _force_torque_jacobian_store;
};

#endif //COMPUTEGRAINFORCEANDTORQUE_H
