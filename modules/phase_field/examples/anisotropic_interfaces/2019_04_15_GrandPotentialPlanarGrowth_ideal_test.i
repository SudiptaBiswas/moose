[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 10
  xmin = 0
  xmax = 100
  ymin = 0
  ymax = 10
  # uniform_refine = 2
[]

# [GlobalParams]
#   x1 = -100
#   y1 = -10
#   x2 = -8.0
#   y2 = 10.0
# []

[Variables]
  [./w]
  [../]
  [./etaa0]
  [../]
  [./etab0]
  [../]
[]

[AuxVariables]
  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]
  #Temperature
  [./T]
  [../]
[]

[AuxKernels]
  [./T]
    type = FunctionAux
    # function = 95.0+2.0*(y-1.0*t)
    function = 1710
    variable = T
    execute_on = 'initial timestep_begin'
  [../]
  # [./T]
  #   type = ConstantAux
  #   value = -10
  #   variable = T
  #   execute_on = "initial timestep_begin"
  # [../]
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'etaa0 etab0'
  [../]
[]

[ICs]
  [./w]
    type = BoundingBoxIC
    variable = w
    x1 = 0
    y1 = 0
    x2 = 10.0
    y2 = 10.0
    outside = -6.8e-7  #-5.135e-4
    inside = -6.58e-7
    # outside = -4.9e-4
  [../]
  # [./w]
  #   type = FunctionIC
  #   variable = w
  #   function = ic_func_w
  # [../]
  [./IC_etab0]
    type = FunctionIC
    variable = etab0
    function = ic_func_etab0
  [../]
  [./IC_etam0]
    type = FunctionIC
    variable = etaa0
    function = ic_func_etaa0
  [../]
