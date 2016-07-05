/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "ConstantGrainForceAndTorque.h"

template<>
InputParameters validParams<ConstantGrainForceAndTorque>()
{
  InputParameters params = validParams<GeneralUserObject>();
  params.addClassDescription("Userobject for calculating force and torque acting on a grain");
  params.addParam<std::vector<Real> >("force", "force acting on grains");
  params.addParam<std::vector<Real> >("torque", "torque acting on grains");
  return params;
}

ConstantGrainForceAndTorque::ConstantGrainForceAndTorque(const InputParameters & parameters) :
    GrainForceAndTorqueInterface(),
    GeneralUserObject(parameters),
    _F(getParam<std::vector<Real> >("force")),
    _M(getParam<std::vector<Real> >("torque"))
{
}

void
ConstantGrainForceAndTorque::initialize()
{
  _ncrys = _F.size() / 3;
  _ncomp = 6 * _ncrys;
  _force_values.resize(_ncrys);
  _torque_values.resize(_ncrys);
  for (unsigned int i = 0; i < _ncrys; ++i)
  {
    _force_values[i](0) = _F[3*i+0];
    _force_values[i](1) = _F[3*i+1];
    _force_values[i](2) = _F[3*i+2];
    _torque_values[i](0) = _M[3*i+0];
    _torque_values[i](1) = _M[3*i+1];
    _torque_values[i](2) = _M[3*i+2];
  }
  unsigned int total_dofs = _subproblem.es().n_dofs();
  _force_jacobians.assign(_ncrys*total_dofs, 0.0);
  _torque_jacobians.assign(_ncrys*total_dofs, 0.0);
}
