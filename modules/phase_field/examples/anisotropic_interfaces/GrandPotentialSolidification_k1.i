[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 20
  ny = 20
  xmin = -20
  xmax = 20
  ymin = -20
  ymax = 20
  elem_type = QUAD4
  uniform_refine = 2
[]

[GlobalParams]
  radius = 0.5
  int_width = 0.3
  x1 = 0.0
  y1 = 0.0
[]

[Variables]
  [./w]
  [../]
  [./etaa0]
  [../]
  [./etab0]
  [../]
  [./T]
    initial_condition = -0.5
  [../]
[]

[AuxVariables]
  [./bnds]
  [../]
[]

[AuxKernels]
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'etaa0 etab0'
  [../]
[]

[ICs]
  [./w]
    type = SmoothCircleIC
    variable = w
    # note w = A*(c-cleq), A = 1.0, cleq = 0.0 ,i.e., w = c (in the matrix/liquid phase)
    outvalue = -4.0
    invalue = 0.0
  [../]
  [./etaa0]
    type = SmoothCircleIC
    variable = etaa0
    #Solid phase
    outvalue = 0.0
    invalue = 1.0
  [../]
  [./etab0]
    type = SmoothCircleIC
    variable = etab0
    #Liquid phase
    outvalue = 1.0
    invalue = 0.0
  [../]
[]

[Kernels]
# Order parameter eta_alpha0
  [./ACa0_bulk]
    type = ACGrGrMulti
    variable = etaa0
    v =           'etab0'
    gamma_names = 'gab'
  [../]
  [./ACa0_sw]
    type = ACSwitching
    variable = etaa0
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etab0 w T'
  [../]
  [./ACa0_int1]
    type = ACInterface2DMultiPhase1
    variable = etaa0
    etas = 'etab0'
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    d2kappadgrad_etaa_name = d2kappadgrad_etaa
  [../]
  [./ACa0_int2]
    type = ACInterface2DMultiPhase2
    variable = etaa0
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
  [../]
  [./ea0_dot]
    type = TimeDerivative
    variable = etaa0
  [../]
# Order parameter eta_beta0
  [./ACb0_bulk]
    type = ACGrGrMulti
    variable = etab0
    v =           'etaa0'
    gamma_names = 'gab'
  [../]
  [./ACb0_sw]
    type = ACSwitching
    variable = etab0
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etaa0 w T'
  [../]
  [./ACb0_int1]
    type = ACInterface2DMultiPhase1
    variable = etab0
    etas = 'etaa0'
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
    d2kappadgrad_etaa_name = d2kappadgrad_etab
  [../]
  [./ACb0_int2]
    type = ACInterface2DMultiPhase2
    variable = etab0
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
  [../]
  [./eb0_dot]
    type = TimeDerivative
    variable = etab0
  [../]
#Chemical potential
  [./w_dot]
    type = SusceptibilityTimeDerivative
    variable = w
    f_name = chi
    args = '' # in this case chi (the susceptibility) is simply a constant
  [../]
  [./Diffusion]
    type = MatDiffusion
    variable = w
    D_name = Dchi
    args = ''
  [../]
  [./coupled_etaa0dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etaa0
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0'
  [../]
  [./coupled_etab0dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etab0
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0'
  [../]
  [./T_dot]
    type = TimeDerivative
    variable = T
  [../]
  [./CoefDiffusion]
    type = Diffusion
    variable = T
  [../]
  [./etaa0_dot_T]
    type = CoefCoupledTimeDerivative
    variable = T
    v = etaa0
    coef = -5.0
  [../]
[]


[Materials]
  [./ha]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = ha
    all_etas = 'etaa0 etab0'
    phase_etas = 'etaa0'
    outputs = exodus
    output_properties = 'ha'
  [../]
  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'etaa0 etab0'
    phase_etas = 'etab0'
    outputs = exodus
    output_properties = 'hb'
  [../]
  [./omegaa]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = omegaa
    material_property_names = 'Vm ka caeq'
    function = '-0.5*w^2/Vm^2/ka-w/Vm*caeq'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'omegaa'
  [../]
  [./omegab]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = omegab
    material_property_names = 'Vm kb cbeq S Tm'
    function = '-0.5*w^2/Vm^2/kb-w/Vm*cbeq-S*(T-Tm)'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'omegab'
  [../]
  [./rhoa]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = rhoa
    material_property_names = 'Vm ka caeq'
    function = 'w/Vm^2/ka + caeq/Vm'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'rhoa'
  [../]
  [./rhob]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = rhob
    material_property_names = 'Vm kb cbeq'
    function = 'w/Vm^2/kb + cbeq/Vm'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'rhob'
  [../]
  [./kappaa]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    d2kappadgrad_etaa_name = d2kappadgrad_etaa
    etaa = etaa0
    etab = etab0
    anisotropy_strength = 0.05
    reference_angle = 0
    kappa_bar = 1.0
    outputs = exodus
    output_properties = 'kappaa'
  [../]
  [./kappab]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
    d2kappadgrad_etaa_name = d2kappadgrad_etab
    etaa = etab0
    etab = etaa0
    anisotropy_strength = 0.05
    reference_angle = 0
    kappa_bar = 1.0
    outputs = exodus
    output_properties = 'kappab'
  [../]
  [./const]
    type = GenericConstantMaterial
    prop_names =  'kappa_c   L      D    chi  Vm   ka    caeq kb    cbeq  gab mu   S   Tm'
    prop_values = '0         33.333 1.0  0.1  1.0  10.0  0.1  10.0  0.9   4.5 10.0 1.0 5.0'
    outputs = exodus
  [../]
  [./Mobility]
    type = DerivativeParsedMaterial
    f_name = Dchi
    material_property_names = 'D chi'
    function = 'D*chi'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'Dchi'
  [../]
[]

[Postprocessors]
  [./ndof]
    type = NumDOFs
    system = NL
  [../]
  [./etaa0]
    type = ElementIntegralVariablePostprocessor
    variable = etaa0
  [../]
  [./w]
    type = ElementIntegralVariablePostprocessor
    variable = w
  [../]
  [./memory]
    type = MemoryUsage
    mem_type = physical_memory
    execute_on = 'LINEAR NONLINEAR TIMESTEP_END'
  [../]
  [./active_time]
    type = PerformanceData
    event = ACTIVE
  [../]
  [./alive_time]
    type = PerformanceData
    event = ALIVE
  [../]
  [./elapsed]
    type = PerfGraphData
    section_name = "App"
    data_type = total
  [../]
[]

[VectorPostprocessors]
  [./velocity_x]
    type = LineValueSampler
    variable = 'bnds etaa0'
    start_point = '-20.0 0.0 0.0'
    end_point = '20.0 0.0 0.0'
    sort_by = id
    num_points = 50
  [../]
  [./velocity_y]
    type = LineValueSampler
    variable = 'bnds etaa0'
    start_point = '0.0 -20.0 0.0'
    end_point = '0.0 20.0 0.0'
    sort_by = id
    num_points = 50
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
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -sub_pc_type -sub_ksp_type -pc_asm_overlap'
  petsc_options_value = ' asm      ilu           preonly       1    '
  l_tol = 1.0e-3
  l_max_its = 30
  nl_max_its = 15
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-10
  end_time = 10.0
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.0005
    cutback_factor = 0.95
    growth_factor = 1.05
    optimal_iterations = 4
    iteration_window = 0
    linear_iteration_ratio = 100
  [../]
 []

[Adaptivity]
 initial_steps = 5
 max_h_level = 4
 initial_marker = EFM_3
 marker = EFM_4
[./Markers]
   [./EFM_3]
     type = ErrorFractionMarker
     coarsen = 0.3
     refine = 0.95
     indicator = GJI_3
   [../]
   [./EFM_4]
     type = ErrorFractionMarker
     coarsen = 0.3
     refine = 0.95
     indicator = GJI_4
   [../]
 [../]
 [./Indicators]
   [./GJI_3]
     type = GradientJumpIndicator
     variable = etaa0
    [../]
    [./GJI_4]
      type = GradientJumpIndicator
      variable = bnds
   [../]
 [../]
[]

[Outputs]
  interval = 50
  exodus = true
  csv = true
[]
