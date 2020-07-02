[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 20
  ny = 20
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
  # [./etaa1]
  # [../]
  [./etab0]
  [../]
  # [./T]
  # [../]
[]

[GlobalParams]
  radius = 0.5
  int_width = 0.2
  x1 = 0.0
  y1 = 0.0
  # derivative_order = 2
[]

[ICs]
  # [./etaa0]
  #   type = RandomIC
  #   variable = etaa0
  # [../]
  # [./etab0]
  #   type = RandomIC
  #   variable = etab0
  # [../]
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
    v = 'etaa0 etab0'
  [../]
[]

[Kernels]
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
    args = 'etab0 w '
  [../]
  [./ACa0_int1]
    type = ACInterface2DMultiPhase1
    variable = etaa0
    etas = 'etab0 '
    # args = 'etaa1 etab0'
    kappa_name = kappa_etaa0_etab0
    dkappadgrad_etaa_name = dkappadgrad_etaa0_etab0
    d2kappadgrad_etaa_name = d2kappadgrad_etaa0_etab0
    variable_L = false
  [../]
  [./ACa0_int2]
    type = ACInterface2DMultiPhase2
    variable = etaa0
    kappa_name = kappa_etaa0_etab0
    dkappadgrad_etaa_name = dkappadgrad_etaa0_etab0
    args = ' etab0 '
    variable_L = false
  [../]
  [./ea0_dot]
    type = TimeDerivative
    variable = etaa0
  [../]
  # [./etaa0_kappa]
  #   type = ACKappaFunction
  #   variable = etaa0
  #   mob_name = L
  #   kappa_name = kappaa
  #   v = ' etab0'
  # [../]
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
  [./ACb0_int1]
    type = ACInterface2DMultiPhase1
    variable = etab0
    etas = 'etaa0 '
    # args = 'etaa0 etaa1'
    kappa_name = kappa_etab0_etaa0
    dkappadgrad_etaa_name = dkappadgrad_etab0_etaa0
    d2kappadgrad_etaa_name = d2kappadgrad_etab0_etaa0
    variable_L = false
  [../]
  [./ACb0_int2]
    type = ACInterface2DMultiPhase2
    variable = etab0
    kappa_name = kappa_etab0_etaa0
    dkappadgrad_etaa_name = dkappadgrad_etab0_etaa0
    args = 'etaa0 '
    variable_L = false
  [../]
  [./eb0_dot]
    type = TimeDerivative
    variable = etab0
  [../]
  # [./etab0_kappa]
  #   type = ACKappaFunction
  #   variable = etab0
  #   mob_name = L
  #   kappa_name = kappab
  #   v = ' etaa0'
  # [../]

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
    outputs = exodus
    output_properties = 'ha'
  [../]
  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'etaa0 etab0'
    phase_etas = 'etab0'
    outputs = exodus
    output_properties = 'hb'
  [../]
  [./omegaa]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = omegaa
    material_property_names = 'Vm ka caeq'
    function = '-0.5*w^2/Vm^2/ka-w/Vm*caeq'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'omegaa'
  [../]
  [./omegab]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = omegab
    material_property_names = 'Vm kb cbeq S Tm'
    function = '-0.5*w^2/Vm^2/kb-w/Vm*cbeq-S*(T-Tm)'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'omegab'
  [../]
  [./rhoa]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = rhoa
    material_property_names = 'Vm ka caeq'
    function = 'w/Vm^2/ka + caeq/Vm'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'rhoa'
  [../]
  [./rhob]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = rhob
    material_property_names = 'Vm kb cbeq'
    function = 'w/Vm^2/kb + cbeq/Vm'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'rhob'
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
    outputs = exodus
    # output_properties = 'kappaa'
  [../]
  # [./kappaa10]
  #   type = InterfaceOrientationMultiphaseMaterial
  #   kappa_name = kappaa10
  #   dkappadgrad_etaa_name = dkappadgrad_etaa10
  #   d2kappadgrad_etaa_name = d2kappadgrad_etaa10
  #   etaa = etaa1
  #   etab = etab0
  #   anisotropy_strength = 0.05
  #   kappa_bar = 0.05
  #   reference_angle = 0
  #   # outputs = exodus
  #   # output_properties = 'kappaa1'
  # [../]
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
    outputs = exodus
    # output_properties = 'kappab00'
  [../]
  [./kappa_op]
    type = GrandPotentialAnisoInterface
    # kappaa_names = 'kappab00 kappaa00'
    # dkappadgrad_etaa_names = 'dkappadgrad_etab00 dkappadgrad_etaa00'
    # d2kappadgrad_etaa_names = 'd2kappadgrad_etab00 d2kappadgrad_etaa00'
    etas = 'etab0 etaa0'
    outputs = exodus
    output_properties = 'kappa_op dkappadgrad_etaa d2kappadgrad_etaa'
  [../]
  [./const]
    type = GenericConstantMaterial
    prop_names =  'L     D    chi  Vm   ka    caeq kb    cbeq  gab mu   S   Tm   kappa'
    prop_values = '333.33 1.0  0.1  1.0  10.0  0.1  10.0  0.9   4.5 10.0 1.0 1.0  0.1'
  [../]
  [./Mobility]
    type = DerivativeParsedMaterial
    f_name = Dchi
    material_property_names = 'D chi'
    function = 'D*chi'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'Dchi'
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
  # automatic_scaling = true
  # line_search = basic
  # petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_factor_shift_type'
  # petsc_options_value = 'hypre    boomeramg      31 nonzero'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist'
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
  dt = 0.001
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.0005
    cutback_factor = 0.95
    growth_factor = 1.05
    optimal_iterations = 4
    iteration_window = 0
    linear_iteration_ratio = 100
  [../]
[]

[Adaptivity]
 initial_steps = 2
 max_h_level = 3
 initial_marker = EFM_3
 marker = EFM_4
[./Markers]
   [./EFM_3]
     type = ErrorFractionMarker
     coarsen = 0.3
     refine = 0.95
     indicator = GJI_3
   [../]
   [./EFM_4]
     type = ErrorFractionMarker
     coarsen = 0.3
     refine = 0.95
     indicator = GJI_4
   [../]
 [../]
 [./Indicators]
   [./GJI_3]
     type = GradientJumpIndicator
     variable = etaa0
    [../]
    [./GJI_4]
      type = GradientJumpIndicator
      variable = bnds
   [../]
 [../]
[]

[Outputs]
  csv = true
  exodus = true
  perf_graph = true
[]
