/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "VPIsotropicHardeningRate.h"

template<>
InputParameters validParams<VPIsotropicHardeningRate>()
{
  InputParameters params = validParams<VPHardeningRateBase>();
  params.addClassDescription("User Object to compute material resistance");
  params.addParam<Real>("hardening_exponent", 1.0, "The hardening exponent value");
  return params;
}

VPIsotropicHardeningRate::VPIsotropicHardeningRate(const InputParameters & parameters) :
    VPHardeningRateBase(parameters),
    _exponent(getParam<Real>("hardening_exponent"))
{
}

bool
VPIsotropicHardeningRate::computeValue(unsigned int qp, Real & val) const
{
  RankTwoTensor back_stress = 2/3 * _C * _intvar_tensor[qp];
  RankTwoTensor sdiff = _pk2[qp] - back_stress;
  RankTwoTensor sdev = computeDeviatoricStress(sdiff, _ce[qp]);
  Real eqv_stress = computeEqvStress(sdev, _ce[qp]);
  val = std::pow(macaulayBracket(eqv_stress/_strength[qp] - 1.0), _exponent);

  return true;
}

bool
VPIsotropicHardeningRate::computeDerivative(unsigned int qp, const std::string & coupled_var_name, Real & val) const
{
  val = 0.0;
  if (_strength_prop_name == coupled_var_name)
  {
    RankTwoTensor back_stress = 2/3 * _C * _intvar_tensor[qp];
    RankTwoTensor sdiff = _pk2[qp] - back_stress;
    RankTwoTensor sdev = computeDeviatoricStress(sdiff, _ce[qp]);
    Real eqv_stress = computeEqvStress(sdev, _ce[qp]);
    val = -_exponent * std::pow(macaulayBracket(eqv_stress / _strength[qp]), _exponent) / _strength[qp];
  }

  if (_flow_rate_prop_name == coupled_var_name)
    val = 1.0;

  return true;
}

bool
VPIsotropicHardeningRate::computeTensorDerivative(unsigned int qp, const std::string & coupled_var_name, RankTwoTensor & val) const
{
  val.zero();
  if (_intvar_prop_tensor_name == coupled_var_name)
  {
    RankTwoTensor back_stress = 2/3 * _C * _intvar_tensor[qp];
    RankTwoTensor sdiff = _pk2[qp] - back_stress;
    RankTwoTensor sdev = computeDeviatoricStress(sdiff, _ce[qp]);
    Real eqv_stress = computeEqvStress(sdev, _ce[qp]);
    Real dhardrate_deqvstress = _exponent * std::pow(macaulayBracket(eqv_stress / _strength[qp] - 1.0), _exponent - 1.0) / _strength[qp];

    RankTwoTensor deqvstress_dsdev;
    deqvstress_dsdev.zero();
    if (eqv_stress > 0.0)
      deqvstress_dsdev = -1.5 / eqv_stress * sdev * _ce[qp] * _ce[qp];

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
   RankFourTensor dsdev_dint = dsdev_dsdiff * dsdiff_dbackstress * dbackstress_dint;

   val = dhardrate_deqvstress * dsdev_dint.transposeMajor() * deqvstress_dsdev;
  }

  if (_pk2_prop_name == coupled_var_name)
  {
    RankTwoTensor back_stress = 2/3 * _C * _intvar_tensor[qp];
    RankTwoTensor sdiff = _pk2[qp] - back_stress;
    RankTwoTensor sdev = computeDeviatoricStress(sdiff, _ce[qp]);
    Real eqv_stress = computeEqvStress(sdev, _ce[qp]);
    Real dhardrate_deqvstress = _exponent * std::pow(macaulayBracket(eqv_stress / _strength[qp] - 1.0), _exponent - 1.0) / _strength[qp];

    RankTwoTensor deqvstress_dsdev;
    deqvstress_dsdev.zero();
    if (eqv_stress > 0.0)
      deqvstress_dsdev = 1.5 / eqv_stress * sdev * _ce[qp] * _ce[qp];

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

    RankFourTensor dsdev_dpk2 = dsdev_dsdiff * dsdiff_dpk2;

    val = dhardrate_deqvstress * dsdev_dpk2.transposeMajor() * deqvstress_dsdev;
  }

  return true;
}

Real
VPIsotropicHardeningRate::macaulayBracket(Real val) const
{
  if (val > 0.0)
    return val;
  else
    return 0.0;
}
