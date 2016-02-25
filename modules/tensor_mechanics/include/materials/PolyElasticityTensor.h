/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef POLYELASTICITYTENSOR_H
#define POLYELASTICITYTENSOR_H

#include "ComputeRotatedElasticityTensorBase.h"

/**
 * PolyElasticityTensor defines an elasticity tensor material object with a given base name.
 */
class PolyElasticityTensor : public ComputeRotatedElasticityTensorBase
{
public:
  PolyElasticityTensor(const InputParameters & parameters);

protected:
  virtual void computeQpElasticityTensor();

  unsigned int _n;
  std::vector<VariableValue *> _vals;

  /// Individual material information
  ElasticityTensorR4 _Cijkl;
  ElasticityTensorR4 _Cijkl_GB;

};

#endif //POLYELASTICITYTENSOR_H
