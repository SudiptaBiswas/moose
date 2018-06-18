//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef VARIABLECOEFTIMEDERIVATIVE_H
#define VARIABLECOEFTIMEDERIVATIVE_H

#include "TimeDerivative.h"

// Forward Declaration
class VariableCoefTimeDerivative;

template <>
InputParameters validParams<VariableCoefTimeDerivative>();

/**
 * This calculates the time derivative for a coupled variable
 **/
class VariableCoefTimeDerivative : public TimeDerivative
{
public:
  VariableCoefTimeDerivative(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned int jvar) override;

  Real _coef;
  const VariableValue & _v;
  // const VariableValue & _dv_dot;
  const unsigned int _v_var;
};

#endif // VARIABLECOEFTIMEDERIVATIVE_H
