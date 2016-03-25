/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "VPPlasticStrainRate.h"

template<>
InputParameters validParams<VPPlasticStrainRate>()
{
  InputParameters params = validParams<VPHardeningRateBase>();
  params.addParam<Real>("hardening_multiplier", 1.0, "Names of internal variable property to calculate material resistance: Same as internal variable user object");
  params.addClassDescription("User Object to compute material resistance");
  return params;
}

VPPlasticStrainRate::VPPlasticStrainRate(const InputParameters & parameters) :
    VPHardeningRateBase(parameters),
    _intvar(getMaterialPropertyByName<std::vector<RankTwoTensor> >(_base_name + "intvar_prop_names")),
    _intvar_rate(getMaterialPropertyByName<std::vector<Real> >(_base_name + "intvar_rate_prop_names")),
    _dintvarrate_dstress(getMaterialPropertyByName<std::vector<RankTwoTensor> >(_base_name + "intvar_prop_rate_names" + "stress")),
    _stress(getMaterialProperty<RankTwoTensor>(_base_name + "stress")),
    _C(getParam<Real>("hardening_multiplier"))
{
}

bool
VPPlasticStrainRate::computeValueT(unsigned int qp, RankTwoTensor & val) const
{
  RankTwoTensor back_stress = 2/3 * _C * _intvar[0][qp];
  RankTwoTensor diff_stress = _stress[qp].deviatoric() - back_stress.deviatoric();
  Real J2_back_stress = std::sqrt(3/2 * diff_stress.doubleContraction(diff_stress));

  val = 2/3 * _intvar_rate[1][qp] * diff_stress/J2_back_stress;
  return true;
}

bool
VPPlasticStrainRate::computeDerivativeT(unsigned int qp, const std::vector<std::string> & coupled_var_names, RankTwoTensor & val) const
{
  val.zero();

  for (unsigned int i=0; i<coupled_var_names.size(); ++i)
  {
    if (_intvar_prop_names[0] == coupled_var_names[i])
    {
      RankTwoTensor back_stress = 2/3 * _C * _intvar[0][qp];
      RankTwoTensor diff_stress = _stress[qp].deviatoric() - back_stress.deviatoric();
      Real J2_back_stress = std::sqrt(3/2 * diff_stress.doubleContraction(diff_stress));

      RankTwoTensor dj2backstress_ddiffstess = 1.5 / J2_back_stress * diff_stress;

      RankFourTensor dbackstressdev_dbackstress;
      dbackstressdev_dbackstress = dDevStress_dStress(dbackstressdev_dbackstress);

      Real dbackstress_dint = 2/3 * _C;

      val = -dbackstressdev_dbackstress.transposeMajor() * dj2backstress_ddiffstess * dbackstress_dint;
    }

    if (_intvar_rate_prop_names[1] == coupled_var_names[i])
    {
      RankTwoTensor back_stress = 2/3 * _C * _intvar[0][qp];
      RankTwoTensor diff_stress = _stress[qp].deviatoric() - back_stress.deviatoric();
      Real J2_back_stress = std::sqrt(3/2 * diff_stress.doubleContraction(diff_stress));
      val = diff_stress /J2_back_stress;
    }
  }

  return true;
}

bool
VPPlasticStrainRate::computeStressDerivativeT(unsigned int qp, RankFourTensor & val) const
{
  RankTwoTensor back_stress = 2/3 * _C * _intvar[0][qp];
  RankTwoTensor diff_stress = _stress[qp].deviatoric() - back_stress.deviatoric();
  Real J2_back_stress = std::sqrt(3/2 * diff_stress.doubleContraction(diff_stress));

  RankTwoTensor dj2backstress_ddiffstress = 1.5 / J2_back_stress * diff_stress;

  RankFourTensor dstressdev_dstress;
  dstressdev_dstress = dDevStress_dStress(dstressdev_dstress);

  val.zero();
  for (unsigned int i = 0; i < LIBMESH_DIM; ++i)
    for (unsigned int j = 0; j < LIBMESH_DIM; ++j)
      for (unsigned int k = 0; k < LIBMESH_DIM; ++k)
        for (unsigned int l = 0; l < LIBMESH_DIM; ++l)
        {
          val(i, j, k, l) = 1.5 * (_dintvarrate_dstress[1][qp](k, l) * diff_stress(k, l) / J2_back_stress
                                   + _intvar_rate[1][qp] * dstressdev_dstress(i, j, k, l) / J2_back_stress
                                   - _intvar_rate[1][qp] * diff_stress(k, l) * dstressdev_dstress(i, j, k, l) * dj2backstress_ddiffstress(k, l) / (J2_back_stress * J2_back_stress));
        }

  return true;
}

bool
VPPlasticStrainRate::computeDirection(unsigned int qp, RankTwoTensor & val) const
{
  RankTwoTensor back_stress = 2/3 * _C * _intvar[0][qp];
  RankTwoTensor diff_stress = _stress[qp].deviatoric() - back_stress.deviatoric();
  Real J2_back_stress = std::sqrt(3/2 * diff_stress.doubleContraction(diff_stress));

  val = 2/3 * diff_stress/J2_back_stress;

  return true;
}

RankFourTensor
VPPlasticStrainRate::dDevStress_dStress(RankFourTensor val) const
{
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
