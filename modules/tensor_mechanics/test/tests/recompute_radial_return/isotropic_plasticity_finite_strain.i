# This simulation uses the piece-wise linear strain hardening model
# with the incremental small strain formulation; incremental small strain
# is required to produce the strain_increment for the DiscreteRadialReturnStressIncrement
# class, which handles the calculation of the stress increment to return
# to the yield surface in a J2 (isotropic) plasticity problem.
#
#  This test assumes a Poissons ratio of 0.3 and applies a displacement loading
# condition on the top in the y direction.
#
# An identical problem was run in Abaqus on a similar 1 element mesh and was used
# to verify the SolidMechanics solution; this TensorMechanics code matches the
# SolidMechanics solution.
#
# Mechanical strain is the sum of the elastic and plastic strains but is different
# from total strain in cases with eigen strains, e.g. thermal strain.

[Mesh]
  type = GeneratedMesh
  # file = 1x1x1cube.e
  dim = 1
  nx = 1
  ny = 0
  nz = 0
[]

[GlobalParams]
  displacements = 'disp_x'
[]

[Functions]
  [./top_pull]
    type = ParsedFunction
    value = t*(0.0625)
  [../]
  [./hf]
    type = PiecewiseLinear
    x = '0  30'
    y = '50 80'
  [../]
  # [./hf]
  #   type = ConstantFunction
  #   value = 1.0
  # [../]
[]

[Modules/TensorMechanics/Master]
  [./all]
    strain = FINITE
    add_variables = true
    generate_output = 'stress_xx plastic_strain_xx strain_xx elastic_strain_xx'
  [../]
[]

[BCs]
  [./y_pull_function]
    type = FunctionPresetBC
    variable = disp_x
    boundary = right
    function = top_pull
  [../]
  [./x_bot]
    type = DirichletBC
    variable = disp_x
    boundary = left
    value = 0.0
  [../]
  # [./y_bot]
  #   type = DirichletBC
  #   variable = disp_y
  #   boundary = 3
  #   value = 0.0
  # [../]
  # [./z_bot]
  #   type = DirichletBC
  #   variable = disp_z
  #   boundary = 2
  #   value = 0.0
  # [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 2.1e5
    poissons_ratio = 0.3
  [../]
  [./isotropic_plasticity]
    type = IsotropicPlasticityStressUpdate
    yield_stress = 50.0
    hardening_function = hf
  [../]
  [./radial_return_stress]
    type = ComputeMultipleInelasticStress
    tangent_operator = elastic
    inelastic_models = 'isotropic_plasticity'
  [../]
[]

[Executioner]
  type = Transient

  solve_type = 'PJFNK'

  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '101'

  line_search = 'none'

  l_max_its = 50
  nl_max_its = 50
  nl_rel_tol = 1e-12
  nl_abs_tol = 1e-10
  l_tol = 1e-9

  start_time = 0.0
  end_time = 30
  dt = 1
  dtmin = 0.0001
[]

[Postprocessors]
  [./s_xx]
    type = ElementIntegralVariablePostprocessor
    # point = '0 0 0'
    variable = stress_xx
  [../]
  [./e_xx]
    type = ElementIntegralVariablePostprocessor
    # point = '0 0 0'
    variable = strain_xx
  [../]
  [./ee_xx]
    type = ElementIntegralVariablePostprocessor
    # point = '0 0 0'
    variable = elastic_strain_xx
  [../]
  [./ep_xx]
    type = ElementIntegralVariablePostprocessor
    # point = '0 0 0'
    variable = plastic_strain_xx
  [../]
[]

[Outputs]
  csv = true
  [./out]
    type = Exodus
    elemental_as_nodal = true
  [../]
[]
