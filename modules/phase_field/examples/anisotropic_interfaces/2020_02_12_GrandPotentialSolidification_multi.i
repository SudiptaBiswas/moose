[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 40
  ny = 40
  xmin = 0
  xmax = 40
  ymin = 0
  ymax = 40
  elem_type = QUAD4
  uniform_refine = 3
[]

[GlobalParams]
  radius = 0.3
  int_width = 0.1
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
  [./etaa2]
  [../]
  [./etaa3]
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
    v = 'etaa0 etaa1 etaa2 etaa3 etab0'
  [../]
[]

[ICs]
  [./w]
    type = SpecifiedSmoothCircleIC
    variable = w
    # x_positions = '-5 5'
    x_positions = '15 25 15 25'
    y_positions = '15 15 25 25'
    z_positions = '0 0 0 0'
    radii = '0.3 0.3 0.3 0.3 '
    outvalue = -4 #-6.27e-7
    invalue = 0
  [../]
  [./etaa0]
    type = SmoothCircleIC
    variable = etaa0
    #Solid phase
    x1 = 15
    y1 = 15
    outvalue = 0.0
    invalue = 1.0
  [../]
  [./etaa1]
    type = SmoothCircleIC
    variable = etaa1
    #Solid phase
    x1 = 25
    y1 = 15
    outvalue = 0.0
    invalue = 1.0
  [../]
  [./etaa2]
    type = SmoothCircleIC
    variable = etaa2
    #Solid phase
    x1 = 15
    y1 = 25
    outvalue = 0.0
    invalue = 1.0
  [../]
  [./etaa3]
    type = SmoothCircleIC
    variable = etaa3
    #Solid phase
    x1 = 25
    y1 = 25
    outvalue = 0.0
    invalue = 1.0
  [../]
  [./etab0]
    type = SpecifiedSmoothCircleIC
    variable = etab0
    #Liquid phase
    # x_positions = '-5 5'
    # y_positions = '0 0'
    x_positions = '15 25 15 25'
    y_positions = '15 15 25 25'
    z_positions = '0 0 0 0'
    radii = '0.3 0.3 0.3 0.3'
    outvalue = 1.0
    invalue = 0.0
  [../]
[]

[Kernels]
# Order parameter eta_alpha0
  [./ACa0_bulk]
    type = ACGrGrMulti
    variable = etaa0
    v =           'etab0 etaa1 etaa2 etaa3'
    gamma_names = 'gab   gab gab    gab'
  [../]
  [./ACa0_sw]
    type = ACSwitching
    variable = etaa0
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etab0 w T etaa1 etaa2 etaa3'
  [../]
  [./ACa0_int1]
    type = ACInterface2DMultiPhase1
    variable = etaa0
    etas = 'etab0 etaa1 etaa2 etaa3'
    # args = 'etaa1 etab0'
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    d2kappadgrad_etaa_name = d2kappadgrad_etaa
  [../]
  [./ACa0_int2]
    type = ACInterface2DMultiPhase2
    variable = etaa0
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    args = 'etaa1 etab0 etaa2 etaa3'
  [../]
  [./ea0_dot]
    type = TimeDerivative
    variable = etaa0
  [../]

  [./ACa1_bulk]
    type = ACGrGrMulti
    variable = etaa1
    v =           'etab0 etaa0 etaa2 etaa3'
    gamma_names = 'gab   gab gab    gab'
  [../]
  [./ACa1_sw]
    type = ACSwitching
    variable = etaa1
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etab0 w T etaa0 etaa2 etaa3'
  [../]
  [./ACa1_int1]
    type = ACInterface2DMultiPhase1
    variable = etaa1
    etas = 'etab0 etaa0 etaa2 etaa3'
    # args = 'etaa0 etab0'
    kappa_name = kappaa1
    dkappadgrad_etaa_name = dkappadgrad_etaa1
    d2kappadgrad_etaa_name = d2kappadgrad_etaa1
  [../]
  [./ACa1_int2]
    type = ACInterface2DMultiPhase2
    variable = etaa1
    kappa_name = kappaa1
    dkappadgrad_etaa_name = dkappadgrad_etaa1
    args = 'etaa0 etab0 etaa2 etaa3'
  [../]
  [./ea1_dot]
    type = TimeDerivative
    variable = etaa1
  [../]

  [./ACa2_bulk]
    type = ACGrGrMulti
    variable = etaa2
    v =           'etab0 etaa0 etaa1 etaa3'
    gamma_names = 'gab   gab gab    gab'
  [../]
  [./ACa2_sw]
    type = ACSwitching
    variable = etaa2
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etab0 w T etaa0 etaa1 etaa3'
  [../]
  [./ACa2_int1]
    type = ACInterface2DMultiPhase1
    variable = etaa2
    etas = 'etab0 etaa0 etaa1 etaa3'
    # args = 'etaa0 etab0'
    kappa_name = kappaa2
    dkappadgrad_etaa_name = dkappadgrad_etaa2
    d2kappadgrad_etaa_name = d2kappadgrad_etaa2
  [../]
  [./ACa2_int2]
    type = ACInterface2DMultiPhase2
    variable = etaa2
    kappa_name = kappaa2
    dkappadgrad_etaa_name = dkappadgrad_etaa2
    args = 'etaa0 etab0 etaa1 etaa3'
  [../]
  [./ea2_dot]
    type = TimeDerivative
    variable = etaa2
  [../]

  [./ACa3_bulk]
    type = ACGrGrMulti
    variable = etaa3
    v =           'etab0 etaa0 etaa2 etaa1'
    gamma_names = 'gab   gab gab    gab'
  [../]
  [./ACa3_sw]
    type = ACSwitching
    variable = etaa3
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etab0 w T etaa0 etaa2 etaa1'
  [../]
  [./ACa3_int1]
    type = ACInterface2DMultiPhase1
    variable = etaa3
    etas = 'etab0 etaa0 etaa2 etaa1'
    # args = 'etaa0 etab0'
    kappa_name = kappaa3
    dkappadgrad_etaa_name = dkappadgrad_etaa3
    d2kappadgrad_etaa_name = d2kappadgrad_etaa3
  [../]
  [./ACa3_int2]
    type = ACInterface2DMultiPhase2
    variable = etaa3
    kappa_name = kappaa3
    dkappadgrad_etaa_name = dkappadgrad_etaa3
    args = 'etaa0 etab0 etaa2 etaa1'
  [../]
  [./ea3_dot]
    type = TimeDerivative
    variable = etaa3
  [../]
# Order parameter eta_beta0
  [./ACb0_bulk]
    type = ACGrGrMulti
    variable = etab0
    v =           'etaa0 etaa1 etaa2 etaa3'
    gamma_names = 'gab   gab   gab   gab '
  [../]
  [./ACb0_sw]
    type = ACSwitching
    variable = etab0
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etaa0 w T etaa1 etaa2 etaa3'
  [../]
  [./ACb0_int1]
    type = ACInterface2DMultiPhase1
    variable = etab0
    etas = 'etaa0 etaa1 etaa2 etaa3'
    # args = 'etaa0 etaa1'
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
    d2kappadgrad_etaa_name = d2kappadgrad_etab
  [../]
  [./ACb0_int2]
    type = ACInterface2DMultiPhase2
    variable = etab0
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
    args = 'etaa0 etaa1 etaa2 etaa3'
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
    args = 'etaa0 etab0 etaa1 etaa2 etaa3'
  [../]
  [./coupled_etaa1dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etaa1
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0 etaa1 etaa2 etaa3'
  [../]
  [./coupled_etaa2dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etaa2
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0 etaa1 etaa2 etaa3'
  [../]
  [./coupled_etaa3dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etaa3
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0 etaa1 etaa2 etaa3'
  [../]
  [./coupled_etab0dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etab0
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0 etaa1 etaa2 etaa3'
  [../]
[]

[Materials]
  [./ha]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = ha
    all_etas = 'etaa0 etab0 etaa1 etaa2 etaa3'
    phase_etas = 'etaa0 etaa1 etaa2 etaa3'
  [../]
  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'etaa0 etab0 etaa1 etaa2 etaa3'
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
    etab = 'etab0 etaa1 etaa2 etaa3'
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    outputs = exodus
    output_properties = 'kappaa'
  [../]
  [./kappaa1]
    type = InterfaceOrientationMultiphaseMaterial2
    kappa_name = kappaa1
    dkappadgrad_etaa_name = dkappadgrad_etaa1
    d2kappadgrad_etaa_name = d2kappadgrad_etaa1
    etaa = etaa1
    etab = 'etab0 etaa0 etaa2 etaa3'
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    outputs = exodus
    output_properties = 'kappaa1'
  [../]
  [./kappaa2]
    type = InterfaceOrientationMultiphaseMaterial2
    kappa_name = kappaa2
    dkappadgrad_etaa_name = dkappadgrad_etaa2
    d2kappadgrad_etaa_name = d2kappadgrad_etaa2
    etaa = etaa2
    etab = 'etab0 etaa1 etaa0 etaa3'
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    outputs = exodus
    output_properties = 'kappaa2'
  [../]
  [./kappaa3]
    type = InterfaceOrientationMultiphaseMaterial2
    kappa_name = kappaa3
    dkappadgrad_etaa_name = dkappadgrad_etaa3
    d2kappadgrad_etaa_name = d2kappadgrad_etaa3
    etaa = etaa3
    etab = 'etab0 etaa1 etaa2 etaa0'
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    outputs = exodus
    output_properties = 'kappaa3'
  [../]
  [./kappab]
    type = InterfaceOrientationMultiphaseMaterial2
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
    d2kappadgrad_etaa_name = d2kappadgrad_etab
    etaa = etab0
    etab = 'etaa0 etaa1 etaa2 etaa3'
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    outputs = exodus
    output_properties = 'kappab'
  [../]

  [./const]
    type = GenericConstantMaterial
    prop_names =  'L     D    chi  Vm   ka    caeq kb    cbeq  gab mu   S   Tm'
    prop_values = '333.33 1.0  0.1  1.0  10.0  0.1  10.0  0.9   4.5 10.0 1.0 1.0'
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
  # petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_factor_shift_type'
  # petsc_options_value = 'hypre    boomeramg      31 nonzero'
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  petsc_options = '-snes_converged_reason -ksp_converged_reason'
  l_tol = 1.0e-3
  l_max_its = 30
  nl_max_its = 15
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-8
  end_time = 20.0
  # dtmax = 0.05
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.0005
    # cutback_factor = 0.95
    # growth_factor = 1.05
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
  # file_base = 2020_02_12_GrandPotentialSolidification_multi_quarter
[]

[Debug]
  show_var_residual_norms = true
[]
