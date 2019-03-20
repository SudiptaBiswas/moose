//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef HOMOGENIZEDELASTICITYTENSOR_H
#define HOMOGENIZEDELASTICITYTENSOR_H

#include "ElementAverageValue.h"
#include "RankFourTensor.h"
#include "RankTwoTensor.h"
// Forward Declarations
class HomogenizedElasticityTensor;

template <>
InputParameters validParams<HomogenizedElasticityTensor>();

/**
 * This postprocessor computes the average grain area in a polycrystal
 */
class HomogenizedElasticityTensor : public ElementAverageValue
{
public:
  HomogenizedElasticityTensor(const InputParameters & parameters);

protected:
  virtual Real computeQpIntegral() override;

private:
  unsigned int _ndisp;
  std::vector<const VariableGradient *> _grad_disp;

  // const VariableGradient & _grad_disp_x_xx;
  // const VariableGradient & _grad_disp_y_xx;
  // const VariableGradient & _grad_disp_z_xx;
  //
  // const VariableGradient & _grad_disp_x_yy;
  // const VariableGradient & _grad_disp_y_yy;
  // const VariableGradient & _grad_disp_z_yy;
  //
  // const VariableGradient & _grad_disp_x_zz;
  // const VariableGradient & _grad_disp_y_zz;
  // const VariableGradient & _grad_disp_z_zz;
  //
  // const VariableGradient & _grad_disp_x_xy;
  // const VariableGradient & _grad_disp_y_xy;
  // const VariableGradient & _grad_disp_z_xy;
  //
  // const VariableGradient & _grad_disp_x_yz;
  // const VariableGradient & _grad_disp_y_yz;
  // const VariableGradient & _grad_disp_z_yz;
  //
  // const VariableGradient & _grad_disp_x_zx;
  // const VariableGradient & _grad_disp_y_zx;
  // const VariableGradient & _grad_disp_z_zx;

  const std::string _base_name;
  const MaterialProperty<RankTwoTensor> & _mechanical_strain;
  const MaterialProperty<RankFourTensor> & _elasticity_tensor;
  // unsigned _I, _J;
  unsigned int _i, _j;
  unsigned int _l, _k;
  // const unsigned int _column;

  // Real _volume;
  // Real _integral_value;
};

#endif // HOMOGENIZEDELASTICITYTENSOR_H
