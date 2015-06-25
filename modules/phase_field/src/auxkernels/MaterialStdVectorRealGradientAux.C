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

#include "MaterialStdVectorRealGradientAux.h"

template<>
InputParameters validParams<MaterialStdVectorRealGradientAux>()
{
  InputParameters params = validParams<MaterialStdVectorAuxBase<std::vector<RealGradient> > >();
  params.addClassDescription("Extracts a component of a material's std::vector<RealGradient> to an aux variable.  If the std::vector is not of sufficient size then zero is returned");
  params.addParam<unsigned int>("index", 0, "The index to consider for this kernel");
  MooseEnum component_options("x y z", "x");
  params.addParam<MooseEnum>("component", component_options, "Component of the gradient to be extracted");
  return params;
}

MaterialStdVectorRealGradientAux::MaterialStdVectorRealGradientAux(const std::string & name, InputParameters parameters) :
  MaterialStdVectorAuxBase<std::vector<RealGradient> >(name, parameters),
    _index(getParam<unsigned int>("index")),
    _component(getParam<MooseEnum>("component"))
{
}

MaterialStdVectorRealGradientAux::~MaterialStdVectorRealGradientAux()
{
}

Real
MaterialStdVectorRealGradientAux::computeValue()
{
  Real vec_comp = 0;
  switch (_component)
  {
    case 0: //x-component
      vec_comp = _prop[_qp][_index](0);
    case 1: //y-component
      vec_comp = _prop[_qp][_index](1);
    case 2: //z-component
      vec_comp = _prop[_qp][_index](2);
  }
  mooseError("Error:  Please input gradient component of interest");
  mooseAssert(_prop[_qp].size() > _index, "MaterialStdVectorRealGradientAux: You chose to extract component " << _index << " but your Material property only has size " << _prop[_qp].size());

  return _factor * vec_comp + _offset;
}
