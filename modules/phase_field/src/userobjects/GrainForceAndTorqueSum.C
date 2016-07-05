/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "GrainForceAndTorqueSum.h"

template<>
InputParameters validParams<GrainForceAndTorqueSum>()
{
  InputParameters params = validParams<GeneralUserObject>();
  params.addClassDescription("Userobject for summing forces and torques acting on a grain");
  params.addParam<std::vector<UserObjectName> >("grain_forces", "List of names of user objects that provides forces and torques applied to grains");
  params.addParam<unsigned int>("op_num", "Number of grains");
  return params;
}

GrainForceAndTorqueSum::GrainForceAndTorqueSum(const InputParameters & parameters) :
    GrainForceAndTorqueInterface(),
    GeneralUserObject(parameters),
    _sum_objects(getParam<std::vector<UserObjectName> >("grain_forces")),
    _num_forces(_sum_objects.size()),
    _ncrys(getParam<unsigned int>("op_num")),
    _sum_forces(_num_forces)
{
  for (unsigned int i = 0; i < _num_forces; ++i)
    _sum_forces[i] = & getUserObjectByName<GrainForceAndTorqueInterface>(_sum_objects[i]);
}

void
GrainForceAndTorqueSum::initialize()
{
  _force_values.resize(_ncrys);
  _torque_values.resize(_ncrys);
  for (unsigned int i = 0; i < _ncrys; ++i)
  {
    _force_values[i] = 0.0;
    _torque_values[i] = 0.0;
    for (unsigned int j = 0; j < _num_forces; ++j)
    {
      _force_values[i] += (_sum_forces[j]->getForceValues())[i];
      _torque_values[i] += (_sum_forces[j]->getTorqueValues())[i];
    }
  }
  unsigned int total_dofs = _subproblem.es().n_dofs();
  _force_jacobians.resize(_ncrys*total_dofs);
  _torque_jacobians.resize(_ncrys*total_dofs);
  for (unsigned int i = 0; i < _ncrys; ++i)
    for (unsigned int j = 0; j < total_dofs; ++j)
      for (unsigned int k = 0; k < _num_forces; ++k)
      {
        _force_jacobians[i*total_dofs+j] += (_sum_forces[k]->getForceJacobianValues())[i*total_dofs+j];
        _torque_jacobians[i*total_dofs+j] += (_sum_forces[k]->getTorqueJacobianValues())[i*total_dofs+j];
      }
}
