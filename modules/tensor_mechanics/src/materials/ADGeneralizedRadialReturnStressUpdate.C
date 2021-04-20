//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ADGeneralizedRadialReturnStressUpdate.h"

#include "MooseMesh.h"
#include "MooseTypes.h"
#include "ElasticityTensorTools.h"
#include "libmesh/ignore_warnings.h"
#include "Eigen/Dense"
#include "Eigen/Eigenvalues"
#include "libmesh/restore_warnings.h"

InputParameters
ADGeneralizedRadialReturnStressUpdate::validParams()
{
  InputParameters params = ADStressUpdateBase::validParams();
  params.addClassDescription("Calculates the effective inelastic strain increment required to "
                             "return the isotropic stress state to a J2 yield surface.  This class "
                             "is intended to be a parent class for classes with specific "
                             "constitutive models.");
  params += ADGeneralizedReturnMappingSolution::validParams();
  params.addParam<Real>("max_inelastic_increment",
                        1e-4,
                        "The maximum inelastic strain increment allowed in a time step");
  params.addParam<Real>("max_integration_error",
                        5e-4,
                        "The maximum inelastic strain increment integration error allowed");
  params.addRequiredParam<std::string>(
      "effective_inelastic_strain_name",
      "Name of the material property that stores the effective inelastic strain");
  params.addRequiredParam<std::string>(
      "inelastic_strain_rate_name",
      "Name of the material property that stores the inelastic strain rate");
  MooseEnum axis("x y z", "z");
  params.addParam<MooseEnum>(
      "rotation_axis", axis, "Enum to select the rotation axis for the transformation matrix");
  params.addParam<Real>(
      "rotation_angle", 0.0, "Provide the rotation angle for transformation matrix");
  return params;
}

ADGeneralizedRadialReturnStressUpdate::ADGeneralizedRadialReturnStressUpdate(
    const InputParameters & parameters)
  : ADStressUpdateBase(parameters),
    ADGeneralizedReturnMappingSolution(parameters),
    _effective_inelastic_strain(declareADProperty<Real>(
        _base_name + getParam<std::string>("effective_inelastic_strain_name"))),
    _effective_inelastic_strain_old(getMaterialPropertyOld<Real>(
        _base_name + getParam<std::string>("effective_inelastic_strain_name"))),
    _inelastic_strain_rate(
        declareProperty<Real>(_base_name + getParam<std::string>("inelastic_strain_rate_name"))),
    _inelastic_strain_rate_old(getMaterialPropertyOld<Real>(
        _base_name + getParam<std::string>("inelastic_strain_rate_name"))),
    _max_inelastic_increment(getParam<Real>("max_inelastic_increment")),
    _max_integration_error(getParam<Real>("max_integration_error")),
    _max_integration_error_time_step(std::numeric_limits<Real>::max()),
    _rotation_axis(getParam<MooseEnum>("rotation_axis")),
    _angle(getParam<Real>("rotation_angle")),
    _transformation_tensor(6, 6)
{
}

void
ADGeneralizedRadialReturnStressUpdate::initQpStatefulProperties()
{
  _effective_inelastic_strain[_qp] = 0.0;
  _inelastic_strain_rate[_qp] = 0.0;
}

void
ADGeneralizedRadialReturnStressUpdate::propagateQpStatefulPropertiesRadialReturn()
{
  _effective_inelastic_strain[_qp] = _effective_inelastic_strain_old[_qp];
  _inelastic_strain_rate[_qp] = _inelastic_strain_rate_old[_qp];
}

