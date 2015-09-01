/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "GBVacancyAnnihilation.h"

template<>
InputParameters validParams<GBVacancyAnnihilation>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("Kernel for vacancy annihilation at GBs");
  params.addRequiredCoupledVar("v", "Array of order parameters representing grain orientations");
  params.addParam<MaterialPropertyName>("Svgb", "S", "Efficiency of void nucleation/annihilation");
  params.addParam<Real>("ceq", 0.0, "Equilibrium concentration");
  return params;
}

GBVacancyAnnihilation::GBVacancyAnnihilation(const InputParameters & parameters) :
    Kernel(parameters),
    _Svgb(getMaterialProperty<Real>("Svgb")),
    _ceq(getParam<Real>("ceq")),
    _ncrys(coupledComponents("v")),
    _vals(_ncrys)
{
  // Loop through grains and load coupled variables into the arrays
  for (unsigned int i = 0; i < _ncrys; ++i)
    _vals[i] = &coupledValue("v", i);
}

Real
GBVacancyAnnihilation::computeQpResidual()
{
  Real SumEta = 0.0;
  for (unsigned int i = 0; i < _ncrys; ++i)
    SumEta += (*_vals[i])[_qp]*(*_vals[i])[_qp]; //Sum order parameters

  return _Svgb[_qp] * (1.0 - SumEta) * (_u[_qp] - _ceq) * _test[_i][_qp];
}

Real
GBVacancyAnnihilation::computeQpJacobian()
{
  Real SumEta = 0.0;
  for (unsigned int i = 0; i < _ncrys; ++i)
    SumEta += (*_vals[i])[_qp]*(*_vals[i])[_qp]; //Sum all order parameters

  return _Svgb[_qp] * (1.0 - SumEta) * _phi[_j][_qp] * _test[_i][_qp];
}
