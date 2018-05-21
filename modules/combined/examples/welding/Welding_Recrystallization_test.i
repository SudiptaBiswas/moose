[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 128
  ny = 64
  nz = 0
  xmin = 0
  xmax = 512
  ymin = 0
  ymax = 256
 zmax = 0
 elem_type = QUAD4
[]

[GlobalParams]
  block = 0
  op_num = 20 # total number of OPs
  var_name_base = eta
  grain_num = 50
[]

[Functions]
  [./mob]
    type = MobilityProfile
    x1 = 0
    y1 = 128
    z1 = 0
    r1 = 50
    haz = 75
    vp = 2.5
    factor = 10.0
    invalue = 1e-3
    outvalue = 1e-3
    weldpool_shape = circular
  [../]
[]

[Variables]
  [./PolycrystalVariables]
  [../]
[]

[AuxVariables]
  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]

  [./unique_grains]
    order = CONSTANT
    family = MONOMIAL
  [../]
# dislocation density
  [./dd]
    order = CONSTANT
    family = MONOMIAL
  [../]

[]

[ICs]
  [./PolycrystalICs]
    [./PolycrystalColoringIC]
      polycrystal_ic_uo = voronoi
      op_num = 8
  # only 8 OPs are used to represent the original damaged grains
    [../]
  [../]

 # Extrea OPs for nucleation of new grains
  [./IC_eta19]
    variable = eta19
    type = RandomIC
    max = 2e-2
    min = 1e-2
  [../]
  [./IC_eta18]
    variable = eta18
    seed = 1000
    type = RandomIC
    max = 2e-2
    min = 1e-2
  [../]

  [./IC_eta17]
    variable = eta17
    seed = 798011
    type = RandomIC
    max = 2e-2
    min = 1e-2
  [../]
  [./IC_eta16]
    variable = eta16
    seed = 123321
    type = RandomIC
    max = 2e-2
    min = 1e-2
  [../]

  # Note that the remaining OPs are intially zero on purpose to then hanle the new recrystallized grains

[]

[BCs]
  [./Periodic]
    [./All]
      auto_direction = 'x y'
    [../]
  [../]
[]

# The model is entirly parsed here, We should make an action for it in the future
# the model parameters here are non-dimensionalized (Not for a specfifc material)

