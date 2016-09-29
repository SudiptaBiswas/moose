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
  params.addParam<unsigned int>("grain_num", "Number of grains");
  return params;
}

GrainForceAndTorqueSum::GrainForceAndTorqueSum(const InputParameters & parameters) :
    GrainForceAndTorqueInterface(),
    GeneralUserObject(parameters),
    _sum_objects(getParam<std::vector<UserObjectName> >("grain_forces")),
    _num_forces(_sum_objects.size()),
    _grain_num(getParam<unsigned int>("grain_num")),
    _sum_forces(_num_forces),
    _force_values(_grain_num),
    _torque_values(_grain_num)
{
  for (unsigned int i = 0; i < _num_forces; ++i)
    _sum_forces[i] = & getUserObjectByName<GrainForceAndTorqueInterface>(_sum_objects[i]);
}

void
GrainForceAndTorqueSum::initialize()
{
  for (unsigned int i = 0; i < _grain_num; ++i)
  {
    _force_values[i] = 0.0;
    _torque_values[i] = 0.0;
    for (unsigned int j = 0; j < _num_forces; ++j)
    {
      _force_values[i] += (_sum_forces[j]->getForceValues())[i];
      _torque_values[i] += (_sum_forces[j]->getTorqueValues())[i];
    }
  }

  if (_fe_problem.currentlyComputingJacobian())
  {
    unsigned int total_dofs = _subproblem.es().n_dofs();
    _c_jacobians.resize(6*_grain_num*total_dofs, 0.0);
    _c_nonzerojac_dofs.reserve(total_dofs);
    _eta_jacobians.resize(_grain_num);

    for (unsigned int i = 0; i < _c_jacobians.size(); ++i)
      for (unsigned int j = 0; j < _num_forces; ++j)
        _c_jacobians[i] += (_sum_forces[j]->getForceCJacobians())[i];
    for (unsigned int j = 0; j < _num_forces; ++j)
      _nonzerojac_dofs_c.insert((_sum_forces[j]->getCNonzeroDofs()).begin(),(_sum_forces[j]->getCNonzeroDofs()).end());
    _c_nonzerojac_dofs.assign(_nonzerojac_dofs_c.begin(), _nonzerojac_dofs_c.end());

    for (unsigned int i = 0; i < _grain_num; ++i)
    {
      _eta_jacobians[i].resize(6*_grain_num*total_dofs, 0.0);
      _eta_nonzerojac_dofs[i].reserve(total_dofs);
      for (unsigned int j = 0; j < _eta_jacobians[i].size(); ++j)
        for (unsigned int k = 0; k < _num_forces; ++k)
          _eta_jacobians[i][j] += (_sum_forces[k]->getForceEtaJacobians())[i][j];
      for (unsigned int k = 0; k < _num_forces; ++k)
        _nonzerojac_dofs_eta[i].insert((_sum_forces[k]->getEtaNonzeroDofs())[i].begin(),(_sum_forces[k]->getEtaNonzeroDofs())[i].end());
      _eta_nonzerojac_dofs[i].assign(_nonzerojac_dofs_eta[i].begin(), _nonzerojac_dofs_eta[i].end());
    }
  }
}

const std::vector<RealGradient> &
GrainForceAndTorqueSum::getForceValues() const
{
  return _force_values;
}

const std::vector<RealGradient> &
GrainForceAndTorqueSum::getTorqueValues() const
{
  return _torque_values;
}

const std::vector<Real> &
GrainForceAndTorqueSum::getForceCJacobians() const
{
  return _c_jacobians;
}

const std::vector<std::vector<Real> > &
GrainForceAndTorqueSum::getForceEtaJacobians() const
{
  return _eta_jacobians;
}

const std::vector<dof_id_type> &
GrainForceAndTorqueSum::getCNonzeroDofs() const
{
  return _c_nonzerojac_dofs;
}

const std::vector<std::vector<dof_id_type> > &
GrainForceAndTorqueSum::getEtaNonzeroDofs() const
{
  return _eta_nonzerojac_dofs;
}
