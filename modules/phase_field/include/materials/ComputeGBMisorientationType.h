//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "Material.h"
#include "GrainTracker.h"
#include "EulerAngleProvider.h"

/**
 * Visualize the location of grain boundaries in a polycrystalline simulation.
 */
class ComputeGBMisorientationType : public Material
{
public:
  static InputParameters validParams();

  ComputeGBMisorientationType(const InputParameters & parameters);

protected:
  /// Necessary override. This is where the property values are set.
  virtual void computeQpProperties() override;

  /// Function to get the GB misorientation for triple junctions
  virtual void computeTripleJunctionMisorientation();
  /// Function to convert symmetry matrix to quaternion form
  void rotationSymmetryToQuaternion(const double O[3][3], Eigen::Quaternion<Real> & q);
  /// Function to define the symmetry operator
  void defineSymmetryOperator();
  /// Function to return the misorientation of two quaternions
  double getMisorientationFromQuaternion(const Eigen::Quaternion<Real> qi,
                                         const Eigen::Quaternion<Real> qj);
  /// Get the Misorientation angle
  double getMisorientationAngle(unsigned int grain1, unsigned int grain2);
  // void getMisorientationAngles();

  /// Grain tracker object
  const GrainTracker & _grain_tracker;

  /// EBSD reader user object
  const EulerAngleProvider & _euler;

  /// Parameters to calculate the Misorientation angle file
  Real _misorientation_angle;
  Real _gb;

  /// parameters to store the EBSD id and corresponding value on GB
  std::vector<unsigned int> _gb_pairs;
  std::vector<Real> _gb_op_pairs;

  /// order parameters
  const unsigned int _op_num;
  const std::vector<const VariableValue *> _vals;

  /// the max value of LAGB
  const Real _angle_threshold;

  /// The parameters to calculate the misorientation
  std::vector<Eigen::Quaternion<Real>> _sym_quat;
  int _o_sym = 24;
  // std::vector<EulerAngles> _euler_angle;
  // std::vector<Eigen::Quaternion<Real>> _quat_angle;

  /// precalculated element value
  ADMaterialProperty<Real> & _gb_misorientation;
  ADMaterialProperty<Real> & _gb_type;
};
