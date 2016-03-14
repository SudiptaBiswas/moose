/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef VPHARDENINGMATERIALBASE_H
#define VPHARDENINGMATERIALBASE_H

#include "Material.h"
#include "VPHardeningBase.h"
#include "VPHardeningRateBase.h"

class VPHardeningMaterialBase;

template<>
InputParameters validParams<VPHardeningMaterialBase>();

/**
 * This is a base class for transforming the userobjects to material
 * properties for each internal parameters
 */
class VPHardeningMaterialBase : public Material
{
public:
  VPHardeningMaterialBase (const InputParameters & parameters);

protected:
  /**
   *  This function initializes the properties, stateful properties and user objects
   *  The properties and stateful properties associated with user objects are only initialized here
   *  The properties have the same name as the user object name
   **/
  virtual void initUOVariables();

  /// This function calculates the number of each user object type
  void initNumUserObjects(const std::vector<UserObjectName> &, unsigned int &);

  /// This function initializes properties for each user object
  template <typename T>
  void initProp(const std::vector<UserObjectName> &, unsigned int, std::vector<MaterialProperty<T> *> &);

  /**
   * This function initializes old for stateful properties associated with user object
   * Only user objects that update internal variables have an associated old property
   **/
  template <typename T>
  void initPropOld(const std::vector<UserObjectName> &, unsigned int, std::vector<MaterialProperty<T> *> &);

  /// This function initializes user objects
  template <typename T>
  void initUserObjects(const std::vector<UserObjectName> &, unsigned int, std::vector<const T *> &);


  /// Names of flow rate user objects
  std::vector<UserObjectName> _flow_rate_uo_names;
  /// Names of flow user objects
  std::vector<UserObjectName> _flow_uo_names;
  /// Names of internal variable user objects
  std::vector<UserObjectName> _int_var_uo_names;
  /// Names of internal variable rate user objects
  std::vector<UserObjectName> _int_var_rate_uo_names;

  /// Number of flow rate user objects
  unsigned int _num_flow_rate_uos;
  /// Number of flow user objects
  unsigned int _num_flow_uos;
  /// Number of internal variable user objects
  unsigned int _num_int_var_uos;
  /// Number of internal variable rate user objects
  unsigned int _num_int_var_rate_uos;

  /// Flow rate user objects
  std::vector<const VPHardeningRateBase *> _flow_rate_uo;
  /// Strength user objects
  std::vector<const VPHardeningBase *> _flow_uo;
  /// Internal variable user objects
  std::vector<const VPHardeningBase *> _int_var_uo;
  /// Internal variable rate user objects
  std::vector<const VPHardeningRateBase *> _int_var_rate_uo;

  std::vector< MaterialProperty<Real> * > _flow_rate_prop;
  std::vector< MaterialProperty<Real> * > _flow_prop;
  std::vector< MaterialProperty<Real> * > _int_var_prop;
  std::vector< MaterialProperty<Real> * > _int_var_rate_prop;

  std::vector< MaterialProperty<Real> * > _flow_rate_prop_old;
  std::vector< MaterialProperty<Real> * > _flow_prop_old;
  std::vector< MaterialProperty<Real> * > _int_var_prop_old;
  std::vector< MaterialProperty<Real> * > _int_var_rate_prop_old;

  // std::vector<Real> _int_var_old;

};

#endif //VPHARDENINGMATERIALBASE_H
