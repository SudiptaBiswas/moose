[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 20
  ny = 20
  xmin = 0
  xmax = 100
  ymin = 0
  ymax = 100
  uniform_refine = 3
[]

[GlobalParams]
  # x1 = 50
  # x2 = 100
  # y1 = 0
  # y2 = 10
  # radius = 2.0
  int_width = 1.16
  derivative_order = 2
  dom_dim = 2D
  amplitude = 0.5
  sub_height = 10.0
  ncycl = 50
[]

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
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'etaa0 etab0'
  [../]
  [./T]
    type = FunctionAux
    function = 1710+0.134375*(y-10-0.025*t)
    variable = T
    execute_on = 'initial timestep_begin'
  [../]
[]

[ICs]
  # [./w]
  #   type = SmoothCircleIC
  #   variable = w
  #   outvalue = -6.85e-7 #-6.27e-7
  #   invalue = -6.58e-7
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
  # [./w]
  #   type = BoundingBoxIC
  #   variable = w
  #   # x1 = 0
  #   # x2 = 20
  #   # y1 = 0
  #   # y2 = 5
  #   # note w = A*(c-cleq), A = 1.0, cleq = 0.0 ,i.e., w = c (in the matrix/liquid phase)
  #   outside = -6.85e-7
  #   inside = -6.58e-7
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
  [./c_IC]
    type = SinusoidalSurfaceIC
    var_type = nonconserved
    variable = w
    outvalue = -6.85e-5
    invalue = -6.58e-5
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
    args = 'etaa0 etab0'
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
    # function = '-0.5*w^2/Vm^2/ka-w/Vm*caeq'
    function = 'fsni-kB*T/Vm*plog(1+exp((w-Ea)/kB/T),1e-2)'
    derivative_order = 2
    output_properties = 'omegaa'
    outputs = exodus
  [../]
  [./omegab]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = omegab
    material_property_names = 'Vm kB Ea '
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
    output_properties = 'rhob'
    outputs = exodus
  [../]
  [./int]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = rhodiff
    material_property_names = 'rhoa rhob'
    constant_names = 'int_width a'
    constant_expressions = '1.16 1/2/sqrt(2)'
    function = 'a*int_width*(rhob-rhoa)'
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
    args = 'w etaa0 etab0'
    f_name = chi
    material_property_names = 'chis chil ha hb'
    function = 'ha*chis+hb*chil'
    outputs = exodus
    output_properties = 'chi'
  [../]
  # [./D]
  #   type = DerivativeParsedMaterial
  #   args = 'w '
  #   f_name = D
  #   material_property_names = 'ha hb'
  #   constant_names =  'Dl Ds'
  #   constant_expressions = '0.01 1e-5'
  #   function = 'ha*Ds+hb*Dl'
  #   outputs = exodus
  #   output_properties = 'D'
  # [../]
  [./cs]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = cs
    material_property_names = 'Vm kB Ea'
    function = 'exp((w-Ea)/kB/T)/(1+exp((w-Ea)/kB/T))'
  [../]
  [./cl]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = cl
    material_property_names = 'Vm kB'
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
    anisotropy_strength = 0.05
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
    anisotropy_strength = 0.05
    outputs = exodus
    output_properties = 'kappab'
  [../]
  [./D]
    type = DerivativeParsedMaterial
    args = 'w '
    f_name = D
    material_property_names = 'ha hb'
    constant_names =  'Dl Ds'
    constant_expressions = '0.1 1e-4'
    function = 'ha*Ds+hb*Dl'
    outputs = exodus
    output_properties = 'D'
  [../]
  [./const]
    type = GenericConstantMaterial
    prop_names =  'L    Vm        kB       gab   mu    fsni        Ea   kappa'
    prop_values = '10.0 1.232e-8 1.38e-10   1.5  0.171  -0.245  5.82e-8 0.0287'
  [../]
  [./Mobility]
    type = DerivativeParsedMaterial
    f_name = Dchi
    args = 'w etaa0 etab0'
    material_property_names = 'D chi'
    function = 'D*chi'
    derivative_order = 2
    # enable_jit = false
  [../]
[]

[Postprocessors]
  [./dt]
    type = TimestepSize
  [../]
  # [./interface]
  #   type = FindValueOnLine
  #   v = etaa0
  #   target = 0.5
  #   start_point = '0 0 0'
  #   end_point = '0 1000 0'
  #   depth = 100
  # [../]
  [./eta]
    type = ElementIntegralVariablePostprocessor
    variable = etaa0
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
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart  -pc_factor_shift_type'
  petsc_options_value = 'hypre    boomeramg      31                    NONZERO'
  # petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap -pc_factor_shift_type'
  # petsc_options_value = 'asm         31   preonly   ilu      1 NONZERO'
  # petsc_options =  '-snes_converged_reason -ksp_converged_reason'
  l_tol = 1.0e-3
  l_max_its = 30
  nl_max_its = 15
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-10
  end_time = 10000
  # dt = 0.001
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.0005
    # cutback_factor = 0.95
    growth_factor = 1.2
    optimal_iterations = 8
    # iteration_window = 0
    # linear_iteration_ratio = 100
  [../]
 #  [./Predictor]
 #   type = SimplePredictor
 #   scale = 1
 # [../]
[]

[Adaptivity]
 initial_steps = 5
 max_h_level = 3
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
  # interval = 100
  exodus = true
  csv = true
[]

[Debug]
  show_var_residual_norms = true
[]
