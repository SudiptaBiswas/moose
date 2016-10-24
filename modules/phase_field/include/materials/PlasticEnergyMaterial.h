/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef PLASTICENERGYMATERIAL_H
#define PLASTICENERGYMATERIAL_H

#include "DerivativeFunctionMaterialBase.h"
#include "HEVPStrengthUOBase.h"
#include "VPHardeningRateBase.h"
#include "VPHardeningBase.h"

// Forward Declaration
class PlasticEnergyMaterial;
class RankTwoTensor;
class RankFourTensor;

template<>
InputParameters validParams<DerivativeFunctionMaterialBase>();

/**
 * Material class to compute the elastic free energy and its derivatives
 */
class PlasticEnergyMaterial : public DerivativeFunctionMaterialBase
{
public:
  PlasticEnergyMaterial(const InputParameters & parameters);

protected:
  virtual Real computeF();
  virtual Real computeDF(unsigned int i_var);
  virtual Real computeD2F(unsigned int i_var, unsigned int j_var);

  void computeDerivatives();

  std::string _base_name;

  std::string _intvar_prop_tensor_name;
  const MaterialProperty<RankTwoTensor> & _intvar_tensor;

  std::string _intvar_prop_name;
  const MaterialProperty<Real> & _intvar;
  std::string _flow_rate_prop_name;
  const MaterialProperty<Real> & _yield;

  const Real _C;
  const Real _A;
  const Real _H;

  /// Names of flow rate user objects
  UserObjectName _flow_rate_uo_name;
  /// Names of strength user objects
  UserObjectName _strength_uo_name;
  /// Names of internal variable user objects
  UserObjectName _int_var_uo_name;
  /// Names of internal variable rate user objects
  UserObjectName _int_var_rate_uo_name;
  /// Names of internal variable user objects
  UserObjectName _int_var_tensor_uo_name;
  /// Names of internal variable rate user objects
  UserObjectName _int_var_rate_tensor_uo_name;

  /// Flow rate user objects
  const VPHardeningRateBase & _flow_rate_uo;
  /// Strength user objects
  const HEVPStrengthUOBase & _strength_uo;
  /// Internal variable user objects
  const VPHardeningBase & _int_var_uo;
  /// Internal variable rate user objects
  const VPHardeningRateBase & _int_var_rate_uo;
  /// Internal variable user objects
  const VPHardeningBase & _int_var_tensor_uo;
  /// Internal variable rate user objects
  const VPHardeningRateBase & _int_var_rate_tensor_uo;

  /// Jacobian variables
  Real _dflowrate_dstrength;
  Real _dintvarrate_dflowrate;
  Real _dintvar_dintvarrate;
  RankTwoTensor _dintvarratetensor_dflowrate;
  RankFourTensor _dintvartensor_dintvarratetensor;

  Real _dt_substep;

  std::vector<const MaterialProperty<Real> *> _dyieldstrength;
  std::vector<std::vector<const MaterialProperty<Real> *> > _d2yieldstrength;
};

#endif //PLASTICENERGYMATERIAL_H
