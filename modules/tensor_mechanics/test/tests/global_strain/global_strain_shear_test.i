[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 1
  ny = 1
  # nz = 1
[]

[MeshModifiers]
  [./cnode]
    type = AddExtraNodeset
    coord = '0.0 0.0'
    new_boundary = 100
  [../]
  [./enode]
    type = AddExtraNodeset
    coord = '1.0 0.0'
    new_boundary = 110
  [../]
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  # [./u_z]
  # [../]
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
  [./s01]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./e01]
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
  #   component = 1
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
  [./s01]
    type = RankTwoAux
    variable = s01
    rank_two_tensor = stress
    index_i = 0
    index_j = 1
  [../]
  [./e01]
    type = RankTwoAux
    variable = e01
    rank_two_tensor = total_strain
    index_i = 0
    index_j = 1
  [../]
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
  block = 0
[]

[Kernels]
  [./TensorMechanics]
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
  [./Periodic]
    [./x]
      auto_direction = 'x'
      variable = ' disp_x'
    [../]
    [./y]
      auto_direction = 'y'
      variable = ' disp_y'
    [../]
  [../]

  # fix center point location
  [./centerfix_x]
    type = PresetBC
    boundary = 100
    variable = disp_x
    value = 0
  [../]
  [./centerfix_y]
    type = PresetBC
    boundary = 100
    variable = disp_y
    value = 0
  [../]
  [./fix_y]
    type = PresetBC
    boundary = 110
    variable = disp_y
    value = 0
  [../]
  [./centerfix_z]
    type = PresetBC
    boundary = top
    variable = disp_x
    value = 0.01
  [../]
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
[]

# [UserObjects]
#   [./global_strain_uo]
#     type = GlobalStrainUserObject
    # applied_stress_tensor = '0 0 0 5e9 5e9 5e9'
#     execute_on = 'Initial Linear Nonlinear'
#   [../]
# []

[Postprocessors]
  [./l2err_e01]
    type = ElementL2Error
    variable = e01
    function = 0.095 #Shear strain check
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

  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1.0e-10

  start_time = 0.0
  num_steps = 2
[]

[Outputs]
  exodus = true
[]
