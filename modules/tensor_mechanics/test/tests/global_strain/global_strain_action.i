[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 2
  ny = 2
  nz = 2
  xmin = -0.5
  xmax = 0.5
  ymin = -0.5
  ymax = 0.5
  zmin = -0.5
  zmax = 0.5
[]

[MeshModifiers]
  [./cnode]
    type = AddExtraNodeset
    coord = '0 -0.5 0'
    new_boundary = 100
  [../]
[]

[GlobalParams]
  displacements = 'u_x u_y u_z'
  block = 0
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

[Modules]
  [./TensorMechanics]
    [./GlobalStrain]
      [./global_strain]
        scalar_global_strain = global_strain
        periodic_directions = 'z'
        displacements = 'u_x u_y u_z'
        auxiliary_displacements = 'disp_x disp_y disp_z'
      [../]
    [../]
  [../]
[]

[AuxVariables]
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

[Kernels]
  [./TensorMechanics]
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'z'
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
    boundary = bottom
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
    boundary = top
    variable = u_y
    value = 0.033
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    block = 0
    C_ijkl = '7 0.33'
    fill_method = symmetric_isotropic_E_nu
  [../]
  [./strain]
    type = ComputeSmallStrain
    global_strain = global_strain
  [../]
  [./stress]
    type = ComputeLinearElasticStress
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

  l_tol = 1.0e-4

  nl_rel_tol = 1.0e-6
  nl_abs_tol = 1.0e-10

  start_time = 0.0
  num_steps = 2
[]

[Outputs]
  exodus = true
[]
