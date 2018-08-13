[GlobalParams]
  displacements = 'disp_x disp_y'
  volumetric_locking_correction = false
[]

[Problem]
  coord_type = RZ
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 20
  ny = 10
  xmax = 2
  xmin = 0
  ymax = 1
  ymin = 0
[]

[MeshModifiers]
  [./center]
    type = AddExtraNodeset
    new_boundary = 100
    coord = '0 0'
  [../]
  [./bottom]
    type = AddExtraNodeset
    new_boundary = 101
    coord = '0 1.0'
  [../]
[]

[Functions]
  [./exponential]
    type = ParsedFunction
    value = '0.01*exp(1-2/abs(x))'
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
        incremental = true
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
    type = DirichletBC
    variable = disp_x
    boundary = '100 101'
    value = 0.0
  [../]
  [./no_y]
    type = DirichletBC
    variable = disp_y
    boundary = '100'
    value = 0.0
  [../]
[]


[Materials]
  [./stress]
    type = ComputeFiniteStrainElasticStress
  [../]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1
    poissons_ratio = 0
  [../]
  [./reduced_order_eigenstrain]
    type = ComputeIncrementalEigenstrain
    eigenstrain_name = 'eigenstrain'
    eigenstrain_rate_functions = 'exponential'
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
  [./_dt]
    type = TimestepSize
  [../]
[]

[Outputs]
  exodus = true
  csv = true
  file_base = eigenstrain_increment_rz_test
[]
