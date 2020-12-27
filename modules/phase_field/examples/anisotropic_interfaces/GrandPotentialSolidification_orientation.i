[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 40
  ny = 40
  xmin = -20
  xmax = 20
  ymin = -20
  ymax = 20
  uniform_refine = 3
[]

[GlobalParams]
  radius = 0.2
  int_width = 0.1
  x1 = 0.0
  y1 = 0.0
  # derivative_order = 2
  reference_angle = 45
  kappa_name = kappa_op
  dkappadgrad_etaa_name = dkappadgrad_etaa
  variable_L = false
  mob_name = L
  anisotropy_strength = 0.05
  kappa_bar = 0.05
[]

[Variables]
  [./w]
  [../]
  [./etaa0]
  [../]
  [./etab0]
  [../]
  # [./T]
  # [../]
[]

[AuxVariables]
  [./bnds]
  [../]
  [./T]
    initial_condition = -2
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
    # args = 'etab0 w T'
  [../]
  [./ACa0_int1]
    type = ADACInterface2DMultiPhase1
    variable = etaa0
    etas = 'etab0'
    # kappa_name = kappa_etaa0_etab0
    # dkappadgrad_etaa_name = dkappadgrad_etaa0_etab0
    # d2kappadgrad_etaa_name = d2kappadgrad_etaa0_etab0
  [../]
  [./ACa0_int2]
    type = ADACInterface
    variable = etaa0
    # kappa_name = kappa_etaa0_etab0
    # dkappadgrad_etaa_name = dkappadgrad_etaa0_etab0
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
    # args = 'etaa0 w T'
  [../]
  [./ACb0_int1]
    type = ADACInterface2DMultiPhase1
    variable = etab0
    etas = 'etaa0'
    # kappa_name = kappa_etab0_etaa0
    # dkappadgrad_etaa_name = dkappadgrad_etab0_etaa0
  [../]
  [./ACb0_int2]
    type = ADACInterface
    variable = etab0
    # kappa_name = kappa_etab0_etaa0
  [../]
  [./eb0_dot]
    type = ADTimeDerivative
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
    diffusivity = Dchi
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
  # [./coupled_etaa0dot_int]
  #   type = ADAntitrappingCurrent
  #   variable = w
  #   v = etaa0
  #   f_name = rhodiff
  # [../]
  # [./coupled_etab0dot_int]
  #   type = ADAntitrappingCurrent
  #   variable = w
  #   v = etab0
  #   f_name = rhodiff
  # [../]
  # [./T_dot]
  #   type = ADTimeDerivative
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
    outputs = exodus
  [../]
  [./omegab]
    type = ADDerivativeParsedMaterial
    args = 'w T'
    f_name = omegab
    material_property_names = 'Vm kb cbeq S Tm'
    function = '-0.5*w^2/Vm^2/kb-w/Vm*cbeq-S*(T-Tm)'
    outputs = exodus
  [../]
  [./rhoa]
    type = ADDerivativeParsedMaterial
    args = 'w'
    f_name = rhoa
    material_property_names = 'Vm ka caeq'
    function = 'w/Vm^2/ka + caeq/Vm'
    outputs = exodus
  [../]
  [./rhob]
    type = ADDerivativeParsedMaterial
    args = 'w'
    f_name = rhob
    material_property_names = 'Vm kb cbeq'
    function = 'w/Vm^2/kb + cbeq/Vm'
    outputs = exodus
  [../]
  [./rho]
    type = ADDerivativeParsedMaterial
    args = 'w'
    f_name = rho
    material_property_names = 'rhoa rhob ha hb'
    function = 'hb*rhob+ha*rhoa'
    outputs = exodus
  [../]
  [./int]
    type = ADDerivativeParsedMaterial
    args = 'w'
    f_name = rhodiff
    material_property_names = 'rhoa rhob'
    constant_names = 'int_width a b'
    constant_expressions = '0.2 1/2/sqrt(2) 1.0'
    function = 'a*int_width*b*(rhob-rhoa)'
    output_properties = 'rhodiff'
    outputs = exodus
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
    # d2kappadgrad_etaa_name = d2kappadgrad
    etaa = etaa0
    etab = etab0
    outputs = exodus
    output_properties = 'kappa_etaa0_etab0'
  [../]
  [./kappab]
    type = ADInterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    # d2kappadgrad_etaa_name = d2kappadgrad
    etaa = etab0
    etab = etaa0
    outputs = exodus
    output_properties = 'kappa_etab0_etaa0'
  [../]
  [./kappa_op]
    type = ADGrandPotentialAnisoInterfaceOld
    etas = 'etab0 etaa0'
    outputs = exodus
  [../]
  [./const]
    type = ADGenericConstantMaterial
    prop_names =  'L     D    chi  Vm   ka    caeq kb    cbeq   gab mu   S   Tm'
    prop_values = '33.33 1.0  0.1  1.0  10.0  0.1  10.0  0.9   1.5 10.0 1.0 1.0'
  [../]
  [./Mobility]
    type = ADParsedMaterial
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
  solve_type = NEWTON
  line_search = basic
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist '
  # petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  # petsc_options_value = 'hypre    boomeramg      31'
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
 initial_steps = 3
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
  # interval = 5
  exodus = true
[]
