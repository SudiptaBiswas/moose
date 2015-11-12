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
  params.addParam<std::string>("base_name", "Optional parameter that allows the user to define type of force density under consideration");
  params.addParam<MaterialPropertyName>("advection_velocity", "advection_velocity", "Advection velocity material");
  return params;
}

GrainRigidBodyMotionBase::GrainRigidBodyMotionBase(const InputParameters & parameters) :
    Kernel(parameters),
    _c_var(coupled("c")),
    _c_value(coupledValue("c")),
    _grad_c(coupledGradient("c")),
    _c_name(getVar("c", 0)->name()),
    _c_dof(getVar("c", 0)->dofIndices()),
    _ncrys(coupledComponents("v")),
    _vals(_ncrys),
    _vals_var(_ncrys),
    _vals_name(_ncrys),
    _vals_dof(_ncrys),
    _base_name(isParamValid("base_name") ? getParam<std::string>("base_name") + "_" : "" ),
    _vadv_name(getParam<MaterialPropertyName>("advection_velocity")),
    _velocity_advection(getMaterialProperty<std::vector<RealGradient> >(_base_name + _vadv_name)),
    _div_velocity_advection(getMaterialProperty<std::vector<Real> >(_base_name + _vadv_name + "_divergence")),
    _velocity_advection_derivative_c(getMaterialPropertyByName<std::vector<std::vector<RealGradient> > >(propertyNameFirst(_base_name + _vadv_name, _c_name))),
    _div_velocity_advection_derivative_c(getMaterialPropertyByName<std::vector<std::vector<Real> > >(propertyNameFirst(_base_name + _vadv_name + "_divergence", _c_name))),
    _velocity_advection_derivative_eta(getMaterialPropertyByName<std::vector<RealGradient> >(propertyNameFirst(_base_name + _vadv_name, "eta")))
{
  _velocity_advection_derivative_gradeta.resize(_ncrys);
  _div_velocity_advection_derivative_gradeta.resize(_ncrys);
  //Loop through grains and load coupled variables into the arrays
  for (unsigned int i = 0; i < _ncrys; ++i)
  {
    _vals[i] = &coupledValue("v", i);
    _vals_var[i] = coupled("v", i);
    _vals_name[i] = getVar("v", i)->name();
    _vals_dof[i] = &(getVar("v", i)->dofIndices());
    //_vals_dof[i].resize(&(getVar("v", i)->dofIndices()).size());

    _velocity_advection_derivative_gradeta[i] = &getMaterialPropertyByName<std::vector<std::vector<RealGradient> > >(propertyNameFirst(_base_name + _vadv_name, "grad" + _vals_name[i]));
    _div_velocity_advection_derivative_gradeta[i] = &getMaterialPropertyByName<std::vector<std::vector<Real> > >(propertyNameFirst(_base_name + _vadv_name + "_divergence", "grad" + _vals_name[i]));
  }
}