[Kernels]
  [./AC1_bulk]
    type = AllenCahn
    variable = eta1
    f_name = F
    args = 'eta2 eta3 eta0 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14 eta15 eta16 eta17 eta18 eta19'
  [../]
  [./AC1_int]
    type = ACInterface
    variable = eta1
    #kappa_name = kappa_op
  [../]
  [./e1_dot]
    type = TimeDerivative
    variable = eta1
  [../]
  [./AC2_bulk]
    type = AllenCahn
    variable = eta2
    f_name = F
    args = 'eta1 eta3 eta0 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14 eta15 eta16 eta17 eta18 eta19'
  [../]
  [./AC2_int]
    type = ACInterface
    variable = eta2
  [../]
  [./e2_dot]
    type = TimeDerivative
    variable = eta2
  [../]
  [./AC3_bulk]
    type = AllenCahn
    variable = eta3
    f_name = F
    args = 'eta2 eta1 eta0 eta4 eta5  eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14 eta15 eta16 eta17 eta18 eta19'
  [../]
  [./AC3_int]
    type = ACInterface
    variable = eta3
  [../]
  [./e3_dot]
    type = TimeDerivative
    variable = eta3
  [../]
  [./AC4_bulk]
    type = AllenCahn
    variable = eta0
    f_name = F
    args = 'eta2 eta3 eta1 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14 eta15 eta16 eta17 eta18 eta19'
  [../]
  [./AC4_int]
    type = ACInterface
    variable = eta0
  [../]
  [./e4_dot]
    type = TimeDerivative
    variable = eta0
  [../]
  [./AC5_bulk]
    type = AllenCahn
    variable = eta4
    f_name = F
    args = 'eta2 eta3 eta1 eta0 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14 eta15 eta16 eta17 eta18 eta19'
  [../]
  [./AC5_int]
    type = ACInterface
    variable = eta4
  [../]
  [./e5_dot]
    type = TimeDerivative
    variable = eta4
  [../]
  [./AC6_bulk]
    type = AllenCahn
    variable = eta5
    f_name = F
    args = 'eta2 eta3 eta1 eta4 eta0 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14 eta15 eta16 eta17 eta18 eta19'
  [../]
  [./AC6_int]
    type = ACInterface
    variable = eta5
  [../]
  [./e6_dot]
    type = TimeDerivative
    variable = eta5
  [../]
  [./AC7_bulk]
    type = AllenCahn
    variable = eta6
    f_name = F
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14 eta15 eta16 eta17 eta18 eta19'
  [../]
  [./AC7_int]
    type = ACInterface
    variable = eta6
  [../]
  [./e7_dot]
    type = TimeDerivative
    variable = eta6
  [../]
  [./AC8_bulk]
    type = AllenCahn
    variable = eta7
    f_name = F
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta6 eta8 eta9 eta10 eta11 eta12 eta13 eta14 eta15 eta16 eta17 eta18 eta19'
  [../]
  [./AC8_int]
    type = ACInterface
    variable = eta7
  [../]
  [./e8_dot]
    type = TimeDerivative
    variable = eta7
  [../]
  [./AC9_bulk]
    type = AllenCahn
    variable = eta8
    f_name = F
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta7 eta6 eta9 eta10 eta11 eta12 eta13 eta14 eta15 eta16 eta17 eta18 eta19'
  [../]
  [./AC9_int]
    type = ACInterface
    variable = eta8
  [../]
  [./e9_dot]
    type = TimeDerivative
    variable = eta8
  [../]
  [./AC10_bulk]
    type = AllenCahn
    variable = eta9
    f_name = F
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta7 eta8 eta6 eta10 eta11 eta12 eta13 eta14 eta15 eta16 eta17 eta18 eta19'
  [../]
  [./AC10_int]
    type = ACInterface
    variable = eta9
  [../]
  [./e10_dot]
    type = TimeDerivative
    variable = eta9
  [../]
  [./AC11_bulk]
    type = AllenCahn
    variable = eta10
    f_name = F
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta7 eta8 eta9 eta6 eta11 eta12 eta13 eta14 eta15 eta16 eta17 eta18 eta19'
  [../]
  [./AC11_int]
    type = ACInterface
    variable = eta10
  [../]
  [./e11_dot]
    type = TimeDerivative
    variable = eta10
  [../]
  [./AC12_bulk]
    type = AllenCahn
    variable = eta11
    f_name = F
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta7 eta8 eta9 eta10 eta6 eta12 eta13 eta14 eta15 eta16 eta17 eta18 eta19'
  [../]
  [./AC12_int]
    type = ACInterface
    variable = eta11
  [../]
  [./e12_dot]
    type = TimeDerivative
    variable = eta11
  [../]
  [./AC13_bulk]
    type = AllenCahn
    variable = eta12
    f_name = F
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta7 eta8 eta9 eta10 eta6 eta11 eta13 eta14 eta15 eta16 eta17 eta18 eta19'
  [../]
  [./AC13_int]
    type = ACInterface
    variable = eta12
  [../]
  [./e13_dot]
    type = TimeDerivative
    variable = eta12
  [../]
  [./AC14_bulk]
    type = AllenCahn
    variable = eta13
    f_name = F
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta7 eta8 eta9 eta10 eta6 eta12 eta11 eta14 eta15 eta16 eta17 eta18 eta19'
  [../]
  [./AC14_int]
    type = ACInterface
    variable = eta13
  [../]
  [./e14_dot]
    type = TimeDerivative
    variable = eta13
  [../]
  [./AC15_bulk]
    type = AllenCahn
    variable = eta14
    f_name = F
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta7 eta8 eta9 eta10 eta6 eta12 eta13 eta11 eta15 eta16 eta17 eta18 eta19'
  [../]
  [./AC15_int]
    type = ACInterface
    variable = eta14
  [../]
  [./e15_dot]
    type = TimeDerivative
    variable = eta14
  [../]
  [./AC16_bulk]
    type = AllenCahn
    variable = eta15
    f_name = F
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta7 eta8 eta9 eta10 eta6 eta12 eta13 eta14 eta11 eta16 eta17 eta18 eta19'
  [../]
  [./AC16_int]
    type = ACInterface
    variable = eta15
  [../]
  [./e16_dot]
    type = TimeDerivative
    variable = eta15
  [../]
  [./AC17_bulk]
    type = AllenCahn
    variable = eta16
    f_name = F
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta7 eta8 eta9 eta10 eta6 eta12 eta13 eta14 eta15 eta11 eta17 eta18 eta19'
  [../]
  [./AC17_int]
    type = ACInterface
    variable = eta16
  [../]
  [./e17_dot]
    type = TimeDerivative
    variable = eta16
  [../]
  [./AC18_bulk]
    type = AllenCahn
    variable = eta17
    f_name = F
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta7 eta8 eta9 eta10 eta6 eta12 eta13 eta14 eta15 eta11 eta16 eta18 eta19'
  [../]
  [./AC18_int]
    type = ACInterface
    variable = eta17
  [../]
  [./e18_dot]
    type = TimeDerivative
    variable = eta17
  [../]
  [./AC19_bulk]
    type = AllenCahn
    variable = eta18
    f_name = F
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta7 eta8 eta9 eta10 eta6 eta12 eta13 eta14 eta15 eta11 eta17 eta16 eta19'
  [../]
  [./AC19_int]
    type = ACInterface
    variable = eta18
  [../]
  [./e19_dot]
    type = TimeDerivative
    variable = eta18
  [../]
  [./AC20_bulk]
    type = AllenCahn
    variable = eta19
    f_name = F
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta7 eta8 eta9 eta10 eta6 eta12 eta13 eta14 eta15 eta11 eta17 eta18 eta16'
  [../]
  [./AC20_int]
    type = ACInterface
    variable = eta19
  [../]
  [./e20_dot]
    type = TimeDerivative
    variable = eta19
  [../]

