[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 50
  ny = 50
  xmin = -100
  xmax = 100
  ymin = -100
  ymax = 100
  uniform_refine = 2
[]

[GlobalParams]
  radius = 3.0
  int_width = 1.16
  derivative_order = 2
[]

[Variables]
  [./w]
  [../]
  [./etaa0]
  [../]
  [./etaa1]
  [../]
  [./etab0]
  [../]
[]

[AuxVariables]
  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxKernels]
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'etaa0 etab0 etaa1'
  [../]
[]

[ICs]
  [./w]
    type = SpecifiedSmoothCircleIC
    variable = w
    x_positions = '-25 25'
    y_positions = '0 0'
    z_positions = '0 0'
    radii = '3.0 3.0'
    outvalue = -7.0e-7 #-6.27e-7
    invalue = -6.58e-7
  [../]
  [./etaa0]
    type = SmoothCircleIC
    variable = etaa0
    #Solid phase
    x1 = -25
    y1 = 0
    outvalue = 0.0
    invalue = 1.0
  [../]
  [./etaa1]
    type = SmoothCircleIC
    variable = etaa1
    #Solid phase
    x1 = 25
    y1 = 0
    outvalue = 0.0
    invalue = 1.0
  [../]
  [./etab0]
    type = SpecifiedSmoothCircleIC
    variable = etab0
    #Liquid phase
    x_positions = '-25 25'
    y_positions = '0 0'
    z_positions = '0 0'
    radii = '3.0 3.0'
    outvalue = 1.0
    invalue = 0.0
  [../]
[]


[Kernels]
# Order parameter eta_alpha0
  [./ACa0_bulk]
    type = ACGrGrMulti
    variable = etaa0
    v =           'etab0 etaa1'
    gamma_names = 'gab  gab'
  [../]
  [./ACa0_sw]
    type = ACSwitching
    variable = etaa0
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etaa1 etab0 w'
  [../]
  # [./ACa0_int]
  #   type = ACInterface
  #   variable = etaa0
  #   kappa_name = kappa
  # [../]
  [./ACa0_int1]
    type = ACInterface2DMultiPhase1
    variable = etaa0
    etas = 'etab0 etaa1'
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
  # Order parameter eta_alpha0
    [./ACa1_bulk]
      type = ACGrGrMulti
      variable = etaa1
      v =           'etab0 etaa0'
      gamma_names = 'gab  gab'
    [../]
    [./ACa1_sw]
      type = ACSwitching
      variable = etaa1
      Fj_names  = 'omegaa omegab'
      hj_names  = 'ha     hb'
      args = 'etaa0 etab0 w'
    [../]
    # [./ACa0_int]
    #   type = ACInterface
    #   variable = etaa0
    #   kappa_name = kappa
    # [../]
    [./ACa1_int1]
      type = ACInterface2DMultiPhase1
      variable = etaa1
      etas = 'etab0 etaa0'
      kappa_name = kappaa1
      dkappadgrad_etaa_name = dkappadgrad_etaa1
      d2kappadgrad_etaa_name = d2kappadgrad_etaa1
    [../]
    [./ACa1_int2]
      type = ACInterface2DMultiPhase2
      variable = etaa1
      kappa_name = kappaa1
      dkappadgrad_etaa_name = dkappadgrad_etaa1
    [../]
    [./ea1_dot]
      type = TimeDerivative
      variable = etaa1
    [../]
# Order parameter eta_beta0
  [./ACb0_bulk]
    type = ACGrGrMulti
    variable = etab0
    v =           'etaa0 etaa1'
    gamma_names = 'gab   gab'
  [../]
  [./ACb0_sw]
    type = ACSwitching
    variable = etab0
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etaa0 etaa1 w'
  [../]
  # [./ACb0_int]
  #   type = ACInterface
  #   variable = etab0
  #   kappa_name = kappa
  # [../]
  [./ACb0_int1]
    type = ACInterface2DMultiPhase1
    variable = etab0
    etas = 'etaa0 etaa1'
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
    args = 'etaa0 etab0 etaa1'
  [../]
  [./Diffusion]
    type = MatDiffusion
    variable = w
    D_name = Dchi
    args = 'etaa0 etab0 etaa1'
  [../]
  [./coupled_etaa0dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etaa0
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0 etaa1'
  [../]
  [./coupled_etaa1dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etaa1
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0 etaa1'
  [../]
  [./coupled_etab0dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etab0
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0 etaa1'
  [../]
[]

[Materials]
  [./ha]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = ha
    all_etas = 'etaa0 etab0 etaa1'
    phase_etas = 'etaa0 etaa1'
  [../]
  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'etaa0 etab0 etaa1'
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
    material_property_names = 'Vm kB Ea fsni T'
    # function = '-0.5*w^2/Vm^2/ka-w/Vm*caeq'
    function = 'fsni-kB*T/Vm*plog(1+exp((w-Ea)/kB/T),1e-2)'
    derivative_order = 2
    output_properties = 'omegaa'
    outputs = exodus
  [../]
  [./omegab]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = omegab
    material_property_names = 'Vm kB Ea T'
    # function = '-0.5*w^2/Vm^2/kb-w/Vm*cbeq-S*(T-Tm)'
    function = '-kB*T/Vm*plog(1+exp((w)/kB/T),1e-2)'
    derivative_order = 2
    output_properties = 'omegab'
    outputs = exodus
  [../]
  [./rhoa]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = rhoa
    material_property_names = 'Vm kB Ea T'
    function = '1.0/Vm*exp((w-Ea)/kB/T)/(1+exp((w-Ea)/kB/T))'
    derivative_order = 2
    output_properties = 'rhoa'
    outputs = exodus
  [../]
  [./rhob]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = rhob
    material_property_names = 'Vm kB T'
    function = '1.0/Vm*exp((w)/kB/T)/(1+exp((w)/kB/T))'
    derivative_order = 2
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
  [./kappaa0]
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
  [./kappaa1]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappaa1
    dkappadgrad_etaa_name = dkappadgrad_etaa1
    d2kappadgrad_etaa_name = d2kappadgrad_etaa1
    etaa = etaa1
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
  [./const]
    type = GenericConstantMaterial
    prop_names =  'L    D    Vm        kB       gab   mu    fsni        Ea  T   kappa'
    prop_values = '3.33 0.01 1.232e-8 1.38e-10   1.5  0.171  -0.245  5.82e-8 1710 0.0287'
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
  [./etaa0]
    type = ElementIntegralVariablePostprocessor
    variable = etaa0
  [../]
  [./etaa1]
    type = ElementIntegralVariablePostprocessor
    variable = etaa1
  [../]
  # [./interface]
  #   type = FindValueOnLine
  #   v = etaa0
  #   target = 0.5
  #   start_point = '0 0 0'
  #   end_point = '100 0 0'
  #   depth = 50
  # [../]
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
  end_time = 50000.0
  # dt = 0.001
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
     variable = etab0
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
