[Mesh]
  type = FileMesh
  file = unitcell.e
[]

[MeshModifiers]
  [./cnode]
    type = AddExtraNodeset
    coord = '0 0 0'
    new_boundary = 100
  [../]
[]

[Variables]
  [./u_x]
    # scaling = 1e2
  [../]
  [./u_y]
  [../]
  [./u_z]
    # scaling = 1e2
  [../]
  [./global_strain]
    order = SIXTH
    family = SCALAR
  [../]
[]

[AuxVariables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
  [./s00]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./s11]
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
  [./disp_z]
    type = GlobalDisplacementAux
    variable = disp_z
    scalar_global_strain = global_strain
    global_strain_uo = global_strain_uo
    component = 2
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
[]

[GlobalParams]
  displacements = 'u_x u_y u_z'
  block = '1 2'
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
      auto_direction = 'z'
      # primary = 5
      # secondary = 5
      variable = 'u_x u_y u_z'
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
    boundary = 5
    variable = u_y
    value = 0
  [../]
  [./centerfix_z]
    type = PresetBC
    boundary = 100
    variable = u_z
    value = 0
  [../]
  [./appl_y]
    type = PresetBC
    boundary = 6
    variable = u_y
    value = 0.033
  [../]
[]

[Materials]
  [./elasticity_tensor1]
    type = ComputeElasticityTensor
    block = 2
    C_ijkl = '7 0.33'
    fill_method = symmetric_isotropic_E_nu
  [../]
  [./elasticity_tensor2]
    type = ComputeElasticityTensor
    block = 1
    C_ijkl = '3 0.2'
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
  # petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type'
  # petsc_options_value = '70 hypre boomeramg'

  l_max_its = 30
  nl_max_its = 12

  l_tol = 1.0e-4

  nl_rel_tol = 1.0e-6
  nl_abs_tol = 1.0e-8

  start_time = 0.0
  num_steps = 2
  dt = 0.1
[]

[Outputs]
  exodus = true
  file_base = composite
[]

[Debug]
  show_var_residual_norms = true
[../]
