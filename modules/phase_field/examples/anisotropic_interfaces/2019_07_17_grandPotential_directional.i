[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 50
  ny = 50
  xmin = 0
  xmax = 20
  ymin = 0
  ymax = 20
  uniform_refine = 2
[]

[GlobalParams]
  # x1 = 0
  # y1 = -10
  # radius = 0.2
  int_width = 0.2
  enable_jit = true
  derivative_order = 2
  dom_dim = 2D
  amplitude = 0.5
  sub_height = 5.0
  ncycl = 10
  # x1 = 0
  # x2 = 20
  # y1 = 0
  # y2 = 5
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
  #Temperature
  # [./T]
  #   initial_condition = -0.5
  # [../]
[]

[AuxKernels]
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'etaa0 etab0'
  [../]
  # [./T]
  #   type = FunctionAux
  #   function = -0.5+0.134375*(y-1.5-0.025*t)
  #   variable = T
  #   execute_on = 'initial timestep_begin'
  # [../]
[]

[Functions]
  [./ic_func_etaa0]
    type = ParsedFunction
    value = '0.5*(1-tanh((y-5)/sqrt(2.0)))'
  [../]
  [./ic_func_etab0]
    type = ParsedFunction
    value = '0.5*(1+tanh((y-5)/sqrt(2.0)))'
  [../]
  [./ic_func_w]
    type = ParsedFunction
    value = '-(1+tanh((y-5)/sqrt(2.0)))'
  [../]
[]

[ICs]
  # [./w]
  #   type = SmoothCircleIC
  #   variable = w
  #   outvalue = -4.0
  #   invalue = 0.0
  # [../]
  # [./etaa0]
  #   type = SmoothCircleIC
  #   variable = etaa0
  #   #Solid phase
  #   outvalue = 0.0
  #   invalue = 1.0
  # [../]
  # [./etab0]
  #   type = SmoothCircleIC
  #   variable = etab0
  #   #Liquid phase
  #   outvalue = 1.0
  #   invalue = 0.0
  # [../]
  # [./IC_etaa0]
  #   type = FunctionIC
  #   variable = etaa0
  #   function = ic_func_etaa0
  # [../]
  # [./IC_etab0]
  #   type = FunctionIC
  #   variable = etab0
  #   function = ic_func_etab0
  # [../]
  # [./IC_w]
  #   type = FunctionIC
  #   variable = w
  #   function = ic_func_w
  # [../]
  [./c_IC]
    type = SinusoidalSurfaceIC
    var_type = nonconserved
    variable = w
    outvalue = -4.0
    invalue = 0.0
  [../]
  [./etaa0_IC]
    type = SinusoidalSurfaceIC
    var_type = nonconserved
    variable = etaa0
    outvalue = 0.0
    invalue = 1.0
  [../]
  [./etab0_IC]
    type = SinusoidalSurfaceIC
    var_type = nonconserved
    variable = etab0
    outvalue = 1.0
    invalue = 0.0
  [../]
  # [./w]
  #   type = BoundingBoxIC
  #   variable = w
  #   # x1 = 0
  #   # x2 = 20
  #   # y1 = 0
  #   # y2 = 5
  #   # note w = A*(c-cleq), A = 1.0, cleq = 0.0 ,i.e., w = c (in the matrix/liquid phase)
  #   outside = -4.0
  #   inside = 0.0
  # [../]
  # [./etaa0]
  #   type = BoundingBoxIC
  #   variable = etaa0
  #   #Solid phase
  #   outside = 0.0
  #   inside = 1.0
  # [../]
  # [./etab0]
  #   type = BoundingBoxIC
  #   variable = etab0
  #   #Liquid phase
  #   outside = 1.0
  #   inside = 0.0
  # [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x'
      variable = 'w etaa0 etab0'
    [../]
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
  [./noise_etaa0]
    type = LangevinNoise
    multiplier = noise
    amplitude = 0.8
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
  [./noise_etab0]
    type = LangevinNoise
    multiplier = noise
    amplitude = 0.8
    variable = etab0
  [../]
#Chemical potential
  [./w_dot]
    type = SusceptibilityTimeDerivative
    variable = w
    f_name = chi
  [../]
  [./Diffusion]
    type = MatDiffusion
    variable = w
    diffusivity = Dchi
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
  [./coupled_etaa0dot_int]
    type = AntitrappingCurrent
    variable = w
    v = etaa0
    f_name = rhodiff
  [../]
  [./coupled_etab0dot_int]
    type = AntitrappingCurrent
    variable = w
    v = etab0
    f_name = rhodiff
  [../]
  [./noise_w]
    type = LangevinNoise
    multiplier = noise_w
    amplitude = 0.6
    variable = w
  [../]
  # [./T_dot]
  #   type = TimeDerivative
  #   variable = T
  # [../]
  # [./CoefDiffusion]
  #   type = Diffusion
  #   variable = T
  # [../]
  # [./etaa0_dot_T]
  #   type = CoefCoupledTimeDerivative
  #   variable = T
  #   v = etaa0
  #   coef = -5.0
  # [../]
[]


[Materials]
  [./ha]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = ha
    all_etas = 'etaa0 etab0'
    phase_etas = 'etaa0'
  [../]
  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'etaa0 etab0'
    phase_etas = 'etab0'
  [../]
  [./omegaa]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = omegaa
    material_property_names = 'Vm ka caeq'
    function = '-0.5*w^2/Vm^2/ka-w/Vm*caeq'
  [../]
  [./omegab]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = omegab
    material_property_names = 'Vm kb cbeq S Tm'
    function = '-0.5*w^2/Vm^2/kb-w/Vm*cbeq-S*(T-Tm)'
  [../]
  [./rhoa]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = rhoa
    material_property_names = 'Vm ka caeq'
    function = 'w/Vm^2/ka + caeq/Vm'
  [../]
  [./rhob]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = rhob
    material_property_names = 'Vm kb cbeq'
    function = 'w/Vm^2/kb + cbeq/Vm'
  [../]
  [./int]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = rhodiff
    material_property_names = 'rhoa rhob'
    constant_names = 'int_width a'
    constant_expressions = '0.2 1/2/sqrt(2)'
    function = 'a*int_width*(rhob-rhoa)'
  [../]
  [./cs]
    type = DerivativeParsedMaterial
    args = 'w '
    f_name = ca
    material_property_names = 'Vm ka caeq'
    function = 'w/Vm/ka+caeq'
    output_properties = 'ca'
    outputs = exodus
  [../]
  [./cl]
    type = DerivativeParsedMaterial
    args = 'w '
    f_name = cb
    material_property_names = 'Vm ka cbeq'
    function = 'w/Vm/ka+cbeq'
    output_properties = 'cb'
    outputs = exodus
  [../]
  [./c]
    type = DerivativeParsedMaterial
    args = 'w etaa0 etab0 T'
    f_name = c
    material_property_names = 'ca cb ha hb'
    function = 'ha*ca+hb*cb'
    outputs = exodus
    output_properties = 'c'
  [../]
  [./noise_prefactor]
    type = DerivativeParsedMaterial
    args = 'etaa0 etab0'
    f_name = noise
    # material_property_names = 'ca cb ha hb'
    function = 'etaa0*etab0'
    outputs = exodus
    output_properties = 'noise'
  [../]
  [./noise_prefactor_w]
    type = DerivativeParsedMaterial
    args = 'etaa0 etab0'
    f_name = noise_w
    # material_property_names = 'ca cb ha hb'
    function = 'etab0'
    outputs = exodus
    output_properties = 'noise_w'
  [../]
  [./kappaa]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    d2kappadgrad_etaa_name = d2kappadgrad_etaa
    etaa = etaa0
    etab = etab0
    anisotropy_strength = 0.05
    kappa_bar = 0.05
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
    kappa_bar = 0.05
    outputs = exodus
    output_properties = 'kappab'
  [../]
  [./D]
    type = DerivativeParsedMaterial
    args = 'w '
    f_name = D
    material_property_names = 'ha hb'
    constant_names =  'Dl Ds'
    constant_expressions = '1.0 1e-4'
    function = 'ha*Ds+hb*Dl'
    outputs = exodus
    output_properties = 'D'
  [../]
  [./const]
    type = GenericConstantMaterial
    prop_names =  'L      chi  Vm   ka    caeq kb    cbeq  gab mu   S   Tm'
    prop_values = '33.333 0.1  1.0  10.0  0.1  10.0  0.9   1.5 10.0 1.0 1.0'
  [../]
  [./Mobility]
    type = ParsedMaterial
    f_name = Dchi
    material_property_names = 'D chi'
    function = 'D*chi'
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
  # line_search = basic
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre    boomeramg      31'
  # petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  # petsc_options_value = 'asm         31   preonly   lu      1'
  # petsc_options = '-snes_converged_reason -ksp_converged_reason'
  l_tol = 1.0e-3
  l_max_its = 30
  nl_max_its = 15
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-8
  end_time = 200.0
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.0005
    cutback_factor = 0.7
    growth_factor = 1.2
  [../]
[]

[Adaptivity]
 initial_steps = 3
 max_h_level = 2
 initial_marker = err_eta
 marker = err_bnds
[./Markers]
   [./err_eta]
     type = ErrorFractionMarker
     coarsen = 0.3
     refine = 0.9
     indicator = ind_eta
   [../]
   [./err_bnds]
     type = ErrorFractionMarker
     coarsen = 0.3
     refine = 0.9
     indicator = ind_bnds
   [../]
 [../]
 [./Indicators]
   [./ind_eta]
     type = GradientJumpIndicator
     variable = etaa0
    [../]
    [./ind_bnds]
      type = GradientJumpIndicator
      variable = bnds
   [../]
 [../]
[]

[Outputs]
  # interval = 10
  exodus = true
[]

[Debug]
  show_var_residual_norms = true
[]
