//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef SUSCEPTIBILITYCOUPLEDACINTERFACE_H
#define SUSCEPTIBILITYCOUPLEDACINTERFACE_H

#include "Kernel.h"
#include "JvarMapInterface.h"
#include "DerivativeMaterialInterface.h"

class SusceptibilityCoupledACInterface;

template <>
InputParameters validParams<SusceptibilityCoupledACInterface>();

/**
 * Kernel 1 of 2 for interfacial energy anisotropy in the Allen-Cahn equation as
 * implemented in R. Kobayashi, Physica D, 63, 410-423 (1993).
 * doi:10.1016/0167-2789(93)90120-P
 * This kernel implements the first two terms on the right side of eq. (3) of the paper.
 */
class SusceptibilityCoupledACInterface
  : public DerivativeMaterialInterface<JvarMapKernelInterface<Kernel>>
{
public:
  SusceptibilityCoupledACInterface(const InputParameters & parameters);
  virtual void initialSetup();

protected:
  /// Enum of computeDFDOP inputs
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  const unsigned int _nvar;
  const VariableValue & _v;
  const VariableGradient & _grad_v;
  const unsigned int _v_var;
  const Real _penalty;
  // susceptibility
  const MaterialProperty<Real> & _L;
  const MaterialProperty<Real> & _dLdu;

  /// susceptibility derivative w.r.t. the kernel variable
  const MaterialProperty<Real> & _dChidu;
  const MaterialProperty<Real> & _d2Chidu2;

  /// susceptibility derivatives w.r.t. coupled variables
  // std::vector<const MaterialProperty<Real> *> _dChidarg;
  std::vector<const MaterialProperty<Real> *> _d2Chidargdu;
  std::vector<const MaterialProperty<Real> *> _dLdarg;
};

#endif // SUSCEPTIBILITYCOUPLEDACINTERFACE_H
