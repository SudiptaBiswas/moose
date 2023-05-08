# input file for bubble groeth and pressure build up in HbS structure
# For model parameterization, time scale = 1 sec, length scale  = 1 nm, energy density scale = 1 eV/nm^3, int_width = 10 nm
# domain size is scaled for reducing computational cost
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 60
  ny = 24
  xmin = 0
  xmax = 1500
  ymin = -300
  ymax = 300
  uniform_refine = 3
[]

[GlobalParams]
  op_num = 15
  grain_num = 120
  var_name_base = eta
  # numbub = 1
  # bubspac = 600
  # radius = 100.0
  int_width = 20.0
  polycrystal_ic_uo = voronoi
[]

[Variables]
  [PolycrystalVariables]
  []
  # [w]
  # []
  # [wg]
  # []
  [etab]
  []
[]

[ICs]
  [PolycrystalICs]
    [PolycrystalColoringIC]
      polycrystal_ic_uo = voronoi
    []
  []
  [bnds]
    type = BndsCalcIC
    variable = bnds
    op_num = 15
  []
  # [etab]
  #   type = m
  #   variable = bnds
  #   op_num = 15
  # []
[]

[AuxVariables]
  [bnds]
    order = FIRST
    family = LAGRANGE
  []
  [unique_grains]
    order = CONSTANT
    family = MONOMIAL
  []
  [var_indices]
    order = CONSTANT
    family = MONOMIAL
  []
  [halos]
    order = CONSTANT
    family = MONOMIAL
  []
  [temp]
    order = FIRST
    family = MONOMIAL
  []
[]

