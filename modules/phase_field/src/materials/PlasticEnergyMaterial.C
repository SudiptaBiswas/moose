/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "PlasticEnergyMaterial.h"
#include "RankTwoTensor.h"
#include "RankFourTensor.h"

template<>
InputParameters validParams<PlasticEnergyMaterial>()
{
  InputParameters params = validParams<DerivativeFunctionMaterialBase>();
  params.addClassDescription("Free energy material for the plastic energy contributions.");
  params.addParam<std::string>("base_name", "Material property base name");
  params.addRequiredCoupledVar("args", "Arguments of F() - use vector coupling");
  params.addCoupledVar("displacement_gradients", "Vector of displacement gradient variables (see Modules/PhaseField/DisplacementGradients action)");
  params.addParam<MaterialPropertyName>("yield", "yield", "yield strength.");
  params.addParam<std::string>("intvar_prop_tensor_name", "intvar_tensor", "intvar_tensor_name");
  params.addParam<std::string>("intvar_prop_name", "intvar", "intvar_prop_name");
  params.addParam<std::string>("flow_rate_prop_name", "flow_rate", "flow_rate_prop_name");
  params.addCoupledVar("plasticity_variable", "Name of flow rate property: Same as the flow rate user object name specified in input file");
  params.addParam<Real>("A", "Gradient co-efficient");
  params.addParam<Real>("C", "hardening multiplier");
  params.addParam<Real>("H", "hardening co-efficient");
  params.addParam<UserObjectName>("flow_rate_user_object", "List of User object names that computes flow rate and derivatives");
  params.addParam<UserObjectName>("strength_user_object", "List of User object names that computes strength variables and derivatives");
  params.addParam<UserObjectName>("internal_var_user_object", "List of User object names that integrates internal variables and computes derivatives");
  params.addParam<UserObjectName>("internal_var_rate_user_object", "List of User object names that computes internal variable rates and derivatives");
  params.addParam<UserObjectName>("internal_var_tensor_user_object", "List of User object names that integrates internal variables and computes derivatives");
  params.addParam<UserObjectName>("internal_var_tensor_rate_user_object", "List of User object names that computes internal variable rates and derivatives");
  return params;
}

PlasticEnergyMaterial::PlasticEnergyMaterial(const InputParameters & parameters) :
    DerivativeFunctionMaterialBase(parameters),
    _base_name(isParamValid("base_name") ? getParam<std::string>("base_name") + "_" : "" ),
    _intvar_prop_tensor_name(isParamValid("intvar_prop_tensor_name") ? getParam<std::string>(_base_name + "intvar_prop_tensor_name") : ""),
    _intvar_tensor(getMaterialPropertyByName<RankTwoTensor>(_base_name + _intvar_prop_tensor_name)),
    _intvar_prop_name(isParamValid("intvar_prop_name") ? getParam<std::string>(_base_name + "intvar_prop_name") : ""),
    _intvar(getMaterialPropertyByName<Real>(_base_name + _intvar_prop_name)),
    _flow_rate_prop_name(getParam<std::string>("flow_rate_prop_name")),
    // _intvar(coupledValue("plasticity_variable")),
    // _grad_intvar(coupledGradient("plasticity_variable")),
    _yield(getMaterialProperty<Real>("yield")),
    _C(getParam<Real>("C")),
    _A(getParam<Real>("A")),
    _H(getParam<Real>("H")),
    _flow_rate_uo_name(getParam<UserObjectName>("flow_rate_user_object")),
    _strength_uo_name(getParam<UserObjectName>("strength_user_object")),
    _int_var_uo_name(getParam<UserObjectName>("internal_var_user_object")),
    _int_var_rate_uo_name(getParam<UserObjectName>("internal_var_rate_user_object")),
    _int_var_tensor_uo_name(getParam<UserObjectName>("internal_var_tensor_user_object")),
    _int_var_rate_tensor_uo_name(getParam<UserObjectName>("internal_var_tensor_rate_user_object")),
    _flow_rate_uo(getUserObjectByName<VPHardeningRateBase>(_flow_rate_uo_name)),
    _strength_uo(getUserObjectByName<HEVPStrengthUOBase>(_strength_uo_name)),
    _int_var_uo(getUserObjectByName<VPHardeningBase>(_int_var_uo_name)),
    _int_var_rate_uo(getUserObjectByName<VPHardeningRateBase>(_int_var_rate_uo_name)),
    _int_var_tensor_uo(getUserObjectByName<VPHardeningBase>(_int_var_tensor_uo_name)),
    _int_var_rate_tensor_uo(getUserObjectByName<VPHardeningRateBase>(_int_var_rate_tensor_uo_name))
{
  _dyieldstrength.resize(_nargs);
  _d2yieldstrength.resize(_nargs);
  // fetch stress and elasticity tensor derivatives (in simple eigenstrain models this is is only w.r.t. 'c')
  for (unsigned int i = 0; i < _nargs; ++i)
  {
    _dyieldstrength[i] = &getMaterialPropertyDerivativeByName<Real>(_base_name + "intvar", _arg_names[i]);

    _d2yieldstrength[i].resize(_nargs);

    for (unsigned int j = 0; j < _nargs; ++j)
      _d2yieldstrength[i][j] = &getMaterialPropertyDerivativeByName<Real>(_base_name + "intvar", _arg_names[i], _arg_names[j]);
  }
}

