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
#include "ExampleIntegralElementKernel.h"

template<>
InputParameters validParams<ExampleIntegralElementKernel>()
{
  InputParameters params = validParams<Kernel>();
  params.addRequiredParam<UserObjectName>("user_object", "Name of an ExampleShapeElementUserObject");
  params.addRequiredCoupledVar("u", "first coupled variable");
  params.addRequiredCoupledVar("v", "second coupled variable");
  return params;
}


ExampleIntegralElementKernel::ExampleIntegralElementKernel(const InputParameters & parameters) :
    Kernel(parameters),
    _shp(getUserObject<ExampleIntegralElementUserObject>("user_object")),
    _shp_integral(_shp.getIntegralValue()),
    _shp_dintdu(_shp.getDerivativeU()),
    _shp_dintdv(_shp.getDerivativeV()),
    _u_var(coupled("u")),
    _u_dofs(getVar("u", 0)->dofIndices()),
    _v_var(coupled("v")),
    _v_dofs(getVar("v", 0)->dofIndices())
{
}

Real
ExampleIntegralElementKernel::computeQpResidual()
{
  return _test[_i][_qp] * _shp_integral;
}

Real
ExampleIntegralElementKernel::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (jvar == _v_var)
    return _test[_i][_qp] * _shp_dintdv * _phi[_j][_qp];
  if (jvar == _u_var)
    return _test[_i][_qp] * _shp_dintdu * _phi[_j][_qp];

  return 0.0;
}
