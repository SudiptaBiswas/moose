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

#include "ShapeElementUserObjectTest.h"
#include "libmesh/quadrature.h"

template<>
InputParameters validParams<ShapeElementUserObjectTest>()
{
  InputParameters params = validParams<ShapeElementUserObject>();
  params.addRequiredCoupledVar("u", "intergral variable");
  return params;
}

ShapeElementUserObjectTest::ShapeElementUserObjectTest(const InputParameters & parameters) :
    ShapeElementUserObject(parameters),
    _grad_u(coupledGradient("u")),
    _u_var(coupled("u"))
{
}

void
ShapeElementUserObjectTest::initialize()
{
  _integral = 0.0;

  // Jacobian term storage is up to the user. One option is using an std::vector
  // We resize it to the total number of DOFs in the system and zero it out.
  // WARNING: this can be large number (smart sparse storage could be a future improvement)
  if (_fe_problem.currentlyComputingJacobian())
    _jacobian_storage.assign(_subproblem.es().n_dofs(), 0.0);
}

void
ShapeElementUserObjectTest::execute()
{
  //
  // integrate u over the simulation domain
  //
  // _integral = 1.0;
  for (unsigned int qp = 0; qp < _qrule->n_points(); ++qp)
    _integral += _JxW[qp] * _coord[qp] * _grad_u[qp] * _grad_u[qp];
}

void
ShapeElementUserObjectTest::executeJacobian(unsigned int jvar)
{
  // derivative of _integral w.r.t. u_j
  if (jvar == _u_var)
  {
    // sum jacobian contributions over quadrature points
    Real sum = 0.0;
    for (unsigned int qp = 0; qp < _qrule->n_points(); ++qp)
      sum += 2 * _JxW[qp] * _coord[qp] * _grad_u[qp] * _grad_phi[_j][qp];

    // the user has to store the value of sum in a storage object indexed by global DOF _j_global
    _jacobian_storage[_j_global] += sum;
  }
}

void
ShapeElementUserObjectTest::finalize()
{
  gatherSum(_integral);
  if (_fe_problem.currentlyComputingJacobian())
    gatherSum(_jacobian_storage);
}

void
ShapeElementUserObjectTest::threadJoin(const UserObject & y)
{
  const ShapeElementUserObjectTest & shp_uo = dynamic_cast<const ShapeElementUserObjectTest &>(y);

  _integral += shp_uo._integral;

  if (_fe_problem.currentlyComputingJacobian())
  {
    mooseAssert(_jacobian_storage.size() == shp_uo._jacobian_storage.size(), "Jacobian storage size is inconsistent across threads");
    for (unsigned int i = 0; i < _jacobian_storage.size(); ++i)
      _jacobian_storage[i] += shp_uo._jacobian_storage[i];
  }
}
