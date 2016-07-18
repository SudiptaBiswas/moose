/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef FINITESTRAINVISCOPLASTIC_H
#define FINITESTRAINVISCOPLASTIC_H

#include "FiniteStrainHyperElasticViscoPlastic.h"
#include "HEVPFlowRateUOBase.h"
#include "HEVPStrengthUOBase.h"
#include "HEVPInternalVarUOBase.h"
#include "HEVPInternalVarRateUOBase.h"
#include "VPHardeningRateBase.h"
#include "VPHardeningBase.h"

class FiniteStrainViscoPlastic;

template<>
InputParameters validParams<FiniteStrainViscoPlastic>();

/**
 * This class solves the viscoplastic flow rate equations in the total form
 * Involves 4 different types of user objects that calculates:
 * Internal variable rates - functions of internal variables and flow rates
 * Internal variables - functions of internal variables
 * Strengths - functions of internal variables
 * Flow rates - functions of strengths and PK2 stress
 * Flow directions - functions of strengths and PK2 stress
 * The associated derivatives from user objects are assembled and the system is solved using NR
 */
class FiniteStrainViscoPlastic : public FiniteStrainHyperElasticViscoPlastic
{
public:
  FiniteStrainViscoPlastic (const InputParameters & parameters);

protected:
  /**
   *  This function initializes the properties, stateful properties and user objects
   *  The properties and stateful properties associated with user objects are only initialized here
   *  The properties have the same name as the user object name
   **/
   virtual void initUOVariables();

  /// This function initialize variables required for Jacobian calculation
  virtual void initJacobianVariables();

  /// Initializes state
  virtual void initQpStatefulProperties();

  /// This function saves the old stateful properties that is modified during sub stepping
  virtual void saveOldState();

  /// Sets state for solve
  virtual void preSolveQp();

  /// This function restores the the old stateful properties after a successful solve
  virtual void recoverOldState();

  /// Sets state for solve (Inside substepping)
  virtual void preSolveFlowrate();

  /// Update state for output (Inside substepping)
  virtual void postSolveFlowrate();

  /// Names of internal variable user objects
  std::vector<UserObjectName> _int_var_tensor_uo_names;
  /// Names of internal variable rate user objects
  std::vector<UserObjectName> _int_var_rate_tensor_uo_names;

  /// Number of flow rate user objects
  unsigned int _num_int_var_rate_tensor_uos;
  unsigned int _num_int_var_tensor_uos;

  /// Internal variable user objects
  std::vector<const VPHardeningBase *> _int_var_tensor_uo;
  /// Internal variable rate user objects
  std::vector<const VPHardeningRateBase *> _int_var_rate_tensor_uo;
  std::vector< MaterialProperty<Real> * > _int_var_tensor_stateful_prop;
  std::vector< MaterialProperty<Real> * > _int_var_tensor_stateful_prop_old;
  std::vector< MaterialProperty<Real> * > _int_var_rate_tensor_prop;
  std::vector<Real> _int_var_tensor_old;

  /// Jacobian variables
  std::vector< DenseVector<Real> > _dintvarratetensor_dflowrate;
  std::vector< DenseVector<Real> > _dintvartensor_dflowrate_tmp;
  DenseMatrix<Real> _dintvarratetensor_dintvartensor;
  DenseMatrix<Real> _dintvartensor_dintvarratetensor;
  DenseMatrix<Real> _dintvartensor_dintvartensor;
  DenseMatrix<Real> _dintvartensor_dintvar;
  DenseMatrix<Real> _dintvartensor_dflowrate;
  DenseMatrix<Real> _dstrength_dintvartensor;
  DenseVector<Real> _dintvartensor_dintvar_x;

};

#endif //FiniteStrainViscoPlastic_H