void
ADGeneralizedRadialReturnStressUpdate::updateState(
    ADRankTwoTensor & elastic_strain_increment,
    ADRankTwoTensor & inelastic_strain_increment,
    const ADRankTwoTensor & /*rotation_increment*/,
    ADRankTwoTensor & stress_new,
    const RankTwoTensor & stress_old,
    const ADRankFourTensor & elasticity_tensor,
    const RankTwoTensor & /*elastic_strain_old*/,
    bool /*compute_full_tangent_operator = false*/,
    RankFourTensor & /*tangent_operator = StressUpdateBaseTempl<is_ad>::_identityTensor*/)
{
  // Prepare initial trial stress for generalized return mapping
  ADRankTwoTensor deviatoric_trial_stress = stress_new.deviatoric();

  ADDenseVector stress_new_vector(6);
  stress_new_vector(0) = stress_new(0, 0);
  stress_new_vector(1) = stress_new(1, 1);
  stress_new_vector(2) = stress_new(2, 2);
  stress_new_vector(3) = stress_new(0, 1);
  stress_new_vector(4) = stress_new(1, 2);
  stress_new_vector(5) = stress_new(0, 2);

  ADDenseVector stress_dev(6);
  stress_dev(0) = deviatoric_trial_stress(0, 0);
  stress_dev(1) = deviatoric_trial_stress(1, 1);
  stress_dev(2) = deviatoric_trial_stress(2, 2);
  stress_dev(3) = deviatoric_trial_stress(0, 1);
  stress_dev(4) = deviatoric_trial_stress(1, 2);
  stress_dev(5) = deviatoric_trial_stress(0, 2);

  computeStressInitialize(stress_dev, stress_new_vector, elasticity_tensor);

  // Use Newton iteration to determine a plastic multiplier variable
  ADReal delta_gamma = 0.0;

  // Use Newton iteration to determine the scalar effective inelastic strain increment
  if (!MooseUtils::absoluteFuzzyEqual(MetaPhysicL::raw_value(stress_dev).l2_norm(), 0.0))
  {
    returnMappingSolve(stress_dev, stress_new_vector, delta_gamma, _console);

    if (delta_gamma != 0.0)
      computeStrainFinalize(inelastic_strain_increment, stress_new, stress_dev, delta_gamma);
    else
      inelastic_strain_increment.zero();
  }
  else
    inelastic_strain_increment.zero();

  elastic_strain_increment -= inelastic_strain_increment;

  computeStressFinalize(inelastic_strain_increment,
                        delta_gamma,
                        stress_new,
                        stress_dev,
                        stress_old,
                        elasticity_tensor);
}

Real
ADGeneralizedRadialReturnStressUpdate::computeReferenceResidual(
    const ADDenseVector & /*effective_trial_stress*/,
    const ADDenseVector & /*stress_new*/,
    const ADReal & /*residual*/,
    const ADReal & /*scalar_effective_inelastic_strain*/)
{
  mooseError("ADGeneralizedRadialReturnStressUpdate::computeReferenceResidual must be implemented "
             "by child classes");

  return 0.0;
}

ADReal
ADGeneralizedRadialReturnStressUpdate::maximumPermissibleValue(
    const ADDenseVector & /*effective_trial_stress*/) const
{
  return std::numeric_limits<Real>::max();
}

Real
ADGeneralizedRadialReturnStressUpdate::computeTimeStepLimit()
{

  // Add a new criterion including numerical integration error
  Real scalar_inelastic_strain_incr = MetaPhysicL::raw_value(_effective_inelastic_strain[_qp]) -
                                      _effective_inelastic_strain_old[_qp];

  if (MooseUtils::absoluteFuzzyEqual(scalar_inelastic_strain_incr, 0.0))
    return std::numeric_limits<Real>::max();

  return std::min(_dt * _max_inelastic_increment / scalar_inelastic_strain_incr,
                  computeIntegrationErrorTimeStep());
}

void
ADGeneralizedRadialReturnStressUpdate::outputIterationSummary(std::stringstream * iter_output,
                                                              const unsigned int total_it)
{
  if (iter_output)
  {
    *iter_output << "At element " << _current_elem->id() << " _qp=" << _qp << " Coordinates "
                 << _q_point[_qp] << " block=" << _current_elem->subdomain_id() << '\n';
  }
  ADGeneralizedReturnMappingSolution::outputIterationSummary(iter_output, total_it);
}