Real
PlasticEnergyMaterial::computeF()
{
  return 1/3 * _C * _intvar_tensor[_qp].doubleContraction(_intvar_tensor[_qp])
         + 0.5 * _H * _intvar[_qp] * _intvar[_qp];
}

Real
PlasticEnergyMaterial::computeDF(unsigned int i_var)
{
  unsigned int i = argIndex(i_var);
  computeDerivatives();
  Real dintvar_darg = _dintvar_dintvarrate * _dintvarrate_dflowrate * _dflowrate_dstrength * (*_dyieldstrength[i])[_qp];
  RankTwoTensor dintvartensor_darg = _dintvartensor_dintvarratetensor * _dintvarratetensor_dflowrate * _dflowrate_dstrength * (*_dyieldstrength[i])[_qp];

  // product rule d/di computeF (doubleContraction commutes)
  return 1/3 * _C * (dintvartensor_darg).doubleContraction(_intvar_tensor[_qp])
         + 1/3 * _C * (_intvar_tensor[_qp]).doubleContraction(dintvartensor_darg)
         + _H * _intvar[_qp] * dintvar_darg;
}

Real
PlasticEnergyMaterial::computeD2F(unsigned int i_var, unsigned int j_var)
{
  unsigned int i = argIndex(i_var);
  unsigned int j = argIndex(j_var);

  computeDerivatives();
  Real dintvar_darg = _dintvar_dintvarrate * _dintvarrate_dflowrate * _dflowrate_dstrength * (*_dyieldstrength[i])[_qp];
  RankTwoTensor dintvartensor_darg = _dintvartensor_dintvarratetensor * _dintvarratetensor_dflowrate * _dflowrate_dstrength * (*_dyieldstrength[i])[_qp];
  Real d2intvar_darg2 = _dintvar_dintvarrate * _dintvarrate_dflowrate * _dflowrate_dstrength * (*_d2yieldstrength[i][j])[_qp];
  RankTwoTensor d2intvartensor_darg2 = _dintvartensor_dintvarratetensor * _dintvarratetensor_dflowrate * _dflowrate_dstrength * (*_d2yieldstrength[i][j])[_qp];

  return 1/3 * _C * (d2intvartensor_darg2).doubleContraction(_intvar_tensor[_qp])
         + 1/3 * _C * (_intvar_tensor[_qp]).doubleContraction(d2intvartensor_darg2)
         + 2/3 * _C * (dintvartensor_darg).doubleContraction(dintvartensor_darg)
         + _H * _intvar[_qp] * d2intvar_darg2
         + _H * dintvar_darg * dintvar_darg;
}

void
PlasticEnergyMaterial::computeDerivatives()
{
  _int_var_rate_uo.computeDerivative(_qp, _strength_uo_name, _dflowrate_dstrength);

  _int_var_rate_uo.computeDerivative(_qp, _flow_rate_uo_name, _dintvarrate_dflowrate);
  _int_var_uo.computeDerivative(_qp, _dt_substep, _int_var_rate_uo_name, _dintvar_dintvarrate);

  _int_var_rate_tensor_uo.computeTensorDerivative(_qp, _flow_rate_uo_name, _dintvarratetensor_dflowrate);
  _int_var_tensor_uo.computeRankFourTensorDerivative(_qp, _dt_substep, _int_var_rate_tensor_uo_name, _dintvartensor_dintvarratetensor);
}
