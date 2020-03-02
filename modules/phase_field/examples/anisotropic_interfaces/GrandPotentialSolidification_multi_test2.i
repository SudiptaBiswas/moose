[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 60
  ny = 40
  xmin = -15
  xmax = 15
  ymin = -10
  ymax = 10
  uniform_refine = 3
[]

[GlobalParams]
  radius = 0.5
  int_width = 0.2
  # x1 = 0.0
  # y1 = 0.0
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
  # [./T]
  # [../]
[]

[AuxVariables]
  [./bnds]
  [../]
  [./T]
    initial_condition = -0.5
  [../]
[]

[AuxKernels]
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'etaa0 etaa1 etab0'
  [../]
[]

[ICs]
  [./w]
    type = SpecifiedSmoothCircleIC
    variable = w
    x_positions = '-5 5'
    y_positions = '0 0'
    z_positions = '0 0'
    radii = '0.5 0.5'
    outvalue = -4 #-6.27e-7
    invalue = 0
  [../]
  [./etaa0]
    type = SmoothCircleIC
    variable = etaa0
    #Solid phase
    x1 = -5
    y1 = 0
    outvalue = 0.0
    invalue = 1.0
  [../]
  [./etaa1]
    type = SmoothCircleIC
    variable = etaa1
    #Solid phase
    x1 = 5
    y1 = 0
    outvalue = 0.0
    invalue = 1.0
  [../]
  [./etab0]
    type = SpecifiedSmoothCircleIC
    variable = etab0
    #Liquid phase
    x_positions = '-5 5'
    y_positions = '0 0'
    z_positions = '0 0'
    radii = '0.5 0.5'
    outvalue = 1.0
    invalue = 0.0
  [../]
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
[]

[Kernels]
# Order parameter eta_alpha0
  [./ACa0_bulk]
    type = ACGrGrMulti
    variable = etaa0
    v =           'etab0 etaa1'
    gamma_names = 'gab   gab'
  [../]
  [./ACa0_sw]
    type = ACSwitching
    variable = etaa0
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etab0 w T etaa1'
  [../]
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
    args = 'etaa1 etab0'
  [../]
  [./ea0_dot]
    type = TimeDerivative
    variable = etaa0
  [../]

  [./ACa1_bulk]
    type = ACGrGrMulti
    variable = etaa1
    v =           'etab0 etaa0'
    gamma_names = 'gab   gab '
  [../]
  [./ACa1_sw]
    type = ACSwitching
    variable = etaa1
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etab0 w T etaa0'
  [../]
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
    args = 'etaa0 etab0'
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
    args = 'etaa0 w T etaa1'
  [../]
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
    args = 'etaa0 etaa1'
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
  # [./etaa0_dot_T]
  #   type = CoefCoupledTimeDerivative
  #   variable = T
  #   v = etaa1
  #   coef = -5.0
  # [../]
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
  [./kappaa]
    type = InterfaceOrientationMultiphaseMaterial2
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    d2kappadgrad_etaa_name = d2kappadgrad_etaa
    etaa = etaa0
    etab = 'etab0 etaa1'
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    # outputs = exodus
    output_properties = 'kappaa'
  [../]
  [./kappaa1]
    type = InterfaceOrientationMultiphaseMaterial2
    kappa_name = kappaa1
    dkappadgrad_etaa_name = dkappadgrad_etaa1
    d2kappadgrad_etaa_name = d2kappadgrad_etaa1
    etaa = etaa1
    etab = 'etab0 etaa0'
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    # outputs = exodus
    output_properties = 'kappaa1'
  [../]
  [./kappab]
    type = InterfaceOrientationMultiphaseMaterial2
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
    d2kappadgrad_etaa_name = d2kappadgrad_etab
    etaa = etab0
    etab = 'etaa0 etaa1'
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    # outputs = exodus
    output_properties = 'kappab'
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
    # outputs = exodus
  [../]
  [./cl]
    type = DerivativeParsedMaterial
    args = 'w '
    f_name = cb
    material_property_names = 'Vm ka cbeq'
    function = 'w/Vm/ka+cbeq'
    output_properties = 'cb'
    # outputs = exodus
  [../]
  [./c]
    type = DerivativeParsedMaterial
    args = 'w etaa0 etab0 etaa1 T'
    f_name = c
    material_property_names = 'ca cb ha hb'
    function = 'ha*ca+hb*cb'
    # outputs = exodus
    # output_properties = 'c'
  [../]
  # [./noise_prefactor]
  #   type = DerivativeParsedMaterial
  #   args = 'etaa0 etab0 etaa1'
  #   f_name = noise
  #   # material_property_names = 'ca cb ha hb'
  #   function = 'etaa0*etab0+etaa'
  #   outputs = exodus
  #   output_properties = 'noise'
  # [../]
  [./const]
    type = GenericConstantMaterial
    prop_names =  'L     D    chi  Vm   ka    caeq kb    cbeq  gab mu   S   Tm'
    prop_values = '33.33 1.0  0.1  1.0  10.0  0.1  10.0  0.9   1.5 10.0 1.0 1.0'
  [../]
  [./Mobility]
    type = ParsedMaterial
    f_name = Dchi
    material_property_names = 'D chi'
    function = 'D*chi'
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
  [./etab0]
    type = ElementIntegralVariablePostprocessor
    variable = etab0
  [../]
  [./c]
    type = ElementIntegralMaterialProperty
    mat_prop = c
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
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_factor_shift_type'
  petsc_options_value = 'hypre    boomeramg      31 nonzero'
  # petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap -pc_factor_shift_type'
  # petsc_options_value = 'asm         31   preonly   lu      1 nonzero'
   l_tol = 1.0e-3
  l_max_its = 30
  nl_max_its = 15
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-8
  end_time = 20.0
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

[Debug]
  show_var_residual_norms = true
[]
