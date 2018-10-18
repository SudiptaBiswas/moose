[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 40
  ny = 40
  xmin = -0.5
  xmax = 0.5
  ymin = -0.5
  ymax = 0.5
  # elem_type = QUAD9
[]

# [Mesh]
#   file = anisoLongFiber.e
# []

[MeshModifiers]
  [./cnode]
    type = AddExtraNodeset
    coord = '0 0'
    new_boundary = 100
  [../]
  [./subdomains]
    type = SubdomainBoundingBox
    bottom_left = '-0.25 -0.5 0'
    top_right = '0.25 0.5 0'
    block_id = 1
  [../]
  [./bnode]
    type = AddExtraNodeset
    coord = '0 -0.5'
    new_boundary = 110
  [../]
[]

[Variables]
  [./u_x]
    # scaling = 1e2
    # order = SECOND
    # family = HERMITE
  [../]
  [./u_y]
    # order = SECOND
    # family = HERMITE
  [../]
  [./global_strain]
    order = THIRD
    family = SCALAR
  [../]
[]

[AuxVariables]
  [./disp_x]
  [../]
  [./disp_y]
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
  [./s_von]
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
  [./s_von]
    type = RankTwoScalarAux
    variable = s_von
    scalar_type = VonMisesStress
    rank_two_tensor = stress
  [../]
[]

[GlobalParams]
  displacements = 'u_x u_y'
  block = '0 1'
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

  # [./Periodic]
  #   [./up_down]
  #     variable = u_x
  #     primary = bottom
  #     secondary = top
  #     translation = '0 1 0'
  #   [../]
  #   [./left_right]
  #     variable = u_y
  #     primary = left
  #     secondary = right
  #     translation = '1 0 0'
  #   [../]
  # [../]

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
  #   value = 0.02
  # [../]
[]

[Materials]
  [./elasticity_tensor1]
    type = ComputeElasticityTensor
    block = 0
    C_ijkl = '81.360117 26.848839 26.848839 81.360117 26.848839 81.360117 27.255639 27.255639 27.255639'
    # C_ijkl = '72.5 0.33'
    fill_method = symmetric9
  [../]
  [./elasticity_tensor2]
    type = ComputeElasticityTensor
    block = 1
    # C_ijkl = '400 0.2'
    C_ijkl = '416.66667 83.333333 83.333333 416.66667 83.333333 416.66667 166.66667 166.66667 166.66667'
    fill_method = symmetric9
  [../]
  [./strain]
    type = ComputeSmallStrain
    global_strain = global_strain
    eigenstrain_names = eigen
  [../]
  [./global_strain]
    type = ComputeGlobalStrain
    scalar_global_strain = global_strain
    global_strain_uo = global_strain_uo
  [../]
  [./stress]
    type = ComputeLinearElasticStress
  [../]
  [./strain_energy]
    type = StrainEnergyDensity
    incremental = false
  [../]
  [./eigen]
    type = ComputeEigenstrain
    eigenstrain_name = eigen
    eigen_base = '0.0 0.0 0.0 0.0 0.0 0.0'
  [../]
[]

[UserObjects]
  [./global_strain_uo]
    type = GlobalStrainUserObject2
    execute_on = 'Initial Linear Nonlinear'
    applied_strain_tensor = '0.0 0.01 0.0 0.0 0.0 0.00'
  [../]
[]

[Postprocessors]
  [./s00]
    type = SideAverageValue
    variable = s00
    boundary = left
  [../]
  [./s11]
    type = SideAverageValue
    variable = s11
    boundary = top
  [../]
  [./s01]
    type = SideAverageValue
    variable = s01
    boundary = left
  [../]
  [./s10]
    type = SideAverageValue
    variable = s10
    boundary = top
  [../]
  [./e00]
    type = SideAverageValue
    variable = e00
    boundary = left
  [../]
  [./e11]
    type = SideAverageValue
    variable = e11
    boundary = top
  [../]
  [./e01]
    type = SideAverageValue
    variable = e01
    boundary = left
  [../]
  [./e10]
    type = SideAverageValue
    variable = e10
    boundary = top
  [../]
  [./s00_avg]
    type = ElementAverageValue
    variable = s00
  [../]
  [./s11_avg]
    type = ElementAverageValue
    variable = s11
  [../]
  [./s01_avg]
    type = ElementAverageValue
    variable = s01
  [../]
  [./s10_avg]
    type = ElementAverageValue
    variable = s10
  [../]
  [./e00_avg]
    type = ElementAverageValue
    variable = e00
  [../]
  [./e11_avg]
    type = ElementAverageValue
    variable = e11
  [../]
  [./e01_avg]
    type = ElementAverageValue
    variable = e01
  [../]
  [./e10_avg]
    type = ElementAverageValue
    variable = e10
  [../]
  [./dispx_left]
    type = SideIntegralVariablePostprocessor
    variable = disp_x
    boundary = left
  [../]
  [./dispx_right]
    type = SideIntegralVariablePostprocessor
    variable = disp_x
    boundary = right
  [../]
  [./dispx_top]
    type = SideIntegralVariablePostprocessor
    variable = disp_x
    boundary = top
  [../]
  [./dispx_bottom]
    type = SideIntegralVariablePostprocessor
    variable = disp_x
    boundary = bottom
  [../]
  [./dispy_left]
    type = SideIntegralVariablePostprocessor
    variable = disp_y
    boundary = left
  [../]
  [./dispy_right]
    type = SideIntegralVariablePostprocessor
    variable = disp_y
    boundary = right
  [../]
  [./dispy_top]
    type = SideIntegralVariablePostprocessor
    variable = disp_y
    boundary = top
  [../]
  [./dispy_bottom]
    type = SideIntegralVariablePostprocessor
    variable = disp_y
    boundary = bottom
  [../]
  [./U]
    type = ElementIntegralMaterialProperty
    mat_prop = strain_energy_density
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
