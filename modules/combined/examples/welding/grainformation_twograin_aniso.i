[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  xmax = 1.0
  ymax = 1.0
  uniform_refine = 2
[]

[Variables]
  [./eta0]
  [../]
  [./eta1]
  [../]
  [./w]
  [../]
  # [./T]
  # [../]
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
    int_width = 0.01
    x1 = 0.25
    y1 = 0.5
    radius = 0.08
    outvalue = 0
    invalue = 1
  [../]
  [./w]
    type = SpecifiedSmoothCircleIC
    variable = w
    int_width = 0.01
    x_positions = '0.25 0.75'
    y_positions = '0.5 0.5'
    z_positions = '0 0'
    radii = '0.08 0.08'
    outvalue = 0
    invalue = 1
  [../]
  [./eta1]
    type = SmoothCircleIC
    variable = eta1
    int_width = 0.01
    x1 = 0.75
    y1 = 0.5
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
  [./w_int]
    type = ACInterface
    variable = w
  [../]
  # [./anisoACinterface1]
  #   type = ACInterfaceKobayashi1
  #   variable = w
  # [../]
  # [./anisoACinterface2]
  #   type = ACInterfaceKobayashi2
  #   variable = w
  # [../]
  [./w_bulk]
    type = AllenCahn
    variable = w
    f_name = F
    # args = T
  [../]
  [./w2_eta0]
    type = SusceptibilityCoupledACInterface
    variable = w
    v = eta0
    f_name = int_coeff
    # kappa_name = kappa_theta
  [../]
  # [./w2_eta0]
  #   type = HigherCoupledACInterface
  #   variable = w
  #   v = eta0
  #   f_name = int_coeff2
  #   # kappa_name = kappa_theta
  # [../]

  [./w2_eta1]
    type = SusceptibilityCoupledACInterface
    variable = w
    v = eta1
    f_name = int_coeff
    # kappa_name = kappa_theta
  [../]
  # [./w2_eta1]
  #   type = HigherCoupledACInterface
  #   variable = w
  #   v = eta1
  #   f_name = int_coeff2
  #   # kappa_name = kappa_theta
  # [../]

  [./eta0_dot]
    type = TimeDerivative
    variable = eta0
    # f_name = time_coeff
    # args = 'w'
  [../]
  [./ACinterface_eta0]
    type = SusceptibilityACInterface
    variable = eta0
    f_name = int_coeff
    args = 'w'
  [../]

  [./eta1_dot]
    type = TimeDerivative
    variable = eta1
    # f_name = time_coeff
    # args = 'w'
  [../]
  [./ACinterface_eta1]
    type = SusceptibilityACInterface
    variable = eta1
    f_name = int_coeff
    args = 'w'
  [../]
  # [./ACinterface2_eta]
  #   type = ACInterfaceAniso
  #   variable = eta0
  #   f_name = int_coeff
  #   args = 'w'
  #   # variable_L = false
  # [../]
  # [./T_dot]
  #   type = TimeDerivative
  #   variable = T
  # [../]
  # [./CoefDiffusion]
  #   type = Diffusion
  #   variable = T
  # [../]
  # [./w_dot_T]
  #   type = CoefCoupledTimeDerivative
  #   variable = T
  #   v = w
  #   coef = -10
  # [../]

[]

[Materials]
  [./bulk_en]
    type = DerivativeParsedMaterial
    args = 'w'
    constant_names = 'Tm  Lt T'
    constant_expressions = '10 1.0 500'
    # function = 'm:=Lt/Tm * (T - Tm); w^2 * (1-w)^2 + m * w^3 * (10-15*w+6*w^2)'
    function = 'm:=Lt/Tm * (T - Tm); w^2 * (1-w)^2 - m * (1 - 20*w^3+ 45*w^4 - 36*w^5 + 10*w^6)'
    # constant_names = pi
    # constant_expressions = 4*atan(1)
    # function = 'm:=0.9 * atan(10 * (1 - T)) / pi; 1/4*w^4 - (1/2 - m/3) * w^3 + (1/4 - m/2) * w^2'
    # derivative_order = 2
    outputs = exodus
  [../]
  [./material]
    type = InterfaceOrientationMaterial
    op = w
  [../]
  [./time_coeff]
    type = DerivativeParsedMaterial
    args = w
    function = '(1-w)^2'
    f_name = time_coeff
    outputs = exodus
  [../]
  [./int_coeff]
    type = DerivativeParsedMaterial
    f_name = int_coeff
    args = w
    # function = '(7*w^3 - 6*w^4)'
    function = 'w^2'
    outputs = exodus
  [../]
  # [./int_coeff1]
  #   type = DerivativeParsedMaterial
  #   f_name = int_coeff2
  #   material_property_names = 'int_coeff time_coeff'
  #   function = if(time_coeff>1e-6,int_coeff/time_coeff,int_coeff)
  #   args = w
  #   outputs = exodus
  # [../]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'L   kappa_op'
    prop_values = '1.0 0.5'
  [../]
[]
#
# [BCs]
#   [./Periodic]
#     [./all]
#     auto_direction = 'x y'
#     variable = 'w eta0 eta1'
#   [../]
# [../]
# []

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
  # petsc_options_iname = '-pc_type '
  # petsc_options_value = 'lu    '
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_factor_shift_type'
  petsc_options_value = 'hypre    boomeramg      31 NONZERO '
  # petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap -pc_factor_shift_type -pc_factor_shift_amount'
  # petsc_options_value = 'asm         31                 preonly      ilu            1             NONZERO               1e-3'
  petsc_options = '-snes_converged_reason -ksp_converged_reason1'

  nl_abs_tol = 1e-10
  nl_rel_tol = 1e-08
  l_max_its = 20
  nl_max_its = 20
  l_tol = 1e-4
  # dt = 0.02
  end_time = 10

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
  marker = err
  max_h_level = 3
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
    [./err]
      type = ErrorFractionMarker
      indicator = error
      coarsen = 0.2
      refine = 0.75
    [../]
  [../]
[]

[Outputs]
  # interval = 5
  exodus = true
  file_base = notemp_aniso_twograin_suscp
[]

[Debug]
  show_var_residual_norms = true
[]
