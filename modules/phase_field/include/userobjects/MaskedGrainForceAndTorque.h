/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef MaskedGrainForceAndTorque_H
#define MaskedGrainForceAndTorque_H

#include "GrainForceAndTorqueInterface.h"
#include "GeneralUserObject.h"

//Forward Declarations
class MaskedGrainForceAndTorque;

template<>
InputParameters validParams<MaskedGrainForceAndTorque>();

/**
 * This class is here to get the force and torque acting on a grain
 * from different userobjects and sum them all
 */
class MaskedGrainForceAndTorque :
    public GrainForceAndTorqueInterface,
    public GeneralUserObject
{
public:
  MaskedGrainForceAndTorque(const InputParameters & parameters);

  virtual void initialize();
  virtual void execute(){};
  virtual void finalize(){};

  virtual const std::vector<RealGradient> & getForceValues() const { return _force_values; }
  virtual const std::vector<RealGradient> & getTorqueValues() const { return _torque_values; }
  virtual const std::vector<RealGradient> & getForceJacobianValues() const { return _force_jacobians; }
  virtual const std::vector<RealGradient> & getTorqueJacobianValues() const { return _torque_jacobians; }

protected:

  const GrainForceAndTorqueInterface & _grain_force_torque_input;
  const std::vector<RealGradient> & _grain_forces_input;
  const std::vector<RealGradient> & _grain_torques_input;
  const std::vector<RealGradient> & _grain_force_jacobians_input;
  const std::vector<RealGradient> & _grain_torque_jacobians_input;

  std::vector<unsigned int> _pinned_grains;
  unsigned int _num_pinned_grains;
  unsigned int _ncrys;

  ///@{ providing sum of all grain forces, torques & their derivatives
  std::vector<RealGradient> _force_values;
  std::vector<RealGradient> _torque_values;
  std::vector<RealGradient> _force_jacobians;
  std::vector<RealGradient> _torque_jacobians;
  ///@}
};

#endif //MaskedGrainForceAndTorque_H
