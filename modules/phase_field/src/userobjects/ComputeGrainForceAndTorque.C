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
  InputParameters params = validParams<ElementUserObject>();
  params.addClassDescription("Userobject for calculating force and torque acting on a grain");
  params.addParam<MaterialPropertyName>("force_density", "force_density", "Force density material");
  params.addParam<UserObjectName>("grain_data", "center of mass of grains");
  params.addCoupledVar("c", "Concentration field");
  params.addRequiredCoupledVarWithAutoBuild("etas", "var_name_base", "op_num", "Array of coupled variable names");
  return params;
}

ComputeGrainForceAndTorque::ComputeGrainForceAndTorque(const InputParameters & parameters) :
    ElementUserObject(parameters),
    GrainForceAndTorqueInterface(),
    _c_name(getVar("c", 0)->name()),
    _dF(getMaterialProperty<std::vector<RealGradient> >("force_density")),
    _dF_name(getParam<MaterialPropertyName>("force_density")),
    _dFdc(getMaterialPropertyByName<std::vector<RealGradient> >(propertyNameFirst(_dF_name, _c_name))),
    _grain_data(getUserObject<ComputeGrainCenterUserObject>("grain_data")),
    _grain_volumes(_grain_data.getGrainVolumes()),
    _grain_centers(_grain_data.getGrainCenters()),
    _op_num(_grain_volumes.size()),
    _ncomp(6*_op_num),
    _vals_var(_op_num),
    _vals_name(_op_num),
    _dFdgradeta(_op_num),
    _force_values(_op_num),
    _torque_values(_op_num),
    _force_derivatives(_op_num),
    _torque_derivatives(_op_num),
    _force_derivatives_eta(_op_num),
    _torque_derivatives_eta(_op_num),
    _force_torque_store(_ncomp),
    _force_torque_derivative_store(_ncomp)
{
 for (unsigned int i = 0; i < _op_num; ++i)
 {
   _vals_var[i] = coupled("etas", i);
   _vals_name[i] = getVar("etas", i)->name();
   _dFdgradeta[i] = &getMaterialPropertyByName<std::vector<Real> >(propertyNameFirst(_dF_name, _vals_name[i]));
 }
}

void
ComputeGrainForceAndTorque::initialize()
{
  for (unsigned int i = 0; i < _ncomp; ++i)
  {
    _force_torque_store[i] = 0;
    _force_torque_derivative_store[i] = 0;
  }

  _force_torque_eta_derivative_store.resize(_op_num);
  for (unsigned int i = 0; i < _op_num; ++i)
  {
    _force_torque_eta_derivative_store[i].assign(_ncomp, 0.0);
    _force_derivatives_eta[i].resize(_op_num);
    _torque_derivatives_eta[i].resize(_op_num);
  }
}

void
ComputeGrainForceAndTorque::execute()
{
  for (unsigned int i = 0; i < _op_num; ++i)
    for (_qp=0; _qp<_qrule->n_points(); ++_qp)
    {
      const RealGradient compute_torque =_JxW[_qp] * _coord[_qp] * (_q_point[_qp] - _grain_centers[i]).cross(_dF[_qp][i]);
      _force_torque_store[6*i+0] += _JxW[_qp] * _coord[_qp] * _dF[_qp][i](0);
      _force_torque_store[6*i+1] += _JxW[_qp] * _coord[_qp] * _dF[_qp][i](1);
      _force_torque_store[6*i+2] += _JxW[_qp] * _coord[_qp] * _dF[_qp][i](2);
      _force_torque_store[6*i+3] += compute_torque(0);
      _force_torque_store[6*i+4] += compute_torque(1);
      _force_torque_store[6*i+5] += compute_torque(2);

      const RealGradient compute_torque_derivative_c =_JxW[_qp] * _coord[_qp] * (_q_point[_qp] - _grain_centers[i]).cross(_dFdc[_qp][i]);
      _force_torque_derivative_store[6*i+0] += _JxW[_qp] * _coord[_qp] * _dFdc[_qp][i](0);
      _force_torque_derivative_store[6*i+1] += _JxW[_qp] * _coord[_qp] * _dFdc[_qp][i](1);
      _force_torque_derivative_store[6*i+2] += _JxW[_qp] * _coord[_qp] * _dFdc[_qp][i](2);
      _force_torque_derivative_store[6*i+3] += compute_torque_derivative_c(0);
      _force_torque_derivative_store[6*i+4] += compute_torque_derivative_c(1);
      _force_torque_derivative_store[6*i+5] += compute_torque_derivative_c(2);
    }

    for (unsigned int i = 0; i < _op_num; ++i)
      for (unsigned int j = 0; j < _op_num; ++j)
        for (_qp=0; _qp<_qrule->n_points(); ++_qp)
        {
          const Real factor =_JxW[_qp] * _coord[_qp] * (*_dFdgradeta[i])[_qp][j];
          RealVectorValue I(1.0, 1.0, 1.0);
          const RealGradient compute_torque_derivative_eta = factor * (_q_point[_qp] - _grain_centers[i]).cross(I);
          _force_torque_eta_derivative_store[i][6*j+0] += factor;
          _force_torque_eta_derivative_store[i][6*j+1] += factor;
          _force_torque_eta_derivative_store[i][6*j+2] += factor;
          _force_torque_eta_derivative_store[i][6*j+3] += compute_torque_derivative_eta(0);
          _force_torque_eta_derivative_store[i][6*j+4] += compute_torque_derivative_eta(1);
          _force_torque_eta_derivative_store[i][6*j+5] += compute_torque_derivative_eta(2);
        }
}

