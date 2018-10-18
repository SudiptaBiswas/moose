[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 40
  ny = 40
  xmin = -0.5
  xmax = 0.5
  ymin = -0.5
  ymax = 0.5
  # second_order = true
  # elem_type = QUAD
[]

[MeshModifiers]
  [./cnode]
    type = AddExtraNodeset
    coord = '0 0'
    new_boundary = 100
  [../]
  [./subdomains1]
    type = SubdomainBoundingBox
    bottom_left = '-0.5 -0.375 0'
    top_right = '-0.375 0.375 0'
    block_id = 1
  [../]
  [./subdomains2]
    type = SubdomainBoundingBox
    bottom_left = '0.375 -0.375 0'
    top_right = '0.5 0.375 0'
    block_id = 2
  [../]
  [./subdomains3]
    type = SubdomainBoundingBox
    bottom_left = '-0.125 -0.5 0'
    top_right = '0.125 -0.125 0'
    block_id = 3
  [../]
  [./subdomains4]
    type = SubdomainBoundingBox
    bottom_left = '-0.125 0.125 0'
    top_right = '0.125 0.5 0'
    block_id = 4
  [../]
[]

[Variables]
  [./u_x]
    # scaling = 1e2
    # order = SECOND
    # family = LAGRANGE
  [../]
  [./u_y]
    # order = SECOND
    # family = LAGRANGE
  [../]
  [./global_strain]
    order = THIRD
    family = SCALAR
  [../]
[]

[AuxVariables]
  [./disp_x]
    # order = SECOND
    # family = LAGRANGE
  [../]
  [./disp_y]
    # order = SECOND
    # family = LAGRANGE
  [../]
  [./s00]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./s11]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./s10]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./s01]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./e00]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./e11]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./e01]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./e10]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./disp_x]
    type = GlobalDisplacementAux
    variable = disp_x
    scalar_global_strain = global_strain
    global_strain_uo = global_strain_uo
    component = 0
  [../]
  [./disp_y]
    type = GlobalDisplacementAux
    variable = disp_y
    scalar_global_strain = global_strain
    global_strain_uo = global_strain_uo
    component = 1
  [../]
  [./s00]
    type = RankTwoAux
    variable = s00
    rank_two_tensor = stress
    index_i = 0
    index_j = 0
  [../]
  [./s11]
    type = RankTwoAux
    variable = s11
    rank_two_tensor = stress
    index_i = 1
    index_j = 1
  [../]
  [./s01]
    type = RankTwoAux
    variable = s01
    rank_two_tensor = stress
    index_i = 0
    index_j = 1
  [../]
  [./s10]
    type = RankTwoAux
    variable = s10
    rank_two_tensor = stress
    index_i = 1
    index_j = 0
  [../]
  [./e00]
    type = RankTwoAux
    variable = e00
    rank_two_tensor = total_strain
    index_i = 0
    index_j = 0
  [../]
  [./e11]
    type = RankTwoAux
    variable = e11
    rank_two_tensor = total_strain
    index_i = 1
    index_j = 1
  [../]
  [./e01]
    type = RankTwoAux
    variable = e01
    rank_two_tensor = total_strain
    index_i = 0
    index_j = 1
  [../]
  [./e10]
    type = RankTwoAux
    variable = e10
    rank_two_tensor = total_strain
    index_i = 1
    index_j = 0
  [../]
[]

[GlobalParams]
  displacements = 'u_x u_y'
  block = '0 1 2 3 4'
  # scaling = 1e3
[]

[Kernels]
  [./TensorMechanics]
  [../]
[]

[ScalarKernels]
  [./global_strain]
    type = GlobalStrain
    variable = global_strain
    global_strain_uo = global_strain_uo
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
  [./centerfix_y]
    type = PresetBC
    boundary = 100
    variable = u_y
    value = 0
  [../]
  # [./fix_y]
  #   type = PresetBC
  #   boundary = bottom
  #   variable = u_y
  #   value = 0
  # [../]
  # [./appl_y]
  #   type = PresetBC
  #   boundary = top
  #   variable = u_y
  #   value = 0.01
  # [../]
[]

[Materials]
  [./elasticity_tensor1]
    type = ComputeElasticityTensor
    block = 0
    # C_ijkl = '72.5 0.33'
    C_ijkl = '75.0 0.3'
    fill_method = symmetric_isotropic_E_nu
  [../]
  [./elasticity_tensor2]
    type = ComputeElasticityTensor
    block = '1 2 3 4'
    # C_ijkl = '400 0.2'
    C_ijkl = '140.0 0.27'
    fill_method = symmetric_isotropic_E_nu
  [../]
  [./strain]
    type = ComputeSmallStrain
    global_strain = global_strain
  [../]
  [./global_strain]
    type = ComputeGlobalStrain
    scalar_global_strain = global_strain
    global_strain_uo = global_strain_uo
  [../]
  [./stress]
    type = ComputeLinearElasticStress
  [../]
[]

[UserObjects]
  [./global_strain_uo]
    type = GlobalStrainUserObject
    execute_on = 'Initial Linear Nonlinear'
    applied_stress_tensor = '1.0 0.0 0.0 0.0 0.0 0.0'
  [../]
[]

[Postprocessors]
  [./s00]
    type = ElementIntegralVariablePostprocessor
    variable = s00
  [../]
  [./s11]
    type = ElementIntegralVariablePostprocessor
    variable = s11
  [../]
  [./s01]
    type = ElementIntegralVariablePostprocessor
    variable = s01
  [../]
  [./s10]
    type = ElementIntegralVariablePostprocessor
    variable = s10
  [../]
  [./e00]
    type = ElementIntegralVariablePostprocessor
    variable = e00
  [../]
  [./e11]
    type = ElementIntegralVariablePostprocessor
    variable = e11
  [../]
  [./e01]
    type = ElementIntegralVariablePostprocessor
    variable = e01
  [../]
  [./e10]
    type = ElementIntegralVariablePostprocessor
    variable = e10
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Steady
  # scheme = bdf2
  solve_type = 'PJFNK'

  # line_search = basic

  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'
  # petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type'
  # petsc_options_value = '70 hypre boomeramg'

  l_max_its = 30
  nl_max_its = 12

  l_tol = 1.0e-4

  nl_rel_tol = 1.0e-6
  nl_abs_tol = 1.0e-8

  # start_time = 0.0
  # num_steps = 2
  # dt = 0.1
[]

[Outputs]
  exodus = true
  # file_base = composite
[]

[Debug]
  show_var_residual_norms = true
[../]
