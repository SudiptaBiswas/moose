//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef POLYCRYSTALSOLIDIFICATIONKERNEL_H
#define POLYCRYSTALSOLIDIFICATIONKERNEL_H

#include "Kernel.h"
#include "JvarMapInterface.h"
#include "DerivativeMaterialInterface.h"

// Forward Declarations
class PolycrystalSolidificationKernel;

template <>
InputParameters validParams<PolycrystalSolidificationKernel>();

/**
 * PolycrystalSolidificationKernel uses the Free Energy function and derivatives
 * provided by a DerivativeParsedMaterial to computer the
 * residual for the bulk part of the Allen-Cahn equation.
 */
class PolycrystalSolidificationKernel
  : public DerivativeMaterialInterface<JvarMapKernelInterface<Kernel>>
{
public:
  PolycrystalSolidificationKernel(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  const unsigned int _nvar;
  const VariableValue & _theta;
  const VariableGradient & _grad_theta;
  const unsigned int _theta_var;
  const Real _penalty;
  const MaterialProperty<Real> & _L;
  const MaterialProperty<Real> & _kappa;
  const MaterialProperty<Real> & _dhdPhi;
  const MaterialProperty<Real> & _d2hdPhi2;

  std::vector<const MaterialProperty<Real> *> _d2hdPhidarg;
  std::vector<const MaterialProperty<Real> *> _dkappadarg;
};

#endif // POLYCRYSTALSOLIDIFICATIONKERNEL_H
