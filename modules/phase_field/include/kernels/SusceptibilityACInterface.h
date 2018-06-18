//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef SUSCEPTIBILITYACINTERFACE_H
#define SUSCEPTIBILITYACINTERFACE_H

#include "ACInterface.h"
#include "JvarMapInterface.h"
#include "DerivativeMaterialInterface.h"

class SusceptibilityACInterface;

template <>
InputParameters validParams<SusceptibilityACInterface>();

/**
 * Kernel 1 of 2 for interfacial energy anisotropy in the Allen-Cahn equation as
 * implemented in R. Kobayashi, Physica D, 63, 410-423 (1993).
 * doi:10.1016/0167-2789(93)90120-P
 * This kernel implements the first two terms on the right side of eq. (3) of the paper.
 */
class SusceptibilityACInterface : public ACInterface
{
public:
  SusceptibilityACInterface(const InputParameters & parameters);
  virtual void initialSetup();

protected:
  /// Enum of computeDFDOP inputs
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  // susceptibility
  const MaterialProperty<Real> & _Chi;

  /// susceptibility derivative w.r.t. the kernel variable
  const MaterialProperty<Real> & _dChidu;

  /// susceptibility derivatives w.r.t. coupled variables
  std::vector<const MaterialProperty<Real> *> _dChidarg;
};

#endif // SUSCEPTIBILITYACINTERFACE_H
