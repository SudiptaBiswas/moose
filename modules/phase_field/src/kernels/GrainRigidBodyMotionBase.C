/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "GrainRigidBodyMotionBase.h"

template<>
InputParameters validParams<GrainRigidBodyMotionBase>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("Base class for adding rigid mody motion to grains");
  params.addRequiredCoupledVar("c", "Concentration");
  params.addRequiredCoupledVar("v", "Array of coupled variable names");
  params.addParam<std::string>("force_type", "Optional parameter that allows the user to define type of force density under consideration");
  return params;
}

GrainRigidBodyMotionBase::GrainRigidBodyMotionBase(const InputParameters & parameters) :
    Kernel(parameters),
    _c_var(coupled("c")),
    _c(coupledValue("c")),
    _grad_c(coupledGradient("c")),
    _ncrys(coupledComponents("v")),
    _vals(_ncrys),
    _vals_var(_ncrys),
    _force_type(isParamValid("force_type") ? getParam<std::string>("force_type") + "_" : "" ),
    _velocity_advection(getMaterialProperty<std::vector<RealGradient> >(_force_type + "advection_velocity")),
    _div_velocity_advection(getMaterialProperty<std::vector<Real> >(_force_type + "advection_velocity_divergence")),
    _velocity_advection_derivative_c(getMaterialProperty<std::vector<RealGradient> >(_force_type + "advection_velocity_derivative_c")),
    _div_velocity_advection_derivative_c(getMaterialProperty<std::vector<Real> >(_force_type + "advection_velocity_divergence_derivative_c")),
    _velocity_advection_derivative_eta(getMaterialProperty<std::vector<RealGradient> >(_force_type + "advection_velocity_derivative_eta"))
{
  //Loop through grains and load coupled variables into the arrays
  for (unsigned int i = 0; i < _ncrys; ++i)
  {
    _vals[i] = &coupledValue("v", i);
    _vals_var[i] = coupled("v", i);
  }
}
