#
# Example 1
# Illustrating the coupling between chemical and mechanical (elastic) driving forces.
# An oversized precipitate deforms under a uniaxial compressive stress
# Check the file below for comments and suggestions for parameter modifications.
#

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 20
  ny = 20
  # nz = 20
  xmin = -20
  xmax = 20
  ymin = -20
  ymax = 20
  # zmin = -20
  # zmax = 20
  # elem_type = HEX8
  uniform_refine = 3
[]

[MeshModifiers]
  [./cnode]
    type = AddExtraNodeset
    coord = '0 0'
    new_boundary = 100
  [../]
  [./cnode2]
    type = AddExtraNodeset
    coord = '-20.0 0.0'
    new_boundary = 101
  [../]
  # [./cnode3]
  #   type = AddExtraNodeset
  #   coord = '0.0 0.0 -20.0'
  #   new_boundary = 102
  # [../]
[]

[GlobalParams]
  displacements = 'u_x u_y'
  block = 0
[]

[Variables]
  [./c]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      type = SmoothCircleIC
      x1 = 0
      y1 = 0
      radius = 5.0
      invalue = 1.0
      outvalue = 0.1
      int_width = 1.0
    [../]
  [../]
  [./w]
    order = FIRST
    family = LAGRANGE
  [../]
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
        eigenstrain_names = 'eigenstrain'
        global_strain = global_strain #global strain contribution
        generate_output = 'strain_xx strain_xy strain_yy stress_xx stress_xy
                           stress_yy vonmises_stress'
      [../]
    [../]
    [./GlobalStrain]
      [./global_strain]
        scalar_global_strain = global_strain
        displacements = 'u_x u_y'
        auxiliary_displacements = 'disp_x disp_y'
      [../]
    [../]
  [../]
[]

[Kernels]
  [./c_res]
    type = SplitCHParsed
    variable = c
    f_name = F
    kappa_name = kappa_c
    w = w
  [../]
  [./w_res]
    type = SplitCHWRes
    variable = w
    mob_name = M
  [../]
  [./time]
    type = CoupledTimeDerivative
    variable = w
    v = c
  [../]
[]

[Materials]
  [./pfmobility]
    type = GenericConstantMaterial
    prop_names  = 'M kappa_c'
    prop_values = '0.001 0.1'
    block = 0
    #kappa = 0.1
    #mob = 1e-3
  [../]

  # simple chemical free energy with a miscibility gap
  [./chemical_free_energy]
    type = DerivativeParsedMaterial
    block = 0
    f_name = Fc
    args = 'c'
    constant_names       = 'barr_height  cv_eq'
    constant_expressions = '0.1          1.0e-2'
    function = 16*barr_height*(c-cv_eq)^2*(1-cv_eq-c)^2
    enable_jit = true
    derivative_order = 2
    outputs = exodus
  [../]

  # undersized solute (voidlike)
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    block = 0
    # lambda, mu values
    C_ijkl = '10 10'
    # Stiffness tensor is created from lambda=7, mu=7 using symmetric_isotropic fill method
    fill_method = symmetric_isotropic
    # See RankFourTensor.h for details on fill methods
    # '15 15' results in a high stiffness (the elastic free energy will dominate)
    # '7 7' results in a low stiffness (the chemical free energy will dominate)
  [../]
  [./stress]
    type = ComputeLinearElasticStress
    block = 0
  [../]
  [./var_dependence]
    type = DerivativeParsedMaterial
    block = 0
    # eigenstrain coefficient
    # -0.1 will result in an undersized precipitate
    #  0.1 will result in an oversized precipitate
    function = -0.2*c^2
    # function = c
    args = c
    f_name = var_dep
    enable_jit = true
    derivative_order = 2
  [../]
  [./eigenstrain]
    type = ComputeVariableEigenstrain
    block = 0
    eigen_base = '1 1 0 0 0 0.5'
    prefactor = var_dep
    #outputs = exodus
    args = 'c'
    eigenstrain_name = eigenstrain
  [../]
  [./elastic_free_energy]
    type = ElasticEnergyMaterial
    f_name = Fe
    block = 0
    args = 'c'
    derivative_order = 2
    outputs = exodus
  [../]

  # Sum up chemical and elastic contributions
  [./free_energy]
    type = DerivativeSumMaterial
    block = 0
    f_name = F
    sum_materials = 'Fc Fe'
    args = 'c'
    derivative_order = 2
    outputs = exodus
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y'
      variable = 'c u_x u_y'
    [../]
  [../]
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
  # [./centerfix_z]
  #   type = PresetBC
  #   boundary = 100
  #   variable = disp_z
  #   value = 0
  # [../]
  # [./appl_y]
  #   type = PresetBC
  #   boundary = top
  #   variable = disp_y
  #   value = 0.033
  # [../]
  # [./fix_x]
  #   type = PresetBC
  #   boundary = 102
  #   variable = disp_x
  #   value = 0
  # [../]
  # [./fix_zz]
  #   type = PresetBC
  #   boundary = 101
  #   variable = disp_y
  #   value = 0
  # [../]
[]

[Preconditioning]
  # active = ' '
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  scheme = bdf2

  solve_type = 'PJFNK'
  # petsc_options_iname = '-pc_type  -sub_pc_type '
  # petsc_options_value = 'asm       lu'

  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'

  l_max_its = 30
  nl_max_its = 10
  l_tol = 1.0e-4
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1.0e-10
  start_time = 0.0
  num_steps = 100
  [./TimeStepper]
   type = IterationAdaptiveDT
   dt = 0.1
   growth_factor = 1.5
  [../]
[]

# [Adaptivity]
#  initial_steps = 3
#  max_h_level = 3
#  marker = EFM
# [./Markers]
#    [./EFM]
#      type = ErrorFractionMarker
#      coarsen = 0.2
#      refine = 0.8
#      indicator = GJI
#    [../]
#  [../]
#  [./Indicators]
#    [./GJI]
#      type = GradientJumpIndicator
#      variable = c
#     [../]
#  [../]
# []

[Outputs]
  exodus = true
  file_base = VoidGrowth_elasticity_undersize_global2
[]
