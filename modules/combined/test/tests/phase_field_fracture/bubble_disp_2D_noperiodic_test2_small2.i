[Mesh]
  [gmg]
    type = DistributedRectilinearMeshGenerator
    dim = 2
    nx = 150
    ny = 150
    # nz = 60
    xmin = -0.75
    xmax = 0.75
    ymin = -0.75
    ymax = 0.75
    # zmax = 1.5
    partition = square
  []
  [cnode]
    type = ExtraNodesetGenerator
    coord = '0.0 0.0 0.0'
    new_boundary = 100
    input = gmg
  []
[]

[Problem]
  type = ReferenceResidualProblem
  reference_vector = 'ref'
  extra_tag_vectors = 'ref'
[]

[GlobalParams]
  # op_num = 10
  # var_name_base = gr
  # int_width = 0.03
  displacements = 'disp_x disp_y'
[]

# [Variables]
#   [./global_strain]
#     order = THIRD
#     family = SCALAR
#   [../]
# []

[Modules]
  [./TensorMechanics]
    [./Master]
      [./mech]
        add_variables = true
        strain = SMALL
        incremental = false
        additional_generate_output = 'stress_yy stress_xy stress_xx '
                                     'strain_xx strain_xy strain_yy '
                                     'hydrostatic_stress mid_principal_stress min_principal_stress max_principal_stress'
        decomposition_method = EigenSolution
        # global_strain = global_strain
        save_in = 'force_x force_y'
        extra_vector_tags = 'ref'
      [../]
    [../]
    # [./GlobalStrain]
    #   [./global_strain]
    #     scalar_global_strain = global_strain
    #     applied_stress_tensor = '0 0 0 0 0 0'
    #     displacements = 'u_x u_y'
    #     auxiliary_displacements = 'disp_x disp_y'
    #     global_displacements = 'ug_x ug_y'
    #   [../]
    # [../]
  [../]
[]

[AuxVariables]
  [d]
  []
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./force_x]
  [../]
  [./force_y]
  [../]
  # [./force_z]
  # [../]
  [./c]
  [../]
  [./C1111]
    order = CONSTANT
    family = MONOMIAL
    block = 0
  [../]
  [./strain_yy]
    family = MONOMIAL
    order = CONSTANT
  [../]
  # [./disp_x]
  # [../]
  # [./disp_y]
  # [../]
  # [./disp_z]
  # [../]
[]

[ICs]
  [c]
    type = SmoothCircleIC
    variable = c
    x1 = 0.0
    y1 = 0.0
    # z1 = 0.75
    radius = 0.5
    invalue = 1.0
    outvalue = 0.0
    int_width = 0.03
  []
[]

[Functions]
 [./pressure]
   type = PiecewiseLinear
   x = '0 200'
   y = '0 200.0'
 [../]
[]

[AuxKernels]
  [./C1111]
    type = RankFourAux
    variable = C1111
    rank_four_tensor = elasticity_tensor
    index_l = 0
    index_j = 0
    index_k = 0
    index_i = 0
    execute_on = timestep_end
  [../]
[]

