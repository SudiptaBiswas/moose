/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "VPHardeningMaterialBase.h"

template<>
InputParameters validParams<VPHardeningMaterialBase>()
{
  InputParameters params = validParams<Material>();
  params.addClassDescription("Material class for converting UserObjects to material properties");
  params.addParam<std::vector<UserObjectName> >("flow_rate_user_objects", "List of User object names that computes flow rate and derivatives");
  params.addParam<std::vector<UserObjectName> >("Flow_user_objects", "List of User object names that computes flow variables and derivatives");
  params.addParam<std::vector<UserObjectName> >("internal_var_user_objects", "List of User object names that integrates internal variables and computes derivatives");
  params.addParam<std::vector<UserObjectName> >("internal_var_rate_user_objects", "List of User object names that computes internal variable rates and derivatives");
  return params;
}

VPHardeningMaterialBase::VPHardeningMaterialBase(const InputParameters & parameters) :
    Material(parameters),
    _flow_rate_uo_names(isParamValid("flow_rate_user_objects") ? getParam<std::vector<UserObjectName> >("flow_rate_user_objects") : std::vector<UserObjectName>(0)),
    _flow_uo_names(isParamValid("flow_user_objects") ? getParam<std::vector<UserObjectName> >("flow_user_objects") : std::vector<UserObjectName>(0)),
    _int_var_uo_names(isParamValid("internal_var_user_objects") ? getParam<std::vector<UserObjectName> >("internal_var_user_objects") : std::vector<UserObjectName>(0)),
    _int_var_rate_uo_names(isParamValid("internal_var_rate_user_objects") ? getParam<std::vector<UserObjectName> >("internal_var_rate_user_objects") : std::vector<UserObjectName>(0))
{
  initUOVariables();
}

void
VPHardeningMaterialBase::initUOVariables()
{
  initNumUserObjects(_flow_rate_uo_names, _num_flow_rate_uos);
  initNumUserObjects(_flow_uo_names, _num_flow_uos);
  initNumUserObjects(_int_var_uo_names, _num_int_var_uos);
  initNumUserObjects(_int_var_rate_uo_names, _num_int_var_rate_uos);

  initProp(_flow_rate_uo_names, _num_flow_rate_uos, _flow_rate_prop);
  initProp(_flow_uo_names, _num_flow_uos, _flow_prop);
  initProp(_int_var_uo_names, _num_int_var_uos, _int_var_prop);
  initProp(_int_var_rate_uo_names, _num_int_var_rate_uos, _int_var_rate_prop);

  initPropOld(_flow_rate_uo_names, _num_flow_rate_uos, _flow_rate_prop_old);
  initPropOld(_flow_uo_names, _num_flow_uos, _flow_prop_old);
  initPropOld(_int_var_uo_names, _num_int_var_uos, _int_var_prop_old);
  initPropOld(_int_var_rate_uo_names, _num_int_var_rate_uos, _int_var_rate_prop_old);

  initUserObjects(_flow_rate_uo_names, _num_flow_rate_uos, _flow_rate_uo);
  initUserObjects(_flow_uo_names, _num_flow_uos, _flow_uo);
  initUserObjects(_int_var_uo_names, _num_int_var_uos, _int_var_uo);
  initUserObjects(_int_var_rate_uo_names, _num_int_var_rate_uos, _int_var_rate_uo);
}

void
VPHardeningMaterialBase::initNumUserObjects(const std::vector<UserObjectName> & uo_names, unsigned int & uo_num)
{
  uo_num = uo_names.size();
}

template <typename T>
void
VPHardeningMaterialBase::initProp(const std::vector<UserObjectName> & uo_names, unsigned int uo_num, std::vector<MaterialProperty<T> *> & uo_prop)
{
  uo_prop.resize(uo_num);
  for (unsigned int i = 0; i < uo_num; ++i)
    uo_prop[i] = &declareProperty<T>(uo_names[i]);
}

template <typename T>
void
VPHardeningMaterialBase::initPropOld(const std::vector<UserObjectName> & uo_names, unsigned int uo_num, std::vector<MaterialProperty<T> *> & uo_prop_old)
{
  uo_prop_old.resize(uo_num);
  for (unsigned int i = 0; i < uo_num; ++i)
    uo_prop_old[i] = &declarePropertyOld<T>(uo_names[i]);
}

template <typename T>
void
VPHardeningMaterialBase::initUserObjects(const std::vector<UserObjectName> & uo_names, unsigned int uo_num, std::vector<const T *> & uo)
{
  uo.resize(uo_num);

  if (uo_num == 0)
    mooseError("Specify atleast one user object of type" << typeid(T).name());

  for (unsigned int i = 0; i < uo_num; ++i)
    uo[i] = &getUserObjectByName<T>(uo_names[i]);
}
