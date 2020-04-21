//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "GlobalStrainLoadingUserObject.h"

#include "libmesh/quadrature.h"

registerMooseObject("TensorMechanicsApp", GlobalStrainLoadingUserObject);

defineLegacyParams(GlobalStrainLoadingUserObject);

InputParameters
GlobalStrainLoadingUserObject::validParams()
{
  InputParameters params = GlobalStrainUserObject::validParams();
  params.addClassDescription("This provides function uniform Global Strain UserObject to provide "
                             "Residual and diagonal Jacobian entry");

  params.addRequiredParam<std::vector<FunctionName>>(
      "loading_function",
      "A list of functions describing the applied uniform stress. There must be 6 of these, "
      "corresponding to the xx, yy, zz, yz, xz, xy components respectively");

  return params;
}

GlobalStrainLoadingUserObject::GlobalStrainLoadingUserObject(const InputParameters & parameters)
  : GlobalStrainUserObject(parameters)
{
  const std::vector<FunctionName> & fcn_names(
      getParam<std::vector<FunctionName>>("loading_function"));
  const std::size_t num = fcn_names.size();

  if ((_dim == 1 && num != 1) || (_dim == 2 && num != 3) || (_dim == 3 && num != 6))
    paramError("loading_function",
               "Loading function should provide one component in 1D, three components in 2D, and "
               "six components in 3D. You have ",
               num,
               " components for a ",
               _dim,
               "D problem.");

  _stress_fcn.resize(num);
  for (unsigned i = 0; i < num; ++i)
    _stress_fcn[i] = &getFunctionByName(fcn_names[i]);
}

void
GlobalStrainLoadingUserObject::computeAdditionalStress(unsigned int qp)
{
  if (_dim == 1)
    _applied_stress_tensor(0, 0) = _stress_fcn[0]->value(_t, _q_point[qp]);

  else if (_dim == 2)
  {
    _applied_stress_tensor(0, 0) = _stress_fcn[0]->value(_t, _q_point[qp]);
    _applied_stress_tensor(1, 1) = _stress_fcn[1]->value(_t, _q_point[qp]);
    _applied_stress_tensor(0, 1) = _stress_fcn[3]->value(_t, _q_point[qp]);
  }

  else
  {
    _applied_stress_tensor(0, 0) = _stress_fcn[0]->value(_t, _q_point[qp]);
    _applied_stress_tensor(1, 1) = _stress_fcn[1]->value(_t, _q_point[qp]);
    _applied_stress_tensor(2, 2) = _stress_fcn[2]->value(_t, _q_point[qp]);
    _applied_stress_tensor(1, 2) = _stress_fcn[3]->value(_t, _q_point[qp]);
    _applied_stress_tensor(0, 2) = _stress_fcn[4]->value(_t, _q_point[qp]);
    _applied_stress_tensor(0, 1) = _stress_fcn[5]->value(_t, _q_point[qp]);
  }
}
