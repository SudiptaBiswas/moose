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
  params.addParam<Real>("hardening_multiplier", 1.0, "The multiplier used in back stress calculation");
  return params;
}

VPIsotropicHardeningRate::VPIsotropicHardeningRate(const InputParameters & parameters) :
    VPHardeningRateBase(parameters),
    _exponent(getParam<Real>("hardening_exponent")),
    _C(getParam<Real>("hardening_multiplier"))
{
}

bool
VPIsotropicHardeningRate::computeValue(unsigned int qp, Real & val) const
{
  RankTwoTensor pk2_dev = computePK2Deviatoric(_pk2[qp], _ce[qp]);
  Real eqv_stress = computeEqvStress(pk2_dev, _ce[qp], _intvar_tensor[qp]);
  val = std::pow(macaulayBracket(eqv_stress/_strength[qp] - 1.0), _exponent);

  return true;
}

bool
VPIsotropicHardeningRate::computeDerivative(unsigned int qp, const std::string & coupled_var_name, Real & val) const
{
  val = 0.0;
  if (_strength_prop_name == coupled_var_name)
  {
    RankTwoTensor pk2_dev = computePK2Deviatoric(_pk2[qp], _ce[qp]);
    Real eqv_stress = computeEqvStress(pk2_dev, _ce[qp], _intvar_tensor[qp]);
    val = -_exponent * std::pow(macaulayBracket(eqv_stress / _strength[qp]), _exponent) / _strength[qp];
  }
  return true;
}

bool
VPIsotropicHardeningRate::computeTensorDerivative(unsigned int qp, const std::string & coupled_var_name, RankTwoTensor & val) const
{
  val.zero();
  // for (unsigned int i=0; i<coupled_var_names.size(); ++i)
  // {
    if (_intvar_prop_name == coupled_var_name)
    {
      RankTwoTensor pk2_dev = computePK2Deviatoric(_pk2[qp], _ce[qp]);
      Real eqv_stress = computeEqvStress(pk2_dev, _ce[qp], _intvar_tensor[qp]);

      Real dhardrate_deqvstress = _exponent * std::pow(macaulayBracket(eqv_stress / _strength[qp] - 1.0), _exponent - 1.0) / _strength[qp];
      RankTwoTensor back_stress = 2/3 * _C * _intvar_tensor[qp];
      RankTwoTensor sdev = pk2_dev * _ce[qp] - back_stress.deviatoric() ;
      RankTwoTensor deqvstress_dbackstressdev = -1.5 / eqv_stress * sdev;
      Real dbackstress_dint = 2/3 * _C;

      RankFourTensor dbackstressdev_dbackstress;
      for (unsigned int i = 0; i < LIBMESH_DIM; ++i)
        for (unsigned int j = 0; j < LIBMESH_DIM; ++j)
          for (unsigned int k = 0; k < LIBMESH_DIM; ++k)
            for (unsigned int l = 0; l < LIBMESH_DIM; ++l)
            {
              dbackstressdev_dbackstress(i, j, k, l) = 0.0;
              if (i==k && j==l)
                dbackstressdev_dbackstress(i, j, k, l) = 1.0;
              if (i==j && k==l)
                dbackstressdev_dbackstress(i, j, k, l) -= 1.0/3.0;
            }
      val = dhardrate_deqvstress * dbackstress_dint * dbackstressdev_dbackstress.transposeMajor() * deqvstress_dbackstressdev ;
    }

    if (_pk2_prop_name == coupled_var_name)
    {
      RankTwoTensor pk2_dev = computePK2Deviatoric(_pk2[qp], _ce[qp]);
      Real eqv_stress = computeEqvStress(pk2_dev, _ce[qp], _intvar_tensor[qp]);
      Real dhardrate_deqvstress = _exponent * std::pow(macaulayBracket(eqv_stress / _strength[qp] - 1.0), _exponent - 1.0) / _strength[qp];
      RankTwoTensor back_stress = 2/3 * _C * _intvar_tensor[qp];
      RankTwoTensor sdev = pk2_dev * _ce[qp] - back_stress.deviatoric() ;
      RankTwoTensor dseqv_dpk2dev;

      dseqv_dpk2dev.zero();
      if (eqv_stress > 0.0)
        dseqv_dpk2dev = 1.5/eqv_stress * sdev * _ce[qp];

      RankTwoTensor ce_inv = _ce[qp].inverse();

      RankFourTensor dpk2dev_dpk2;
      for (unsigned int i = 0; i < LIBMESH_DIM; ++i)
        for (unsigned int j = 0; j < LIBMESH_DIM; ++j)
          for (unsigned int k = 0; k < LIBMESH_DIM; ++k)
            for (unsigned int l = 0; l < LIBMESH_DIM; ++l)
            {
              dpk2dev_dpk2(i, j, k, l) = 0.0;
              if (i==k && j==l)
                dpk2dev_dpk2(i, j, k, l) = 1.0;
              dpk2dev_dpk2(i, j, k, l) -= ce_inv(i, j) * _ce[qp](k, l)/3.0;
            }
      val = dhardrate_deqvstress * dpk2dev_dpk2.transposeMajor() * dseqv_dpk2dev;
    }
  // }
  return true;
}

RankTwoTensor
VPIsotropicHardeningRate::computePK2Deviatoric(const RankTwoTensor & pk2, const RankTwoTensor & ce) const
{
  return pk2 - (pk2.doubleContraction(ce) * ce.inverse())/3.0;
}

Real
VPIsotropicHardeningRate::computeEqvStress(const RankTwoTensor & pk2_dev, const RankTwoTensor & ce, const RankTwoTensor & intvar) const
{
  RankTwoTensor back_stress = 2/3 * _C * intvar;
  RankTwoTensor sdev = pk2_dev * ce - back_stress.deviatoric() ;
  Real val = sdev.doubleContraction(sdev.transpose());
  return std::pow(1.5 * val, 0.5);
}

Real
VPIsotropicHardeningRate::macaulayBracket(Real val) const
{
  if (val > 0.0)
    return val;
  else
    return 0.0;
}
