[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  volumetric_locking_correction = false
[]

# [Problem]
#   coord_type = RZ
# []

[Mesh]
  type = FileMesh
  file = 3D_cyl.e
[]

# [MeshModifiers]
#   [./bottom]
#     type = AddExtraNodeset
#     new_boundary = 100
#     coord = '0 0'
#   [../]
#   [./top]
#     type = AddExtraNodeset
#     new_boundary = 101
#     coord = '0 2.0'
#   [../]
#   [./center]
#     type = AddExtraNodeset
#     new_boundary = 102
#     coord = '0 1.0'
#   [../]
#   # [./corner]
#   #   type = AddExtraNodeset
#   #   new_boundary = 110
#   #   coord = '2.0 4.0'
#   # [../]
# []

[Functions]
  [./exponential1]
    type = ParsedFunction
    value = 'if(x>0, 0.01*exp(1-2/x), 0)'
  [../]
  [./exponential2]
    type = ParsedFunction
    value = '0.01*exp(-x/2)'
  [../]
[]

[AuxVariables]
  [./hydro]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./sxx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./szz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./exx]
    order = FIRST
    family = MONOMIAL
  [../]
  [./ezz]
    order = FIRST
    family = MONOMIAL
  [../]
  [./exx_total]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./ezz_total]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Modules]
  [./TensorMechanics]
    [./Master]
      [./all]
        add_variables = true
        strain = SMALL
        eigenstrain_names = 'eigenstrain'
      [../]
    [../]
  [../]
[]

[AuxKernels]
  [./hydro]
    type = RankTwoScalarAux
    variable = hydro
    rank_two_tensor = stress
    scalar_type = Hydrostatic
  [../]
  [./sxx]
    type = RankTwoAux
    variable = sxx
    rank_two_tensor = stress
    index_i = 0
    index_j = 0
  [../]
  [./szz]
    type = RankTwoAux
    variable = szz
    rank_two_tensor = stress
    index_i = 1
    index_j = 1
  [../]
  [./exx]
    type = RankTwoAux
    variable = exx
    rank_two_tensor = eigenstrain
    index_i = 0
    index_j = 0
  [../]
  [./ezz]
    type = RankTwoAux
    variable = ezz
    rank_two_tensor = eigenstrain
    index_i = 1
    index_j = 1
  [../]
  [./exx_total]
    type = RankTwoAux
    variable = exx_total
    rank_two_tensor = mechanical_strain
    index_i = 0
    index_j = 0
  [../]
  [./ezz_total]
    type = RankTwoAux
    variable = ezz_total
    rank_two_tensor = mechanical_strain
    index_i = 1
    index_j = 1
  [../]
[]

[BCs]
  [./no_x]
    type = PresetBC
    variable = disp_x
    boundary = 110
    value = 0.0
  [../]
  [./no_y]
    type = PresetBC
    variable = disp_y
    boundary = Bottom
    value = 0.0
  [../]
[]


[Materials]
  [./stress]
    type = ComputeLinearElasticStress
  [../]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 2000
    poissons_ratio = 0.3
  [../]
  [./reduced_order_eigenstrain]
    type = ComputeIncrementalEigenstrain
    eigenstrain_name = 'eigenstrain'
    eigenstrain_rate_functions = 'exponential1'
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
  solve_type = 'PJFNK'
  scheme = bdf2
  petsc_options_iname = '-pc_type -pc_asm_overlap -sub_pc_type -ksp_type -ksp_gmres_restart'
  petsc_options_value = ' asm      2              lu            gmres     200             '
  num_steps = 10
  nl_rel_tol = 1e-8
[]

[Postprocessors]
  [./dx_right_avg]
    type = SideAverageValue
    boundary = Outer
    variable = disp_x
  [../]
  [./dy_top_avg]
    type = SideAverageValue
    boundary = top
    variable = disp_y
  [../]
  [./dx_right]
    type = SideIntegralVariablePostprocessor
    boundary = Outer
    variable = disp_x
  [../]
  [./dy_top]
    type = SideIntegralVariablePostprocessor
    boundary = top
    variable = disp_y
  [../]
  [./dx_max]
    type = NodalMaxValue
    variable = disp_x
    # use_displaced_mesh = true
    # boundary = 110
  [../]
  [./dy_max]
    type = NodalMaxValue
    variable = disp_y
    # boundary = 110
  [../]
  [./ex_right]
    type = SideAverageValue
    boundary = Outer
    variable = exx_total
  [../]
  [./ez_top]
    type = SideAverageValue
    boundary = top
    variable = ezz_total
  [../]
  [./ex_max]
    type = ElementExtremeValue
    variable = exx_total

    # use_displaced_mesh = true
    # boundary = 110
  [../]
  [./ez_max]
    type = ElementExtremeValue
    variable = ezz_total
    # boundary = 110
  [../]
[]

[Outputs]
  exodus = true
  csv = true
  # file_base = exp1_test_22pd
  gnuplot = true
[]
