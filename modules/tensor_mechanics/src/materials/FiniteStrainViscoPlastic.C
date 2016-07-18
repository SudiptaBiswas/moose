/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "FiniteStrainViscoPlastic.h"

template<>
InputParameters validParams<FiniteStrainViscoPlastic>()
{
  InputParameters params = validParams<FiniteStrainHyperElasticViscoPlastic>();
  params.addParam<std::vector<UserObjectName> >("internal_var_tensor_user_objects", "List of User object names that integrates internal variables and computes derivatives");
  params.addParam<std::vector<UserObjectName> >("internal_var_tensor_rate_user_objects", "List of User object names that computes internal variable rates and derivatives");
  params.addClassDescription("Material class for hyper-elastic visco-platic flow: Can handle multiple flow models defined by flowratemodel type user objects");

  return params;
}

FiniteStrainViscoPlastic::FiniteStrainViscoPlastic(const InputParameters & parameters) :
    FiniteStrainHyperElasticViscoPlastic(parameters),
    _int_var_tensor_uo_names(isParamValid("internal_var_tensor_user_objects") ? getParam<std::vector<UserObjectName> >("internal_var_tensor_user_objects") : std::vector<UserObjectName>(0)),
    _int_var_rate_tensor_uo_names(isParamValid("internal_var_rate_user_objects") ? getParam<std::vector<UserObjectName> >("internal_var_tensor_rate_user_objects") : std::vector<UserObjectName>(0))
{
}

void
FiniteStrainViscoPlastic::initUOVariables()
{
  FiniteStrainHyperElasticViscoPlastic::initUOVariables();

  initNumUserObjects(_int_var_tensor_uo_names, _num_int_var_tensor_uos);
  initNumUserObjects(_int_var_rate_tensor_uo_names, _num_int_var_rate_tensor_uos);

  initProp(_int_var_tensor_uo_names, _num_int_var_tensor_uos, _int_var_tensor_stateful_prop);
  initProp(_int_var_rate_tensor_uo_names, _num_int_var_rate_tensor_uos, _int_var_rate_tensor_prop);

  initPropOld(_int_var_tensor_uo_names, _num_int_var_uos, _int_var_stateful_prop_old);

  initUserObjects(_int_var_tensor_uo_names, _num_int_var_tensor_uos, _int_var_tensor_uo);
  initUserObjects(_int_var_rate_tensor_uo_names, _num_int_var_rate_tensor_uos, _int_var_rate_tensor_uo);

  _int_var_tensor_old.resize(_num_int_var_tensor_uos, 0.0);
}

void
FiniteStrainViscoPlastic::initJacobianVariables()
{
  FiniteStrainHyperElasticViscoPlastic::initJacobianVariables();

  _dintvarratetensor_dflowrate.resize(_num_flow_rate_uos);
  for (unsigned int i = 0; i < _num_flow_rate_uos; ++i)
    _dintvarratetensor_dflowrate[i].resize(_num_int_var_rate_tensor_uos);

  _dintvartensor_dflowrate_tmp.resize(_num_flow_rate_uos);
  for (unsigned int i = 0; i < _num_flow_rate_uos; ++i)
    _dintvartensor_dflowrate_tmp[i].resize(_num_int_var_tensor_uos);

  _dintvarratetensor_dintvartensor.resize(_num_int_var_rate_uos, _num_int_var_uos);
  _dintvartensor_dintvarratetensor.resize(_num_int_var_uos, _num_int_var_rate_uos);
  _dintvartensor_dflowrate.resize(_num_int_var_uos, _num_flow_rate_uos);
  _dintvartensor_dintvar.resize(_num_int_var_uos, _num_int_var_uos);
  _dintvartensor_dintvartensor.resize(_num_int_var_uos, _num_int_var_uos);
  // _dstrength_dintvartensor.resize(_num_strength_uos, _num_int_var_uos);

  _dintvartensor_dintvar_x.resize(_num_int_var_uos);
}

void
FiniteStrainViscoPlastic::initQpStatefulProperties()
{
  FiniteStrainHyperElasticViscoPlastic::initQpStatefulProperties();

  for (unsigned int i = 0; i < _num_int_var_tensor_uos; ++i)
  {
    (*_int_var_tensor_stateful_prop[i])[_qp] = 0.0;
    (*_int_var_tensor_stateful_prop_old[i])[_qp] = 0.0;
  }

  for (unsigned int i = 0; i < _num_int_var_rate_tensor_uos; ++i)
    (*_int_var_rate_tensor_prop[i])[_qp] = 0.0;
}

void
FiniteStrainViscoPlastic::saveOldState()
{
  FiniteStrainHyperElasticViscoPlastic::saveOldState();

  for (unsigned int i = 0; i < _num_int_var_tensor_uos; ++i)
    _int_var_tensor_old[i] = (*_int_var_tensor_stateful_prop_old[i])[_qp];
}

void
FiniteStrainViscoPlastic::preSolveQp()
{
  FiniteStrainHyperElasticViscoPlastic::preSolveQp();

  for (unsigned int i = 0; i < _num_int_var_tensor_uos; ++i)
    (*_int_var_tensor_stateful_prop[i])[_qp] = (*_int_var_tensor_stateful_prop_old[i])[_qp] = _int_var_old[i];
}

void
FiniteStrainViscoPlastic::recoverOldState()
{
  FiniteStrainHyperElasticViscoPlastic::recoverOldState();

  for (unsigned int i = 0; i < _num_int_var_tensor_uos; ++i)
    (*_int_var_tensor_stateful_prop_old[i])[_qp] = _int_var_tensor_old[i];
}

void
FiniteStrainViscoPlastic::preSolveFlowrate()
{
  FiniteStrainHyperElasticViscoPlastic::preSolveFlowrate();

  for (unsigned int i = 0; i < _num_int_var_tensor_uos; ++i)
    (*_int_var_tensor_stateful_prop[i])[_qp] = (*_int_var_tensor_stateful_prop_old[i])[_qp];
}

void
FiniteStrainViscoPlastic::postSolveFlowrate()
{
  FiniteStrainHyperElasticViscoPlastic::postSolveFlowrate();

  for (unsigned int i = 0; i < _num_int_var_tensor_uos; ++i)
    (*_int_var_tensor_stateful_prop_old[i])[_qp] = (*_int_var_tensor_stateful_prop[i])[_qp];
}
