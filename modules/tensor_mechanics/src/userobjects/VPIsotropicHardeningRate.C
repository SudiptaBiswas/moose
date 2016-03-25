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
  params.addParam<Real>("yield_stress", "Yield strength");
  params.addParam<Real>("hardening_exponent", 1.0, "The hardening exponent value");
  params.addParam<Real>("hardening_multiplier", 1.0, "The multiplier used in back stress calculation");
  return params;
}

VPIsotropicHardeningRate::VPIsotropicHardeningRate(const InputParameters & parameters) :
    VPHardeningRateBase(parameters),
    _intvar(getMaterialPropertyByName<std::vector<RankTwoTensor> >(_base_name + "intvar_prop_names")),
    _stress(getMaterialProperty<RankTwoTensor>(_base_name + "stress")),
    _yield_stress(getParam<Real>(_base_name + "yield_stress")),
    _exponent(getParam<Real>("hardening_exponent")),
    _C(getParam<Real>("hardening_multiplier"))
{
}

bool
VPIsotropicHardeningRate::computeValue(unsigned int qp, Real & val) const
{
  RankTwoTensor back_stress = 2/3 * _C * _intvar[0][qp];
  RankTwoTensor diff_stress = _stress[qp].deviatoric() - back_stress.deviatoric();
  Real J2_back_stress = std::sqrt(3/2 * diff_stress.doubleContraction(diff_stress));

  val = std::pow(macaulayBracket(J2_back_stress / _yield_stress - 1.0), _exponent);
  return true;
}

bool
VPIsotropicHardeningRate::computeDerivativeT(unsigned int qp, const std::vector<std::string> & coupled_var_names, RankTwoTensor & val) const
{
  val.zero();

  for (unsigned int i=0; i<coupled_var_names.size(); ++i)
  {
    if (_intvar_prop_names[0] == coupled_var_names[i])
    {
      RankTwoTensor back_stress = 2/3 * _C * _intvar[0][qp];
      RankTwoTensor diff_stress = _stress[qp].deviatoric() - back_stress.deviatoric();
      Real J2_back_stress = std::sqrt(3/2 * diff_stress.doubleContraction(diff_stress));

      Real dhardrate_dj2backstress = _exponent * std::pow(macaulayBracket(J2_back_stress / _yield_stress - 1.0), _exponent - 1.0) / _yield_stress;

      RankTwoTensor dj2backstress_ddiffstess = 1.5 / J2_back_stress * diff_stress;

      RankFourTensor dbackstressdev_dbackstress;
      dbackstressdev_dbackstress = dDevStress_dStress(dbackstressdev_dbackstress);

      Real dbackstress_dint = 2/3 * _C;

      val = -dhardrate_dj2backstress * dbackstressdev_dbackstress.transposeMajor() * dj2backstress_ddiffstess * dbackstress_dint;
    }
  }
  return true;
}

bool
VPIsotropicHardeningRate::computeStressDerivativeT(unsigned int qp, RankTwoTensor & val) const
{
  // val.zero();
  RankTwoTensor back_stress = 2/3 * _C * _intvar[0][qp];
  RankTwoTensor diff_stress = _stress[qp].deviatoric() - back_stress.deviatoric();
  Real J2_back_stress = std::sqrt(3/2 * diff_stress.doubleContraction(diff_stress));

  Real dhardrate_dj2backstress = _exponent * std::pow(macaulayBracket(J2_back_stress / _yield_stress - 1.0), _exponent - 1.0) / _yield_stress;

  RankTwoTensor dj2backstress_ddiffstess = 1.5 / J2_back_stress * diff_stress;

  RankFourTensor dstressdev_dstress;
  dstressdev_dstress = dDevStress_dStress(dstressdev_dstress);

  val = dhardrate_dj2backstress * dstressdev_dstress.transposeMajor() * dj2backstress_ddiffstess;

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

RankFourTensor
VPIsotropicHardeningRate::dDevStress_dStress(RankFourTensor val) const
{
  // RankFourTensor val;
  for (unsigned int i = 0; i < LIBMESH_DIM; ++i)
    for (unsigned int j = 0; j < LIBMESH_DIM; ++j)
      for (unsigned int k = 0; k < LIBMESH_DIM; ++k)
        for (unsigned int l = 0; l < LIBMESH_DIM; ++l)
        {
          val(i, j, k, l) = 0.0;
          if (i==k && j==l)
            val(i, j, k, l) = 1.0;
          if (i==j && k==l)
            val(i, j, k, l) -= 1/3.0;
        }

  return val;
}
