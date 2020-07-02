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
  uniform_refine = 3
[]

[GlobalParams]
  radius = 0.5
  int_width = 0.2
  x1 = 0.0
  y1 = 0.0
  derivative_order = 2
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

[AuxVariables]
  [./bnds]
  [../]
  [./T]
    initial_condition = -0.5
  [../]
  [grad_etaa_x]
    family = MONOMIAL
    order = CONSTANT
  []
  [grad_etaa_y]
    family = MONOMIAL
    order = CONSTANT
  []
  [grad_etaa_z]
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
  [grad_etaa1_z]
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
  [grad_etab_z]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'etaa0 etab0'
  [../]
  [./grad_etaa0]
    type = VariableGradientComponent
    variable = grad_etaa_x
    gradient_variable = etaa0
    component = x
  [../]
  [./grad_etaa1]
    type = VariableGradientComponent
    variable = grad_etaa_y
    gradient_variable = etaa0
    component = y
  [../]
  [./grad_etaa2]
    type = VariableGradientComponent
    variable = grad_etaa_z
    gradient_variable = etaa0
    component = z
  [../]
  # [./grad_etaa1x]
  #   type = VariableGradientComponent
  #   variable = grad_etaa1_x
  #   gradient_variable = etaa1
  #   component = x
  # [../]
  # [./grad_etaa1y]
  #   type = VariableGradientComponent
  #   variable = grad_etaa1_y
  #   gradient_variable = etaa1
  #   component = y
  # [../]
  # [./grad_etaa1z]
  #   type = VariableGradientComponent
  #   variable = grad_etaa1_z
  #   gradient_variable = etaa1
  #   component = z
  # [../]
  [./grad_etab0]
    type = VariableGradientComponent
    variable = grad_etab_x
    gradient_variable = etab0
    component = x
  [../]
  [./grad_etab1]
    type = VariableGradientComponent
    variable = grad_etab_y
    gradient_variable = etab0
    component = y
  [../]
  [./grad_etab2]
    type = VariableGradientComponent
    variable = grad_etab_z
    gradient_variable = etab0
    component = z
  [../]

[]

[ICs]
  # [./w]
  #   type = SpecifiedSmoothCircleIC
  #   variable = w
  #   # x_positions = '-5 5'
  #   x_positions = '6 12'
  #   y_positions = '5 5'
  #   z_positions = '0 0'
  #   radii = '0.5 0.5'
  #   outvalue = -4 #-6.27e-7
  #   invalue = 0
  # [../]
  # [./etaa0]
  #   type = SmoothCircleIC
  #   variable = etaa0
  #   #Solid phase
  #   x1 = 6#-5
  #   y1 = 5
  #   outvalue = 0.0
  #   invalue = 1.0
  # [../]
  # [./etaa1]
  #   type = SmoothCircleIC
  #   variable = etaa1
  #   #Solid phase
  #   x1 = 12#5
  #   y1 = 5
  #   outvalue = 0.0
  #   invalue = 1.0
  # [../]
  # [./etab0]
  #   type = SpecifiedSmoothCircleIC
  #   variable = etab0
  #   #Liquid phase
  #   # x_positions = '-5 5'
  #   # y_positions = '0 0'
  #   x_positions = '6 12'
  #   y_positions = '5 5'
  #   z_positions = '0 0'
  #   radii = '0.5 0.5'
  #   outvalue = 1.0
  #   invalue = 0.0
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

