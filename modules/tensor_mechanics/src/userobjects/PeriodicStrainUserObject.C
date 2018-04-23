//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "PeriodicStrainUserObject.h"
// #include "RankTwoTensor.h"
// #include "RankFourTensor.h"
#include "Function.h"
#include "Assembly.h"

#include "libmesh/quadrature.h"

registerMooseObject("TensorMechanicsApp", PeriodicStrainUserObject);

template <>
InputParameters
validParams<PeriodicStrainUserObject>()
{
  InputParameters params = validParams<ElementUserObject>();
  params.addClassDescription(
      "Periodic Strain UserObject to provide Residual and diagonal Jacobian entry");
  params.addRequiredParam<std::vector<Real>>("applied_stress_tensor",
                                             "Vector of values defining the constant applied stress "
                                             "to add, in order 11, 22, 33, 23, 13, 12");
  params.addParam<Real>("factor", 1.0, "Scale factor applied to prescribed pressure");
  params.addParam<std::string>("base_name", "Material properties base name");
  params.set<ExecFlagEnum>("execute_on") = EXEC_LINEAR;

  return params;
}

PeriodicStrainUserObject::PeriodicStrainUserObject(
    const InputParameters & parameters)
  : ElementUserObject(parameters),
    _base_name(isParamValid("base_name") ? getParam<std::string>("base_name") + "_" : ""),
    _Cijkl(getMaterialProperty<RankFourTensor>(_base_name + "elasticity_tensor")),
    _periodic_strain(getMaterialProperty<RankTwoTensor>(_base_name + "periodic_strain")),
    _factor(getParam<Real>("factor"))
{
  if (isParamValid("applied_stress_tensor"))
    _applied_stress_tensor.fillFromInputVector(getParam<std::vector<Real>>("applied_stress_tensor"));
  else
    _applied_stress_tensor.zero();
}

void
PeriodicStrainUserObject::initialize()
{
  _residual.zero();
  _jacobian.zero();
}

void
PeriodicStrainUserObject::execute()
{
  for (unsigned int _qp = 0; _qp < _qrule->n_points(); _qp++)
  {
    // residual, integral of stress_zz for COORD_XYZ
    RankTwoTensor stress = _Cijkl[_qp] * _periodic_strain[_qp]
                          + _applied_stress_tensor * _factor;
    _residual += _JxW[_qp] * _coord[_qp] * stress;

    // diagonal jacobian, integral of C(2, 2, 2, 2) for COORD_XYZ
    // _jacobian +=
    //     _JxW[_qp] * _coord[_qp] * _Cijkl[_qp];
  }
}

void
PeriodicStrainUserObject::threadJoin(const UserObject & uo)
{
  const PeriodicStrainUserObject & pstuo =
      static_cast<const PeriodicStrainUserObject &>(uo);

  for (unsigned int i = 0; i < LIBMESH_DIM; ++i)
    for (unsigned int j = 0; j < LIBMESH_DIM; ++j)
    {
      _residual(i,j) += pstuo._residual(i,j);
      _jacobian(i,j) += pstuo._jacobian(i,j);
    }
}

void
PeriodicStrainUserObject::finalize()
{
  for (unsigned int i = 0; i < LIBMESH_DIM; ++i)
    for (unsigned int j = 0; j < LIBMESH_DIM; ++j)
    {
      gatherSum(_residual(i,j));
      gatherSum(_jacobian(i,j));
    }
}

Real
PeriodicStrainUserObject::returnResidual(unsigned int scalar_var_order) const
{
  return _residual(scalar_var_order,scalar_var_order);
}

Real
PeriodicStrainUserObject::returnJacobian(unsigned int scalar_var_id) const
{
  return _jacobian(scalar_var_id,scalar_var_id);
}
