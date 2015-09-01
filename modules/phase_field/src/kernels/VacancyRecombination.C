/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "VacancyRecombination.h"

template<>
InputParameters validParams<VacancyRecombination>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("Kernel for recombination of vacancies and interstitials");
  params.addCoupledVar("eta", "Order parameter representing voids");
  params.addCoupledVar("ci", "Additional Concentration field for interstitials");
  params.addParam<Real>("Rbulk", 0.0, "Co-effienient of bulk recombination");
  params.addParam<Real>("Rs", 1.0, "Co-effienient of surface recombination");
  return params;
}

VacancyRecombination::VacancyRecombination(const InputParameters & parameters) :
    Kernel(parameters),
    _eta(coupledValue("eta")),
    _ci(coupledValue("ci")),
    _Rbulk(getParam<Real>("Rbulk")),
    _Rs(getParam<Real>("Rs"))
{
}

Real
VacancyRecombination::computeQpResidual()
{
  Real Rr = _Rbulk + _eta[_qp] * _Rs;

  return Rr * _ci[_qp] * _u[_qp] * _test[_i][_qp];
}

Real
VacancyRecombination::computeQpJacobian()
{
  Real Rr = _Rbulk + _eta[_qp] * _Rs;

  return Rr * _ci[_qp] * _phi[_j][_qp] * _test[_i][_qp];
}
