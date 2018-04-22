//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "PeriodicStrainUserObject.h"
#include "RankTwoTensor.h"
#include "RankFourTensor.h"
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
  params.addParam<UserObjectName>("subblock_index_provider",
                                  "SubblockIndexProvider user object name");
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
    _subblock_id_provider(nullptr),
    _applied_pressure(getFunction("applied_pressure")),
    _factor(getParam<Real>("factor"))
{
  _applied_stress_tensor.fillFromInputVector(getParam<std::vector<Real>>("applied_stress_tensor"));
}

void
PeriodicStrainUserObject::initialize()
{
  if (isParamValid("subblock_index_provider"))
    _subblock_id_provider = &getUserObject<SubblockIndexProvider>("subblock_index_provider");
  if (_assembly.coordSystem() == Moose::COORD_XYZ)
    _scalar_out_of_plane_strain_direction = 2;
  else if (_assembly.coordSystem() == Moose::COORD_RZ)
    _scalar_out_of_plane_strain_direction = 1;
  else
    mooseError("Unsupported coordinate system for generalized plane strain formulation");

  unsigned int max_size = _subblock_id_provider ? _subblock_id_provider->getMaxSubblockIndex() : 1;
  _residual.assign(max_size, 0.0);
  _jacobian.assign(max_size, 0.0);
}

void
PeriodicStrainUserObject::execute()
{
  const unsigned int subblock_id =
      _subblock_id_provider ? _subblock_id_provider->getSubblockIndex(*_current_elem) : 0;

  for (unsigned int _qp = 0; _qp < _qrule->n_points(); _qp++)
  {
    // residual, integral of stress_zz for COORD_XYZ
    RankTwoTensor stress = _Cijkl[_qp] * _periodic_strain[_qp]
                          + _applied_stress_tensor * _factor;
    _residual[subblock_id] += _JxW[_qp] * _coord[_qp] * stress;

    // diagonal jacobian, integral of C(2, 2, 2, 2) for COORD_XYZ
    _jacobian[subblock_id] +=
        _JxW[_qp] * _coord[_qp] * _Cijkl[_qp];
  }
}

void
PeriodicStrainUserObject::threadJoin(const UserObject & uo)
{
  const PeriodicStrainUserObject & pstuo =
      static_cast<const PeriodicStrainUserObject &>(uo);
  for (unsigned int i = 0; i < _residual.size(); ++i)
  {
    _residual[i] += pstuo._residual[i];
    _jacobian[i] += pstuo._jacobian[i];
  }
}

void
PeriodicStrainUserObject::finalize()
{
  gatherSum(_residual);
  gatherSum(_reference_residual);
  gatherSum(_jacobian);
}

Real
PeriodicStrainUserObject::returnResidual(unsigned int scalar_var_order) const
{
  if (_residual.size() <= scalar_var_id)
    mooseError("Index out of bounds!");

  return _residual[scalar_var_id];
}

Real
PeriodicStrainUserObject::returnJacobian(unsigned int scalar_var_id) const
{
  if (_jacobian.size() <= scalar_var_id)
    mooseError("Index out of bounds!");

  return _jacobian[scalar_var_id];
}