[Materials]
  [./pfbulkmat]
    type = GenericConstantMaterial
    prop_names = 'l visco'
    prop_values = '0.01 1e-3'
  [../]
  [pressure]
    type = GenericFunctionMaterial
    block = 0
    prop_names = fracture_pressure
    prop_values = pressure
    # factor = 1e-6
  []
  [pressure_void]
    type = ParsedMaterial
    f_name = pressure_void
    args = 'c'
    material_property_names = 'fracture_pressure'
    function = 'fracture_pressure * c'
    outputs = nemesis
  []
  [./gc]
    type = GenericConstantMaterial
    prop_names = gc_prop
    prop_values = '0.012'
  [../]
  [./define_mobility]
    type = ParsedMaterial
    material_property_names = 'gc_prop visco'
    f_name = L
    function = '1.0/(gc_prop * visco)'
  [../]
  [./define_kappa]
    type = ParsedMaterial
    material_property_names = 'gc_prop l'
    f_name = kappa_op
    function = 'gc_prop * l / 3.14159 * 2'
  [../]

  [./damage_stress]
    type = ComputeLinearElasticPFFractureStress
    c = d
    E_name = 'elastic_energy'
    D_name = 'degradation'
    F_name = 'local_fracture_energy'
    I_name = 'indicator_function'
    #decomposition_type = strain_vol_dev
    decomposition_type = none
    use_snes_vi_solver = true
    output_properties = 'hist'
    outputs = nemesis
  [../]
  [./indicator_function]
    type = DerivativeParsedMaterial
    f_name = indicator_function
    args = 'd'
    function = 'd*d'
    derivative_order = 2
  [../]
  [./degradation]
    type = DerivativeParsedMaterial
    f_name = degradation
    args = 'd'
    function = '((1.0-d)^2+eta)/((1.0-d)^2+d*(1-0.5*d)*(4/3.14159/l*E*gc_prop/sigma^2))'
    material_property_names = 'gc_prop l'
    constant_names       = 'E sigma eta'
    constant_expressions = '385000 130 1e-4'
    derivative_order = 2
  [../]
  [./fracture_energy]
    type = DerivativeParsedMaterial
    f_name = local_fracture_energy
    args = 'd'
    material_property_names = 'gc_prop l'
    function = 'gc_prop/l/3.14159*(2*d-d^2)'
    derivative_order = 2
  [../]
  [./fracture_driving_energy]
    type = DerivativeParsedMaterial
    args = 'c d'
    material_property_names = 'elastic_energy(d) local_fracture_energy(d)'
    function = '(1-c)*elastic_energy + local_fracture_energy'
    derivative_order = 2
    f_name = F
  [../]
  [./const_stress]
    type = ComputeExtraStressConstant
    block = 0
    extra_stress_tensor = '-1.0 -1.0 -1.0 0 0 0'
    prefactor = pressure_void
  [../]
  [elasticity_tensor]
    type = ComputeConcentrationDependentElasticityTensor
    block = 0
    c = c
    C1_ijkl = '3.85 0.23'
    C0_ijkl = '385000 0.23'
    fill_method1 = symmetric_isotropic_E_nu
    fill_method0 = symmetric_isotropic_E_nu
  []
[]

[BCs]
  [./yfix]
    type = DirichletBC
    variable = disp_y
    boundary = bottom
    value = 0
  [../]
  [./xfix]
    type = DirichletBC
    variable = disp_x
    boundary = left
    value = 0
  [../]
  # [./zfix]
  #   type = DirichletBC
  #   variable = disp_z
  #   boundary = back
  #   value = 0
  # [../]
  [./Pressure]
    [./coolantPressure]
      boundary = 'top right'
      factor = 0
      function = 1
    [../]
  [../]
[]

# [BCs]
#   [./Periodic]
#     [./all]
#       auto_direction = 'x y '
#       variable = 'u_x u_y'
#     [../]
#   [../]
#   [./yfix]
#     type = DirichletBC
#     variable = u_y
#     boundary = 100
#     value = 0
#   [../]
#   [./xfix]
#     type = DirichletBC
#     variable = u_x
#     boundary = 100
#     value = 0
#   [../]
# []

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm 31 preonly lu 1'
  # petsc_options_iname = '-pc_type -sub_pc_type -ksp_type -pc_asm_overlap -pc_factor_levels -pc_factor_shift_type -pc_factor_shift_amount'
  # petsc_options_value = 'asm ilu preonly  1  0 NONZERO 1e-10'
  # petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_factor_shift_type -pc_factor_shift_amount'
  # petsc_options_value = 'hypre    boomeramg      31 nonzero 1e-10'
  # petsc_options_iname = '-pc_type -ksp_type -snes_type -pc_factor_shift_type -pc_factor_shift_amount '
  # petsc_options_value = 'lu preonly  vinewtonrsls NONZERO 1e-10'
#  petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -snes_max_it -sub_pc_factor_shift_type -pc_asm_overlap -snes_type'
#  petsc_options_value = 'gmres asm lu 100 NONZERO 2 vinewtonrsls'
  nl_rel_tol = 1e-6  ##nonlinear relative tolerance
  nl_abs_tol = 1e-6
  l_max_its = 10   ##max linear iterations Previous:200
  nl_max_its = 20  ##max nonlinear iterations Previous:50
  start_time = 0
  line_search = 'none'
  end_time = 200
  num_steps = 1500
  dt = 1
  dtmin = 1e-15
  automatic_scaling = true
#  [./TimeStepper]
#    type = IterationAdaptiveDT
#    dt = 1
#    optimal_iterations = 10
#    iteration_window = 0
#    growth_factor = 1.2
#    cutback_factor = 0.5
#  [../]

  picard_max_its = 20
  picard_rel_tol = 1e-6
  picard_abs_tol = 1e-6
  accept_on_max_picard_iteration = true
[]

[Outputs]
  # [exodus]
  #   type = Exodus
  #   interval = 25
  #   execute_on = 'initial timestep_end'
  # []
  csv = true
  nemesis = true
#gnuplot = true
[]

[Debug]
  show_var_residual_norms = true
[]
