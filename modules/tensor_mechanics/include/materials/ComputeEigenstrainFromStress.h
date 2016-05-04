/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef COMPUTEEIGENSTRAINFROMSTRESS_H
#define COMPUTEEIGENSTRAINFROMSTRESS_H

#include "ComputeStressFreeStrainBase.h"

/**
 * ComputeEigenstrainFromStress computes an Eigenstrain that is a function of a single variable defined by a base tensor and a scalar function defined in a Derivative Material.
 */
class ComputeEigenstrainFromStress : public ComputeStressFreeStrainBase
{
public:
  ComputeEigenstrainFromStress(const InputParameters & parameters);

protected:
  virtual void computeQpStressFreeStrain();

  const MaterialProperty<Real> & _prefactor;

  RankFourTensor _Cijkl;
  RankTwoTensor _applied_stress_tensor;
  RankTwoTensor _eigen_strain;
  // const MaterialProperty<RankFourTensor> & _elasticity_tensor;
};

#endif //COMPUTEEIGENSTRAINFROMSTRESS_H