[Kernels]
  #order parameter etab for bubbles
  [ACb_bulk]
    type = ACGrGrMulti
    variable = etab
    v = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmb  gmb  gmb   gmb gmb  gmb  gmb  gmb  gmb  gmb    gmb   gmb  gmb   gmb '
    mob_name = L
  []
  # [ACb_sw]
  #   type = ACSwitching
  #   variable = etab
  #   Fj_names = 'omegab  omegam'
  #   hj_names = 'hb      hm'
  #   args = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  #   mob_name = L
  # []
  [ACb_int]
    type = ACInterface
    variable = etab
    kappa_name = kappa
    mob_name = L
  []
  [eb_dot]
    type = TimeDerivative
    variable = etab
  []
  # Order parameter eta0 for matrix grain 0
  [ACm0_bulk]
    type = ACGrGrMulti
    variable = eta0
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm   gmm   gmm    gmm'
  []
  # [ACm0_sw]
  #   type = ACSwitching
  #   variable = eta0
  #   Fj_names = 'omegab   omegam'
  #   hj_names = 'hb       hm'
  #   args = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  # []
  [ACm0_int]
    type = ACInterface
    variable = eta0
    kappa_name = kappa
  []
  [em0_dot]
    type = TimeDerivative
    variable = eta0
  []
  # Order parameter eta1 for matrix grain 1
  [ACm1_bulk]
    type = ACGrGrMulti
    variable = eta1
    v = 'etab eta0 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm   gmm   gmm   gmm '
  []
  # [ACm1_sw]
  #   type = ACSwitching
  #   variable = eta1
  #   Fj_names = 'omegab   omegam'
  #   hj_names = 'hb       hm'
  #   args = 'etab eta0 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  # []
  [ACm1_int]
    type = ACInterface
    variable = eta1
    kappa_name = kappa
  []
  [em1_dot]
    type = TimeDerivative
    variable = eta1
  []
  # Order parameter eta2 for matrix grain 2
  [ACm2_bulk]
    type = ACGrGrMulti
    variable = eta2
    v = 'etab eta1 eta0 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm    gmm  gmm   gmm'
  []
  # [ACm2_sw]
  #   type = ACSwitching
  #   variable = eta2
  #   Fj_names = 'omegab   omegam'
  #   hj_names = 'hb       hm'
  #   args = 'etab eta1 eta0 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  # []
  [ACm2_int]
    type = ACInterface
    variable = eta2
    kappa_name = kappa
  []
  [em2_dot]
    type = TimeDerivative
    variable = eta2
  []
  # Order parameter eta3 for matrix grain 3
  [ACm3_bulk]
    type = ACGrGrMulti
    variable = eta3
    v = 'etab eta1 eta2 eta0 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm    gmm    gmm gmm'
  []
  # [ACm3_sw]
  #   type = ACSwitching
  #   variable = eta3
  #   Fj_names = 'omegab   omegam'
  #   hj_names = 'hb       hm'
  #   args = 'etab eta1 eta2 eta0 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  # []
  [ACm3_int]
    type = ACInterface
    variable = eta3
    kappa_name = kappa
  []
  [em3_dot]
    type = TimeDerivative
    variable = eta3
  []
  # Order parameter eta4 for matrix grain 4
  [ACm4_bulk]
    type = ACGrGrMulti
    variable = eta4
    v = 'etab eta1 eta2 eta3 eta0 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm    gmm   gmm   gmm'
  []
  # [ACm4_sw]
  #   type = ACSwitching
  #   variable = eta4
  #   Fj_names = 'omegab   omegam'
  #   hj_names = 'hb       hm'
  #   args = 'etab eta1 eta2 eta3 eta0 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  # []
  [ACm4_int]
    type = ACInterface
    variable = eta4
    kappa_name = kappa
  []
  [em4_dot]
    type = TimeDerivative
    variable = eta4
  []
  # Order parameter eta5 for matrix grain 5
  [ACm5_bulk]
    type = ACGrGrMulti
    variable = eta5
    v = 'etab eta1 eta2 eta3 eta4 eta0 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm   gmm  gmm   gmm '
  []
  # [ACm5_sw]
  #   type = ACSwitching
  #   variable = eta5
  #   Fj_names = 'omegab   omegam'
  #   hj_names = 'hb       hm'
  #   args = 'etab eta1 eta2 eta3 eta4 eta0 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  # []
  [ACm5_int]
    type = ACInterface
    variable = eta5
    kappa_name = kappa
  []
  [em5_dot]
    type = TimeDerivative
    variable = eta5
  []
  # Order parameter eta6 for matrix grain 6
  [ACm6_bulk]
    type = ACGrGrMulti
    variable = eta6
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta0 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm    gmm   gmm   gmm '
  []
  # [ACm6_sw]
  #   type = ACSwitching
  #   variable = eta6
  #   Fj_names = 'omegab   omegam'
  #   hj_names = 'hb       hm'
  #   args = 'etab eta1 eta2 eta3 eta4 eta5 eta0 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  # []
  [ACm6_int]
    type = ACInterface
    variable = eta6
    kappa_name = kappa
  []
  [em6_dot]
    type = TimeDerivative
    variable = eta6
  []
  # Order parameter eta7 for matrix grain 7
  [ACm7_bulk]
    type = ACGrGrMulti
    variable = eta7
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta0 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm    gmm   gmm   gmm'
  []
  # [ACm7_sw]
  #   type = ACSwitching
  #   variable = eta7
  #   Fj_names = 'omegab   omegam'
  #   hj_names = 'hb       hm'
  #   args = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta0 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  # []
  [ACm7_int]
    type = ACInterface
    variable = eta7
    kappa_name = kappa
  []
  [em7_dot]
    type = TimeDerivative
    variable = eta7
  []
  # Order parameter eta8 for matrix grain 8
  [ACm8_bulk]
    type = ACGrGrMulti
    variable = eta8
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta0 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm    gmm  gmm   gmm'
  []
  # [ACm8_sw]
  #   type = ACSwitching
  #   variable = eta8
  #   Fj_names = 'omegab   omegam'
  #   hj_names = 'hb       hm'
  #   args = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta0 eta9 eta10 eta11 eta12 eta13 eta14'
  # []
  [ACm8_int]
    type = ACInterface
    variable = eta8
    kappa_name = kappa
  []
  [em8_dot]
    type = TimeDerivative
    variable = eta8
  []
  # Order parameter eta9 for matrix grain 9
  [ACm9_bulk]
    type = ACGrGrMulti
    variable = eta9
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta0 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm   gmm   gmm    gmm'
  []
  # [ACm9_sw]
  #   type = ACSwitching
  #   variable = eta9
  #   Fj_names = 'omegab   omegam'
  #   hj_names = 'hb       hm'
  #   args = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta0 eta10 eta11 eta12 eta13 eta14'
  # []
  [ACm9_int]
    type = ACInterface
    variable = eta9
    kappa_name = kappa
  []
  [em9_dot]
    type = TimeDerivative
    variable = eta9
  []
  # Order parameter eta10 for matrix grain 10
  [ACm10_bulk]
    type = ACGrGrMulti
    variable = eta10
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta0 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm  gmm   gmm    gmm '
  []
  # [ACm10_sw]
  #   type = ACSwitching
  #   variable = eta10
  #   Fj_names = 'omegab   omegam'
  #   hj_names = 'hb       hm'
  #   args = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta0 eta11 eta12 eta13 eta14'
  # []
  [ACm10_int]
    type = ACInterface
    variable = eta10
    kappa_name = kappa
  []
  [em10_dot]
    type = TimeDerivative
    variable = eta10
  []
  # Order parameter eta11 for matrix grain 11
  [ACm11_bulk]
    type = ACGrGrMulti
    variable = eta11
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta0 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm  gmm   gmm    gmm'
  []
  # [ACm11_sw]
  #   type = ACSwitching
  #   variable = eta11
  #   Fj_names = 'omegab   omegam'
  #   hj_names = 'hb       hm'
  #   args = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta0 eta12 eta13 eta14'
  # []
  [ACm11_int]
    type = ACInterface
    variable = eta11
    kappa_name = kappa
  []
  [em11_dot]
    type = TimeDerivative
    variable = eta11
  []
  # Order parameter eta12 for matrix grain 12
  [ACm12_bulk]
    type = ACGrGrMulti
    variable = eta12
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta0 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm  gmm   gmm    gmm'
  []
  # [ACm12_sw]
  #   type = ACSwitching
  #   variable = eta12
  #   Fj_names = 'omegab   omegam'
  #   hj_names = 'hb       hm'
  #   args = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta0 eta13 eta14'
  # []
  [ACm12_int]
    type = ACInterface
    variable = eta12
    kappa_name = kappa
  []
  [em12_dot]
    type = TimeDerivative
    variable = eta12
  []
  # Order parameter eta13 for matrix grain 13
  [ACm13_bulk]
    type = ACGrGrMulti
    variable = eta13
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta0 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm  gmm   gmm    gmm'
  []
  # [ACm13_sw]
  #   type = ACSwitching
  #   variable = eta13
  #   Fj_names = 'omegab   omegam'
  #   hj_names = 'hb       hm'
  #   args = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta0 eta14'
  # []
  [ACm13_int]
    type = ACInterface
    variable = eta13
    kappa_name = kappa
  []
  [em13_dot]
    type = TimeDerivative
    variable = eta13
  []
  # Order parameter eta14 for matrix grain 14
  [ACm14_bulk]
    type = ACGrGrMulti
    variable = eta14
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta0'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm  gmm   gmm    gmm'
  []
  # [ACm14_sw]
  #   type = ACSwitching
  #   variable = eta14
  #   Fj_names = 'omegab   omegam'
  #   hj_names = 'hb       hm'
  #   args = 'w wg etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta0'
  # []
  [ACm14_int]
    type = ACInterface
    variable = eta14
    kappa_name = kappa
  []
  [em14_dot]
    type = TimeDerivative
    variable = eta14
  []
