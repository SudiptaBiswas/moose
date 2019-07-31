# This is a basic test of the system for continuum damage mechanics
# materials. It uses ScalarMaterialDamage for the damage model,
# which simply gets its damage index from another material. In this
# case, we prescribe the evolution of the damage index using a
# function. A single element has a fixed prescribed displacement
# on one side that puts the element in tension, and then the
# damage index evolves from 0 to 1 over time, and this verifies
# that the stress correspondingly drops to 0.

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 1
  ny = 1
  nz = 1
  elem_type = HEX8
[]

[AuxVariables]
  [damage_index]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Modules/TensorMechanics/Master]
  [all]
    strain = FINITE
    incremental = true
    add_variables = true
    generate_output = 'stress_yy strain_yy creep_strain_yy plastic_strain_yy'
  []
[]

[AuxKernels]
  [damage_index]
    type = MaterialRealAux
    variable = damage_index
    property = damage_index_prop
    execute_on = timestep_end
  []
[]

[BCs]
  [symmy]
    type = PresetBC
    variable = disp_y
    boundary = bottom
    value = 0
  []
  [symmx]
    type = PresetBC
    variable = disp_x
    boundary = left
    value = 0
  []
  [symmz]
    type = PresetBC
    variable = disp_z
    boundary = back
    value = 0
  []
  # [axial_load]
  #   type = NeumannBC
  #   variable = disp_x
  #   boundary = right
  #   value = 10e6
  # []
  [./u_top_pull]
    type = Pressure
    variable = disp_y
    component = 1
    boundary = top
    factor = 1
    function = top_pull
  [../]
[]

[Functions]
  [damage_evolution]
    type = PiecewiseLinear
    xy_data = '0.0   0.0
               0.1   0.0
               2.1   2.0'
  []
  [top_pull]
    type = PiecewiseLinear
    x = '  0   1   1.5'
    y = '-10 -20   -10'
  []
  [dts]
    type = PiecewiseLinear
    x = '0        0.5    1.0    1.5'
    y = '0.015  0.015  0.005  0.005'
  []
[]

[Materials]
  [damage_index]
    type = GenericFunctionMaterial
    prop_names = damage_index_prop
    prop_values = damage_evolution
  []
  [damage]
    type = ScalarMaterialDamage
    damage_index = damage_index_prop
    use_old_damage = true
  []
  [creep_plas]
    type = ComputeMultipleInelasticStress
    block = 0
    tangent_operator = elastic
    inelastic_models = 'creep plas'
    max_iterations = 50
    absolute_tolerance = 1e-05
    combined_inelastic_strain_weights = '0.0 1.0'
    damage_model = damage
    # include_damage = true
  []
  # [stress]
  #   type = ComputeInelasticDamageStress
  #   damage_model = damage
  #   tangent_operator = elastic
  #   inelastic_models = 'creep plas'
  #   max_iterations = 50
  #   absolute_tolerance = 1e-05
  #   combined_inelastic_strain_weights = '0.0 1.0'
  # []
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    # block = 0
    youngs_modulus = 1e3
    poissons_ratio = 0.3
  []
  [creep]
    type = PowerLawCreepStressUpdate
    # block = 0
    coefficient = 0.5e-7
    n_exponent = 5
    m_exponent = -0.5
    activation_energy = 0
  []
  [plas]
    type = IsotropicPlasticityStressUpdate
    # block = 0
    hardening_constant = 100
    yield_stress = 20
  []
[]

# [UserObjects]
#   [update]
#     type = LinearViscoelasticityManager
#     viscoelastic_model = kelvin_voigt
#   []
# []

[Postprocessors]
  [stress_xx]
    type = ElementAverageValue
    variable = stress_yy
  []
  [strain_xx]
    type = ElementAverageValue
    variable = strain_yy
  []
  [creep_strain_xx]
    type = ElementAverageValue
    variable = creep_strain_yy
  []
  [plastic_strain_xx]
    type = ElementAverageValue
    variable = plastic_strain_yy
  []
  [damage_index]
    type = ElementAverageValue
    variable = damage_index
  []
  [time_step_limit]
    type = MaterialTimeStepPostprocessor
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient

  solve_type = 'PJFNK'

  petsc_options = '-snes_ksp'
  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '101'

  # line_search = 'none'

  l_max_its = 20
  nl_max_its = 6
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10
  l_tol = 1e-4
  start_time = 0.0
  dt = 0.01
  dtmin = 2e-4
  end_time = 1.1
[]

[Outputs]
  csv=true
[]
