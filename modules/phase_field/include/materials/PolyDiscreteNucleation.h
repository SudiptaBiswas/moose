/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef POLYDISCRETENUCLEATION_H
#define POLYDISCRETENUCLEATION_H

#include "DiscreteNucleation.h"

// Forward declaration
class PolyDiscreteNucleation;


template<>
InputParameters validParams<PolyDiscreteNucleation>();

/**
 * Free energy penalty contribution to force the nucleation of subresolution particles
 */
class PolyDiscreteNucleation : public DiscreteNucleation
{
public:
  PolyDiscreteNucleation(const InputParameters & params);

  virtual void computeProperties();

protected:
  /// No. of grains
  unsigned int _ncrys;
  /// Order parameter representing unique grain orientation
  std::vector<VariableValue *> _vals;
};

#endif //POLYDISCRETENUCLEATION_H
