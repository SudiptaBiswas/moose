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

#include "ExampleIntegralElementUserObject.h"

template<>
InputParameters validParams<ExampleIntegralElementUserObject>()
{
  InputParameters params = validParams<ElementUserObject>();
  params.addRequiredCoupledVar("u", "first coupled variable");
  params.addRequiredCoupledVar("v", "second coupled variable");
  return params;
}

ExampleIntegralElementUserObject::ExampleIntegralElementUserObject(const InputParameters & parameters) :
    ElementUserObject(parameters),
    _u_value(coupledValue("u")),
    _u_var(coupled("u")),
    _v_value(coupledValue("v")),
    _v_var(coupled("v"))
{
}

void
ExampleIntegralElementUserObject::initialize()
{
  _integral = 0.0;
  _dintdu = 0.0;
  _dintdu = 0.0;
}

void
ExampleIntegralElementUserObject::execute()
{
  //
  // integrate u^2*v over the simulation domain
  //
  for (unsigned int qp = 0; qp < _qrule->n_points(); ++qp)
  {
    _integral += _JxW[qp] * _coord[qp] * (_u_value[qp] * _u_value[qp]) * _v_value[qp];
    _dintdu += _JxW[qp] * _coord[qp] * (2.0 * _u_value[qp]) * _v_value[qp];
    _dintdv += _JxW[qp] * _coord[qp] * (_u_value[qp] * _u_value[qp]);
  }
}

void
ExampleIntegralElementUserObject::finalize()
{
  gatherSum(_integral);
  gatherSum(_dintdu);
  gatherSum(_dintdv);
}

void
ExampleIntegralElementUserObject::threadJoin(const UserObject & y)
{
  const ExampleIntegralElementUserObject & shp_uo = dynamic_cast<const ExampleIntegralElementUserObject &>(y);

  _integral += shp_uo._integral;
  _dintdu += shp_uo._dintdu;
  _dintdv += shp_uo._dintdv;
}
