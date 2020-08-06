[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 40
  ny = 40
  xmin = -10
  xmax = 10
  ymin = -10
  ymax = 10
  uniform_refine = 2
[]

[GlobalParams]
  radius = 0.4
  int_width = 0.1
  # use_tolerance = false
  mob_name = L
  kappa_name = kappa_op
  dkappadgrad_etaa_name = dkappadgrad_etaa
  variable_L = false
  d2kappadgrad_etaa_name = d2kappadgrad_etaa
[]

[Variables]
  [./w]
  [../]
  [./etaa0]
  [../]
  [./etab0]
  [../]
  [./etaa1]
  [../]
  # [./T]
  # [../]
[]

[AuxVariables]
  [./bnds]
  [../]
  [./T]
    initial_condition = -0.5
  [../]
  [./kappa_grad_x]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./kappa_grad_y]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [grad_etaa0_x]
    family = MONOMIAL
    order = CONSTANT
  []
  [grad_etaa0_y]
    family = MONOMIAL
    order = CONSTANT
  []

  [grad_etaa1_x]
    family = MONOMIAL
    order = CONSTANT
  []
  [grad_etaa1_y]
    family = MONOMIAL
    order = CONSTANT
  []

  [grad_etab_x]
    family = MONOMIAL
    order = CONSTANT
  []
  [grad_etab_y]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'etaa0 etaa1 etab0'
    # v = 'etaa0 etab0'
  [../]
  [./kappa_grad_x]
    type = MaterialRealVectorValueAux
    property = dkappadgrad_etaa
    variable = kappa_grad_x
    component = 0
  [../]
  [./kappa_grad_y]
    type = MaterialRealVectorValueAux
    property = dkappadgrad_etaa
    variable = kappa_grad_y
    component = 1
  [../]
  [./grad_etaa0x]
    type = VariableGradientComponent
    variable = grad_etaa0_x
    gradient_variable = etaa0
    component = x
  [../]
  [./grad_etaa0y]
    type = VariableGradientComponent
    variable = grad_etaa0_y
    gradient_variable = etaa0
    component = y
  [../]

  [./grad_etaa1x]
    type = VariableGradientComponent
    variable = grad_etaa1_x
    gradient_variable = etaa1
    component = x
  [../]
  [./grad_etaa1y]
    type = VariableGradientComponent
    variable = grad_etaa1_y
    gradient_variable = etaa1
    component = y
  [../]

  [./grad_etabx]
    type = VariableGradientComponent
    variable = grad_etab_x
    gradient_variable = etab0
    component = x
  [../]
  [./grad_etaby]
    type = VariableGradientComponent
    variable = grad_etab_y
    gradient_variable = etab0
    component = y
  [../]
[]

[ICs]
  # [./w]
  #   type = SmoothCircleIC
  #   variable = w
  #   # note w = A*(c-cleq), A = 1.0, cleq = 0.0 ,i.e., w = c (in the matrix/liquid phase)
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
  [./etaa0]
    type = SmoothCircleIC
    variable = etaa0
    #Solid phase
    x1 = -2
    y1 = 0
    outvalue = 0.0
    invalue = 1.0
  [../]
  [./etaa1]
    type = SmoothCircleIC
    variable = etaa1
    #Solid phase
    x1 = 2
    y1 = 0
    outvalue = 0.0
    invalue = 1.0
  [../]
  [./etab0]
    type = SpecifiedSmoothCircleIC
    variable = etab0
    #Liquid phase
    x_positions = '-2 2'
    y_positions = '0 0'
    z_positions = '0 0'
    radii = '0.4 0.4'
    outvalue = 1.0
    invalue = 0.0
  [../]
  [./w]
    type = SpecifiedSmoothCircleIC
    variable = w
    #Liquid phase
    x_positions = '-2 2'
    y_positions = '0 0'
    z_positions = '0 0'
    radii = '0.4 0.4'
    outvalue = -4.0
    invalue = 0.0
  [../]
[]

[Kernels]
# Order parameter eta_alpha0
  [./ACa0_bulk]
    type = ACGrGrMulti
    variable = etaa0
    v =           'etab0 etaa1'
    gamma_names = 'gab gab'
  [../]
  [./ACa0_sw]
    type = ACSwitching
    variable = etaa0
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etab0 etaa1 w T'
  [../]
  [./ACa0_int1]
    type = ACInterface2DMultiPhase1
    variable = etaa0
    etas = 'etab0 etaa1'
    # args = 'etab0 etaa1'
  [../]
  [./ACa0_int2]
    type = ACInterface2DMultiPhase2
    variable = etaa0
    args = 'etab0 etaa1'
  [../]
  [./ea0_dot]
    type = TimeDerivative
    variable = etaa0
  [../]
  [./etaa0_kappa]
    type = ACKappaFunction
    variable = etaa0
    v = ' etab0 etaa1'
  [../]

  [./ACa1_bulk]
    type = ACGrGrMulti
    variable = etaa1
    v =           'etab0 etaa0'
    gamma_names = 'gab gab'
  [../]
  [./ACa1_sw]
    type = ACSwitching
    variable = etaa1
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etab0 etaa0 w T'
  [../]
  [./ACa1_int1]
    type = ACInterface2DMultiPhase1
    variable = etaa1
    etas = 'etab0 etaa0'
    # args = 'etab0 etaa0'
  [../]
  [./ACa1_int2]
    type = ACInterface2DMultiPhase2
    variable = etaa1
    args = 'etaa0 etab0'
  [../]
  [./ea1_dot]
    type = TimeDerivative
    variable = etaa1
  [../]
  [./etaa1_kappa]
    type = ACKappaFunction
    variable = etaa1
    v = ' etab0 etaa0'
  [../]
