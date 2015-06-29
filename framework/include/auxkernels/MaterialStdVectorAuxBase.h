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
#include "MaterialScaleAuxBase.h"

// Forward declarations
template<typename T>
class MaterialStdVectorAuxBase;

template<>
InputParameters validParams<MaterialStdVectorAuxBase<std::vector<Real> > >();

template<>
InputParameters validParams<MaterialStdVectorAuxBase<std::vector<RealGradient> > >();

/**
 * A base class for the various Material related AuxKernal objects
 */
template<typename T>
class MaterialStdVectorAuxBase : public MaterialScaleAuxBase
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
  const MaterialProperty<T> & _vec_prop;
  /// index of the vecor element
  unsigned int _index;
};

template<typename T>
MaterialStdVectorAuxBase<T>::MaterialStdVectorAuxBase(const std::string & name, InputParameters parameters) :
    MaterialScaleAuxBase(name, parameters),
    _vec_prop(getMaterialProperty<T>("vector_property")),
    _index(getParam<unsigned int>("index"))
{
  mooseAssert(_vec_prop[_qp].size() < _index, "MaterialStdVectorAux: You chose to extract component " << _index << " but your Material property only has size " << _vec_prop[_qp].size());
}
#endif //MATERIALSTDVECTORAUXBASE_H
