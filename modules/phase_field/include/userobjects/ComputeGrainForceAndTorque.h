/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef COMPUTEGRAINFORCEANDTORQUE_H
#define COMPUTEGRAINFORCEANDTORQUE_H

#include "ShapeElementUserObject.h"
// #include "ElementUserObject.h"
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
    // public ElementUserObject,
    public ShapeElementUserObject,
    public DerivativeMaterialPropertyNameInterface,
    public GrainForceAndTorqueInterface
{
public:
  ComputeGrainForceAndTorque(const InputParameters & parameters);

  virtual void initialize();
  virtual void execute();
  virtual void executeJacobian(unsigned int jvar);
  virtual void finalize();
  virtual void threadJoin(const UserObject & y);

  virtual const std::vector<RealGradient> & getForceValues() const { return _force_values; }
  virtual const std::vector<RealGradient> & getTorqueValues() const { return _torque_values; }
  virtual const std::vector<RealGradient> & getForceJacobianValues() const { return _force_jacobians; }
  virtual const std::vector<RealGradient> & getTorqueJacobianValues() const { return _torque_jacobians; }

  // virtual const std::vector<RealGradient> & getForceDerivatives() const = 0;
  // virtual const std::vector<RealGradient> & getTorqueDerivatives() const = 0;
protected:
  unsigned int _qp;

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

  /// vector storing grain force and torque values
  std::vector<Real> _force_torque_store;
  /// vector storing derivative of grain force and torque values
  std::vector<Real> _force_torque_derivative_store;

  ///@{ providing grain forces, torques and their derivatives w. r. t c
  std::vector<RealGradient> _force_values;
  std::vector<RealGradient> _torque_values;
  std::vector<RealGradient> _force_jacobians;
  std::vector<RealGradient> _torque_jacobians;
  ///@}
};

#endif //COMPUTEGRAINFORCEANDTORQUE_H
