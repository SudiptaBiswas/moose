[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 40
  ny = 40
  xmin = -10
  xmax = 10
  ymin = -10
  ymax = 10
  elem_type = QUAD4
  uniform_refine = 2
[]

[Variables]
  [./w]
    # scaling = 10
  [../]
  [./etaa0]
  [../]
  [./etaa1]
  [../]
  [./etab0]
  [../]

[]

[GlobalParams]
  radius = 0.4
  int_width = 0.1
  # x1 = 0.0
  # y1 = 0.0
  # derivative_order = 2
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
  [./ACa0_bulk]
    type = ADACGrGrMulti
    variable = etaa0
    v =           'etab0 etaa1'
    gamma_names = 'gab gab'

  [../]
  [./ACa0_sw]
    type = ADACSwitching
    variable = etaa0
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    # args = 'etab0 etaa1 w T'
  [../]
  [./ACa0_int1]
    type = ADACInterface2DMultiPhase1
    variable = etaa0
    etas = 'etab0 etaa1 '
    mob_name = L
    # args = 'etaa1 etab0'
    kappa_name = kappa_op
    dkappadgrad_etaa_name = dkappadgrad_etaa
    # d2kappadgrad_etaa_name = d2kappadgrad_etaa
    variable_L = false
  [../]
  [./ACa0_int2]
    type = ADACInterface
    variable = etaa0
    kappa_name = kappa_op
    mob_name = L
    # dkappadgrad_etaa_name = dkappadgrad_etaa
    args = ' etab0 etaa1 '
    variable_L = false
  [../]
  [./ea0_dot]
    type = ADTimeDerivative
    variable = etaa0
  [../]
  [./etaa0_kappa]
    type = ADACKappaFunction
    variable = etaa0
    mob_name = L
    kappa_name = kappa_op
    v = ' etab0 etaa1'
  [../]
  [./ACa1_bulk]
    type = ADACGrGrMulti
    variable = etaa1
    v =           'etab0 etaa0'
    gamma_names = 'gab gab'

  [../]
  [./ACa1_sw]
    type = ADACSwitching
    variable = etaa1
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    # args = 'etab0 etaa0 w T'
  [../]
  [./ACa1_int1]
    type = ADACInterface2DMultiPhase1
    variable = etaa1
    etas = 'etab0 etaa0'
    mob_name = L
    kappa_name = kappa_op
    dkappadgrad_etaa_name = dkappadgrad_etaa
    variable_L = false
    # d2kappadgrad_etaa_name = d2kappadgrad_etaa
  [../]
  [./ACa1_int2]
    type = ADACInterface
    variable = etaa1
    mob_name = L
    kappa_name = kappa_op
    # dkappadgrad_etaa_name = dkappadgrad_etaa
    args = 'etaa0 etab0'
    variable_L = false
  [../]
  [./ea1_dot]
    type = ADTimeDerivative
    variable = etaa1
  [../]
  [./etaa1_kappa]
    type = ADACKappaFunction
    variable = etaa1
    mob_name = L
    kappa_name = kappa_op
    v = ' etab0 etaa0'
  [../]
# Order parameter eta_beta0
[./ACb0_bulk]
  type = ADACGrGrMulti
  variable = etab0
  v =           'etaa0 etaa1'
  gamma_names = 'gab gab'

[../]
[./ACb0_sw]
  type = ADACSwitching
  variable = etab0
  Fj_names  = 'omegaa omegab'
  hj_names  = 'ha     hb'
  # args = 'etaa0 etaa1 w T'
[../]
  [./ACb0_int1]
    type = ADACInterface2DMultiPhase1
    variable = etab0
    etas = 'etaa0 etaa1'
    # args = 'etaa0 etaa1'
    mob_name = L
    kappa_name = kappa_op
    dkappadgrad_etaa_name = dkappadgrad_etaa
    # d2kappadgrad_etaa_name = d2kappadgrad_etaa
    variable_L = false
  [../]
  [./ACb0_int2]
    type = ADACInterface
    variable = etab0
    mob_name = L
    kappa_name = kappa_op
    # dkappadgrad_etaa_name = dkappadgrad_etaa
    args = 'etaa0 etaa1 '
    variable_L = false
  [../]
  [./eb0_dot]
    type = ADTimeDerivative
    variable = etab0
  [../]
  [./etab0_kappa]
    type = ADACKappaFunction
    variable = etab0
    mob_name = L
    kappa_name = kappa_op
    v = ' etaa0 etaa1'
  [../]
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
    args = 'etaa0 etab0 etaa1'
  [../]
  [./coupled_etaa1dot]
    type = ADCoupledSwitchingTimeDerivative
    variable = w
    v = etaa1
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0 etaa1'
  [../]
  [./coupled_etab0dot]
    type = ADCoupledSwitchingTimeDerivative
    variable = w
    v = etab0
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0 etaa1'
  [../]
[]

[Materials]
  [./ha]
    type = ADSwitchingFunctionMultiPhaseMaterial
    h_name = ha
    all_etas = 'etaa0 etab0 etaa1'
    phase_etas = 'etaa0 etaa1'
  [../]
  [./hb]
    type = ADSwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'etaa0 etab0 etaa1'
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
  [./kappaa00]
    type = ADInterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    # d2kappadgrad_etaa_name = d2kappadgrad
    etaa = etaa0
    etab = etab0
    reference_angle = 0
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    outputs = exodus
    output_properties = 'kappa_etaa0_etab0'
  [../]
  [./kappaa10]
    type = ADInterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    # d2kappadgrad_etaa_name = d2kappadgrad
    etaa = etaa1
    etab = etab0
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    reference_angle = 0
    outputs = exodus
    output_properties = 'kappa_etaa1_etab0'
  [../]
  [./kappaa01]
    type = ADInterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    # d2kappadgrad_etaa_name = d2kappadgrad
    etaa = etaa0
    etab = etaa1
    reference_angle = 0
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    outputs = exodus
    output_properties = 'kappa_etaa0_etaa1'
  [../]
  [./kappaa11]
    type = ADInterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    # d2kappadgrad_etaa_name = d2kappadgrad
    etaa = etaa1
    etab = etaa0
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    reference_angle = 0
    outputs = exodus
    output_properties = 'kappa_etaa1_etaa0'
    # output_properties = 'kappaa11'
  [../]
  [./kappab00]
    type = ADInterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    # d2kappadgrad_etaa_name = d2kappadgrad
    etaa = etab0
    etab = etaa0
    anisotropy_strength = 0.05
    reference_angle = 0
    kappa_bar = 0.05
    outputs = exodus
    output_properties = 'kappa_etab0_etaa0'
  [../]
  [./kappab01]
    type = ADInterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    # d2kappadgrad_etaa_name = d2kappadgrad
    etaa = etab0
    etab = etaa1
    anisotropy_strength = 0.05
    reference_angle = 0
    kappa_bar = 0.05
    outputs = exodus
    output_properties = 'kappa_etab0_etaa1'
  [../]
  [./kappa_op]
    type = ADGrandPotentialAnisoInterface
    # kappaa_names = 'kappab00 kappab01 kappaa00 kappaa01 kappaa10 kappaa11'
    # dkappadgrad_etaa_names = 'dkappadgrad_etab00 dkappadgrad_etab01 dkappadgrad_etaa00 dkappadgrad_etaa01 dkappadgrad_etaa10 dkappadgrad_etaa11'
    # d2kappadgrad_etaa_names = 'd2kappadgrad_etab00 d2kappadgrad_etab01 d2kappadgrad_etaa00 d2kappadgrad_etaa01 d2kappadgrad_etaa10 d2kappadgrad_etaa11'
    etas = 'etab0 etaa0 etaa1'
    outputs = exodus
    # output_properties = 'kappa_op dkappadgrad_etaa d2kappadgrad_etaa'
  [../]
  [./const]
    type = ADGenericConstantMaterial
    prop_names =  'L     D    chi  Vm   ka    caeq kb    cbeq  gab mu   S   Tm   kappa'
    prop_values = '33.33 1.0  0.1  1.0  10.0  0.1  10.0  0.9   4.5 10.0 1.0 5.0  0.1'
  [../]
  # [./const_ad]
  #   type = ADGenericConstantMaterial
  #   prop_names =  'adL  '
  #   prop_values = '33.33 '
  # [../]
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
  automatic_scaling = true
  # line_search = none
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_factor_shift_type'
  petsc_options_value = 'hypre    boomeramg      31 nonzero'
  # petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  # petsc_options_value = 'lu       superlu_dist '
  # petsc_options_iname = '-pc_type -pc_factor_shift_type'
  # petsc_options_value = 'lu       nonzero '
  # petsc_options = '-ksp_converged_reason -snes_converged_reason -snes_linesearch_monitor -ksp_monitor_true_residual'

  # petsc_options = '-ksp_monitor_true_residual'
  # petsc_options_iname = '-ksp_gmres_restart -pc_type -mg_levels_pc_type -mg_levels_sub_pc_type -ksp_type -mg_levels_ksp_type -mat_mffd_type -mat_mffd_err'
  # petsc_options_value = '201                hmg      bjacobi            sor                    fgmres    gmres               ds             1e-4'
  # automatic_scaling = true

  l_tol = 1.0e-3
  l_max_its = 20
  nl_max_its = 20
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-8
  end_time = 20.0
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.0005
    cutback_factor = 0.7
    growth_factor = 1.2
  [../]
[]

[Adaptivity]
 initial_steps = 2
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
  csv = true
  exodus = true
  perf_graph = true
  # file_base = solidification_multiop_test
[]