[]

[AuxKernels]
  [BndsCalc]
    type = BndsCalcAux
    variable = bnds
    op_num = 15
    execute_on = 'timestep_end'
  []
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
  [temp]
    type = ADMaterialRealAux
    variable = temp
    property = temp_source
  []
[]

[Materials]
  [hm]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hm
    all_etas = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14 etab'
    phase_etas = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    outputs = exodus
    output_properties = 'hm'
  []
  [hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14 etab'
    phase_etas = 'etab'
    outputs = exodus
    output_properties = 'hb'
  []

  [constants]
    type = GenericConstantMaterial
    prop_names = 'kappa   mu      Va        cb_eq  cgb_eq    kb        gmb    gmm    T  f0     kB      burg_vec  G_mod YXe Dg Dv'
    prop_values = '70.2   5.62    0.04092   0.562  0.438    245.0     1.5	  1.5   1200  5.31579 8.6173324e-5   0.5      400.0 0.2156 0.0175 16.5'
  []

  # [f0_test]
  #   type = ParsedMaterial
  #   f_name = f0_test
  #   material_property_names = 'T'
  #   function = '0.0049*T-0.5799'
  #   outputs = exodus
  # []
  [heat]
    type = ADHeatConductionMaterial
    specific_heat = 500
    thermal_conductivity = 20e-2
  []
  [density]
    type = ADGenericConstantMaterial
    prop_names = 'density'
    prop_values = '8000e-12'
  []
  [meltpool]
    type = ADRosenthalTemperatureSource
    power = 100000
    velocity = 5.0
    absorptivity = 1.0
    melting_temperature = 1700
    ambient_temperature = 300
  []
  [gb_mob]
    type = ParsedMaterial
    property_name = M
    material_property_names = 'kB'
    coupled_variables = temp
    constant_names = 'Q M0'
    constant_expressions = '0.23 2.5e-6'
    function = 'exp(-Q/kB/temp)'
    outputs = exodus
  []
  [mob]
    type = ParsedMaterial
    property_name = L
    coupled_variables = temp
    material_property_names = 'M phase'
    # expression = M*phase
    expression = 'if(temp<1700,M,0.0)'
    outputs = exodus
  []
  [phasemap]
    type = ParsedMaterial
    property_name = phase
    coupled_variables = 'temp'
    expression = 'if(temp<1700,1,0)'
    outputs = exodus
  []
[]

[Postprocessors]
  [DOFs_NL]
    type = NumDOFs
    execute_on = 'initial timestep_end'
    system = NL
  []
  [DOFs_total]
    type = NumDOFs
    execute_on = 'initial timestep_end'
  []
  [dt]
    type = TimestepSize
  []
  [memory]
    type = MemoryUsage
  []
  [ngrains]
    type = FeatureFloodCount
    variable = bnds
    threshold = 0.7
  []
  [num_grains]
    type = FeatureFloodCount
    variable = unique_grains
  []
  [area]
    type = GrainBoundaryArea
    grains_per_side = 2
  []
  [area_bubble]
    type = GrainBoundaryArea
    grains_per_side = 1
  []
  [feature_counter]
    type = FeatureFloodCount
    variable = etab
    threshold = 0.5
    compute_var_to_feature_map = true
    execute_on = 'initial timestep_end'
  []
  # [porosity]
  #   type = Porosity
  #   variable = etab
  # []
[]

[UserObjects]
  [voronoi]
    type = PolycrystalVoronoi
    rand_seed = 123
    # file_name = grains100.txt
  []
  [grain_tracker]
    type = GrainTracker
    compute_var_to_feature_map = true
    execute_on = 'initial timestep_begin'
    halo_level = 3
    remap_grains = true
  []
[]

[BCs]
  [Periodic]
    [all]
      auto_direction = 'x y'
    []
  []
[]

[Adaptivity]
  initial_steps = 3
  max_h_level = 3
  marker = err
  [Markers]
    [err_bnds]
      type = ErrorFractionMarker
      coarsen = 0.01
      refine = 0.8
      indicator = ind_bnds
    []
    [err_b]
      type = ErrorFractionMarker
      coarsen = 0.01
      refine = 0.8
      indicator = ind_b
    []
    [err]
      type = ComboMarker
      markers = 'err_bnds err_b'
    []
  []
  [Indicators]
    [ind_bnds]
      type = GradientJumpIndicator
      variable = bnds
    []
    [ind_b]
      type = GradientJumpIndicator
      variable = etab
    []
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  scheme = 'BDF2'
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap  -pc_factor_shift_type -pc_factor_shift_amount'
  petsc_options_value = 'asm         31   preonly   ilu      1  NONZERO 1e-8'
  # petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_factor_shift_type'
  # petsc_options_value = 'hypre    boomeramg      31 nonzero'
  # petsc_options_iname = '-pc_type -ksp_type -ksp_gmres_restart'
  # petsc_options_value = 'bjacobi  gmres     30'
  petsc_options = '-ksp_converged_reason -snes_converged_reason'
  automatic_scaling = true
  l_tol = 1.0e-3
  l_max_its = 20
  nl_max_its = 12
  nl_rel_tol = 1.0e-6
  nl_abs_tol = 1.0e-8
  # num_steps = 2

  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1.0 #s
    cutback_factor = 0.85
    growth_factor = 1.2
    optimal_iterations = 6
    iteration_window = 1
  []

  dtmax = 800000
  end_time = 250
[]

[Outputs]
  csv = true
  perf_graph = true
  checkpoint = true

  [console]
    type = Console
    max_rows = 10
    interval = 1
  []
  [exodus]
    type = Exodus
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
[]

[Debug]
  show_var_residual_norms = true
[]