[]

[AuxKernels]

  [./bnds]
    type = BndsCalcAux
    variable = bnds
    execute_on = timestep_end
  [../]
  [./unique_grains]
    type = FeatureFloodCountAux
    variable = unique_grains
    flood_counter = grain_tracker
    execute_on = 'initial timestep_begin'
  [../]
  [./dd]
    type = MaterialRealAux
    variable = dd
    property = dis_den
  [../]

[]

[Materials]
  [./FreeEng]
    type = DerivativeParsedMaterial
    args = 'eta1 eta2 eta3 eta0 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14 eta15 eta16 eta17 eta18 eta19'
    constant_names = 'g b'
    constant_expressions = '1.50 2.0'
    material_property_names = 'dis_den'
    function = 'sumeta:=eta0^2+eta1^2+eta2^2+eta3^2+eta4^2+eta5^2+eta6^2+eta7^2+eta8^2+eta9^2+eta10^2+eta11^2+eta12^2+eta13^2+eta14^2+eta15^2+eta16^2+eta17^2+eta18^2+eta19^2;f3:=1.0/4.0+1.0/4.0*eta1^4-1.0/2.0*eta1^2+1.0/4.0*eta2^4-1.0/2.0*eta2^2+1.0/4.0*eta3^4-1.0/2.0*eta3^2+1.0/4.0*eta0^4-1.0/2.0*eta0^2+1.0/4.0*eta4^4-1.0/2.0*eta4^2+1.0/4.0*eta5^4-1.0/2.0*eta5^2+1.0/4.0*eta6^4-1.0/2.0*eta6^2+1.0/4.0*eta7^4-1.0/2.0*eta7^2+1.0/4.0*eta8^4-1.0/2.0*eta8^2+1.0/4.0*eta9^4-1.0/2.0*eta9^2+1.0/4.0*eta10^4-1.0/2.0*eta10^2+1.0/4.0*eta11^4-1.0/2.0*eta11^2+1.0/4.0*eta12^4-1.0/2.0*eta12^2+1.0/4.0*eta13^4-1.0/2.0*eta13^2+1.0/4.0*eta14^4-1.0/2.0*eta14^2+1.0/4.0*eta15^4-1.0/2.0*eta15^2+1.0/4.0*eta16^4-1.0/2.0*eta16^2+1.0/4.0*eta17^4-1.0/2.0*eta17^2+1.0/4.0*eta18^4-1.0/2.0*eta18^2+1.0/4.0*eta19^4-1.0/2.0*eta19^2;f4:=g*(eta1^2*eta3^2+eta1^2*eta0^2+eta1^2*eta2^2+eta1^2*eta5^2+eta1^2*eta4^2+eta1^2*eta6^2+eta1^2*eta7^2+eta1^2*eta8^2+eta1^2*eta9^2+eta1^2*eta10^2+eta1^2*eta11^2+eta1^2*eta12^2+eta1^2*eta13^2+eta1^2*eta14^2+eta1^2*eta15^2+eta1^2*eta16^2+eta1^2*eta17^2+eta1^2*eta18^2+eta1^2*eta19^2+eta2^2*eta3^2+eta2^2*eta0^2+eta2^2*eta4^2+eta2^2*eta5^2+eta2^2*eta6^2+eta2^2*eta7^2+eta2^2*eta8^2+eta2^2*eta9^2+eta2^2*eta10^2+eta2^2*eta11^2+eta2^2*eta12^2+eta2^2*eta13^2+eta2^2*eta14^2+eta2^2*eta15^2+eta2^2*eta16^2+eta2^2*eta17^2+eta2^2*eta18^2+eta2^2*eta19^2+eta3^2*eta0^2+eta3^2*eta4^2+eta3^2*eta5^2+eta3^2*eta6^2+eta3^2*eta7^2+eta3^2*eta8^2+eta3^2*eta9^2+eta3^2*eta10^2+eta3^2*eta11^2+eta3^2*eta12^2+eta3^2*eta13^2+eta3^2*eta14^2+eta3^2*eta15^2+eta3^2*eta16^2+eta3^2*eta17^2+eta3^2*eta18^2+eta3^2*eta19^2+eta4^2*eta5^2+eta4^2*eta6^2+eta4^2*eta0^2+eta4^2*eta7^2+eta4^2*eta8^2+eta4^2*eta9^2+eta4^2*eta10^2+eta4^2*eta11^2+eta4^2*eta12^2+eta4^2*eta13^2+eta4^2*eta14^2+eta4^2*eta15^2+eta4^2*eta16^2+eta4^2*eta17^2+eta4^2*eta18^2+eta4^2*eta19^2+eta5^2*eta0^2+eta5^2*eta6^2+eta5^2*eta7^2+eta5^2*eta8^2+eta5^2*eta9^2+eta5^2*eta10^2+eta5^2*eta11^2+eta5^2*eta12^2+eta5^2*eta13^2+eta5^2*eta14^2+eta5^2*eta15^2+eta5^2*eta16^2+eta5^2*eta17^2+eta5^2*eta18^2+eta5^2*eta19^2+eta6^2*eta0^2+eta6^2*eta7^2+eta6^2*eta8^2+eta6^2*eta9^2+eta6^2*eta10^2+eta6^2*eta11^2+eta6^2*eta12^2+eta6^2*eta13^2+eta6^2*eta14^2+eta6^2*eta15^2+eta6^2*eta16^2+eta6^2*eta17^2+eta6^2*eta18^2+eta6^2*eta19^2+eta7^2*eta0^2+eta7^2*eta8^2+eta7^2*eta9^2+eta7^2*eta10^2+eta7^2*eta11^2+eta7^2*eta12^2+eta7^2*eta13^2+eta7^2*eta14^2+eta7^2*eta15^2+eta7^2*eta16^2+eta7^2*eta17^2+eta7^2*eta18^2+eta7^2*eta19^2+eta8^2*eta0^2+eta8^2*eta9^2+eta8^2*eta10^2+eta8^2*eta11^2+eta8^2*eta12^2+eta8^2*eta13^2+eta8^2*eta14^2+eta8^2*eta15^2+eta8^2*eta16^2+eta8^2*eta17^2+eta8^2*eta18^2+eta8^2*eta19^2+eta9^2*eta0^2+eta9^2*eta10^2+eta9^2*eta11^2+eta9^2*eta12^2+eta9^2*eta13^2+eta9^2*eta14^2+eta9^2*eta15^2+eta9^2*eta16^2+eta9^2*eta17^2+eta9^2*eta18^2+eta9^2*eta19^2+eta10^2*eta0^2+eta10^2*eta11^2+eta10^2*eta12^2+eta10^2*eta13^2+eta10^2*eta14^2+eta10^2*eta15^2+eta10^2*eta16^2+eta10^2*eta17^2+eta10^2*eta18^2+eta10^2*eta19^2+eta11^2*eta0^2+eta11^2*eta12^2+eta11^2*eta13^2+eta11^2*eta14^2+eta11^2*eta15^2+eta11^2*eta16^2+eta11^2*eta17^2+eta11^2*eta18^2+eta11^2*eta19^2+eta12^2*eta0^2+eta12^2*eta13^2+eta12^2*eta14^2+eta12^2*eta15^2+eta12^2*eta16^2+eta12^2*eta17^2+eta12^2*eta18^2+eta12^2*eta19^2+eta13^2*eta0^2+eta13^2*eta14^2+eta13^2*eta15^2+eta13^2*eta16^2+eta13^2*eta17^2+eta13^2*eta18^2+eta13^2*eta19^2+eta14^2*eta0^2+eta14^2*eta15^2+eta14^2*eta16^2+eta14^2*eta17^2+eta14^2*eta18^2+eta14^2*eta19^2+eta15^2*eta0^2+eta15^2*eta16^2+eta15^2*eta17^2+eta15^2*eta18^2+eta15^2*eta19^2+eta16^2*eta0^2+eta16^2*eta17^2+eta16^2*eta18^2+eta16^2*eta19^2+eta17^2*eta0^2+eta17^2*eta18^2+eta17^2*eta19^2+eta18^2*eta0^2+eta18^2*eta19^2+eta19^2*eta0^2);f1:=dis_den*((eta0^2+eta1^2+eta2^2+eta3^2+eta4^2+eta5^2+eta6^2+eta7^2)/sumeta);f:=f1+b*(f3+f4);f'
    derivative_order = 2
    enable_jit = true
  [../]
  # [./const]
  #   type = GenericConstantMaterial
  #   prop_names = 'kappa_op L'
  #   prop_values = '0.50 1.0'
  #
  # [../]
  [./CuGrGr]
    # Material properties
    type = FunctionGBEvolution
    # Constant temperature of the simulation (for mobility calculation)
    wGB = 14 # Width of the diffuse GB
    GBMobility = mob #m^4(Js) for copper from Schoenfelder1997
    GBenergy = 0.0072 #J/m^2 from Schoenfelder1997
    t0 = 0.5
    outputs = exodus
  [../]

  [./dis_den]
    type = ParsedMaterial
    f_name = dis_den
    args = 'unique_grains'
    constant_names = 'e'
    constant_expressions = '2.0'
    function = if(unique_grains>49,0,e)

   # dislocation density equals e in the deformed grain and zero in the recrystallized grain
   # All existing grains are assumed to be damaged/deformed
   # Note that unique_grains runs from 0 to grain_num - 1
  [../]