# Order parameter eta_beta0
  [./ACb0_bulk]
    type = ACGrGrMulti
    variable = etab0
    v =           'etaa0 etaa1'
    gamma_names = 'gab gab'
  [../]
  [./ACb0_sw]
    type = ACSwitching
    variable = etab0
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etaa0 etaa1 w T'
  [../]
  [./ACb0_int1]
    type = ACInterface2DMultiPhase1
    variable = etab0
    # args = 'etaa0 etaa1'
    etas = 'etaa0 etaa1'
  [../]
  [./ACb0_int2]
    type = ACInterface2DMultiPhase2
    variable = etab0
    args = 'etaa0 etaa1'
  [../]
  [./eb0_dot]
    type = TimeDerivative
    variable = etab0
  [../]
  [./etab0_kappa]
    type = ACKappaFunction
    variable = etab0
    v = ' etaa0 etaa1'
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
    all_etas = 'etaa0 etaa1 etab0'
    phase_etas = 'etaa0 etaa1'
  [../]
  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'etaa0 etaa1 etab0'
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

  [./kappaa00]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    d2kappadgrad_etaa_name = d2kappadgrad
    etaa = etaa0
    etab = etab0
    reference_angle = 0
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    # use_tolerance = true
    outputs = exodus
    output_properties = 'kappa_etaa0_etab0'
  [../]
  [./kappaa10]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    d2kappadgrad_etaa_name = d2kappadgrad
    etaa = etaa1
    etab = etab0
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    reference_angle = 0
    # use_tolerance = true
    outputs = exodus
    output_properties = 'kappa_etaa1_etab0'
  [../]
  [./kappaa01]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    d2kappadgrad_etaa_name = d2kappadgrad
    etaa = etaa0
    etab = etaa1
    reference_angle = 0
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    # use_tolerance = true
    outputs = exodus
    output_properties = 'kappa_etaa0_etaa1'
  [../]
  [./kappaa11]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    d2kappadgrad_etaa_name = d2kappadgrad
    etaa = etaa1
    etab = etaa0
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    reference_angle = 0
    # use_tolerance = true
    outputs = exodus
    output_properties = 'kappa_etaa1_etaa0'
  [../]
  [./kappab00]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    d2kappadgrad_etaa_name = d2kappadgrad
    etaa = etab0
    etab = etaa0
    anisotropy_strength = 0.05
    reference_angle = 0
    kappa_bar = 0.05
    # use_tolerance = true
    outputs = exodus
    output_properties = 'kappa_etab0_etaa0'
  [../]
  [./kappab01]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    d2kappadgrad_etaa_name = d2kappadgrad
    etaa = etab0
    etab = etaa1
    anisotropy_strength = 0.05
    reference_angle = 0
    kappa_bar = 0.05
    # use_tolerance = true
    outputs = exodus
    output_properties = 'kappa_etab0_etaa1'
  [../]
  [./kappa_op]
    type = GrandPotentialAnisoInterface
    etas = 'etab0 etaa0 etaa1'
    outputs = exodus
    # output_properties = 'kappa_op dkappadgrad_etaa d2kappadgrad_etaa'
  [../]
  [./const]
    type = GenericConstantMaterial
    prop_names =  'L     D    chi  Vm   ka    caeq kb    cbeq  gab mu   S   Tm'
    prop_values = '33.33 1.0  0.1  1.0  10.0  0.1  10.0  0.9   4.5 10.0 1.0 5.0'
  [../]
  # [./const_ad]
  #   type = GenericConstantMaterial
  #   prop_names =  'adL  '
  #   prop_values = '33.33 '
  # [../]
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
  # line_search = none
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre    boomeramg      31'
  # petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  # petsc_options_value = 'lu       superlu_dist '
   l_tol = 1.0e-3
  l_max_its = 30
  nl_max_its = 15
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-10
  end_time = 2.0
  dtmax = 0.05
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.0005
    cutback_factor = 0.7
    growth_factor = 1.2
  [../]
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
  # interval = 5
  exodus = true
[]
