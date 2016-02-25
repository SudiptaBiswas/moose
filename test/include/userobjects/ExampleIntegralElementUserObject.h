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


#ifndef EXAMPLEINTEGRALELEMENTUSEROBJECT_H
#define EXAMPLEINTEGRALELEMENTUSEROBJECT_H

#include "ElementUserObject.h"

//Forward Declarations
class ExampleIntegralElementUserObject;

template<>
InputParameters validParams<ExampleIntegralElementUserObject>();

/**
 * Test and proof of concept class for computing UserObject Jacobians using the
 * ShapeElementUserObject base class. This object computes the integral
 * \f$ \int_\Omega u^2v dr \f$
 * and builds a vector of all derivatives of the integral w.r.t. the DOFs of u and v.
 * These Jacobian terms can be utilized by a Kernel that uses the integral in the
 * calculation of its residual.
 */
class ExampleIntegralElementUserObject :
  public ElementUserObject
{
public:
  ExampleIntegralElementUserObject(const InputParameters & parameters);

  //virtual ~ExampleIntegralElementUserObject() {}

  virtual void initialize();
  virtual void execute();
  //virtual void executeJacobian(unsigned int jvar);
  virtual void finalize();
  virtual void threadJoin(const UserObject & y);

  ///@{ custom UserObject interface functions
  const Real & getIntegralValue() const { return _integral; }
  const Real & getDerivativeU() const { return _dintdu; }
  const Real & getDerivativeV() const { return _dintdv; }
  ///@}

protected:
  Real _integral;
  Real _dintdu;
  Real _dintdv;

  VariableValue & _u_value;
  unsigned int _u_var;
  VariableValue & _v_value;
  unsigned int _v_var;
};

#endif