void
ADGeneralizedRadialReturnStressUpdate::rotateHillConstants(ADDenseVector & hill_constants)
{
  _transformation_tensor.zero();

  const Real s = std::sin(_angle * libMesh::pi / 180.0);
  const Real c = std::cos(_angle * libMesh::pi / 180.0);

  switch (_rotation_axis)
  {
    case 0:
      _transformation_tensor(0, 0) = 1.0;

      _transformation_tensor(1, 1) = c * c;
      _transformation_tensor(1, 2) = s * s;
      _transformation_tensor(1, 3) = 2 * c * s;

      _transformation_tensor(2, 1) = s * s;
      _transformation_tensor(2, 2) = c * c;
      _transformation_tensor(2, 3) = -2 * c * s;

      _transformation_tensor(3, 1) = -c * s;
      _transformation_tensor(3, 2) = c * s;
      _transformation_tensor(3, 3) = c * c - s * s;

      _transformation_tensor(4, 4) = c;
      _transformation_tensor(4, 5) = -s;

      _transformation_tensor(5, 4) = -s;
      _transformation_tensor(5, 5) = c;

      // the matrix is filled in rowwise
      // _transformation_tensor(0, 0) = 1.0;
      //
      // _transformation_tensor(1, 1) = c * c;
      // _transformation_tensor(1, 2) = s * s;
      // _transformation_tensor(1, 5) = c * s;
      //
      // _transformation_tensor(2, 1) = s * s;
      // _transformation_tensor(2, 2) = c * c;
      // _transformation_tensor(2, 5) = -c * s;
      //
      // _transformation_tensor(3, 3) = c;
      // _transformation_tensor(3, 4) = -s;
      //
      // _transformation_tensor(4, 3) = s;
      // _transformation_tensor(4, 4) = c;
      //
      // _transformation_tensor(5, 1) = -2.0 * c * s;
      // _transformation_tensor(5, 2) = 2.0 * c * s;
      // _transformation_tensor(5, 5) = c * c - s * s;

      break;

    case 1:
      _transformation_tensor(0, 0) = c * c;
      _transformation_tensor(0, 2) = s * s;
      _transformation_tensor(0, 4) = 2 * c * s;

      _transformation_tensor(1, 1) = 1.0;

      _transformation_tensor(2, 0) = s * s;
      _transformation_tensor(2, 2) = c * c;
      _transformation_tensor(2, 4) = -2 * c * s;

      _transformation_tensor(3, 3) = c;
      _transformation_tensor(3, 5) = -s;

      _transformation_tensor(4, 0) = -c * s;
      _transformation_tensor(4, 2) = c * s;
      _transformation_tensor(4, 4) = c * c - s * s;

      _transformation_tensor(5, 3) = -s;
      _transformation_tensor(5, 5) = c;
      break;

    case 2:
      _transformation_tensor(0, 0) = c * c;
      _transformation_tensor(0, 1) = s * s;
      _transformation_tensor(0, 5) = 2 * c * s;

      _transformation_tensor(1, 0) = s * s;
      _transformation_tensor(1, 1) = c * c;
      _transformation_tensor(1, 5) = -2 * c * s;

      _transformation_tensor(2, 2) = 1.0;

      _transformation_tensor(3, 3) = c;
      _transformation_tensor(3, 4) = s;

      _transformation_tensor(4, 3) = s;
      _transformation_tensor(4, 4) = c;

      _transformation_tensor(5, 0) = -c * s;
      _transformation_tensor(5, 1) = c * s;
      _transformation_tensor(5, 5) = c * c - s * s;
      break;

    default:
      mooseError("Unknown axis of rotation for transformation matrix in "
                 "ADGeneralizedRadialReturnStressUpdate");
      break;
  }

  // mooseWarning("transformation_mtarix = {",
  //              _transformation_tensor(0, 0),
  //              " ",
  //              _transformation_tensor(0, 1),
  //              " ",
  //              _transformation_tensor(0, 2),
  //              " ",
  //              _transformation_tensor(0, 3),
  //              " ",
  //              _transformation_tensor(0, 4),
  //              " ",
  //              _transformation_tensor(0, 5),
  //              " ",
  //              _transformation_tensor(1, 0),
  //              " ",
  //              _transformation_tensor(1, 1),
  //              " ",
  //              _transformation_tensor(1, 2),
  //              " ",
  //              _transformation_tensor(1, 3),
  //              " ",
  //              _transformation_tensor(1, 4),
  //              " ",
  //              _transformation_tensor(1, 5),
  //              " ",
  //              _transformation_tensor(2, 0),
  //              " ",
  //              _transformation_tensor(2, 1),
  //              " ",
  //              _transformation_tensor(2, 2),
  //              " ",
  //              _transformation_tensor(2, 3),
  //              " ",
  //              _transformation_tensor(2, 4),
  //              " ",
  //              _transformation_tensor(2, 5),
  //              " ",
  //              _transformation_tensor(3, 3),
  //              " ",
  //              _transformation_tensor(4, 4),
  //              " ",
  //              _transformation_tensor(5, 5),
  //              "}");

  hill_constants(0) *= _transformation_tensor(1, 2) * _transformation_tensor(2, 1);
  hill_constants(1) *= _transformation_tensor(0, 2) * _transformation_tensor(2, 0);
  hill_constants(2) *= _transformation_tensor(0, 1) * _transformation_tensor(1, 0);
  hill_constants(3) *= _transformation_tensor(4, 4) * _transformation_tensor(4, 4);
  hill_constants(4) *= _transformation_tensor(5, 5) * _transformation_tensor(5, 5);
  hill_constants(5) *= _transformation_tensor(3, 3) * _transformation_tensor(3, 3);
}

