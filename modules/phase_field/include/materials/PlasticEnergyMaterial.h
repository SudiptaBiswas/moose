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
  virtual void initQpStatefulProperties() override;
  virtual Real computeF();
  virtual Real computeDF(unsigned int /*i_var*/);
  virtual Real computeD2F(unsigned int /*i_var*/, unsigned int /*j_var*/);

  std::string _base_name;
  const MaterialProperty<RankTwoTensor> & _stress;
  const MaterialProperty<RankFourTensor> & _elasticity_tensor;
  const MaterialProperty<RankTwoTensor> & _elastic_strain;
  const MaterialProperty<RankTwoTensor> & _total_strain;
  const MaterialProperty<RankTwoTensor> & _plastic_strain;
  MaterialProperty<Real> & _plastic_energy;
  const MaterialProperty<Real> & _plastic_energy_old;
};

#endif //PLASTICENERGYMATERIAL_H
