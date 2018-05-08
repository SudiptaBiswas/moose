//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ComputeGlobalStrain.h"
#include "RankTwoTensor.h"

registerMooseObject("TensorMechanicsApp", ComputeGlobalStrain);

template <>
InputParameters
validParams<ComputeGlobalStrain>()
{
  InputParameters params = validParams<Material>();
  params.addClassDescription(
      "Material for storing the global strain values from the scalar variable");
  params.addParam<std::string>("base_name",
                               "Optional parameter that allows the user to define "
                               "multiple mechanics material systems on the same "
                               "block, i.e. for multiple phases");
  params.addCoupledVar("scalar_global_strain", "Scalar variable for global strain");
  params.addCoupledVar("displacements", "The name of the displacement variables");

  return params;
}

ComputeGlobalStrain::ComputeGlobalStrain(const InputParameters & parameters)
  : Material(parameters),
    _base_name(isParamValid("base_name") ? getParam<std::string>("base_name") + "_" : ""),
    _scalar_global_strain(coupledScalarValue("scalar_global_strain")),
    _global_strain(declareProperty<RankTwoTensor>(_base_name + "global_strain")),
    _dim(_mesh.dimension()),
    _ndisp(coupledComponents("displacements")),
    _disp_var(_ndisp)
{
  for (unsigned int i = 0; i < _ndisp; ++i)
    _disp_var[i] = coupled("displacements", i);
}

void
ComputeGlobalStrain::initQpStatefulProperties()
{
  _global_strain[_qp].zero();
}

void
ComputeGlobalStrain::computeProperties()
{
  RankTwoTensor & strain = _global_strain[0];
  strain.fillFromScalarVariable(_scalar_global_strain);

  for (unsigned int dir = 0; dir < _dim; ++dir)
    for (unsigned int var = 0; var < _ndisp; ++var)
    {
      bool periodic = _mesh.isTranslatedPeriodic(_disp_var[var], dir);
      if (!periodic)
        strain(dir, var) = 0.0;
    }

  for (_qp = 0; _qp < _qrule->n_points(); ++_qp)
    _global_strain[_qp] = strain;
}