void
ComputeGrainForceAndTorque::finalize()
{
  gatherSum(_force_torque_store);
  gatherSum(_force_torque_derivative_store);

  for (unsigned int i = 0; i < _op_num; ++i)
    gatherSum(_force_torque_eta_derivative_store[i]);

  for (unsigned int i = 0; i < _op_num; ++i)
  {
    _force_values[i](0) = _force_torque_store[6*i+0];
    _force_values[i](1) = _force_torque_store[6*i+1];
    _force_values[i](2) = _force_torque_store[6*i+2];
    _torque_values[i](0) = _force_torque_store[6*i+3];
    _torque_values[i](1) = _force_torque_store[6*i+4];
    _torque_values[i](2) = _force_torque_store[6*i+5];

    _force_derivatives[i](0) = _force_torque_derivative_store[6*i+0];
    _force_derivatives[i](1) = _force_torque_derivative_store[6*i+1];
    _force_derivatives[i](2) = _force_torque_derivative_store[6*i+2];
    _torque_derivatives[i](0) = _force_torque_derivative_store[6*i+3];
    _torque_derivatives[i](1) = _force_torque_derivative_store[6*i+4];
    _torque_derivatives[i](2) = _force_torque_derivative_store[6*i+5];

    for (unsigned int j = 0; j < _op_num; ++j)
    {
      _force_derivatives_eta[j][i](0) = _force_torque_eta_derivative_store[j][6*i+0];
      _force_derivatives_eta[j][i](1) = _force_torque_eta_derivative_store[j][6*i+1];
      _force_derivatives_eta[j][i](2) = _force_torque_eta_derivative_store[j][6*i+2];
      _torque_derivatives_eta[j][i](0) = _force_torque_eta_derivative_store[j][6*i+3];
      _torque_derivatives_eta[j][i](1) = _force_torque_eta_derivative_store[j][6*i+4];
      _torque_derivatives_eta[j][i](2) = _force_torque_eta_derivative_store[j][6*i+5];
    }
  }
}

void
ComputeGrainForceAndTorque::threadJoin(const UserObject & y)
{
  const ComputeGrainForceAndTorque & pps = static_cast<const ComputeGrainForceAndTorque &>(y);
  for (unsigned int i = 0; i < _ncomp; ++i)
  {
    _force_torque_store[i] += pps._force_torque_store[i];
    _force_torque_derivative_store[i] += pps._force_torque_derivative_store[i];
  }
  for (unsigned int i = 0; i < _op_num; ++i)
      for (unsigned int j = 0; j < _ncomp; ++j)
        _force_torque_eta_derivative_store[i][j] += pps._force_torque_eta_derivative_store[i][j];
}

const std::vector<RealGradient> &
ComputeGrainForceAndTorque::getForceValues() const
{
  return _force_values;
}

const std::vector<RealGradient> &
ComputeGrainForceAndTorque::getTorqueValues() const
{
  return _torque_values;
}

const std::vector<RealGradient> &
ComputeGrainForceAndTorque::getForceDerivatives() const
{
  return _force_derivatives;
}

const std::vector<RealGradient> &
ComputeGrainForceAndTorque::getTorqueDerivatives() const
{
  return _torque_derivatives;
}

const std::vector<RealGradient> &
ComputeGrainForceAndTorque::getForceEtaDerivatives(unsigned int jvar) const
{
  return _force_derivatives_eta[jvar];
}

const std::vector<RealGradient> &
ComputeGrainForceAndTorque::getTorqueEtaDerivatives(unsigned int jvar) const
{
  return _torque_derivatives_eta[jvar];
}
