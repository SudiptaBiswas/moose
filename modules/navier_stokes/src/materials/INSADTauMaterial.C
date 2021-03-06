//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

// Navier-Stokes includes
#include "INSADTauMaterial.h"
#include "NonlinearSystemBase.h"
#include "INSADObjectTracker.h"

registerMooseObject("NavierStokesApp", INSADTauMaterial);

InputParameters
INSADTauMaterial::validParams()
{
  InputParameters params = INSADMaterial::validParams();
  params.addClassDescription(
      "This is the material class used to compute the stabilization parameter tau.");
  params.addParam<Real>("alpha", 1., "Multiplicative factor on the stabilization parameter tau.");
  return params;
}

INSADTauMaterial::INSADTauMaterial(const InputParameters & parameters)
  : INSADMaterial(parameters), _alpha(getParam<Real>("alpha")), _tau(declareADProperty<Real>("tau"))
{
}

void
INSADTauMaterial::computeHMax()
{
  if (!_displacements.size())
  {
    _hmax = _current_elem->hmax();
    return;
  }

  _hmax = 0;

  for (unsigned int n_outer = 0; n_outer < _current_elem->n_vertices(); n_outer++)
    for (unsigned int n_inner = n_outer + 1; n_inner < _current_elem->n_vertices(); n_inner++)
    {
      VectorValue<DualReal> diff = (_current_elem->point(n_outer) - _current_elem->point(n_inner));
      unsigned dimension = 0;
      for (const auto & disp_num : _displacements)
      {
        diff(dimension)
            .derivatives()[disp_num * _fe_problem.getNonlinearSystemBase().getMaxVarNDofsPerElem() +
                           n_outer] = 1.;
        diff(dimension++)
            .derivatives()[disp_num * _fe_problem.getNonlinearSystemBase().getMaxVarNDofsPerElem() +
                           n_inner] = -1.;
      }

      _hmax = std::max(_hmax, diff.norm_sq());
    }

  _hmax = std::sqrt(_hmax);
}

void
INSADTauMaterial::computeProperties()
{
  computeHMax();

  Material::computeProperties();
}

void
INSADTauMaterial::computeQpProperties()
{
  INSADMaterial::computeQpProperties();

  auto && nu = _mu[_qp] / _rho[_qp];
  auto && transient_part = _object_tracker->hasTransient() ? 4. / (_dt * _dt) : 0.;
  _tau[_qp] = _alpha / std::sqrt(transient_part +
                                 (2. * _velocity[_qp].norm() / _hmax) *
                                     (2. * _velocity[_qp].norm() / _hmax) +
                                 9. * (4. * nu / (_hmax * _hmax)) * (4. * nu / (_hmax * _hmax)));
}
