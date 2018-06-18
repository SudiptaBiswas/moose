[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  xmax = 0.7
  ymax = 0.7
[]

[Variables]
  [./eta0]
    # scaling = 1e-3
  [../]
  [./eta1]
    # scaling = 1e-3
  [../]
  [./w]
    # scaling = 1e8
  [../]
  [./T]
    # initial_condition = 500
  [../]
[]

[AuxVariables]
  [./bnds]
  [../]
[]

[AuxKernels]
[./bnds]
  type = BndsCalcAux
  v = 'eta0 eta1'
  variable = bnds
[../]
[]

[ICs]
  [./eta0]
    type = SmoothCircleIC
    variable = eta0
    int_width = 0.1
    x1 = 0.15
    y1 = 0.35
    radius = 0.08
    outvalue = 0
    invalue = 1
  [../]
  [./w]
    type = SpecifiedSmoothCircleIC
    variable = w
    int_width = 0.1
    x_positions = '0.15 0.55'
    y_positions = '0.35 0.35'
    z_positions = '0 0'
    radii = '0.08 0.08'
    outvalue = 0
    invalue = 1
  [../]
  [./eta1]
    type = SmoothCircleIC
    variable = eta1
    int_width = 0.1
    x1 = 0.55
    y1 = 0.35
    radius = 0.08
    outvalue = 0
    invalue = 1
  [../]
  # [./wIC]
  #   type = RandomIC
  #   variable = w
  # [../]
  # [./etaIC]
  #   type = RandomIC
  #   variable = eta
  # [../]
[]

[Kernels]
  [./w_dot]
    type = TimeDerivative
    variable = w
  [../]
  # [./w_int]
  #   type = ACInterface
  #   variable = w
  # [../]
  [./anisoACinterface1]
    type = ACInterfaceKobayashi1
    variable = w
    mob_name = L
  [../]
  [./anisoACinterface2]
    type = ACInterfaceKobayashi2
    variable = w
    mob_name = L
  [../]
  [./w_bulk]
    type = AllenCahn
    variable = w
    f_name = F
    args = T
  [../]
  [./w_eta0]
    type = SusceptibilityCoupledACInterface
    variable = w
    v = eta0
    f_name = int_coeff
    penalty = 0.01
  [../]
  [./w_eta1]
    type = SusceptibilityCoupledACInterface
    variable = w
    v = eta1
    f_name = int_coeff
    penalty = 0.01
  [../]
  [./w2_eta0]
    type = HigherCoupledACInterface
    variable = w
    v = eta0
    f_name = int_coeff
    kappa_name = kappa_theta
  [../]
  [./w2_eta1]
    type = HigherCoupledACInterface
    variable = w
    v = eta1
    f_name = int_coeff
    kappa_name = kappa_theta
  [../]
  [./eta0_dot]
    type = SusceptibilityTimeDerivative
    variable = eta0
    f_name = time_coeff
    # kappa_name = kappa_theta
    args = 'w'
  [../]
  [./eta1_dot]
    type = SusceptibilityTimeDerivative
    variable = eta1
    f_name = time_coeff
    # kappa_name = kappa_theta
    args = 'w'
  [../]
  [./ACinterface_eta0]
    type = SusceptibilityACInterface
    variable = eta0
    f_name = int_coeff
    kappa_name = kappa_theta
    args = 'w'
  [../]
  [./ACinterface_eta1]
    type = SusceptibilityACInterface
    variable = eta1
    f_name = int_coeff
    kappa_name = kappa_theta
    args = 'w'
  [../]
  # [./ACinterface2_eta]
  #   type = ACInterfaceAniso
  #   variable = eta
  #   f_name = int_coeff
  #   args = 'w'
  #   # variable_L = false
  # [../]

  [./T_dot]
    type = TimeDerivative
    variable = T
  [../]
  [./CoefDiffusion]
    type = Diffusion
    variable = T
  [../]
  [./w_dot_T]
    type = CoefCoupledTimeDerivative
    variable = T
    v = w
    coef = -1.8
  [../]
[]

[Materials]
  [./bulk_en]
    type = DerivativeParsedMaterial
    args = 'w T'
    constant_names = 'alpha gamma T_e'
    constant_expressions = '0.9 10 1 4*atan(1)'
    function = 'm:=alpha/pi * atan(gamma * (T_e - T)); 1/4*w^4 - (1/2 - m/3) * w^3 + (1/4 - m/2) * w^2'
    derivative_order = 2
    # outputs = exodus
  [../]
  [./material]
    type = InterfaceOrientationMaterial
    op = w
  [../]
  [./time_coeff]
    type = DerivativeParsedMaterial
    args = w
    function = 'w*w'
    f_name = time_coeff
    # outputs = exodus
  [../]
  [./int_coeff]
    type = DerivativeParsedMaterial
    f_name = int_coeff
    args = w
    function = 'w*w'
  [../]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'L       kappa_theta'
    prop_values = '333.333  0.0008'
  [../]
[]
#
[BCs]
  [./Periodic]
    [./all]
    auto_direction = 'x y'
    variable = 'w eta0 eta1'
  [../]
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
  # petsc_options_iname = '-pc_type '
  # petsc_options_value = 'lu    '
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_factor_shift_type'
  petsc_options_value = 'hypre    boomeramg      31 NONZERO'
  # petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap -pc_factor_shift_type'
  # petsc_options_value = 'asm         31   preonly   ilu      1 NONZERO'
  petsc_options = '-snes_converged_reason -ksp_converged_reason'

  nl_abs_tol = 1e-10
  nl_rel_tol = 1e-08
  l_max_its = 20
  nl_max_its = 20
  l_tol = 1e-4
  # num_steps = 5
  # dt = 0.02
  end_time = 1

  [./TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 6
    iteration_window = 2
    dt = 0.001
    growth_factor = 1.1
    cutback_factor = 0.75
  [../]
[]

[Adaptivity]
  marker = bound_adapt
  max_h_level = 2
  [./Indicators]
    [./error]
      type = GradientJumpIndicator
      variable = w
    [../]
  [../]
  [./Markers]
    [./bound_adapt]
      type = ValueRangeMarker
      lower_bound = 0.1
      upper_bound = 0.99
      variable = bnds
    [../]
  [../]
[]

[Outputs]
  # interval = 5
  exodus = true
  print_perf_log = true

  # file_base = iso_multi_test2
[]

[Debug]
  show_var_residual_norms = true
[]
