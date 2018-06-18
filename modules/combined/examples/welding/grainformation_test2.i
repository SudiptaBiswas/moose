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
  [./eta]
    # scaling = 1e-3
  [../]
  [./w]
    # scaling = 1e8
  [../]
[]

# [AuxVariables]
#   [./w]
#   [../]
# []

[ICs]
  [./eta]
    type = SmoothCircleIC
    variable = eta
    int_width = 0.005
    x1 = 0.5
    y1 = 0.5
    radius = 0.1
    outvalue = 0
    invalue = 1
  [../]
  [./w]
    type = SmoothCircleIC
    variable = w
    int_width = 0.005
    x1 = 0.5
    y1 = 0.5
    radius = 0.1
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
  [./w_int]
    type = ACInterface
    variable = w
  [../]
  [./w_bulk]
    type = AllenCahn
    variable = w
    f_name = F
  [../]
  [./w_eta]
    type = SusceptibilityCoupledACInterface
    variable = w
    v = eta
    f_name = int_coeff
  [../]
  [./w_eta2]
    type = HigherCoupledACInterface
    variable = w
    v = eta
    f_name = int_coeff
  [../]
  [./eta_dot]
    type = SusceptibilityTimeDerivative
    variable = eta
    f_name = time_coeff
    args = 'w'
  [../]
  [./ACinterface_eta]
    type = SusceptibilityACInterface
    variable = eta
    f_name = int_coeff
    args = 'w'
  [../]
  # [./ACinterface2_eta]
  #   type = ACInterfaceAniso
  #   variable = eta
  #   f_name = int_coeff
  #   args = 'w'
  #   # variable_L = false
  # [../]
[]

[Materials]
  [./bulk_en]
    type = DerivativeParsedMaterial
    args = w
    function = '(1-w)*(1-w)'
    # f_name = time_coeff
    # outputs = exodus
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
    function = 'w'
  [../]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'L       kappa_op'
    prop_values = '1.0 0.1'
  [../]
[]
#
[BCs]
  [./Periodic]
    [./all]
    auto_direction = 'x y'
    variable = 'w'
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
  solve_type = NEWTON
  # line_search = basic
  # petsc_options_iname = '-pc_type '
  # petsc_options_value = 'lu    '
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_shift'
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
  file_base = iso_multi_test2
[]

[Debug]
  show_var_residual_norms = true
[]
