/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "VPKinematicHardeningRate.h"

template<>
InputParameters validParams<VPKinematicHardeningRate>()
{
  InputParameters params = validParams<VPHardeningRateBase>();
  params.addParam<UserObjectName>("flow_rate_uo", "Reference flow rate for rate dependent flow");
  params.addParam<Real>("hardening_multiplier", 1.0, "Material parameter used in hardening rule");
  params.addClassDescription("User Object to compute material resistance");
  return params;
}

VPKinematicHardeningRate::VPKinematicHardeningRate(const InputParameters & parameters) :
    VPHardeningRateBase(parameters),
    _flow_rate_uo_name(getParam<UserObjectName>("flow_rate_uo")),
    _flow_rate_uo(getUserObjectByName<VPHardeningRateBase>(_flow_rate_uo_name)),
    _D(getParam<Real>("hardening_multiplier"))
{
}

bool
VPKinematicHardeningRate::computeTensorValue(unsigned int qp, RankTwoTensor & val) const
{
  RankTwoTensor flow_direction;
  flow_direction.zero();
  RankTwoTensor back_stress = 2/3 * _C * _intvar_tensor[qp];
  RankTwoTensor sdiff = _pk2[qp] - back_stress;
  RankTwoTensor sdev = computeDeviatoricStress(sdiff, _ce[qp]);
  Real eqv_stress = computeEqvStress(sdev, _ce[qp]);

  if (eqv_stress > 0.0)
    flow_direction = 1.5/eqv_stress * _ce[qp] * sdev * _ce[qp];

  val = _flow_rate[qp] * flow_direction - _D * _intvar_tensor[qp] * _intvar_rate[qp];

  return true;
}

bool
VPKinematicHardeningRate::computeTensorDerivative(unsigned int qp, const std::string & coupled_var_name, RankTwoTensor & val) const
{
  val.zero();

  if (_flow_rate_prop_name == coupled_var_name)
  {
    RankTwoTensor flow_direction;
    flow_direction.zero();
    RankTwoTensor back_stress = 2/3 * _C * _intvar_tensor[qp];
    RankTwoTensor sdiff = _pk2[qp] - back_stress;
    RankTwoTensor sdev = computeDeviatoricStress(sdiff, _ce[qp]);
    Real eqv_stress = computeEqvStress(sdev, _ce[qp]);

    if (eqv_stress > 0.0)
      flow_direction = 1.5/eqv_stress * _ce[qp] * sdev * _ce[qp];

    val = flow_direction - _D * _intvar_tensor[qp];
  }

  return true;
}

