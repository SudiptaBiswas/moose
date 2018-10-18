//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "GlobalStrainEnergyUserObject.h"

#include "libmesh/quadrature.h"

registerMooseObject("TensorMechanicsApp", GlobalStrainEnergyUserObject);

template <>
InputParameters
validParams<GlobalStrainEnergyUserObject>()
{
  InputParameters params = validParams<ElementUserObject>();
  params.addClassDescription(
      "Global Strain UserObject to provide Residual and diagonal Jacobian entry");
  params.addParam<std::vector<Real>>("applied_strain_tensor",
                                     "Vector of values defining the constant applied stress "
                                     "to add, in order 11, 22, 33, 23, 13, 12");
  params.addParam<std::string>("base_name", "Material properties base name");
  params.addCoupledVar("displacements", "The name of the displacement variables");
  params.set<ExecFlagEnum>("execute_on") = EXEC_LINEAR;

  return params;
}

GlobalStrainEnergyUserObject::GlobalStrainEnergyUserObject(const InputParameters & parameters)
  : ElementUserObject(parameters),
    GlobalStrainUserObjectInterface(),
    _base_name(isParamValid("base_name") ? getParam<std::string>("base_name") + "_" : ""),
    _dstress_dstrain(getMaterialProperty<RankFourTensor>(_base_name + "Jacobian_mult")),
    _stress(getMaterialProperty<RankTwoTensor>(_base_name + "stress")),
    _mechanical_strain(getMaterialProperty<RankTwoTensor>(_base_name + "mechanical_strain")),
    _dim(_mesh.dimension()),
    _ndisp(coupledComponents("displacements")),
    _disp_var(_ndisp),
    _disp(_ndisp),
    _grad_disp(_ndisp),
    _periodic_dir()
{
  for (unsigned int i = 0; i < _ndisp; ++i)
    _disp_var[i] = coupled("displacements", i);

  for (unsigned int dir = 0; dir < _dim; ++dir)
  {
    _periodic_dir(dir) = _mesh.isTranslatedPeriodic(_disp_var[0], dir);

    for (unsigned int i = 1; i < _ndisp; ++i)
      if (_mesh.isTranslatedPeriodic(_disp_var[i], dir) != _periodic_dir(dir))
        mooseError("All the displacement components in a particular direction should have same "
                   "periodicity.");
  }

  if (isParamValid("applied_stress_tensor"))
    _applied_strain_tensor.fillFromInputVector(
        getParam<std::vector<Real>>("applied_strain_tensor"));
  else
    _applied_strain_tensor.zero();
}

void
GlobalStrainEnergyUserObject::initialize()
{
  for (unsigned int i = 0; i < _ndisp; ++i)
  {
    _disp[i] = &coupledValue("displacements", i);
    _grad_disp[i] = &coupledGradient("displacements", i);
  }

  // set unused dimensions to zero
  for (unsigned i = _ndisp; i < 3; ++i)
  {
    _disp[i] = &_zero;
    _grad_disp[i] = &_grad_zero;
  }

  _residual.zero();
  _jacobian.zero();
}

void
GlobalStrainEnergyUserObject::execute()
{
  computeAdditionalStress();

  for (unsigned int _qp = 0; _qp < _qrule->n_points(); _qp++)
  {
    RankTwoTensor grad_tensor((*_grad_disp[0])[_qp], (*_grad_disp[1])[_qp], (*_grad_disp[2])[_qp]);

    // residual, integral of stress components
    // _residual += 0.5 * _JxW[_qp] * _coord[_qp] * _stress[_qp] *
    //              (_mechanical_strain[_qp] - _applied_strain_tensor);
    _residual +=
        0.5 * _JxW[_qp] * _coord[_qp] * _stress[_qp] * (grad_tensor - _applied_strain_tensor);
    // diagonal jacobian, integral of elasticity tensor components
    // _jacobian += 0.5 * _JxW[_qp] * _coord[_qp] * _dstress_dstrain[_qp] *
    //              (grad_tensor - _applied_strain_tensor);
  }
}

void
GlobalStrainEnergyUserObject::threadJoin(const UserObject & uo)
{
  const GlobalStrainEnergyUserObject & pstuo =
      static_cast<const GlobalStrainEnergyUserObject &>(uo);
  _residual += pstuo._residual;
  _jacobian += pstuo._jacobian;
}

void
GlobalStrainEnergyUserObject::finalize()
{
  std::vector<Real> residual(9);
  std::vector<Real> jacobian(81);

  std::copy(&_residual(0, 0), &_residual(0, 0) + 9, residual.begin());
  std::copy(&_jacobian(0, 0, 0, 0), &_jacobian(0, 0, 0, 0) + 81, jacobian.begin());

  gatherSum(residual);
  gatherSum(jacobian);

  std::copy(residual.begin(), residual.end(), &_residual(0, 0));
  std::copy(jacobian.begin(), jacobian.end(), &_jacobian(0, 0, 0, 0));
}

const RankTwoTensor &
GlobalStrainEnergyUserObject::getResidual() const
{
  return _residual;
}

const RankFourTensor &
GlobalStrainEnergyUserObject::getJacobian() const
{
  return _jacobian;
}

const VectorValue<bool> &
GlobalStrainEnergyUserObject::getPeriodicDirections() const
{
  return _periodic_dir;
}
