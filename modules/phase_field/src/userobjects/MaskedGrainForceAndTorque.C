/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "MaskedGrainForceAndTorque.h"

template<>
InputParameters validParams<MaskedGrainForceAndTorque>()
{
  InputParameters params = validParams<GeneralUserObject>();
  params.addClassDescription("Userobject for masking/pinning grains and making forces and torques acting on that grain zero");
  params.addParam<UserObjectName>("grain_force", "userobject for getting force and torque acting on grains");
  params.addParam<std::vector<unsigned int> >("pinned_grains", "Grain numbers for pinned grains");
  return params;
}

MaskedGrainForceAndTorque::MaskedGrainForceAndTorque(const InputParameters & parameters) :
    GrainForceAndTorqueInterface(),
    GeneralUserObject(parameters),
    _grain_force_torque_input(getUserObject<GrainForceAndTorqueInterface>("grain_force")),
    _grain_forces_input(_grain_force_torque_input.getForceValues()),
    _grain_torques_input(_grain_force_torque_input.getTorqueValues()),
    _grain_force_jacobians_input(_grain_force_torque_input.getForceJacobianValues()),
    _grain_torque_jacobians_input(_grain_force_torque_input.getTorqueJacobianValues()),
    _pinned_grains(getParam<std::vector<unsigned int> >("pinned_grains")),
    _num_pinned_grains(_pinned_grains.size()),
    _ncrys(_grain_forces_input.size()),
    _force_values(_ncrys),
    _torque_values(_ncrys)
{
}

void
MaskedGrainForceAndTorque::initialize()
{
  for (unsigned int i = 0; i < _ncrys; ++i)
  {
    _force_values[i] = _grain_forces_input [i];
    _torque_values[i] = _grain_torques_input[i];

    if (_num_pinned_grains != 0)
    {
      for (unsigned int j = 0; j < _num_pinned_grains; ++j)
      {
        if (i == _pinned_grains[j])
        {
          _force_values[i] = 0.0;
          _torque_values[i] = 0.0;
        }
      }
    }
  }

  unsigned int total_dofs = _subproblem.es().n_dofs();
  _force_jacobians.resize(_ncrys*total_dofs);
  _torque_jacobians.resize(_ncrys*total_dofs);
  for (unsigned int i = 0; i < _ncrys; ++i)
    for (unsigned int j = 0; j < total_dofs; ++j)
    {
      _force_jacobians[i*total_dofs+j] = _grain_force_jacobians_input[i*total_dofs+j];
      _torque_jacobians[i*total_dofs+j] = _grain_torque_jacobians_input[i*total_dofs+j];

      if (_num_pinned_grains != 0)
      {
        for (unsigned int k = 0; k < _num_pinned_grains; ++k)
        {
          if (i == _pinned_grains[k])
          {
            _force_jacobians[i*total_dofs+j] = 0.0;
            _torque_jacobians[i*total_dofs+j] = 0.0;
          }
        }
      }
  }
}
