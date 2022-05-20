[Mesh]
  [gmg]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 60
    ny = 60
    nz = 60
    xmax = 1.5
    ymax = 1.5
    zmax = 1.5
    uniform_refine = 2
    parallel_type = replicated
    # partition = square
  []
[]

[Adaptivity]
  initial_steps = 3
  max_h_level = 3
  # stop_time = 1.0e-10
  initial_marker = err_bnds
  [./Markers]
    [./err_bnds]
      type = ErrorFractionMarker
      coarsen = 0.1
      refine = 0.9
      indicator = ind_bnds
    [../]
  [../]
  [./Indicators]
     [./ind_bnds]
       type = GradientJumpIndicator
       variable = bnds
    [../]
  [../]
[]

[GlobalParams]
  op_num = 15
  var_name_base = gr
  displacements = 'u_x u_y u_z'
  int_width = 0.03
[]

[Variables]
  [./d]
  [../]
[]


[AuxVariables]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./force_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./force_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./force_z]
    order = FIRST
    family = LAGRANGE
  [../]
  [./bnds]
  [../]
  [./c]
    order = FIRST
    family = LAGRANGE
  [../]
  [./gr0]
  [../]
  [./gr1]
  [../]
  [./gr2]
  [../]
  [./gr3]
  [../]
  [./gr4]
  [../]
  [./gr5]
  [../]
  [./gr6]
  [../]
  [./gr7]
  [../]
  [./gr8]
  [../]
  [./gr10]
  [../]
  [./gr11]
  [../]
  [./gr12]
  [../]
  [./gr13]
  [../]
  [./gr14]
  [../]
  [./gr9]
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
  [./bounds_dummy]
    order = FIRST
    family = LAGRANGE
  [../]
  [./var_indices]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./unique_grains]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [halos]
    order = CONSTANT
    family = MONOMIAL
  []
  [global_strain]
    order = SIXTH
    family = SCALAR
  []
  [u_x]
  []
  [u_y]
  []
  [u_z]
  []
[]

[ICs]
  [c]
    type = SmoothCircleIC
    variable = c
    x1 = 0.75
    y1 = 0.75
    z1 = 0.75
    radius = 0.5
    invalue = 1.0
    outvalue = 0.0
    int_width = 0.03
  []
  [./PolycrystalICs]
    [./PolycrystalColoringIC]
      polycrystal_ic_uo = voronoi
    [../]
  [../]
  [bnds]
    type = BndsCalcIC
    variable = bnds
  []
[]

[Functions]
  [./pressure]
    type = PiecewiseLinear
    x = '0 150 200'
    y = '0 200 200'
  [../]
[]

[Bounds]
  [./d_upper_bound]
    type = ConstantBoundsAux
    variable = bounds_dummy
    bounded_variable = d
    bound_type = upper
    bound_value = 1.0
  [../]
  [./d_lower_bound]
    type = VariableOldValueBoundsAux
    variable = bounds_dummy
    bounded_variable = d
    bound_type = lower
  [../]
[]

[Kernels]
  [./pfbulk]
    type = AllenCahn
    variable = d
    mob_name = L
    f_name = F
  [../]
  [./dcdt]
    type = TimeDerivative
    variable = d
  [../]
  [./acint]
    type = ACInterface
    variable = d
    mob_name = L
    kappa_name = kappa_op
  [../]
[]

[AuxKernels]
  [./bnds_aux]
    type = BndsCalcAux
    variable = bnds
    execute_on = timestep_end
  [../]
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
  [unique_grains_calc]
    type = FeatureFloodCountAux
    variable = unique_grains
    flood_counter = grain_tracker
    field_display = UNIQUE_REGION
    execute_on = 'initial timestep_end'
  []
  [var_indices_calc]
    type = FeatureFloodCountAux
    variable = var_indices
    flood_counter = grain_tracker
    field_display = VARIABLE_COLORING
    execute_on = 'initial timestep_end'
  []
  [halos]
    type = FeatureFloodCountAux
    variable = halos
    flood_counter = grain_tracker
    field_display = HALOS
    execute_on = 'initial timestep_end'
  []
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
  # [./gc]
  #   type = GenericConstantMaterial
  #   prop_names = gc_prop
  #   prop_values = '0.0012'
  # [../]
  [./gc]
    type = ParsedMaterial
    f_name = gc_prop
    #function = 'if(bnds < 0.75, if(bnds>0.25, 0.5, 2.5), 2.5)'
    function = 'if(bnds < 0.75 & c < 0.5, 0.0012, 0.012)'
    args = 'bnds c'
    outputs = nemesis
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

  [./strain]
    type = ComputeSmallStrain
    global_strain = global_strain
  [../]
  [global_strain]
    type = ComputeGlobalStrain
    scalar_global_strain = global_strain
    global_strain_uo = global_strain_uo
  []
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
    # base_name = matrix
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
    base_name = void
    extra_stress_tensor = '-1 -1 -1 0 0 0'
    prefactor = fracture_pressure
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

[UserObjects]
  [global_strain_uo]
    type = GlobalStrainUserObject
    applied_stress_tensor = '0 0 0 0 0 0'
    execute_on = 'Initial Linear Nonlinear'
  []
  [voronoi]
    type = PolycrystalVoronoi
    rand_seed = 486
    # grain_num = 50
    # file_name = 3d_fracture_grains100.txt
    file_name = 3d_fracture_domain1p5_grains30.txt
    # coloring_algorithm = jp
  []
  [grain_tracker]
    type = GrainTracker
    compute_var_to_feature_map = true
    execute_on = 'initial timestep_begin'
    halo_level = 3
    remap_grains = false
    compute_halo_maps = true
  []
[]

[Postprocessors]
  [./ave_stress_top]
    type = SideAverageValue
    variable = stress_yy
    boundary = top
  [../]
  [./disp_y_top]
    type = SideAverageValue
    variable = u_y
    boundary = top
  [../]
  [./react_y_top]
    type = NodalSum
    variable = force_y
    boundary = top
  [../]
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -ksp_type -snes_type -pc_factor_shift_type -pc_factor_shift_amount '
  petsc_options_value = 'ilu preonly  vinewtonrsls NONZERO 1e-10'

#  solve_type = PJFNK
 # petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_factor_shift_type'
 # petsc_options_value = 'hypre    boomeramg      31 nonzero'
 # petsc_options_iname = '-pc_type -sub_pc_type -ksp_type -snes_type -pc_asm_overlap -pc_factor_levels -pc_factor_shift_type -pc_factor_shift_amount'
 # petsc_options_value = 'asm ilu preonly vinewtonrsls 1  0 NONZERO 1e-10'
  nl_rel_tol = 1e-6  ##nonlinear relative tolerance
  nl_abs_tol = 1e-6
  l_max_its = 10   ##max linear iterations Previous:200
  nl_max_its = 20  ##max nonlinear iterations Previous:50
  start_time=0
  line_search = 'none'
  end_time = 2000
  dtmax = 1
  dtmin = 1e-14
  automatic_scaling = true
#  [./TimeStepper]
#    type = IterationAdaptiveDT
#    dt = 1
#    optimal_iterations = 10
#    iteration_window = 0
#    growth_factor = 1.2
#    cutback_factor = 0.5
#  [../]
[]

[Outputs]
  print_linear_converged_reason = true
  print_nonlinear_converged_reason = true
  print_linear_residuals = true
  nemesis = true
  csv = true
#gnuplot = true
[]