bool
VPKinematicHardeningRate::computeRankFourTensorDerivative(unsigned int qp, const std::string & coupled_var_name, RankFourTensor & val) const
{
  val.zero();
  if (_intvar_prop_tensor_name == coupled_var_name)
  {
    RankTwoTensor back_stress = 2/3 * _C * _intvar_tensor[qp];
    RankTwoTensor sdiff = _pk2[qp] - back_stress;
    RankTwoTensor sdev = computeDeviatoricStress(sdiff, _ce[qp]);
    Real eqv_stress = computeEqvStress(sdev, _ce[qp]);
    RankTwoTensor dflowdir_deqvstress = -1.5/(eqv_stress * eqv_stress) * sdev;
    Real dflowdir_dsdev = 1.5/eqv_stress;

    RankTwoTensor deqvstress_dsdev;
    deqvstress_dsdev.zero();
    if (eqv_stress > 0.0)
      deqvstress_dsdev = 1.5 / eqv_stress * sdev * _ce[qp] * _ce[qp];

    RankFourTensor dflowdir_deqvstress_dsdev;
    for (unsigned int i = 0; i < LIBMESH_DIM; ++i)
      for (unsigned int j = 0; j < LIBMESH_DIM; ++j)
        for (unsigned int k = 0; k < LIBMESH_DIM; ++k)
          for (unsigned int l = 0; l < LIBMESH_DIM; ++l)
            dflowdir_deqvstress_dsdev(i, j, k, l) += dflowdir_deqvstress(i, j) * deqvstress_dsdev(k, l);

    RankTwoTensor ce_inv = _ce[qp].inverse();

    RankFourTensor dsdev_dsdiff;
    for (unsigned int i = 0; i < LIBMESH_DIM; ++i)
      for (unsigned int j = 0; j < LIBMESH_DIM; ++j)
        for (unsigned int k = 0; k < LIBMESH_DIM; ++k)
          for (unsigned int l = 0; l < LIBMESH_DIM; ++l)
          {
            dsdev_dsdiff(i, j, k, l) = 0.0;
            if (i==k && j==l)
              dsdev_dsdiff(i, j, k, l) = -1.0;
            dsdev_dsdiff(i, j, k, l) += ce_inv(i, j) * _ce[qp](k, l)/3.0;
          }

    RankFourTensor dsdiff_dbackstress;
    for (unsigned int i = 0; i < LIBMESH_DIM; ++i)
      for (unsigned int j = 0; j < LIBMESH_DIM; ++j)
        for (unsigned int k = 0; k < LIBMESH_DIM; ++k)
          for (unsigned int l = 0; l < LIBMESH_DIM; ++l)
          {
            dsdiff_dbackstress(i, j, k, l) = 0.0;
            if (i==k && j==l)
              dsdiff_dbackstress(i, j, k, l) = -1.0;
          }

    RankFourTensor dintvartensor_dintvartensor;
    for (unsigned int i = 0; i < LIBMESH_DIM; ++i)
      for (unsigned int j = 0; j < LIBMESH_DIM; ++j)
        for (unsigned int k = 0; k < LIBMESH_DIM; ++k)
          for (unsigned int l = 0; l < LIBMESH_DIM; ++l)
          {
            dintvartensor_dintvartensor(i, j, k, l) = 0.0;
            if (i==k && j==l)
              dintvartensor_dintvartensor(i, j, k, l) = 1.0;
          }
    RankFourTensor dbackstress_dint = 2/3 * _C * dintvartensor_dintvartensor;


    val = _flow_rate[qp] * dflowdir_deqvstress_dsdev * dsdev_dsdiff * dsdiff_dbackstress * dbackstress_dint
          + _flow_rate[qp] * dflowdir_dsdev * dsdev_dsdiff * dsdiff_dbackstress * dbackstress_dint
          - _D * _intvar_rate[qp] * dintvartensor_dintvartensor;
  }

  if (_pk2_prop_name == coupled_var_name)
  {
    RankTwoTensor flow_direction;
    flow_direction.zero();
    RankTwoTensor back_stress = 2/3 * _C * _intvar_tensor[qp];
    RankTwoTensor sdiff = _pk2[qp] - back_stress;
    RankTwoTensor sdev = computeDeviatoricStress(sdiff, _ce[qp]);
    Real eqv_stress = computeEqvStress(sdev, _ce[qp]);

    if (eqv_stress > 0.0)
      flow_direction = 1.5/eqv_stress * _ce[qp] * sdev * _ce[qp];

    RankTwoTensor dflowdir_deqvstress = -1.5/(eqv_stress * eqv_stress) * sdev;
    Real dflowdir_dsdev = 1.5/eqv_stress;

    RankTwoTensor deqvstress_dsdev;
    deqvstress_dsdev.zero();
    if (eqv_stress > 0.0)
      deqvstress_dsdev = 1.5 / eqv_stress * sdev * _ce[qp] * _ce[qp];

    RankFourTensor dflowdir_deqvstress_dsdev;
    for (unsigned int i = 0; i < LIBMESH_DIM; ++i)
      for (unsigned int j = 0; j < LIBMESH_DIM; ++j)
        for (unsigned int k = 0; k < LIBMESH_DIM; ++k)
          for (unsigned int l = 0; l < LIBMESH_DIM; ++l)
            dflowdir_deqvstress_dsdev(i, j, k, l) += dflowdir_deqvstress(i, j) * deqvstress_dsdev(k, l);

    RankTwoTensor ce_inv = _ce[qp].inverse();

    RankFourTensor dsdev_dsdiff;
    for (unsigned int i = 0; i < LIBMESH_DIM; ++i)
      for (unsigned int j = 0; j < LIBMESH_DIM; ++j)
        for (unsigned int k = 0; k < LIBMESH_DIM; ++k)
          for (unsigned int l = 0; l < LIBMESH_DIM; ++l)
          {
            dsdev_dsdiff(i, j, k, l) = 0.0;
            if (i==k && j==l)
              dsdev_dsdiff(i, j, k, l) = -1.0;
            dsdev_dsdiff(i, j, k, l) += ce_inv(i, j) * _ce[qp](k, l)/3.0;
          }

    RankFourTensor dsdiff_dpk2;
    for (unsigned int i = 0; i < LIBMESH_DIM; ++i)
      for (unsigned int j = 0; j < LIBMESH_DIM; ++j)
        for (unsigned int k = 0; k < LIBMESH_DIM; ++k)
          for (unsigned int l = 0; l < LIBMESH_DIM; ++l)
          {
            dsdiff_dpk2(i, j, k, l) = 0.0;
            if (i==k && j==l)
              dsdiff_dpk2(i, j, k, l) = 1.0;
          }

    val = _flow_rate[qp] * dflowdir_deqvstress_dsdev * dsdev_dsdiff * dsdiff_dpk2
          + _flow_rate[qp] * dflowdir_dsdev * dsdev_dsdiff * dsdiff_dpk2;
  }

  return true;
}
