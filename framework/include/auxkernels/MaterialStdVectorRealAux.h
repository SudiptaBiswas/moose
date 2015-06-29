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

#ifndef MATERIALSTDVECTORREALAUX_H
#define MATERIALSTDVECTORREALAUX_H

// MOOSE includes
#include "MaterialStdVectorAuxBase.h"

// Forward declarations
class MaterialStdVectorRealAux;

template<>
InputParameters validParams<MaterialStdVectorRealAux>();

/**
 * AuxKernel for outputting a std::vector material-property component to an AuxVariable
 */
class MaterialStdVectorRealAux : public MaterialStdVectorAuxBase<std::vector<Real> >
{
public:

  /**
   * Class constructor
   * @param name AuxKernel name
   * @param parameters The input parameters for this object
   */
  MaterialStdVectorRealAux(const std::string & name, InputParameters parameters);

  /**
   * Class destructor
   */
  virtual ~MaterialStdVectorRealAux();

protected:

  /**
   * Compute the value of the material property for the given index
   */
  virtual Real computeValue();

};

#endif //MATERIALSTDVECTORREALAUX_H
