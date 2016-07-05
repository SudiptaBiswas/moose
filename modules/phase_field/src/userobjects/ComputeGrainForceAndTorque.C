/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#include "ComputeGrainForceAndTorque.h"
#include "ComputeGrainCenterUserObject.h"

// libmesh includes
#include "libmesh/quadrature.h"

template<>
InputParameters validParams<ComputeGrainForceAndTorque>()
{
  InputParameters params = validParams<ShapeElementUserObject>();
  params.addClassDescription("Userobject for calculating force and torque acting on a grain");
  params.addParam<MaterialPropertyName>("force_density", "force_density", "Force density material");
  params.addParam<UserObjectName>("grain_data", "center of mass of grains");
  params.addCoupledVar("c", "Concentration field");
  return params;
}

ComputeGrainForceAndTorque::ComputeGrainForceAndTorque(const InputParameters & parameters) :
    // ElementUserObject(parameters),
    ShapeElementUserObject(parameters),
    GrainForceAndTorqueInterface(),
    _c_name(getVar("c", 0)->name()),
    _c_var(getVar("c", 0)->number()),
    _dF(getMaterialProperty<std::vector<RealGradient> >("force_density")),
    _dF_name(getParam<MaterialPropertyName>("force_density")),
    _dFdc(getMaterialPropertyByName<std::vector<RealGradient> >(propertyNameFirst(_dF_name, _c_name))),
    _grain_data(getUserObject<ComputeGrainCenterUserObject>("grain_data")),
    _grain_volumes(_grain_data.getGrainVolumes()),
    _grain_centers(_grain_data.getGrainCenters()),
    _ncrys(_grain_volumes.size()),
    _ncomp(6*_ncrys)
{
}

void
ComputeGrainForceAndTorque::initialize()
{
  _force_torque_store.assign(_ncomp, 0.0);
  unsigned int total_dofs = _subproblem.es().n_dofs();
  _force_torque_derivative_store.assign(_ncomp*total_dofs, 0.0);
  _force_values.resize(_ncrys);
  _torque_values.resize(_ncrys);
  _force_jacobians.assign(_ncrys*total_dofs, 0.0);
  _torque_jacobians.assign(_ncrys*total_dofs, 0.0);
}

void
ComputeGrainForceAndTorque::execute()
{
  for (unsigned int i = 0; i < _ncrys; ++i)
    for (_qp=0; _qp<_qrule->n_points(); ++_qp)
    {
      const RealGradient compute_torque =_JxW[_qp] * _coord[_qp] * (_q_point[_qp] - _grain_centers[i]).cross(_dF[_qp][i]);
      _force_torque_store[6*i+0] += _JxW[_qp] * _coord[_qp] * _dF[_qp][i](0);
      _force_torque_store[6*i+1] += _JxW[_qp] * _coord[_qp] * _dF[_qp][i](1);
      _force_torque_store[6*i+2] += _JxW[_qp] * _coord[_qp] * _dF[_qp][i](2);
      _force_torque_store[6*i+3] += compute_torque(0);
      _force_torque_store[6*i+4] += compute_torque(1);
      _force_torque_store[6*i+5] += compute_torque(2);
    }
}

void
ComputeGrainForceAndTorque::executeJacobian(unsigned int jvar)
{
  if (jvar == _c_var)
  {
    unsigned int total_dofs = _subproblem.es().n_dofs();

    for (unsigned int i = 0; i < _ncrys; ++i)
      for (_qp=0; _qp<_qrule->n_points(); ++_qp)
      {
      const RealGradient compute_torque_derivative_c =_JxW[_qp] * _coord[_qp] * _phi[_j][_qp] * (_q_point[_qp] - _grain_centers[i]).cross(_dFdc[_qp][i]);
      _force_torque_derivative_store[(6*i+0)*total_dofs+_j_global] += _JxW[_qp] * _coord[_qp] * _phi[_j][_qp] * _dFdc[_qp][i](0);
      _force_torque_derivative_store[(6*i+1)*total_dofs+_j_global] += _JxW[_qp] * _coord[_qp] * _phi[_j][_qp] * _dFdc[_qp][i](1);
      _force_torque_derivative_store[(6*i+2)*total_dofs+_j_global] += _JxW[_qp] * _coord[_qp] * _phi[_j][_qp] * _dFdc[_qp][i](2);
      _force_torque_derivative_store[(6*i+3)*total_dofs+_j_global] += compute_torque_derivative_c(0);
      _force_torque_derivative_store[(6*i+4)*total_dofs+_j_global] += compute_torque_derivative_c(1);
      _force_torque_derivative_store[(6*i+5)*total_dofs+_j_global] += compute_torque_derivative_c(2);
    }
  }
}

void
ComputeGrainForceAndTorque::finalize()
{
  gatherSum(_force_torque_store);
  gatherSum(_force_torque_derivative_store);

  unsigned int total_dofs = _subproblem.es().n_dofs();

  for (unsigned int i = 0; i < _ncrys; ++i)
  {
    _force_values[i](0) = _force_torque_store[6*i+0];
    _force_values[i](1) = _force_torque_store[6*i+1];
    _force_values[i](2) = _force_torque_store[6*i+2];
    _torque_values[i](0) = _force_torque_store[6*i+3];
    _torque_values[i](1) = _force_torque_store[6*i+4];
    _torque_values[i](2) = _force_torque_store[6*i+5];

    _force_jacobians[i*total_dofs+_j_global](0) = _force_torque_derivative_store[(6*i+0)*total_dofs+_j_global];
    _force_jacobians[i*total_dofs+_j_global](1) = _force_torque_derivative_store[(6*i+1)*total_dofs+_j_global];
    _force_jacobians[i*total_dofs+_j_global](2) = _force_torque_derivative_store[(6*i+2)*total_dofs+_j_global];
    _torque_jacobians[i*total_dofs+_j_global](0) = _force_torque_derivative_store[(6*i+3)*total_dofs+_j_global];
    _torque_jacobians[i*total_dofs+_j_global](1) = _force_torque_derivative_store[(6*i+4)*total_dofs+_j_global];
    _torque_jacobians[i*total_dofs+_j_global](2) = _force_torque_derivative_store[(6*i+5)*total_dofs+_j_global];
  }
}

void
ComputeGrainForceAndTorque::threadJoin(const UserObject & y)
{
  const ComputeGrainForceAndTorque & pps = static_cast<const ComputeGrainForceAndTorque &>(y);
  for (unsigned int i = 0; i < _ncomp; ++i)
    _force_torque_store[i] += pps._force_torque_store[i];
  for (unsigned int i = 0; i < _ncomp*_subproblem.es().n_dofs(); ++i)
    _force_torque_derivative_store[i] += pps._force_torque_derivative_store[i];
}
