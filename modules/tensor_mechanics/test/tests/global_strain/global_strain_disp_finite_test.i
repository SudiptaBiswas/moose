[Mesh]
  [generated_mesh]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 10
    ny = 10
    nz = 10
    xmin = -0.5
    xmax = 0.5
    ymin = -0.5
    ymax = 0.5
    zmin = -0.5
    zmax = 0.5
  []
  [cnode]
    type = ExtraNodesetGenerator
    coord = '0 -0.5 0'
    new_boundary = 100
    input = generated_mesh
  []
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
  # [./global_strain]
  #   order = SIXTH
  #   family = SCALAR
  # [../]
[]

[AuxVariables]
  # [./disp_x]
  # [../]
  # [./disp_y]
  # [../]
  # [./disp_z]
  # [../]
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
  [./pe11]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./pe22]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./pe33]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./peeq]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  # [./disp_x]
  #   type = GlobalDisplacementAux
  #   variable = disp_x
  #   scalar_global_strain = global_strain
  #   global_strain_uo = global_strain_uo
  #   component = 0
  # [../]
  # [./disp_y]
  #   type = GlobalDisplacementAux
  #   variable = disp_y
  #   scalar_global_strain = global_strain
  #   global_strain_uo = global_strain_uo
  #   component = 1
  # [../]
  # [./disp_z]
  #   type = GlobalDisplacementAux
  #   variable = disp_z
  #   scalar_global_strain = global_strain
  #   global_strain_uo = global_strain_uo
  #   component = 2
  # [../]
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
  [./pe11]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = pe11
    index_i = 0
    index_j = 0
  [../]
    [./pe22]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = pe22
    index_i = 1
    index_j = 1
  [../]
  [./pe33]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = pe33
    index_i = 2
    index_j = 2
  [../]
  [./eqv_plastic_strain]
    type = MaterialRealAux
    property = eqv_plastic_strain
    variable = peeq
  [../]
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  block = 0
[]

[Kernels]
  [./TensorMechanics]
    use_displaced_mesh = true
  [../]
[]

# [ScalarKernels]
#   [./global_strain]
#     type = GlobalStrain
#     variable = global_strain
#     global_strain_uo = global_strain_uo
#   [../]
# []

[Functions]
  [./topfunc]
    type = ParsedFunction
    value = 't'
  [../]
[]

[BCs]
  # [./Periodic]
  #   [./all]
  #     auto_direction = 'z'
  #     variable = 'disp_x disp_y disp_z'
  #   [../]
  # [../]

  # fix center point location
  [./centerfix_x]
    type = DirichletBC
    boundary = 100
    variable = disp_x
    value = 0
  [../]
  [./fix_y]
    type = DirichletBC
    boundary = bottom
    variable = disp_y
    value = 0
  [../]
  [./centerfix_z]
    type = DirichletBC
    boundary = 100
    variable = disp_z
    value = 0
  [../]
  [./appl_y]
    type = FunctionDirichletBC
    boundary = top
    variable = disp_y
    function = topfunc
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    block = 0
    C_ijkl = '2.827e5 1.21e5 1.21e5 2.827e5 1.21e5 2.827e5 0.808e5 0.808e5 0.808e5'
    fill_method = symmetric9
  [../]
  [./strain]
    type = ComputeFiniteStrain
    # global_strain = global_strain
  [../]
  # [./global_strain]
  #   type = ComputeGlobalStrain
  #   scalar_global_strain = global_strain
  #   global_strain_uo = global_strain_uo
  # [../]
  # [./stress]
  #   type = ComputeLinearElasticStress
  # [../]
  [./fplastic]
    type = FiniteStrainPlasticMaterial
    block=0
    yield_stress='0. 445. 0.05 610. 0.1 680. 0.38 810. 0.95 920. 2. 950.'
  [../]
[]

# [UserObjects]
#   [./global_strain_uo]
#     type = GlobalStrainUserObject
#     execute_on = 'Initial Linear Nonlinear'
#   [../]
# []

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

  nl_rel_tol = 1.0e-6
  nl_abs_tol = 1.0e-10
  dt = 0.01
  # start_time = 0.0
  end_time = 1.0
[]

[Outputs]
  exodus = true
[]
