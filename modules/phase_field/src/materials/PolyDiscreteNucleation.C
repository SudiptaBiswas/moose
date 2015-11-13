/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "PolyDiscreteNucleation.h"

template<>
InputParameters validParams<PolyDiscreteNucleation>()
{
  InputParameters params = validParams<DiscreteNucleation>();
  params.addClassDescription("Free energy contribution for nucleating discrete particles in polycrystalline material");
  params.addCoupledVar("v", "Array of order parameters representing grain orientations");
  return params;
}

PolyDiscreteNucleation::PolyDiscreteNucleation(const InputParameters & params) :
    DiscreteNucleation(params),
    _ncrys(coupledComponents("v")),
    _vals(_ncrys)
{
  // Loop through grains and load coupled variables into the arrays
  for (unsigned int i = 0; i < _ncrys; ++i)
    _vals[i] = &coupledValue("v", i);
}

void
PolyDiscreteNucleation::computeProperties()
{
  Real SumEta = 0.0;
  for (unsigned int i = 0; i < _ncrys; ++i)
    SumEta += (*_vals[i])[_qp]*(*_vals[i])[_qp]; //Sum order parameters

  if (SumEta < 0.8)
    DiscreteNucleation::computeProperties();

  // return 0.0;
}
