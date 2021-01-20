[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  xmin = -500
  xmax = 500
  ymin = -500
  ymax = 500
  uniform_refine = 2
[]

[GlobalParams]
  radius = 50.0
  int_width = 10
  x1 = 0
  y1 = 0
  derivative_order = 2
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
  # [./T]
  # [../]
[]

[AuxKernels]
  # [./T]
  #   type = FunctionAux
  #   # function = 95.0+2.0*(y-1.0*t)
  #   function = 1710
  #   variable = T
  #   execute_on = 'initial timestep_begin'
  # [../]
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
    type = SmoothCircleIC
    variable = w
    # note w = A*(c-cleq), A = 1.0, cleq = 0.0 ,i.e., w = c (in the matrix/liquid phase)
    outvalue = -3.81e-5 #-6.58e-7
    invalue =  -3.63e-5 #-6.27e-7
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
  [./ACb0_int]
    type = ACInterface
    variable = etab0
    kappa_name = kappa
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
    args = 'w'
    f_name = omegaa
    material_property_names = 'Vm ka Ea fsni T'
    # function = '-0.5*w^2/Vm^2/ka-w/Vm*caeq'
    function = 'fsni-ka*T/Vm*plog(1+exp((w-Ea)/ka/T),1e-2)'
    # function = 'fsni-ka*T/Vm*log(1+exp((w-Ea)/ka/T))'
    derivative_order = 2
    output_properties = 'omegaa'
    outputs = exodus
  [../]
  [./omegab]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = omegab
    material_property_names = 'Vm ka Ea T'
    # function = '-0.5*w^2/Vm^2/kb-w/Vm*cbeq-S*(T-Tm)'
    function = '-ka*T/Vm*plog(1+exp((w)/ka/T),1e-2)'
    # function = '-ka*T/Vm*log(1+exp((w)/ka/T))'
    derivative_order = 2
    output_properties = 'omegab'
    outputs = exodus
  [../]
  [./rhoa]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = rhoa
    material_property_names = 'Vm ka Ea T'
    function = '1.0/Vm*exp((w-Ea)/ka/T)/(1+exp((w-Ea)/ka/T))'
    derivative_order = 2
    # enable_jit = false
    output_properties = 'rhoa'
    outputs = exodus
  [../]
  [./rhob]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = rhob
    material_property_names = 'Vm ka T'
    function = '1.0/Vm*exp((w)/ka/T)/(1+exp((w)/ka/T))'
    derivative_order = 2
    # enable_jit = false
    output_properties = 'rhob'
    outputs = exodus
  [../]
  [./chis]
    type = DerivativeParsedMaterial
    args = 'w '
    f_name = chis
    material_property_names = 'Vm kB Ea T'
    function = '1.0/Vm/T/kB*exp((w-Ea)/kB/T)/(1+exp((w-Ea)/kB/T))/(1+exp((w-Ea)/kB/T))'
  [../]
  [./chil]
    type = DerivativeParsedMaterial
    args = 'w '
    f_name = chil
    material_property_names = 'Vm kB T'
    function = '1.0/Vm/T/kB*exp((w)/kB/T)/(1+exp((w)/kB/T))/(1+exp((w)/kB/T))'
  [../]
  [./chi]
    type = DerivativeParsedMaterial
    args = 'w '
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
  #   material_property_names = 'ha hb Dl Ds'
  #   function = 'ha*Ds+hb*Dl'
  #   outputs = exodus
  #   output_properties = 'chi'
  # [../]
  [./kappaa]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    d2kappadgrad_etaa_name = d2kappadgrad_etaa
    etaa = etaa0
    etab = etab0
    kappa_bar = 0.166 #0.287
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
    kappa_bar = 0.166 #0.287
    outputs = exodus
    output_properties = 'kappab'
  [../]
  [./const]
    type = GenericConstantMaterial
    prop_names =  'L   Vm        ka       kB       gab   mu    fsni        Ea  T   kappa  D   Ds'
    # prop_values = '1.0 1.232e-8 1.38e-9 1.38e-9  1.5  1.71  -0.245  5.82e-7 1710 0.0287 0.1 1.0'
    prop_values = '10.0 1.232e-5 7.99e-9 7.99e-9  1.5  0.00988  -1.42e-2  3.37e-6 1710 0.0287 0.01 1.0'
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

[Postprocessors]
  [./numDOFs]
    type = NumDOFs
  [../]
  # [./TotalEnergy]
  #   type = ElementIntegralVariablePostprocessor
  #   variable = total_energy
  # [../]
  [./dt]
    type = TimestepSize
  [../]
  [./feature_counter]
    type = FeatureFloodCount
    variable = etaa0
    threshold = 0
    compute_var_to_feature_map = true
    use_displaced_mesh = false
    execute_on = timestep_end
  [../]
  [./interface]
    type = FindValueOnLine
    v = etaa0
    target = 0.5
    start_point = '0 0 0'
    end_point = '100 0 0'
    depth = 50
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
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart  -pc_factor_shift_type'
  petsc_options_value = 'hypre    boomeramg      31                    NONZERO'

  l_tol = 1.0e-3
  l_max_its = 30
  nl_max_its = 15
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-8
  end_time = 10.0
  # dt = 1e-5
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.01
    cutback_factor = 0.95
    growth_factor = 1.05
    optimal_iterations = 6
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
  csv = true
[]

[Debug]
  show_var_residual_norms = true
[]
