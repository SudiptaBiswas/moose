[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 256
  ny = 256
  nz = 0
  xmin = 0
  xmax = 1024
  ymin = 0
  ymax = 1024
 zmax = 0
 uniform_refine = 1
 elem_type = QUAD4
[]

[GlobalParams]
  # int_width = 3.0
  block = 0
  op_num = 12
  # grain_num = 45
  var_name_base = eta
[]

[Variables]

  [./PolycrystalVariables]
  [../]

[]

[AuxVariables]

#active = 'total_F bnds'
  [./total_F]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]
  [./unique_grains]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./var_indices]
    order = CONSTANT
    family = MONOMIAL
  [../]

[]

[UserObjects]
  [./voronoi]
    type = PolycrystalVoronoi
    grain_num = 45 # Number of grains
    rand_seed = 1
    op_num = 9
  [../]
  [./grain_tracker]
    type = GrainTracker
    threshold = 0.6
    connecting_threshold = 0.5
    compute_var_to_feature_map = true
    flood_entity_type = elemental
    execute_on = ' initial timestep_begin'
   halo_level = 2
   reserve_op = 3
  reserve_op_threshold = 0.95
  [../]
[]

[ICs]
  [./PolycrystalICs]
    [./PolycrystalColoringIC]
      polycrystal_ic_uo = voronoi
      op_num = 9
    [../]
  [../]

  [./IC_eta9]
    variable = eta9
    seed = 798011
    type = RandomIC
    max = 2e-2
    min = 1e-2
  [../]
  [./IC_eta10]
    variable = eta10
    seed = 894635
    type = RandomIC
    max = 2e-2
    min = 1e-2
  [../]
  [./IC_eta11]
    variable = eta11
    seed = 10100110
    type = RandomIC
    max = 2e-2
    min = 1e-2
  [../]
[]

[BCs]
  [./Periodic]
    [./All]
      auto_direction = 'x y'
    [../]
  [../]
[]
[Kernels]

  [./AC1_bulk]
    type = AllenCahn
    variable = eta1
    f_name = F
    args = 'eta2 eta3 eta0 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11'
  [../]
  [./AC1_int]
    type = ACInterface
    variable = eta1
    kappa_name = kappa_s
  [../]
  [./e1_dot]
    type = TimeDerivative
    variable = eta1
  [../]
  [./AC2_bulk]
    type = AllenCahn
    variable = eta2
    f_name = F
    args = 'eta1 eta3 eta0 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11'
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
    args = 'eta2 eta1 eta0 eta4 eta5  eta6 eta7 eta8 eta9 eta10 eta11'
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
    args = 'eta2 eta3 eta1 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11'
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
    args = 'eta2 eta3 eta1 eta0 eta5 eta6 eta7 eta8 eta9 eta10 eta11'
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
    args = 'eta2 eta3 eta1 eta4 eta0 eta6 eta7 eta8 eta9 eta10 eta11'
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
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta7 eta8 eta9 eta10 eta11'
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
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta6 eta8 eta9 eta10 eta11'
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
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta7 eta6 eta9 eta10 eta11'
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
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta7 eta8 eta6 eta10 eta11'
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
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta7 eta8 eta9 eta6 eta11'
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
    args = 'eta2 eta3 eta1 eta4 eta0 eta5 eta7 eta8 eta9 eta10 eta6'
  [../]
  [./AC12_int]
    type = ACInterface
    variable = eta11
  [../]
  [./e12_dot]
    type = TimeDerivative
    variable = eta11
  [../]
[]


[AuxKernels]

 #active = 'total_F bnds'
  [./total_F]
    type = TotalFreeEnergy
    variable = total_F
    interfacial_vars = 'eta1 eta2 eta3 eta0 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11'
    kappa_names = 'kappa_s kappa_op kappa_op kappa_op kappa_op kappa_op kappa_op kappa_op kappa_op kappa_op kappa_op kappa_op'
  [../]
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
  [./var_indices]
    type = FeatureFloodCountAux
    variable = var_indices
    flood_counter = grain_tracker
    execute_on = 'initial timestep_begin'
    field_display = VARIABLE_COLORING
  [../]
[]

