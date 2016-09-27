/****************************************************************/
/*               DO NOT MODIFY THIS HEADER                      */
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*           (c) 2010 Battelle Energy Alliance, LLC             */
/*                   ALL RIGHTS RESERVED                        */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*            Under Contract No. DE-AC07-05ID14517              */
/*            With the U. S. Department of Energy               */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/

#include "Advection.h"

template<>
InputParameters validParams<Advection>()
{
  InputParameters params = validParams<Kernel>();
  params.addRequiredCoupledVar("advector", "The gradient of this variable will be used as the velocity vector.");
  return params;
}

Advection::Advection(const InputParameters & parameters) :
    Kernel(parameters),
    _grad_advector(coupledGradient("advector")),
    _adv_var(coupled("advector"))
{}

Real Advection::computeQpResidual()
{
  return _test[_i][_qp] * (_grad_advector[_qp] * _grad_u[_qp]);
}

Real Advection::computeQpJacobian()
{
  return _test[_i][_qp] * (_grad_advector[_qp] * _grad_phi[_j][_qp]);
}

Real Advection::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (jvar == _adv_var)
    return _test[_i][_qp] * (_grad_u[_qp] * _grad_phi[_j][_qp]);

  return 0.0;
}
