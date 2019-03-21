#
# Example 2
# Phase change driven by a mechanical (elastic) driving force.
# An oversized phase inclusion grows under a uniaxial tensile stress.
# Check the file below for comments and suggestions for parameter modifications.
#

[Mesh]
  type = FileMesh
  file = hydride4_transverse_case3_out.e-s004 # hydride0_biaxial_out.e-s004 hydride0/1/2_transverse_out.e-s004/5/5 hydride4_out.e-s005 hydride3_out.e-s003 hydride10_out.e-s005 eigen_effect_hydride5.e-s012
  # file = /Users/bisws/Projects/Strain_periodicity/spinodal/hydride4_transverse_case3_out.e-s004
  parallel_type = replicated
[]

[MeshModifiers]
  [./cnode]
    type = AddExtraNodeset
    coord = '0 0'
    new_boundary = 100
  [../]
[]

# [Problem]
#   coord_type = RZ
#   block = 0
# []

[GlobalParams]
  displacements = 'u_x u_y'
  block = 0
[]

[Variables]
  [./global_strain]
    order = THIRD
    family = SCALAR
  [../]
[]

[Modules]
  [./TensorMechanics]
    [./Master]
      [./stress_div]
        strain = SMALL
        add_variables = true
        # eigenstrain_names = 'eigenstrain_ppt'
        global_strain = global_strain #global strain contribution
        generate_output = 'strain_xx strain_xy strain_yy stress_xx stress_xy
                           stress_yy vonmises_stress'
      [../]
    [../]
    [./GlobalStrain]
      [./global_strain]
        scalar_global_strain = global_strain
        displacements = 'u_x u_y'
        applied_stress_tensor = '0.0 0.0 0.0 0.0 0.0 0.01'
        auxiliary_displacements = 'disp_x disp_y'
      [../]
    [../]
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y'
      variable = 'u_x u_y'
    [../]
  [../]

  # fix center point location
  [./centerfix_x]
    type = PresetBC
    boundary = 100
    variable = u_x
    value = 0
  [../]
  [./fix_y]
    type = PresetBC
    boundary = 100
    variable = u_y
    value = 0
  [../]
[]

[UserObjects]
  [./initial_hydride]
    type = SolutionUserObject
    mesh = hydride4_transverse_case3_out.e-s004
    # /Users/bisws/Projects/Strain_periodicity/spinodal/hydride4_transverse_case3_out.e-s004
    timestep = LATEST
  [../]
[]

[AuxVariables]
  [./eta]
  [../]
[]

[AuxKernels]
  [./init_eta]
    type = SolutionAux
    execute_on = INITIAL
    variable = eta
    solution = initial_hydride
    from_variable = eta
  [../]
[]

[Materials]
  [./h_eta]
    type = SwitchingFunctionMaterial
    h_order = HIGH
    eta = eta
  [../]

  # 1- h(eta), putting in function explicitly
  [./one_minus_h_eta_explicit]
    type = DerivativeParsedMaterial
    f_name = one_minus_h_explicit
    args = eta
    function = 1-eta^3*(6*eta^2-15*eta+10)
    outputs = exodus
  [../]

  #elastic properties for phase with c =0
  [./elasticity_tensor_phase1]
    type = ComputeElasticityTensor
    base_name = C_matrix
    fill_method = symmetric9
    # base_name = phase0
    # fill_method = symmetric_isotropic_E_nu
    C_ijkl = '152.4 66.6 65.5 173.8 65.5 152.4 24.6 24.6 42.9' #alpha zirconium switched y with z
  [../]
  #elastic properties for phase with c = 1
  [./elasticity_tensor_phase0]
    type = ComputeElasticityTensor
    base_name = C_ppt
    fill_method = symmetric9
    # base_name = phase1
    # fill_method = symmetric_isotropic_E_nu
    C_ijkl = '160.8 120.4 110.2 164.5 110.2 160.8 63.5 71.2 63.5'
    # C_ijkl = '140.0 0.27' # check Jason's homogenization paper for isotropic properties
  [../]

  [./C]
    type = CompositeElasticityTensor
    args = eta
    tensors = 'C_matrix               C_ppt'
    weights = 'one_minus_h_explicit   h'
  [../]
  [./stress]
    type = ComputeLinearElasticStress
  [../]

  # [./eigen_strain]
  #   type = ComputeVariableEigenstrain
  #   eigen_base = '0.005 0.005 0.0 0 0 0'
  #   # base_name = phase1
  #   prefactor = h
  #   args = eta
  #   eigenstrain_name = 'eigenstrain_ppt'
  # [../]

  # [./elstc_en]
  #   type = ElasticEnergyMaterial
  #   f_name = E
  #   args = 'eta'
  #   derivative_order = 2
  # [../]
  #
[]

[Postprocessors]
  [./elem_c]
    type = ElementIntegralVariablePostprocessor
    variable = eta
    use_displaced_mesh = false
  [../]
  [./s11]
    type = ElementIntegralVariablePostprocessor
    variable = stress_xx
  [../]
  [./s22]
    type = ElementIntegralVariablePostprocessor
    variable = stress_yy
  [../]
  [./s12]
    type = ElementIntegralVariablePostprocessor
    variable = stress_xy
  [../]
  [./e11]
    type = ElementIntegralVariablePostprocessor
    variable = strain_xx
  [../]
  [./e22]
    type = ElementIntegralVariablePostprocessor
    variable = strain_yy
  [../]
  [./e12]
    type = ElementIntegralVariablePostprocessor
    variable = strain_xy
  [../]
  [./eta]
    type = ElementIntegralVariablePostprocessor
    variable = eta
  [../]
  [./hydride]
    type = Porosity
    variable = eta
    execute_on = 'initial timestep_end'
    cutoff = 0.5
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  scheme = BDF2
  solve_type = PJFNK
  # line_search = basic
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'
  petsc_options = '-snes_converged_reason'
  l_max_its = 20
  nl_max_its = 20
  l_tol = 1.0e-3
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-10
  num_steps = 3
  # dt = 0.005
  [./TimeStepper]
   type = IterationAdaptiveDT
   dt = 0.01
   growth_factor = 1.5
  [../]
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
  file_base = eigen_effect_global_hydride
[]

[Debug]
  show_var_residual_norms = true
[]
