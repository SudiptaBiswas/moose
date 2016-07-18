/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef HEVPLINEARHARDENING_H
#define HEVPLINEARHARDENING_H

#include "HEVPStrengthUOBase.h"

class VPStrength;

template<>
InputParameters validParams<VPStrength>();

/**
 * This user object classs
 * Computes linear hardening
 */
class VPStrength : public HEVPStrengthUOBase
{
public:
  VPStrength(const InputParameters & parameters);

  virtual bool computeValue(unsigned int, Real &) const;
  virtual bool computeDerivative(unsigned int, const std::string &, Real &) const;

protected:
  Real _h;
  Real _a;
  const MaterialProperty<Real> & _intvar_old;
};

#endif
