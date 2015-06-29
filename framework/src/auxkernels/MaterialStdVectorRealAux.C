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

#include "MaterialStdVectorRealAux.h"

template<>
InputParameters validParams<MaterialStdVectorRealAux>()
{
  InputParameters params = validParams<MaterialStdVectorAuxBase<std::vector<Real> > >();
  params.addClassDescription("Extracts a component of a material type std::vector<Real> to an aux variable.  If the std::vector is not of sufficient size then zero is returned");
  return params;
}

MaterialStdVectorRealAux::MaterialStdVectorRealAux(const std::string & name, InputParameters parameters) :
  MaterialStdVectorAuxBase<std::vector<Real> >(name, parameters)
{
}

MaterialStdVectorRealAux::~MaterialStdVectorRealAux()
{
}

Real
MaterialStdVectorRealAux::computeValue()
{
  //Real vec_elem = _vec_prop[_qp][_index];
  return _factor * _vec_prop[_qp][_index] + _offset;
}
