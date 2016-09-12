/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "VPTensorHardening.h"

template<>
InputParameters validParams<VPTensorHardening>()
{
  InputParameters params = validParams<VPHardeningBase>();
  params.addClassDescription("User Object to compute material resistance");
  return params;
}

VPTensorHardening::VPTensorHardening(const InputParameters & parameters) :
    VPHardeningBase(parameters),
    _intvar_rate(getMaterialPropertyByName<RankTwoTensor>(_intvar_rate_prop_name)),
    _this_old(getMaterialPropertyOldByName<RankTwoTensor>(_name))
{
}

bool
VPTensorHardening::computeTensorValue(unsigned int qp, Real dt, RankTwoTensor & val) const
{
  val = _this_old[qp] + _intvar_rate[qp] * dt;
  return true;
}

bool
VPTensorHardening::computeRankFourTensorDerivative(unsigned int qp, Real dt, const std::string & coupled_var_name, RankFourTensor & val) const
{
  val.zero();
  if (_intvar_rate_prop_name == coupled_var_name)
  {
    RankFourTensor dintvartensor_dintvarratetensor;
    for (unsigned int i = 0; i < LIBMESH_DIM; ++i)
      for (unsigned int j = 0; j < LIBMESH_DIM; ++j)
        for (unsigned int k = 0; k < LIBMESH_DIM; ++k)
          for (unsigned int l = 0; l < LIBMESH_DIM; ++l)
          {
            dintvartensor_dintvarratetensor(i, j, k, l) = 0.0;
            if (i==k && j==l)
              dintvartensor_dintvarratetensor(i, j, k, l) = 1.0;
          }
      val = dintvartensor_dintvarratetensor * dt;
    }

    if (_name == coupled_var_name)
    {
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
        val = dintvartensor_dintvartensor;
      }

  return true;
}
