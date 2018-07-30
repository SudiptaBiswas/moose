//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef COUPLEDANISOTROPICINTERFACEENERGY_H
#define COUPLEDANISOTROPICINTERFACEENERGY_H

#include "Kernel.h"
#include "JvarMapInterface.h"
#include "DerivativeMaterialInterface.h"

class CoupledAnisotropicInterfaceEnergy;

template <>
InputParameters validParams<CoupledAnisotropicInterfaceEnergy>();

/**
 * Kernel 1 of 2 for interfacial energy anisotropy in the Allen-Cahn equation as
 * implemented in R. Kobayashi, Physica D, 63, 410-423 (1993).
 * doi:10.1016/0167-2789(93)90120-P
 * This kernel implements the first two terms on the right side of eq. (3) of the paper.
 */
class CoupledAnisotropicInterfaceEnergy
  : public DerivativeMaterialInterface<JvarMapKernelInterface<Kernel>>
{
public:
  CoupledAnisotropicInterfaceEnergy(const InputParameters & parameters);

protected:
  /// Enum of computeDFDOP inputs
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  const VariableValue & _v;
  const VariableGradient & _grad_v;
  const unsigned int _v_var;
  /// Mobility
  const MaterialProperty<Real> & _L;
  const MaterialProperty<Real> & _dLdop;
  const MaterialProperty<Real> & _eps;
  const MaterialProperty<Real> & _deps;
  const MaterialProperty<Real> & _depsdtheta;
  const MaterialProperty<Real> & _d2epsdtheta2;
  const MaterialProperty<RealGradient> & _depsdgrad_op;
  const MaterialProperty<RealGradient> & _ddepsdgrad_op;
  const MaterialProperty<RealGradient> & _ddepsdthetadgrad_op;

  /// Mobility derivative w.r.t. other coupled variables
  std::vector<const MaterialProperty<Real> *> _dLdarg;
  std::vector<const MaterialProperty<Real> *> _depsdarg;
  std::vector<const MaterialProperty<Real> *> _ddepsdarg;
  std::vector<const MaterialProperty<Real> *> _ddepsdthetadarg;
};

#endif // COUPLEDANISOTROPICINTERFACEENERGY_H
