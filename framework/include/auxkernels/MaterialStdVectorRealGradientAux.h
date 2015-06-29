/****************************************************************/
/*               DO NOT MODIFY THIS HEADER                      */
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*           (c) 2010 Battelle Energy Alliance, LLC             */
/*                   ALL RIGHTS RESERVED                        */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*            Under Contract No. DE-AC07-05ID14517              */
/*            With the U. S. Department of Energy               */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/

#ifndef MATERIALSTDVECTORREALGRADIENTAUX_H
#define MATERIALSTDVECTORREALGRADIENTAUX_H

// MOOSE includes
#include "MaterialStdVectorAuxBase.h"

// Forward declarations
class MaterialStdVectorRealGradientAux;

template<>
InputParameters validParams<MaterialStdVectorRealGradientAux>();

/**
 * AuxKernel for outputting a std::vector material-property component to an AuxVariable
 */
class MaterialStdVectorRealGradientAux : public MaterialStdVectorAuxBase<std::vector<RealGradient> >
{
public:

  /**
   * Class constructor
   * @param name AuxKernel name
   * @param parameters The input parameters for this object
   */
  MaterialStdVectorRealGradientAux(const std::string & name, InputParameters parameters);

  /**
   * Class destructor
   */
  virtual ~MaterialStdVectorRealGradientAux();

protected:

  /**
   * Compute the value of the material property for the given index
   */
  virtual Real computeValue();

  /// component of the real gradient to be extracted
  MooseEnum _component;
};

#endif //MATERIALSTDVECTORREALGRADIENTAUX_H
