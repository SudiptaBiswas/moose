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

#ifndef MATERIALSTDVECTORAUXBASE_H
#define MATERIALSTDVECTORAUXBASE_H

// MOOSE includes
#include "AuxKernel.h"

// Forward declarations
template<typename T>
class MaterialStdVectorAuxBase;

template<>
InputParameters validParams<MaterialStdVectorAuxBase<Real> >();

template<>
InputParameters validParams<MaterialStdVectorAuxBase<RealGradient> >();

/**
 * A base class for the various Material related AuxKernal objects
 */
template<typename T>
class MaterialStdVectorAuxBase : public AuxKernel
{
public:

  /**
   * Class constructor
   * @param name Name of the AuxKernel
   * @param parameters The input parameters for this object
   */
  MaterialStdVectorAuxBase(const std::string & name, InputParameters parameters);

  /**
   * Class destructor
   */
  virtual ~MaterialStdVectorAuxBase(){}

protected:

  /// Reference to the material property for this AuxKernel
  const MaterialProperty<T> & _prop;

  // Value to be added to the material property
  const Real _factor;

  // Multiplier for the material property
  const Real _offset;

};

template<typename T>
MaterialStdVectorAuxBase<T>::MaterialStdVectorAuxBase(const std::string & name, InputParameters parameters) :
    AuxKernel(name, parameters),
    _prop(getMaterialProperty<T>("property")),
    _factor(getParam<Real>("factor")),
    _offset(getParam<Real>("offset"))
{
}

#endif //MATERIALSTDVECTORAUXBASE_H