[Materials]
  [./FreeEng]
    type = DerivativeParsedMaterial
    args = 'eta1 eta2 eta3 eta0 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11'
    constant_names = 'a s g b d'
    constant_expressions = '1.0 1.50 1.50 0.40 1.0'
    material_property_names = 'dis_den'
    function = 'f3:=1.0/4.0+1.0/4.0*eta1^4-1.0/2.0*eta1^2+1.0/4.0*eta2^4-1.0/2.0*eta2^2+1.0/4.0*eta3^4-1.0/2.0*eta3^2+1.0/4.0*eta0^4-1.0/2.0*eta0^2+1.0/4.0*eta4^4-1.0/2.0*eta4^2+1.0/4.0*eta5^4-1.0/2.0*eta5^2+1.0/4.0*eta6^4-1.0/2.0*eta6^2+1.0/4.0*eta7^4-1.0/2.0*eta7^2+1.0/4.0*eta8^4-1.0/2.0*eta8^2+1.0/4.0*eta9^4-1.0/2.0*eta9^2+1.0/4.0*eta10^4-1.0/2.0*eta10^2+1.0/4.0*eta11^4-1.0/2.0*eta11^2;f4:=g*(eta1^2*eta3^2+eta1^2*eta0^2+eta1^2*eta2^2+eta1^2*eta5^2+eta1^2*eta4^2+eta1^2*eta6^2+eta1^2*eta7^2+eta1^2*eta8^2+eta1^2*eta9^2+eta1^2*eta10^2+eta1^2*eta11^2+eta2^2*eta3^2+eta2^2*eta0^2+eta2^2*eta4^2+eta2^2*eta5^2+eta2^2*eta6^2+eta2^2*eta7^2+eta2^2*eta8^2+eta2^2*eta9^2+eta2^2*eta10^2+eta2^2*eta11^2+eta3^2*eta0^2+eta3^2*eta4^2+eta3^2*eta5^2+eta3^2*eta6^2+eta3^2*eta7^2+eta3^2*eta8^2+eta3^2*eta9^2+eta3^2*eta10^2+eta3^2*eta11^2+eta4^2*eta5^2+eta4^2*eta6^2+eta4^2*eta0^2+eta4^2*eta7^2+eta4^2*eta8^2+eta4^2*eta9^2+eta4^2*eta10^2+eta4^2*eta11^2+eta5^2*eta0^2+eta5^2*eta6^2+eta5^2*eta7^2+eta5^2*eta8^2+eta5^2*eta9^2+eta5^2*eta10^2+eta5^2*eta11^2+eta6^2*eta0^2+eta6^2*eta7^2+eta6^2*eta8^2+eta6^2*eta9^2+eta6^2*eta10^2+eta6^2*eta11^2+eta7^2*eta0^2+eta7^2*eta8^2+eta7^2*eta9^2+eta7^2*eta10^2+eta7^2*eta11^2+eta8^2*eta0^2+eta8^2*eta9^2+eta8^2*eta10^2+eta8^2*eta11^2+eta9^2*eta0^2+eta9^2*eta10^2+eta9^2*eta11^2+eta10^2*eta0^2+eta10^2*eta11^2+eta11^2*eta0^2);f1:=dis_den*((eta0^2+eta1^2+eta2^2+eta3^2+eta4^2+eta5^2+eta6^2+eta7^2+eta8^2)/(eta0^2+eta1^2+eta2^2+eta3^2+eta4^2+eta5^2+eta6^2+eta7^2+eta8^2+eta9^2+eta10^2+eta11^2));f:=f1+b*(f3+f4);f'
    derivative_order = 2
    #enable_jit = true
   # third_derivavtives = false
  #  outputs = exodus
  [../]
  [./const]
    type = GenericConstantMaterial
    prop_names = 'kappa_c kappa_s kappa_op L M'
    prop_values = '0.0 1.50 1.50 1.0 1.0'
  #  outputs = exodus
  [../]

  [./dis_den]
    type = ParsedMaterial
    f_name = dis_den
    args = 'unique_grains'
    constant_names = 'e'
    constant_expressions = '0.16'
   function = if(unique_grains>44,0,e)
#    outputs = exodus
  [../]

#  [./dis_ind]
    # type = ParsedMaterial
   #  f_name = dis_ind
    # args = 'eta1 eta2 eta3 eta0 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 etab'
    # material_property_names = 'dis_den'
   #  function = dis_den*((eta0^2+eta1^2+eta2^2+eta3^2+eta4^2+eta5^2+eta6^2+eta7^2+eta8^2)/(eta0^2+eta1^2+eta2^2+eta3^2+eta4^2+eta5^2+eta6^2+eta7^2+eta8^2+eta9^2+eta10^2+eta11^2+etab^2))
 #    outputs = exodus
  # [../]
[]

[Postprocessors]
  [./Element_int_eta11]
    type = ElementIntegralVariablePostprocessor
    variable = eta11
  [../]
  [./total_F]
    type = ElementIntegralVariablePostprocessor
    variable = total_F
  [../]
  [./dt]
    type = TimestepSize
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  nl_max_its = 15
#  scheme = bdf2
  solve_type = NEWTON
  petsc_options_iname = -pc_type
  petsc_options_value = asm
  l_max_its = 15
  l_tol = 1.0e-3
  nl_rel_tol = 1.0e-6
  start_time = 0.0
  num_steps = 10000
  nl_abs_tol = 1e-8
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1.0e-2
   # optimal_iteration = 8
  [../]
# [./Adaptivity]
 #   refine_fraction = 0.5
  #  coarsen_fraction = 0.05
   # max_h_level = 3
  #  initial_adaptivity = 2
#  [../]

[]

[Outputs]
   [./csv]
    type = CSV
    interval = 1
  [../]
  [./exo]
    type = Exodus
    interval = 6
  [../]

hide = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8'

[]
