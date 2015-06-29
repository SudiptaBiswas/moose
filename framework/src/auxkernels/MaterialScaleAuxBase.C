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
#include "MaterialScaleAuxBase.h"

/* Each AuxKernel that inherits from MaterialScaleAuxBase must define a specialization
 * of the input parameters that includes the template parameter passed to MaterialScaleAuxBase.
 */
template<>
InputParameters validParams<MaterialScaleAuxBase>()
{
  InputParameters params = validParams<AuxKernel>();
  params.addParam<Real>("factor", 1, "The factor by which to multiply your material property for visualization");
  params.addParam<Real>("offset", 0, "The offset to add to your material property for visualization");
  return params;
}

MaterialScaleAuxBase::MaterialScaleAuxBase(const std::string & name,
                                               InputParameters parameters) :
    AuxKernel(name,parameters),
    _factor(getParam<Real>("factor")),
    _offset(getParam<Real>("offset"))
{
}
