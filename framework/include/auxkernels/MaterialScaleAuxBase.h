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

#ifndef MATERIALSCALEAUXBASE_H
#define MATERIALSCALEAUXBASE_H

// MOOSE includes
#include "AuxKernel.h"

//forward declaration
class MaterialScaleAuxBase;

template<>
InputParameters validParams<MaterialScaleAuxBase>();

class MaterialScaleAuxBase : public AuxKernel
{
public:

  /**
   * Class constructor
   * @param name Name of the AuxKernel
   * @param parameters The input parameters for this object
   */
  MaterialScaleAuxBase(const std::string & name, InputParameters parameters);

protected:
  /// Multiplier for the material property
  const Real _factor;
  /// Value to be added to the material property
  const Real _offset;

};
#endif //MATERIALSCALEAUXBASE_H
