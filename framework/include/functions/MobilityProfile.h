//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef MOBILITYPROFILE_H
#define MOBILITYPROFILE_H

#include "Function.h"

class MobilityProfile;
// class ColumnMajorMatrix;
class BilinearInterpolation;

template <>
InputParameters validParams<MobilityProfile>();

class MobilityProfile : public Function
{
public:
  MobilityProfile(const InputParameters & parameters);

  /**
   * This function will return a value based on the first input argument only.
   */
  virtual Real value(Real t, const Point & pt) const;

private:
  const Real _x1;
  const Real _y1;
  const Real _z1;
  const Real _vp;
  const Real _haz;
  const Real _r1;
  const Real _factor;

  const MooseEnum _shape;

  const Real _a;
  const Real _b;
  const Real _c;
  const Real _invalue;
  const Real _outvalue;
};

#endif // MOBILITYPROFILE_H
