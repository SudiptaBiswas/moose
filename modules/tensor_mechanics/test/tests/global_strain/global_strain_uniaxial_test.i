[Mesh]
  [generated_mesh]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 2
    ny = 2
    nz = 2
  []
  [cnode]
    type = ExtraNodesetGenerator
    coord = '0.0 0.0 0.0'
    new_boundary = 100
    input = generated_mesh
  []
[]

[Variables]
  [./u_x]
  [../]
  [./u_y]
  [../]
  [./u_z]
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
  [./s22]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./s01]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./s02]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./s12]
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
  [./e22]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./e01]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./e02]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./e12]
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
  [./s22]
    type = RankTwoAux
    variable = s22
    rank_two_tensor = stress
    index_i = 2
    index_j = 2
  [../]
  [./s01]
    type = RankTwoAux
    variable = s01
    rank_two_tensor = stress
    index_i = 0
    index_j = 1
  [../]
  [./s02]
    type = RankTwoAux
    variable = s02
    rank_two_tensor = stress
    index_i = 0
    index_j = 2
  [../]
  [./s12]
    type = RankTwoAux
    variable = s12
    rank_two_tensor = stress
    index_i = 1
    index_j = 2
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
  [./e22]
    type = RankTwoAux
    variable = e22
    rank_two_tensor = total_strain
    index_i = 2
    index_j = 2
  [../]
  [./e01]
    type = RankTwoAux
    variable = e01
    rank_two_tensor = total_strain
    index_i = 0
    index_j = 1
  [../]
  [./e02]
    type = RankTwoAux
    variable = e02
    rank_two_tensor = total_strain
    index_i = 0
    index_j = 2
  [../]
  [./e12]
    type = RankTwoAux
    variable = e12
    rank_two_tensor = total_strain
    index_i = 1
    index_j = 2
  [../]
[]

[GlobalParams]
  displacements = 'u_x u_y u_z'
  block = 0
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
      auto_direction = 'x y z'
      variable = ' u_x u_y u_z'
    [../]
  [../]

  # fix center point location
  [./centerfix_x]
    type = DirichletBC
    boundary = 100
    variable = u_x
    value = 0
  [../]
  [./centerfix_y]
    type = DirichletBC
    boundary = 100
    variable = u_y
    value = 0
  [../]
  [./centerfix_z]
    type = DirichletBC
    boundary = 100
    variable = u_z
    value = 0
  [../]
  # [./appl_y]
  #   type = DirichletBC
  #   boundary = top
  #   variable = u_y
  #   value = 0.033
  # [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    block = 0
    C_ijkl = '70e9 0.33'
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
    type = GlobalStrainUserObject2
    # applied_stress_tensor = '5e9 0 0 0 0 0'
    # applied_stress_tensor = '7.4085e9 3.6489e9 3.6489e9 0 0 0'
    # applied_strain_tensor = '0.07142857 -0.023571428 -0.023571428 0 0 0'
    applied_strain_tensor = '0.001 0.0 0.0 0 0 0'
    execute_on = 'Initial Linear Nonlinear'
  [../]
[]

[Postprocessors]
  [./l2err_e00]
    type = ElementL2Error
    variable = e00
    function = 0.001 #strain_xx = C1111/sigma_xx
  [../]
  [./l2err_e11]
    type = ElementL2Error
    variable = e11
    function = 0 #strain_yy = -nu*strain_xx
  [../]
  [./l2err_s00]
    type = ElementL2Error
    variable = s00
    function = 1.037151703e8 #strain_xx = C1111/sigma_xx
  [../]
  [./l2err_s11]
    type = ElementL2Error
    variable = s11
    function = 0.5108359133e8 #strain_yy = -nu*strain_xx
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

  line_search = basic

  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'

  l_max_its = 30
  nl_max_its = 12

  nl_rel_tol = 1.0e-10

  start_time = 0.0
  num_steps = 1
[]

[Outputs]
  exodus = true
  file_base = global_strain_uniaxial_test2
[]
