/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef VACANCYRECOMBINATION_H
#define VACANCYRECOMBINATION_H

#include "Kernel.h"

//Forward Declarations
class VacancyRecombination;

template<>
InputParameters validParams<VacancyRecombination>();

/**
 * This kernel calculates recombination between different Concentration fields
 * specifically between vacancies and interstitials formed during irradiation
 */
class VacancyRecombination : public Kernel
{
public:
  VacancyRecombination(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

private:
  /// Order parameter representing voids
  VariableValue & _eta;
  /// Additional Concentration variable
  VariableValue & _ci;

  /// Co-efficient of bulk recombination
  Real _Rbulk;
  /// Co-effienient of surface recombination
  Real _Rs;
};

#endif //VACANCYRECOMBINATION_H
