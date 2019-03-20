//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "HomogenizedElasticityTensor.h"
#include "SubProblem.h"
#include "MooseMesh.h"

registerMooseObject("TensorMechanicsApp", HomogenizedElasticityTensor);

template <>
InputParameters
validParams<HomogenizedElasticityTensor>()
{
  InputParameters params = validParams<ElementAverageValue>();
  params.addRequiredCoupledVar(
      "displacements",
      "The displacements appropriate for the simulation geometry and coordinate system");
  params.addParam<std::string>("base_name",
                               "Optional parameter that allows the user to define "
                               "multiple mechanics material systems on the same "
                               "block, i.e. for multiple phases");
  //
  // params.addRequiredCoupledVar("dx_xx", "solution in xx");
  // params.addRequiredCoupledVar("dy_xx", "solution in xx");
  // params.addCoupledVar("dz_xx", "solution in xx");
  // params.addRequiredCoupledVar("dx_yy", "solution in yy");
  // params.addRequiredCoupledVar("dy_yy", "solution in yy");
  // params.addCoupledVar("dz_yy", "solution in yy");
  // params.addCoupledVar("dx_zz", "solution in zz");
  // params.addCoupledVar("dy_zz", "solution in zz");
  // params.addCoupledVar("dz_zz", "solution in zz");
  // params.addRequiredCoupledVar("dx_xy", "solution in xy");
  // params.addRequiredCoupledVar("dy_xy", "solution in xy");
  // params.addCoupledVar("dz_xy", "solution in xy");
  // params.addCoupledVar("dx_yz", "solution in yz");
  // params.addCoupledVar("dy_yz", "solution in yz");
  // params.addCoupledVar("dz_yz", "solution in yz");
  // params.addCoupledVar("dx_zx", "solution in zx");
  // params.addCoupledVar("dy_zx", "solution in zx");
  // params.addCoupledVar("dz_zx", "solution in zx");
  // params.addParam<std::string>(
  //     "appended_property_name", "", "Name appended to material properties to make them unique");
  // params.addRequiredParam<unsigned int>("column",
  //                                       "An integer corresponding to the direction the "
  //                                       "variable this kernel acts in. (0 for xx, 1 for "
  //                                       "yy, 2 for zz, 3 for xy, 4 for yz, 5 for zx)");
  // params.addRequiredParam<unsigned int>("row",
  //                                       "An integer corresponding to the direction the "
  //                                       "variable this kernel acts in. (0 for xx, 1 for yy, "
  //                                       "2 for zz, 3 for xy, 4 for yz, 5 for zx)");
  params.addRequiredRangeCheckedParam<unsigned int>(
      "index_i",
      "index_i >= 0 & index_i <= 2",
      "The index i of ijkl for the tensor to output (0, 1, 2)");
  params.addRequiredRangeCheckedParam<unsigned int>(
      "index_j",
      "index_j >= 0 & index_j <= 2",
      "The index j of ijkl for the tensor to output (0, 1, 2)");
  params.addRequiredRangeCheckedParam<unsigned int>(
      "index_k",
      "index_k >= 0 & index_k <= 2",
      "The index k of ijkl for the tensor to output (0, 1, 2)");
  params.addRequiredRangeCheckedParam<unsigned int>(
      "index_l",
      "index_l >= 0 & index_l <= 2",
      "The index l of ijkl for the tensor to output (0, 1, 2)");
  return params;
}

