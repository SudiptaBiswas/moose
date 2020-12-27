[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 20
  ny = 30
  xmin = 0
  xmax = 20
  ymin = 0
  ymax = 30
  uniform_refine = 3
[]

[GlobalParams]
  # x1 = 0
  # y1 = 0
  # radius = 0.5
  int_width = 0.2
  # enable_jit = true
  derivative_order = 2
  dom_dim = 2D
  amplitude = 1.0
  sub_height = 5.0
  ncycl = 10
  use_tolerance = false
  # kappa_name = kappa_op
  # dkappadgrad_etaa_name = dkappadgrad_etaa
  variable_L = false
  mob_name = L
  # reference_angle = 0
  anisotropy_strength = 0.04
  kappa_bar = 0.02
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
  # [./T]
  #   # initial_condition = -0.5
  # [../]
[]

[AuxVariables]
  [./bnds]
  [../]
  #Temperature
  [./T]
    # initial_condition = -2.0
  [../]
[]

[AuxKernels]
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'etaa0 etab0'
  [../]
  [./T]
    type = FunctionAux
    # function = -0.5+0.134375*(y-1.5-0.025*t)
    # function = -3.0+0.05*(y-0.25*t)
    function = -2.0+0.05*(y-10.0*t)
    variable = T
    execute_on = 'initial timestep_begin'
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

# [BCs]
#   [./Periodic]
#     [./all]
#       auto_direction = 'x'
#       variable = 'w etaa0 etab0'
#     [../]
#   [../]
# []


[Kernels]
# Order parameter eta_alpha0
  [./ACa0_bulk]
    type = ADACGrGrMulti
    variable = etaa0
    v =           'etab0'
    gamma_names = 'gab'
  [../]
  [./ACa0_sw]
    type = ADACSwitching
    variable = etaa0
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etab0 w'
  [../]
  [./ACa0_int1]
    type = ADACInterface2DMultiPhase1
    variable = etaa0
    etas = 'etab0'
    kappa_name = kappa_etaa0_etab0
    dkappadgrad_etaa_name = dkappadgrad_etaa0_etab0
    # d2kappadgrad_etaa_name = d2kappadgrad_etaa
  [../]
  [./ACa0_int2]
    type = ADACInterface
    variable = etaa0
    kappa_name = kappa_etaa0_etab0
    dkappadgrad_etaa_name = dkappadgrad_etaa0_etab0
  [../]
  [./ea0_dot]
    type = ADTimeDerivative
    variable = etaa0
  [../]
# Order parameter eta_beta0
  [./ACb0_bulk]
    type = ADACGrGrMulti
    variable = etab0
    v =           'etaa0'
    gamma_names = 'gab'
  [../]
  [./ACb0_sw]
    type = ADACSwitching
    variable = etab0
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etaa0 w'
  [../]
  [./ACb0_int1]
    type = ADACInterface2DMultiPhase1
    variable = etab0
    etas = 'etaa0'
    kappa_name = kappa_etab0_etaa0
    dkappadgrad_etaa_name = dkappadgrad_etab0_etaa0
  [../]
  [./ACb0_int2]
    type = ADACInterface
    variable = etab0
    kappa_name = kappa_etab0_etaa0
  [../]
  [./eb0_dot]
    type = ADTimeDerivative
    variable = etab0
  [../]
  [./noise_etaa0]
    type = LangevinNoise
    multiplier = noise
    amplitude = 100000
    variable = etaa0
  [../]
  [./noise_etab0]
    type = LangevinNoise
    multiplier = noise
    amplitude = 100000
    variable = etab0
  [../]
#Chemical potential
  [./w_dot]
    type = ADSusceptibilityTimeDerivative
    variable = w
    f_name = chi
  [../]
  [./Diffusion]
    type = ADMatDiffusion
    variable = w
    D_name = Dchi
  [../]
  [./coupled_etaa0dot]
    type = ADCoupledSwitchingTimeDerivative
    variable = w
    v = etaa0
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0'
  [../]
  [./coupled_etab0dot]
    type = ADCoupledSwitchingTimeDerivative
    variable = w
    v = etab0
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0'
  [../]
  [./coupled_etaa0dot_int]
    type = ADAntitrappingCurrent
    variable = w
    v = etaa0
    f_name = rhodiff
  [../]
  # [./coupled_etab0dot_int]
  #   type = ADAntitrappingCurrent
  #   variable = w
  #   v = etab0
  #   f_name = rhodiff
  # [../]
  # [./noise_w]
  #   type = LangevinNoise
  #   multiplier = noise_w
  #   amplitude = 1.0
  #   variable = w
  # [../]
  # [./T_dot]
  #   type = ADTimeDerivative
  #   variable = T
  # [../]
  # [./CoefDiffusion]
  #   type = ADDiffusion
  #   variable = T
  # [../]
  # [./etaa0_dot_T]
  #   type = ADCoefCoupledTimeDerivative
  #   variable = T
  #   v = etaa0
  #   coef = -5.0
  # [../]
[]


[Materials]
  [./ha]
    type = ADSwitchingFunctionMultiPhaseMaterial
    h_name = ha
    all_etas = 'etaa0 etab0'
    phase_etas = 'etaa0'
  [../]
  [./hb]
    type = ADSwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'etaa0 etab0'
    phase_etas = 'etab0'
  [../]
  [./omegaa]
    type = ADDerivativeParsedMaterial
    args = 'w'
    f_name = omegaa
    material_property_names = 'Vm ka caeq'
    function = '-0.5*w^2/Vm^2/ka-w/Vm*caeq'
  [../]
  [./omegab]
    type = ADDerivativeParsedMaterial
    args = 'w T'
    f_name = omegab
    material_property_names = 'Vm kb cbeq S Tm'
    function = '-0.5*w^2/Vm^2/kb-w/Vm*cbeq-S*(T-Tm)'
  [../]
  [./rhoa]
    type = ADDerivativeParsedMaterial
    args = 'w'
    f_name = rhoa
    material_property_names = 'Vm ka caeq'
    function = 'w/Vm^2/ka + caeq/Vm'
  [../]
  [./rhob]
    type = ADDerivativeParsedMaterial
    args = 'w'
    f_name = rhob
    material_property_names = 'Vm kb cbeq'
    function = 'w/Vm^2/kb + cbeq/Vm'
  [../]
  [./int]
    type = ADDerivativeParsedMaterial
    args = 'w'
    f_name = rhodiff
    material_property_names = 'rhoa rhob'
    constant_names = 'int_width a'
    constant_expressions = '0.2 1/2/sqrt(2)'
    function = 'a*int_width*(rhob-rhoa)'
  [../]
  [./cs]
    type = ADDerivativeParsedMaterial
    args = 'w '
    f_name = ca
    material_property_names = 'Vm ka caeq'
    function = 'w/Vm/ka+caeq'
    output_properties = 'ca'
    outputs = exodus
  [../]
  [./cl]
    type = ADDerivativeParsedMaterial
    args = 'w '
    f_name = cb
    material_property_names = 'Vm ka cbeq'
    function = 'w/Vm/ka+cbeq'
    output_properties = 'cb'
    outputs = exodus
  [../]
  [./c]
    type = ADDerivativeParsedMaterial
    args = 'w etaa0 etab0 T'
    f_name = c
    material_property_names = 'ca cb ha hb'
    function = 'ha*ca+hb*cb'
    outputs = exodus
    output_properties = 'c'
  [../]
  [./kappaa]
    type = ADInterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    # d2kappadgrad_etaa_name = d2kappadgrad_etaa
    etaa = etaa0
    etab = etab0
    # anisotropy_strength = 0.02
    # kappa_bar = 0.01
    outputs = exodus
    output_properties = 'kappa_etaa0_etab0'
  [../]
  [./kappab]
    type = ADInterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    # d2kappadgrad_etaa_name = d2kappadgrad_etab
    etaa = etab0
    etab = etaa0
    # anisotropy_strength = 0.02
    # kappa_bar = 0.01
    outputs = exodus
    output_properties = 'kappa_etab0_etaa0'
  [../]
  [./D]
    type = ADDerivativeParsedMaterial
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
    type = ADGenericConstantMaterial
    prop_names =  'L       chi  Vm   ka    caeq kb    cbeq  gab mu   S   Tm'
    prop_values = '333.333 0.1  1.0  10.0  0.1  10.0  0.9   1.5 10.0 1.0 1.0'
  [../]
  [./Mobility]
    type = ADParsedMaterial
    f_name = Dchi
    material_property_names = 'D chi'
    function = 'D*chi'
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
  solve_type = NEWTON
  line_search = none
  # petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  # petsc_options_value = 'hypre    boomeramg      31'
  # petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  # petsc_options_value = 'asm         31   preonly   lu      1'
  # petsc_options = '-snes_converged_reason -ksp_converged_reason'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist '
  l_tol = 1.0e-3
  l_max_its = 30
  nl_max_its = 15
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-8
  end_time = 5.0
  automatic_scaling = true
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.0005
    cutback_factor = 0.7
    growth_factor = 1.2
  [../]
[]

[Adaptivity]
 initial_steps = 3
 max_h_level = 5
 initial_marker = err_eta
 marker = err_bnds
[./Markers]
   [./err_eta]
     type = ErrorFractionMarker
     coarsen = 0.3
     refine = 0.95
     indicator = ind_eta
   [../]
   [./err_bnds]
     type = ErrorFractionMarker
     coarsen = 0.3
     refine = 0.95
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
