[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 50
  ny = 50
  xmin = -0.5
  xmax = 0.5
  ymin = -0.5
  ymax = 0.5
[]

[MeshModifiers]
  [./cnode]
    type = AddExtraNodeset
    coord = '0.0 -0.5'
    new_boundary = 100
  [../]
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  # [./global_strain]
  #   order = THIRD
  #   family = SCALAR
  # [../]
  [./c]
    [./InitialCondition]
      type = SmoothCircleIC
      invalue = 0
      outvalue = 1
      radius = 0.15
      x1 = 0
      y1 = 0
      int_width = 0.002
    [../]
  [../]
  [./w]
  [../]
[]

[AuxVariables]
  [./local_energy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  # [./disp_x]
  # [../]
  # [./disp_y]
  # [../]
  # [./s00]
  #   order = CONSTANT
  #   family = MONOMIAL
  # [../]
  # [./s01]
  #   order = CONSTANT
  #   family = MONOMIAL
  # [../]
  # [./s10]
  #   order = CONSTANT
  #   family = MONOMIAL
  # [../]
  # [./s11]
  #   order = CONSTANT
  #   family = MONOMIAL
  # [../]
  # [./e00]
  #   order = CONSTANT
  #   family = MONOMIAL
  # [../]
  # [./e01]
  #   order = CONSTANT
  #   family = MONOMIAL
  # [../]
  # [./e10]
  #   order = CONSTANT
  #   family = MONOMIAL
  # [../]
  # [./e11]
  #   order = CONSTANT
  #   family = MONOMIAL
  # [../]
[]

[AuxKernels]
  [./local_free_energy]
    type = TotalFreeEnergy
    execute_on = 'initial LINEAR'
    variable = local_energy
    interfacial_vars = 'c'
    kappa_names = 'kappa_c'
  [../]
  # [./s00]
  #   type = RankTwoAux
  #   variable = s00
  #   rank_two_tensor = stress
  #   index_i = 0
  #   index_j = 0
  # [../]
  # [./s01]
  #   type = RankTwoAux
  #   variable = s01
  #   rank_two_tensor = stress
  #   index_i = 0
  #   index_j = 1
  # [../]
  # [./s10]
  #   type = RankTwoAux
  #   variable = s10
  #   rank_two_tensor = stress
  #   index_i = 1
  #   index_j = 0
  # [../]
  # [./s11]
  #   type = RankTwoAux
  #   variable = s11
  #   rank_two_tensor = stress
  #   index_i = 1
  #   index_j = 1
  # [../]
  # [./e00]
  #   type = RankTwoAux
  #   variable = e00
  #   rank_two_tensor = total_strain
  #   index_i = 0
  #   index_j = 0
  # [../]
  # [./e01]
  #   type = RankTwoAux
  #   variable = e01
  #   rank_two_tensor = total_strain
  #   index_i = 0
  #   index_j = 1
  # [../]
  # [./e10]
  #   type = RankTwoAux
  #   variable = e10
  #   rank_two_tensor = total_strain
  #   index_i = 1
  #   index_j = 0
  # [../]
  # [./e11]
  #   type = RankTwoAux
  #   variable = e11
  #   rank_two_tensor = total_strain
  #   index_i = 1
  #   index_j = 1
  # [../]
[]

[GlobalParams]
  derivative_order = 2
  enable_jit = true
  displacements = 'disp_x disp_y'
  block = 0
[]

[Kernels]
  [./TensorMechanics]
  [../]

  # Cahn-Hilliard kernels
  [./c_dot]
    type = CoupledTimeDerivative
    variable = w
    v = c
    block = 0
  [../]
  [./c_res]
    type = SplitCHParsed
    variable = c
    f_name = F
    kappa_name = kappa_c
    w = w
    block = 0
  [../]
  [./w_res]
    type = SplitCHWRes
    variable = w
    mob_name = M
    block = 0
  [../]
[]

# [ScalarKernels]
#   [./global_strain]
#     type = GlobalStrain
#     variable = global_strain
#     global_strain_uo = global_strain_uo
#   [../]
# []

[BCs]
  # [./Periodic]
  #   [./all]
  #     auto_direction = 'x'
  #     variable = 'c w disp_x disp_y'
  #   [../]
  # [../]

  # fix center point location
  [./centerfix_x]
    type = PresetBC
    boundary = 100
    variable = disp_x
    value = 0
  [../]
  [./centerfix_y]
    type = PresetBC
    boundary = bottom
    variable = disp_y
    value = 0
  [../]
  [./load_y]
    type = PresetBC
    boundary = top
    variable = disp_y
    value = 0.03
  [../]
[]

[Materials]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'M   kappa_c'
    prop_values = '0.2 0.001   '
  [../]

  [./elasticity_tensor]
    type = ComputeConcentrationDependentElasticityTensor
    c = c
    C0_ijkl = '1 1'
    C1_ijkl = '3 3'
    fill_method0 = symmetric_isotropic
    fill_method1 = symmetric_isotropic
  [../]
  [./strain]
    type = ComputeSmallStrain
    # global_strain = global_strain
  [../]
  # [./global_strain]
  #   type = ComputeGlobalStrain
  #   scalar_global_strain = global_strain
  #   global_strain_uo = global_strain_uo
  # [../]

  [./stress]
    type = ComputeLinearElasticStress
  [../]

  # chemical free energies
  [./chemical_free_energy]
    type = DerivativeParsedMaterial
    f_name = Fc
    function = '4*c^2*(1-c)^2'
    args = 'c'
    outputs = exodus
    # output_properties = Fc
  [../]

  # elastic free energies
  [./elastic_free_energy]
    type = ElasticEnergyMaterial
    f_name = Fe
    args = 'c'
    outputs = exodus
    output_properties = Fe
  [../]

  # free energy (chemical + elastic)
  [./free_energy]
    type = DerivativeSumMaterial
    block = 0
    f_name = F
    sum_materials = 'Fc Fe'
    args = 'c'
  [../]
[]

# [UserObjects]
#   [./global_strain_uo]
#     type = GlobalStrainUserObject
#     execute_on = 'Initial Linear Nonlinear'
#   [../]
# []

[Postprocessors]
  [./total_free_energy]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'initial TIMESTEP_END'
    variable = local_energy
  [../]
  [./total_solute]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'initial TIMESTEP_END'
    variable = c
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  scheme = bdf2
  solve_type = 'PJFNK'

  # line_search = basic

  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'

  l_max_its = 30
  nl_max_its = 12

  l_tol = 1.0e-4

  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1.0e-10

  start_time = 0.0
  end_time = 1.0

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.01
    growth_factor = 1.5
    cutback_factor = 0.8
    optimal_iterations = 9
    iteration_window = 2
  [../]
[]

[Outputs]
  execute_on = 'timestep_end'
  # print_linear_residuals = false
  exodus = true
[]
