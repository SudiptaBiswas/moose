/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "GrainAdvectionVelocity.h"

template<>
InputParameters validParams<GrainAdvectionVelocity>()
{
  InputParameters params = validParams<Material>();
  params.addClassDescription("Calculation the advection velocity of grain due to rigid vody translation and rotation");
  params.addCoupledVar("etas", "Array of other coupled order parameters");
  params.addCoupledVar("c", "Concentration field");
  params.addParam<Real>("translation_constant", 500, "constant value characterizing grain translation");
  params.addParam<Real>("rotation_constant", 1.0, "constant value characterizing grain rotation");
  params.addParam<std::string>("base_name", "Optional parameter that allows the user to define type of force density under consideration");
  params.addParam<UserObjectName>("grain_data", "userobject for getting volume and center of mass of grains");
  params.addParam<UserObjectName>("grain_force", "userobject for getting force and torque acting on grains");
  return params;
}

GrainAdvectionVelocity::GrainAdvectionVelocity(const InputParameters & parameters) :
   DerivativeMaterialInterface<Material>(parameters),
   _grain_data(getUserObject<ComputeGrainCenterUserObject>("grain_data")),
   _grain_volumes(_grain_data.getGrainVolumes()),
   _grain_centers(_grain_data.getGrainCenters()),
   _grain_force_torque(getUserObject<GrainForceAndTorqueInterface>("grain_force")),
   _grain_forces(_grain_force_torque.getForceValues()),
   _grain_torques(_grain_force_torque.getTorqueValues()),
   _grain_force_derivatives(_grain_force_torque.getForceDerivatives()),
   _grain_torque_derivatives(_grain_force_torque.getTorqueDerivatives()),
   _grain_force_derivatives_jac(_grain_force_torque.getForceDerivativesJacobian()),
   _grain_torque_derivatives_jac(_grain_force_torque.getTorqueDerivativesJacobian()),
   _mt(getParam<Real>("translation_constant")),
   _mr(getParam<Real>("rotation_constant")),
   _ncrys(_grain_forces.size()),
   _vals(_ncrys),
   _grad_vals(_ncrys),
   _vals_dof(_ncrys),
   _vals_name(_ncrys),
   _c_name(getVar("c", 0)->name()),
   _c_dof(getVar("c", 0)->dofIndices()),
   _base_name(isParamValid("base_name") ? getParam<std::string>("base_name") + "_" : "" ),
   _velocity_advection(declareProperty<std::vector<RealGradient> >(_base_name + "advection_velocity")),
   _div_velocity_advection(declareProperty<std::vector<Real> >(_base_name + "advection_velocity_divergence")),
   _velocity_advection_derivative_c(declarePropertyDerivative<std::vector<std::vector<RealGradient> > >(_base_name + "advection_velocity", _c_name )),
   _div_velocity_advection_derivative_c(declarePropertyDerivative<std::vector<std::vector<Real> > >(_base_name + "advection_velocity_divergence", _c_name)),
   _velocity_advection_derivative_eta(declarePropertyDerivative<std::vector<RealGradient> >(_base_name + "advection_velocity", "eta"))
{
  _velocity_advection_derivative_gradeta.resize(_ncrys);
  _div_velocity_advection_derivative_gradeta.resize(_ncrys);
  //Loop through grains and load coupled variables into the arrays
  for (unsigned int i = 0; i < _ncrys; ++i)
  {
    _vals[i] = &coupledValue("etas", i);
    _grad_vals[i] = &coupledGradient("etas",i);
    _vals_dof[i] = getVar("etas", i)->dofIndices();
    _vals_name[i] = getVar("etas",i)->name();

    _velocity_advection_derivative_gradeta[i] = &declarePropertyDerivative<std::vector<std::vector<RealGradient> > >(_base_name + "advection_velocity", "grad" + _vals_name[i]);
    _div_velocity_advection_derivative_gradeta[i] = &declarePropertyDerivative<std::vector<std::vector<Real> > >(_base_name + "advection_velocity_divergence", "grad" + _vals_name[i]);
  }
}

