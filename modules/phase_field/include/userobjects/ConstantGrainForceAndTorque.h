/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef CONSTANTGRAINFORCEANDTORQUE_H
#define CONSTANTGRAINFORCEANDTORQUE_H

#include "GeneralUserObject.h"
#include "GrainForceAndTorqueInterface.h"

//Forward Declarations
class ConstantGrainForceAndTorque;

template<>
InputParameters validParams<ConstantGrainForceAndTorque>();

/**
 * This class is here to get the force and torque acting on a grain
 */
class ConstantGrainForceAndTorque :
    public GrainForceAndTorqueInterface,
    public GeneralUserObject
{
public:
  ConstantGrainForceAndTorque(const InputParameters & parameters);

  virtual void initialize();
  virtual void execute() {}
  virtual void finalize() {}

  virtual const std::vector<RealGradient> & getForceValues() const;
  virtual const std::vector<RealGradient> & getTorqueValues() const;
  virtual const std::vector<RealGradient> & getForceDerivatives() const;
  virtual const std::vector<RealGradient> & getTorqueDerivatives() const;
  virtual const std::vector<RealGradient> & getForceEtaDerivatives(unsigned int jvar) const;
  virtual const std::vector<RealGradient> & getTorqueEtaDerivatives(unsigned int javr) const;

protected:
  /// Applied force on particles, size should be 3 times no. of grains
  std::vector<Real> _F;
  /// Applied torque on particles, size should be 3 times no. of grains
  std::vector<Real> _M;

  unsigned int _op_num;
  unsigned int _ncomp;

  std::vector<RealGradient> _force_values;
  std::vector<RealGradient> _torque_values;
  std::vector<RealGradient> _force_derivatives;
  std::vector<RealGradient> _torque_derivatives;
  std::vector<std::vector<RealGradient> > _force_derivatives_eta;
  std::vector<std::vector<RealGradient> > _torque_derivatives_eta;
};

#endif //CONSTANTGRAINFORCEANDTORQUE_H
