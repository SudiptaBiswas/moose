/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef GBVACANCYANNIHILATION_H
#define GBVACANCYANNIHILATION_H

#include "Kernel.h"

//Forward Declarations
class GBVacancyAnnihilation;

template<>
InputParameters validParams<GBVacancyAnnihilation>();

/**
 * This kernel accounts for vacancy source/sink term for
 * annihilation/nucleation of vacnacies at GBs.
 */
class GBVacancyAnnihilation : public Kernel
{
public:
  GBVacancyAnnihilation(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

private:
  /// Material Property providing efficiency of vacancy annihilation/nucleation
  const MaterialProperty<Real> & _Svgb;
  /// Equilibrium concentartion
  Real _ceq;
  /// No. of grains
  unsigned int _ncrys;
  /// Order parameter representing unique grain orientation
  std::vector<VariableValue *> _vals;
};

#endif //GBVACANCYANNIHILATION_H