[Kernels]
# Order parameter eta_alpha0
  [./ACa0_bulk]
    type = ACGrGrMulti
    variable = etaa0
    # v =           'etab0 etaa1'
    # gamma_names = 'gab   gab'
    v =           'etab0 '
    gamma_names = 'gab   '
  [../]
  [./ACa0_sw]
    type = ACSwitching
    variable = etaa0
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etab0 w T '
  [../]
  # [./ACa0_int]
  #   type = ACInterface
  #   variable = etaa0
  #   kappa_name = kappa
  # [../]
  [./ACa0_int1]
    type = ACInterface2DMultiPhase1
    variable = etaa0
    etas = 'etab0 '
    # args = 'etaa1 etab0'
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    d2kappadgrad_etaa_name = d2kappadgrad_etaa
    variable_L = false
  [../]
  [./ACa0_int2]
    type = ACInterface2DMultiPhase2
    variable = etaa0
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
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

  # [./ACa1_bulk]
  #   type = ACGrGrMulti
  #   variable = etaa1
  #   v =           'etab0 etaa0'
  #   gamma_names = 'gab   gab '
  # [../]
  # [./ACa1_sw]
  #   type = ACSwitching
  #   variable = etaa1
  #   Fj_names  = 'omegaa omegab'
  #   hj_names  = 'ha     hb'
  #   args = 'etab0 w T etaa0'
  # [../]
  # # [./ACa1_int]
  # #   type = ACInterface
  # #   variable = etaa1
  # #   kappa_name = kappa
  # # [../]
  # [./ACa1_int1]
  #   type = ACInterface2DMultiPhase1
  #   variable = etaa1
  #   etas = 'etab0 etaa0'
  #   # args = 'etaa0 etab0'
  #   kappa_name = kappaa1
  #   dkappadgrad_etaa_name = dkappadgrad_etaa1
  #   d2kappadgrad_etaa_name = d2kappadgrad_etaa1
  #   variable_L = false
  # [../]
  # [./ACa1_int2]
  #   type = ACInterface2DMultiPhase2
  #   variable = etaa1
  #   kappa_name = kappaa1
  #   dkappadgrad_etaa_name = dkappadgrad_etaa1
  #   args = ' etab0 etaa0 '
  #   variable_L = false
  # [../]
  # [./ea1_dot]
  #   type = TimeDerivative
  #   variable = etaa1
  # [../]
  # [./etaa1_kappa]
  #   type = ACKappaFunction
  #   variable = etaa1
  #   mob_name = L
  #   kappa_name = kappaa1
  #   v = 'etaa0 etab0'
  # [../]
# Order parameter eta_beta0
  [./ACb0_bulk]
    type = ACGrGrMulti
    variable = etab0
    v =           'etaa0 '
    gamma_names = 'gab   '
  [../]
  [./ACb0_sw]
    type = ACSwitching
    variable = etab0
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etaa0 w T '
  [../]
  # [./ACb0_int]
  #   type = ACInterface
  #   variable = etab0
  #   kappa_name = kappa
  # [../]
  [./ACb0_int1]
    type = ACInterface2DMultiPhase1
    variable = etab0
    etas = 'etaa0 '
    # args = 'etaa0 etaa1'
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
    d2kappadgrad_etaa_name = d2kappadgrad_etab
    variable_L = false
  [../]
  [./ACb0_int2]
    type = ACInterface2DMultiPhase2
    variable = etab0
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
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
    args = 'etaa0 etab0 '
  [../]
  # [./coupled_etaa1dot]
  #   type = CoupledSwitchingTimeDerivative
  #   variable = w
  #   v = etaa1
  #   Fj_names = 'rhoa rhob'
  #   hj_names = 'ha   hb'
  #   args = 'etaa0 etab0 '
  # [../]
  [./coupled_etab0dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etab0
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0 '
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
    all_etas = 'etaa0 etab0 '
    phase_etas = 'etaa0 '
  [../]
  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'etaa0 etab0 '
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
  [./concentration]
    type = ParsedMaterial
    f_name = c
    material_property_names = 'rhoa ha rhob hb Vm'
    function = 'Vm*(ha*rhoa+hb*rhob)'
    outputs = exodus
  [../]
  [./kappaa]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    d2kappadgrad_etaa_name = d2kappadgrad_etaa
    etaa = etaa0
    etab = '  etab0'
    reference_angle = 0
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    outputs = exodus
    # output_properties = 'kappaa'
  [../]
  [./kappaa1]
    type = InterfaceOrientationMultiphaseMaterial2
    kappa_name = kappaa1
    dkappadgrad_etaa_name = dkappadgrad_etaa1
    d2kappadgrad_etaa_name = d2kappadgrad_etaa1
    etaa = etaa0
    etab = 'etab0'
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    reference_angle = 0
    outputs = exodus
    # output_properties = 'kappaa1'
  [../]
  [./kappab]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
    d2kappadgrad_etaa_name = d2kappadgrad_etab
    etaa = etab0
    etab = 'etaa0 '
    anisotropy_strength = 0.05
    reference_angle = 0
    kappa_bar = 0.05
    outputs = exodus
    output_properties = 'kappab'
  [../]

  [./const]
    type = GenericConstantMaterial
    prop_names =  'L     D    chi  Vm   ka    caeq kb    cbeq  gab mu   S   Tm   kappa'
    prop_values = '333.33 1.0  0.1  1.0  10.0  0.1  10.0  0.9   4.5 10.0 1.0 1.0  0.1'
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
  # automatic_scaling = true
  # line_search = basic
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_factor_shift_type'
  petsc_options_value = 'hypre    boomeramg      31 nonzero'
  # petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  # petsc_options_value = 'lu       superlu_dist'
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
  # dtmax = 0.05
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.001
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
    [./ind_eta0]
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
  # file_base = 2020_04_21_GrandPotentialSolidification_old
[]

[Debug]
  show_var_residual_norms = true
[]
