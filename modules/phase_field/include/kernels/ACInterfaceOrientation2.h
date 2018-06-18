//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef ACINTERFACEORIENTATION2_H
#define ACINTERFACEORIENTATION2_H

#include "Kernel.h"
#include "JvarMapInterface.h"
#include "DerivativeMaterialInterface.h"

class ACInterfaceOrientation2;

template <>
InputParameters validParams<ACInterfaceOrientation2>();

/**
 * Kernel 1 of 2 for interfacial energy anisotropy in the Allen-Cahn equation as
 * implemented in R. Kobayashi, Physica D, 63, 410-423 (1993).
 * doi:10.1016/0167-2789(93)90120-P
 * This kernel implements the first two terms on the right side of eq. (3) of the paper.
 */
class ACInterfaceOrientation2 : public DerivativeMaterialInterface<JvarMapKernelInterface<Kernel>>
{
public:
  ACInterfaceOrientation2(const InputParameters & parameters);

protected:
  /// Enum of computeDFDOP inputs
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  /// Mobility
  const unsigned int _nvar;
  const MaterialProperty<Real> & _L;
  const MaterialProperty<Real> & _dLdop;
  const Real _penalty;
  const MaterialProperty<Real> & _h;
  const unsigned int _j;
  const MaterialProperty<Real> & _eps;
  const MaterialProperty<Real> & _deps;

  /// Mobility derivative w.r.t. other coupled variables
  std::vector<const MaterialProperty<Real> *> _dLdarg;
  std::vector<const MaterialProperty<Real> *> _depsdarg;
  std::vector<const MaterialProperty<Real> *> _dhdarg;

  const VariableValue & _v;
  const VariableGradient & _grad_v;
  const unsigned int _v_var;
};

#endif // ACINTERFACEORIENTATION2_H