void
GrainAdvectionVelocity::computeQpProperties()
{
  _velocity_advection[_qp].resize(_ncrys);
  _div_velocity_advection[_qp].resize(_ncrys);
  _velocity_advection_derivative_eta[_qp].resize(_ncrys);
  _velocity_advection_derivative_c[_qp].resize(_ncrys);
  _div_velocity_advection_derivative_c[_qp].resize(_ncrys);

  for (unsigned int i = 0; i < _ncrys; ++i)
  {
    const RealGradient velocity_translation = _mt / _grain_volumes[i] * ((*_vals[i])[_qp] * _grain_forces[i]);
    const Real div_velocity_translation = _mt / _grain_volumes[i] * ((*_grad_vals[i])[_qp] * _grain_forces[i]);
    const RealGradient velocity_rotation = _mr / _grain_volumes[i] * (_grain_torques[i].cross(_q_point[_qp] - _grain_centers[i])) * (*_vals[i])[_qp];
    const Real div_velocity_rotation = _mr / _grain_volumes[i] * (_grain_torques[i].cross(_q_point[_qp] - _grain_centers[i])) * (*_grad_vals[i])[_qp];

    // const RealGradient velocity_translation_derivative_c = _mt / _grain_volumes[i] * ((*_vals[i])[_qp] * _grain_force_derivatives[i]);
    // const Real div_velocity_translation_derivative_c = _mt / _grain_volumes[i] * ((*_grad_vals[i])[_qp] * _grain_force_derivatives[i]);
    // const RealGradient velocity_rotation_derivative_c = _mr / _grain_volumes[i] * (_grain_torque_derivatives[i].cross(_q_point[_qp] - _grain_centers[i])) * (*_vals[i])[_qp];
    // const Real div_velocity_rotation_derivative_c = _mr / _grain_volumes[i] * (_grain_torque_derivatives[i].cross(_q_point[_qp] - _grain_centers[i])) * (*_grad_vals[i])[_qp] ;

    const RealGradient velocity_translation_derivative_eta = _mt / _grain_volumes[i] * _grain_forces[i];
    const RealGradient velocity_rotation_derivative_eta = _mr / _grain_volumes[i] * (_grain_torques[i].cross(_q_point[_qp] - _grain_centers[i]));

    _velocity_advection[_qp][i] = velocity_translation + velocity_rotation;
    _div_velocity_advection[_qp][i] = div_velocity_translation + div_velocity_rotation;
    _velocity_advection_derivative_eta[_qp][i] = velocity_translation_derivative_eta + velocity_rotation_derivative_eta;

    _velocity_advection_derivative_c[_qp][i].resize(_subproblem.es().n_dofs());
    _div_velocity_advection_derivative_c[_qp][i].resize(_subproblem.es().n_dofs());

    for (unsigned int k = 0; k < _c_dof.size(); ++k)
    {
      const RealGradient velocity_translation_jacobian_c = _mt / _grain_volumes[i] * ((*_vals[i])[_qp] * _grain_force_derivatives_jac[i][_c_dof[k]]);
      const Real div_velocity_translation_jacobian_c = _mt / _grain_volumes[i] * ((*_grad_vals[i])[_qp] * _grain_force_derivatives_jac[i][_c_dof[k]]);
      const RealGradient velocity_rotation_jacobian_c = _mr / _grain_volumes[i] * (_grain_torque_derivatives_jac[i][_c_dof[k]].cross(_q_point[_qp] - _grain_centers[i])) * (*_vals[i])[_qp];
      const Real div_velocity_rotation_jacobian_c = _mr / _grain_volumes[i] * (_grain_torque_derivatives_jac[i][_c_dof[k]].cross(_q_point[_qp] - _grain_centers[i])) * (*_grad_vals[i])[_qp] ;

      _velocity_advection_derivative_c[_qp][i][_c_dof[k]] = velocity_translation_jacobian_c + velocity_rotation_jacobian_c;
      _div_velocity_advection_derivative_c[_qp][i][_c_dof[k]] = div_velocity_translation_jacobian_c + div_velocity_rotation_jacobian_c;
    }
  }

  for (unsigned int i = 0; i < _ncrys; ++i)
  {
    (*_velocity_advection_derivative_gradeta[i])[_qp].resize(_ncrys);
    (*_div_velocity_advection_derivative_gradeta[i])[_qp].resize(_ncrys);

    for (unsigned int j = 0; j < _ncrys; ++j)
    {
      (*_velocity_advection_derivative_gradeta[i])[_qp][j].resize(_subproblem.es().n_dofs());
      (*_div_velocity_advection_derivative_gradeta[i])[_qp][j].resize(_subproblem.es().n_dofs());

      for (unsigned int k = 0; k < _vals_dof[i].size(); ++k)
      {
        const RealGradient velocity_translation_jacobian_gradeta = _mt / _grain_volumes[j] * ((*_vals[j])[_qp] * _grain_force_derivatives_jac[j][_vals_dof[i][k]]);
        const Real div_velocity_translation_jacobian_gradeta = _mt / _grain_volumes[j] * ((*_grad_vals[j])[_qp] * _grain_force_derivatives_jac[j][_vals_dof[i][k]]);
        const RealGradient velocity_rotation_jacobian_gradeta = _mr / _grain_volumes[j] * (_grain_torque_derivatives_jac[j][_vals_dof[i][k]].cross(_q_point[_qp] - _grain_centers[j])) * (*_vals[j])[_qp];
        const Real div_velocity_rotation_jacobian_gradeta = _mr / _grain_volumes[j] * (_grain_torque_derivatives_jac[j][_vals_dof[i][k]].cross(_q_point[_qp] - _grain_centers[j])) * (*_grad_vals[j])[_qp] ;

        (*_velocity_advection_derivative_gradeta[i])[_qp][j][_vals_dof[i][k]] = velocity_translation_jacobian_gradeta + velocity_rotation_jacobian_gradeta;
        (*_div_velocity_advection_derivative_gradeta[i])[_qp][j][_vals_dof[i][k]] = div_velocity_translation_jacobian_gradeta + div_velocity_rotation_jacobian_gradeta;
      }
    }
  }
}