[]
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
[Functions]
  [./ic_func_etaa0]
    type = ParsedFunction
    vars = 'kappa   mu      '
    vals = '0.0287  0.171'
    value = '0.5*(1.0-tanh((x-10)*sqrt(mu/2.0/kappa)))'
  [../]
  [./ic_func_etab0]
    type = ParsedFunction
    vars = 'kappa   mu     '
    # vals = '0.225  1.33e-4'
    vals = '0.0287  0.171'
    value = '0.5*(1.0+tanh((x-10)*sqrt(mu/2.0/kappa)))'
  [../]
  # [./ic_func_w]
  #   type = ParsedFunction
  #   vars = 'ha   hb     '
  #   # vals = 'ha  hb'
  #   value = '-6.58e-7*ha-6.27e-7*hb'
  # [../]
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
    args = 'etab0 w'
  [../]
  # [./ACa0_int]
  #   type = ACInterface
  #   variable = etaa0
  #   kappa_name = kappa
  # [../]
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
    args = 'etaa0 w'
  [../]
  # [./ACb0_int]
  #   type = ACInterface
  #   variable = etab0
  #   kappa_name = kappa
  # [../]
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
    args = 'etaa0 etab0' # in this case chi (the susceptibility) is simply a constant
  [../]
  [./Diffusion]
    type = MatDiffusion
    variable = w
    D_name = Dchi
    args = 'etaa0 etab0'
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
  # [./Ea]
  #   type = DerivativeParsedMaterial
  #   args = 'w T'
  #   f_name = Ea
  #   material_property_names = 'Vm'
  #   constant_names = 'Tm_cu Tm_Ni L_ni L_cu'
  #   constant_expressions = '1358 1728 0.147 0.108'
  #   function = 'Vm*(L_cu/Tm_cu*(T-Tm_cu)-L_ni/Tm_Ni*(T-Tm_Ni))'
  #   output_properties = 'Ea'
  #   outputs = exodus
  # [../]
  # [./fsni]
  #   type = DerivativeParsedMaterial
  #   args = 'T'
  #   f_name = fsni
  #   # material_property_names = 'Vm'
  #   constant_names = 'Tm_Ni L_ni '
  #   constant_expressions = '1728 0.147'
  #   function = 'L_ni/Tm_Ni*(T-Tm_Ni)'
  #   output_properties = 'fsni'
  #   outputs = exodus
  # [../]
  [./omegaa]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = omegaa
    material_property_names = 'Vm kB Ea fsni'
    # function = '-0.5*w^2/Vm^2/kB-w/Vm*caeq'
    function = 'fsni-kB*T/Vm*plog(1+exp((w-Ea)/kB/T),1e-2)'
    derivative_order = 2
    output_properties = 'omegaa'
    outputs = exodus
  [../]
  [./omegab]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = omegab
    material_property_names = 'Vm kB Ea'
    # function = '-0.5*w^2/Vm^2/kb-w/Vm*cbeq-S*(T-Tm)'
    function = '-kB*T/Vm*plog(1+exp((w)/kB/T),1e-2)'
    derivative_order = 2
    output_properties = 'omegab'
    outputs = exodus
  [../]
  [./rhoa]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = rhoa
    material_property_names = 'Vm kB Ea'
    function = '1.0/Vm*exp((w-Ea)/kB/T)/(1+exp((w-Ea)/kB/T))'
    derivative_order = 2
    # enable_jit = false
    output_properties = 'rhoa'
    outputs = exodus
  [../]
  [./rhob]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = rhob
    material_property_names = 'Vm kB'
    function = '1.0/Vm*exp((w)/kB/T)/(1+exp((w)/kB/T))'
    derivative_order = 2
    # enable_jit = false
    output_properties = 'rhob'
    outputs = exodus
  [../]
  [./chis]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = chis
    material_property_names = 'Vm kB Ea'
    function = '1.0/Vm/T/kB*exp((w-Ea)/kB/T)/(1+exp((w-Ea)/kB/T))/(1+exp((w-Ea)/kB/T))'
  [../]
  [./chil]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = chil
    material_property_names = 'Vm kB'
    function = '1.0/Vm/T/kB*exp((w)/kB/T)/(1+exp((w)/kB/T))/(1+exp((w)/kB/T))'
  [../]
  [./chi]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = chi
    material_property_names = 'chis chil ha hb'
    function = 'ha*chis+hb*chil'
    outputs = exodus
    output_properties = 'chi'
  [../]
  [./cs]
    type = DerivativeParsedMaterial
    args = 'w '
    f_name = cs
    material_property_names = 'Vm kB Ea T'
    function = 'exp((w-Ea)/kB/T)/(1+exp((w-Ea)/kB/T))'
  [../]
  [./cl]
    type = DerivativeParsedMaterial
    args = 'w '
    f_name = cl
    material_property_names = 'Vm kB T'
    function = 'exp((w)/kB/T)/(1+exp((w)/kB/T))'
  [../]
  [./c]
    type = DerivativeParsedMaterial
    args = 'w etaa0 etab0'
    f_name = c
    material_property_names = 'cs cl ha hb'
    function = 'ha*cs+hb*cl'
    outputs = exodus
    output_properties = 'c'
  [../]
  [./kappaa]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    d2kappadgrad_etaa_name = d2kappadgrad_etaa
    etaa = etaa0
    etab = etab0
    kappa_bar = 0.0287
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
    kappa_bar = 0.0287
    outputs = exodus
    output_properties = 'kappab'
  [../]
  [./const]
    type = GenericConstantMaterial
    # prop_names =  'L   D    Vm       ka       kB       gab   mu    fsni       Ea        kappa'
    # prop_values = '1.0 1.0  0.01232 1.078e-7 1.078e-7  1.5 1.33e-4 -1.9124e-4  4.546e-5 0.225'
    prop_names =  'L   D     Vm        kB       gab   mu    fsni        Ea     T   kappa'
    prop_values = '1.0 1.0 1.232e-8 1.38e-10   1.5  0.171  -0.245  5.82e-8 1710 0.0287'
  [../]
  [./Mobility]
    type = DerivativeParsedMaterial
    f_name = Dchi
    material_property_names = 'D chi'
    function = 'D*chi'
    derivative_order = 2
    # enable_jit = false
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
  line_search = basic
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart  -pc_factor_shift_type'
  petsc_options_value = 'hypre    boomeramg      31                    NONZERO'

  l_tol = 1.0e-3
  l_max_its = 30
  nl_max_its = 15
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-8
  # end_time = 1000.0
  num_steps = 1000
  dtmax = 100
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1.0
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
  # file_base = equilibrium_ideal
[]

[Debug]
  show_var_residual_norms = true
[]
