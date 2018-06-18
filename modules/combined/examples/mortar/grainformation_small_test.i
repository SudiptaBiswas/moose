[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  xmax = 1.0
  ymax = 1.0
  # uniform_refine = 2
[]

[Variables]
  [./eta1]
  [../]
  [./w]
  [../]
[]

# [AuxVariables]
#   [./w]
#   [../]
# []

[ICs]
  [./eta1]
    type = SmoothCircleIC
    variable = eta1
    int_width = 0.005
    x1 = 0.5
    y1 = 0.5
    radius = 0.2
    outvalue = 0
    invalue = 1
  [../]
  [./w]
    type = SmoothCircleIC
    variable = w
    int_width = 0.005
    x1 = 0.5
    y1 = 0.5
    radius = 0.2
    outvalue = 0
    invalue = 1
  [../]
[]

[Kernels]
  [./eta1_dot]
    type = VariableCoefTimeDerivative
    variable = eta1
    v = w
  [../]
  [./ACinterface_eta1]
    type = ACInterfaceOrientation
    variable = eta1
    mob_name = M
    # eps_name = kappa_op
    v = w
    # h_name = h
    penalty = 0.1
  [../]
  [./ACinterface2_eta1]
    type = ACInterfaceOrientation2
    variable = eta1
    mob_name = M
    # eps_name = kappa_op
    v = w
    # h_name = h
    penalty = 0.1
  [../]
  # [./w_dot]
  #   type = TimeDerivative
  #   variable = w
  # [../]
  # [./w_diff]
  #   type = Diffusion
  #   variable = w
  # [../]
  [./W_dot]
    type = TimeDerivative
    variable = w
  [../]
  [./anisoACinterface1]
    type = ACInterfaceKobayashi1
    variable = w
    mob_name = M
  [../]
  [./anisoACinterface2]
    type = ACInterfaceKobayashi2
    variable = w
    mob_name = M
  [../]
  [./AllenCahn]
    type = AllenCahn
    variable = w
    mob_name = M
    f_name = fbulk
    # args = T
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y'
      variable = 'w eta1'
    [../]
  [../]
[]

[Materials]
  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = fbulk
    args = 'w'
    constant_names = m
    constant_expressions = 0.3
    function = '  1/4*w^4 - (1/2 - m/3) * w^3 + (1/4 - m/2) * w^2'
    derivative_order = 2
    # outputs = exodus
  [../]
  [./h]
    type = SwitchingFunctionMaterial
    h_order = SIMPLE
    function_name = h
    eta = w
    # outputs = exodus
  [../]
  [./int_eta2]
    type = InterfaceOrientationMaterial
    op = w
    # mode_number = 0
    anisotropy_strength = 0
    eps_bar = 0.01
  [../]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'M       kappa_op'
    prop_values = '3333.333 0.1'
  [../]
[]

# [AuxKernels]
#   [./w]
#     type = FunctionAux
#     variable = w
#     function = 'x^2'
#     execute_on = timestep_end
#   [../]
# []

# [Preconditioning]
#   [./SMP]
#     type = SMP
#     full = true
#   [../]
# []

[Executioner]
  type = Transient
  scheme = bdf2
  solve_type = FD
  # petsc_options_iname = '-pc_type '
  # petsc_options_value = 'lu    '
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre    boomeramg      31'
  # petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  # petsc_options_value = 'asm         31   preonly   lu      1'
  nl_abs_tol = 1e-10
  nl_rel_tol = 1e-08
  l_max_its = 30
  l_tol = 1e-4
  num_steps = 10

  [./TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 6
    iteration_window = 2
    dt = 0.0005
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
      variable = w
    [../]
  [../]
[]

[Outputs]
  # interval = 5
  exodus = true
  # file_base = notemp_iso_multi_test2
[]

[Debug]
  show_var_residual_norms = true
[]