[]

[UserObjects]
  [./grain_tracker]
    type = GrainTracker
    threshold = 0.6
    connecting_threshold = 0.4
    compute_var_to_feature_map = true
    flood_entity_type = elemental
    execute_on = ' initial timestep_begin'
    halo_level = 3
  [../]
  [./voronoi]
    type = PolycrystalVoronoi
    op_num = 8
    rand_seed = 81
    coloring_algorithm = bt
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
  nl_max_its = 15
  solve_type = NEWTON
  petsc_options_iname = -pc_type
  petsc_options_value = asm
  l_max_its = 15
  l_tol = 1.0e-3
  nl_rel_tol = 1.0e-7
  start_time = 0.0
  num_steps = 10000
  nl_abs_tol = 1e-8

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.1
    growth_factor = 1.1
    cutback_factor = 0.75
    optimal_iterations = 7
  [../]
  # [./Adaptivity]
  #   initial_adaptivity = 1 # Number of times mesh is adapted to initial condition
  #   refine_fraction = 0.5 # Fraction of high error that will be refined
  #   coarsen_fraction = 0.05 # Fraction of low error that will coarsened
  #   max_h_level = 2 # Max number of refinements used, starting from initial mesh (before uniform refinement)
  # [../]
[]

[Adaptivity]
  marker = bound_adapt
  max_h_level = 2
  [./Indicators]
    [./error]
      type = GradientJumpIndicator
      variable = bnds
    [../]
  [../]
  [./Markers]
    [./bound_adapt]
      type = ValueRangeMarker
      lower_bound = 0.1
      upper_bound = 0.99
      variable = bnds
    [../]
  [../]
[]

[Outputs]
  exodus = true
  file_base = welding_recrys_vp25_dd2
  # [./exo]
  #   type = Exodus
  #   # interval = 3
  # [../]
 # show = 'bnds dd unique_grains'
[]