void
ADGeneralizedRadialReturnStressUpdate::rotateHillTensor(ADDenseMatrix & hill_tensor)
{
  _transformation_tensor.zero();

  const Real s = std::sin(_angle * libMesh::pi / 180.0);
  const Real c = std::cos(_angle * libMesh::pi / 180.0);

  switch (_rotation_axis)
  {
    case 0:

      // _transformation_tensor(0, 0) = 1.0;
      //
      // _transformation_tensor(1, 1) = c * c;
      // _transformation_tensor(1, 2) = s * s;
      // _transformation_tensor(1, 5) = c * s;
      //
      // _transformation_tensor(2, 1) = s * s;
      // _transformation_tensor(2, 2) = c * c;
      // _transformation_tensor(2, 5) = -c * s;
      //
      // _transformation_tensor(3, 3) = c;
      // _transformation_tensor(3, 4) = -s;
      //
      // _transformation_tensor(4, 3) = s;
      // _transformation_tensor(4, 4) = c;
      //
      // _transformation_tensor(5, 1) = -2.0 * c * s;
      // _transformation_tensor(5, 2) = 2.0 * c * s;
      // _transformation_tensor(5, 5) = c * c - s * s;

      _transformation_tensor(0, 0) = 1.0;

      _transformation_tensor(1, 1) = c * c;
      _transformation_tensor(1, 2) = s * s;
      _transformation_tensor(1, 3) = 2 * c * s;

      _transformation_tensor(2, 1) = s * s;
      _transformation_tensor(2, 2) = c * c;
      _transformation_tensor(2, 3) = -2 * c * s;

      _transformation_tensor(3, 1) = -c * s;
      _transformation_tensor(3, 2) = c * s;
      _transformation_tensor(3, 3) = c * c - s * s;

      _transformation_tensor(4, 4) = c;
      _transformation_tensor(4, 5) = -s;

      _transformation_tensor(5, 4) = -s;
      _transformation_tensor(5, 5) = c;
      break;

    case 1:
      _transformation_tensor(0, 0) = c * c;
      _transformation_tensor(0, 2) = s * s;
      _transformation_tensor(0, 4) = 2 * c * s;

      _transformation_tensor(1, 1) = 1.0;

      _transformation_tensor(2, 0) = s * s;
      _transformation_tensor(2, 2) = c * c;
      _transformation_tensor(2, 4) = -2 * c * s;

      _transformation_tensor(3, 3) = c;
      _transformation_tensor(3, 5) = -s;

      _transformation_tensor(4, 0) = -c * s;
      _transformation_tensor(4, 2) = c * s;
      _transformation_tensor(4, 4) = c * c - s * s;

      _transformation_tensor(5, 3) = -s;
      _transformation_tensor(5, 5) = c;
      break;

    case 2:
      _transformation_tensor(0, 0) = c * c;
      _transformation_tensor(0, 1) = s * s;
      _transformation_tensor(0, 5) = 2 * c * s;

      _transformation_tensor(1, 0) = s * s;
      _transformation_tensor(1, 1) = c * c;
      _transformation_tensor(1, 5) = -2 * c * s;

      _transformation_tensor(2, 2) = 1.0;

      _transformation_tensor(3, 3) = c;
      _transformation_tensor(3, 4) = s;

      _transformation_tensor(4, 3) = s;
      _transformation_tensor(4, 4) = c;

      _transformation_tensor(5, 0) = -c * s;
      _transformation_tensor(5, 1) = c * s;
      _transformation_tensor(5, 5) = c * c - s * s;
      break;

    default:
      mooseError("Unknown axis of rotation for transformation matrix in "
                 "ADGeneralizedRadialReturnStressUpdate");
      break;
  }

  hill_tensor.right_multiply_transpose(_transformation_tensor);
  hill_tensor.left_multiply(_transformation_tensor);
}