HomogenizedElasticityTensor::HomogenizedElasticityTensor(const InputParameters & parameters)
  : ElementAverageValue(parameters),
    _ndisp(coupledComponents("displacements")),
    _grad_disp(_ndisp),

    // _grad_disp_x_xx(coupledGradient("dx_xx")),
    //
    // _grad_disp_y_xx(coupledGradient("dy_xx")),
    // _grad_disp_z_xx(_subproblem.mesh().dimension() == 3 ? coupledGradient("dz_xx") : _grad_zero),
    // _grad_disp_x_yy(coupledGradient("dx_yy")),
    // _grad_disp_y_yy(coupledGradient("dy_yy")),
    // _grad_disp_z_yy(_subproblem.mesh().dimension() == 3 ? coupledGradient("dz_yy") : _grad_zero),
    // _grad_disp_x_zz(_subproblem.mesh().dimension() == 3 ? coupledGradient("dx_zz") : _grad_zero),
    // _grad_disp_y_zz(_subproblem.mesh().dimension() == 3 ? coupledGradient("dy_zz") : _grad_zero),
    // _grad_disp_z_zz(_subproblem.mesh().dimension() == 3 ? coupledGradient("dz_zz") : _grad_zero),
    // _grad_disp_x_xy(coupledGradient("dx_xy")),
    // _grad_disp_y_xy(coupledGradient("dy_xy")),
    // _grad_disp_z_xy(_subproblem.mesh().dimension() == 3 ? coupledGradient("dz_xy") : _grad_zero),
    // _grad_disp_x_yz(_subproblem.mesh().dimension() == 3 ? coupledGradient("dx_yz") : _grad_zero),
    // _grad_disp_y_yz(_subproblem.mesh().dimension() == 3 ? coupledGradient("dy_yz") : _grad_zero),
    // _grad_disp_z_yz(_subproblem.mesh().dimension() == 3 ? coupledGradient("dz_yz") : _grad_zero),
    // _grad_disp_x_zx(_subproblem.mesh().dimension() == 3 ? coupledGradient("dx_zx") : _grad_zero),
    // _grad_disp_y_zx(_subproblem.mesh().dimension() == 3 ? coupledGradient("dy_zx") : _grad_zero),
    // _grad_disp_z_zx(_subproblem.mesh().dimension() == 3 ? coupledGradient("dz_zx") : _grad_zero),

    _base_name(isParamValid("base_name") ? getParam<std::string>("base_name") + "_" : ""),
    _mechanical_strain(getMaterialPropertyByName<RankTwoTensor>(_base_name + "mechanical_strain")),
    _elasticity_tensor(getMaterialPropertyByName<RankFourTensor>(_base_name + "elasticity_tensor")),
    // _component(getParam<unsigned int>("component")),
    _i(getParam<unsigned int>("index_i")),
    _j(getParam<unsigned int>("index_j")),
    _l(getParam<unsigned int>("index_l")),
    _k(getParam<unsigned int>("index_k"))
// _column(getParam<unsigned int>("column"))
// _row(getParam<unsigned int>("row"))
{
  for (unsigned int i = 0; i < _ndisp; ++i)
  {
    // _disp[i] = &coupledValue("displacements", i);
    _grad_disp[i] = &coupledGradient("displacements", i);
  }

  // set unused dimensions to zero
  for (unsigned i = _ndisp; i < 3; ++i)
  {
    // _disp[i] = &_zero;
    _grad_disp[i] = &_grad_zero;
  }
  // if (_column == 0)
  // {
  //   _k = 0;
  //   _l = 0;
  // }
  //
  // if (_column == 1)
  // {
  //   _k = 1;
  //   _l = 1;
  // }
  //
  // if (_column == 2)
  // {
  //   _k = 2;
  //   _l = 2;
  // }
  //
  // if (_column == 3)
  // {
  //   _k = 1;
  //   _l = 2;
  // }
  //
  // if (_column == 4)
  // {
  //   _k = 0;
  //   _l = 2;
  // }
  //
  // if (_column == 5)
  // {
  //   _k = 0;
  //   _l = 1;
  // }
}

Real
HomogenizedElasticityTensor::computeQpIntegral()
{
  // ColumnMajorMatrix E(_elasticity_tensor[_qp].columnMajorMatrix9x9());
  Real value;

  value = 0.0;

  // const VariableGradient * grad[6][3];
  // grad[0][0] = &_grad_disp_x_xx;
  // grad[0][1] = &_grad_disp_y_xx;
  // grad[0][2] = &_grad_disp_z_xx;
  //
  // grad[1][0] = &_grad_disp_x_yy;
  // grad[1][1] = &_grad_disp_y_yy;
  // grad[1][2] = &_grad_disp_z_yy;
  //
  // grad[2][0] = &_grad_disp_x_zz;
  // grad[2][1] = &_grad_disp_y_zz;
  // grad[2][2] = &_grad_disp_z_zz;
  //
  // grad[3][0] = &_grad_disp_x_yz;
  // grad[3][1] = &_grad_disp_y_yz;
  // grad[3][2] = &_grad_disp_z_yz;
  //
  // grad[4][0] = &_grad_disp_x_zx;
  // grad[4][1] = &_grad_disp_y_zx;
  // grad[4][2] = &_grad_disp_z_zx;
  //
  // grad[5][0] = &_grad_disp_x_xy;
  // grad[5][1] = &_grad_disp_y_xy;
  // grad[5][2] = &_grad_disp_z_xy;

  // RankTwoTensor grad_tensor((*_grad_disp[0])[_qp], (*_grad_disp[1])[_qp], (*_grad_disp[2])[_qp]);

  for (int p = 0; p < 3; p++)
  {
    for (int q = 0; q < 3; q++)
    {
      // value += _elasticity_tensor[_qp](_i, _j, p, q) * grad_tensor(p, q);
      value += _elasticity_tensor[_qp](_i, _j, p, q) * _mechanical_strain[_qp](p, q);
      // value += _elasticity_tensor[_qp](_i, _j, p, q) * (*grad[_column][p])[_qp](q);
    }
  }

  return (_elasticity_tensor[_qp](_i, _j, _k, _l) + value);
}
