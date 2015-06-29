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

// MOOSE includes
#include "MaterialStdVectorAuxBase.h"

/* Each AuxKernel that inherits from MaterialStdVectorAuxBase must define a specialization
 * of the input parameters that includes the template parameter passed to MaterialStdVectorAuxBase.
 */
template<>
InputParameters validParams<MaterialStdVectorAuxBase<Real> >()
{
  InputParameters params = validParams<MaterialScaleAuxBase>();
  params.addRequiredParam<MaterialPropertyName>("vector_property", "The scalar material property name");
  params.addParam<unsigned int>("index", 0, "The index to consider for this kernel");
  return params;
}

template<>
InputParameters validParams<MaterialStdVectorAuxBase<std::vector<Real> > >()
{
  return validParams<MaterialStdVectorAuxBase<Real> >();
}

template<>
InputParameters validParams<MaterialStdVectorAuxBase<std::vector<RealGradient> > >()
{
  return validParams<MaterialStdVectorAuxBase<Real> >();
}
