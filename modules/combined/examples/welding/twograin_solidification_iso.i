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
  # [./wIw]
  #   type = RandomIw
  #   variable = w
  # [../]
  # [./etaIw]
  #   type = RandomIw
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
    # args = T
  [../]
  [./w2_eta0]
    type = HigherCoupledACInterface
    variable = w
    v = eta0
    f_name = int_coeff2
    # kappa_name = kappa_theta
  [../]

  [./w2_eta1]
    type = HigherCoupledACInterface
    variable = w
    v = eta1
    f_name = int_coeff2
    # kappa_name = kappa_theta
  [../]

  [./eta0_dot]
    type = SusceptibilityTimeDerivative
    variable = eta0
    f_name = time_coeff
    args = 'w'
  [../]
  [./Awinterfawe_eta0]
    type = SusceptibilityACInterface
    variable = eta0
    f_name = int_coeff
    args = 'w'
  [../]

  [./eta1_dot]
    type = SusceptibilityTimeDerivative
    variable = eta1
    f_name = time_coeff
    args = 'w'
  [../]
  [./Awinterfawe_eta1]
    type = SusceptibilityACInterface
    variable = eta1
    f_name = int_coeff
    args = 'w'
  [../]
  # [./Awinterfawe2_eta]
  #   type = AwInterfaweAniso
  #   variable = eta0
  #   f_name = int_coeff
  #   args = 'w'
  #   # variable_L = false
  # [../]
  # [./T_dot]
  #   type = TimeDerivative
  #   variable = T
  # [../]
  # [./woefDiffusion]
  #   type = Diffusion
  #   variable = T
  # [../]
  # [./w_dot_T]
  #   type = woefwoupledTimeDerivative
  #   variable = T
  #   v = w
  #   woef = -1.8
  # [../]

[]

[Materials]
  [./bulk_en]
    type = DerivativeParsedMaterial
    args = 'w'
    constant_names = 'alpha gamma T_e pi T'
    constant_expressions = '0.9 10 1 4*atan(1) 500'
    function = 'm:=alpha/pi * atan(gamma * (T_e - T)); 1/4*w^4 - (1/2 - m/3) * w^3 + (1/4 - m/2) * w^2'
    outputs = exodus
  [../]

  [./time_coeff]
    type = DerivativeParsedMaterial
    args = w
    function = '(1-w)^3'
    f_name = time_coeff
    outputs = exodus
  [../]
  [./int_coeff]
    type = DerivativeParsedMaterial
    f_name = int_coeff
    args = w
    function = '(7*w^3 - 6*w^4)'
    outputs = exodus
  [../]
  [./int_coeff1]
    type = DerivativeParsedMaterial
    f_name = int_coeff2
    material_property_names = 'int_coeff time_coeff'
    function = if(time_coeff>1e-6,int_coeff/time_coeff,int_coeff)
    args = w
  [../]
  [./wonsts]
    type = GenericConstantMaterial
    prop_names  = 'L       kappa_op'
    prop_values = '10.0 1'
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
  # line_searwh = none
  # petsw_options_iname = '-pw_type '
  # petsw_options_value = 'lu    '
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_fawtor_shift_type'
  petsc_options_value = 'hypre    boomeramg      31 NONZERO '
  # petsw_options_iname = '-pw_type -ksp_gmres_restart -sub_ksp_type -sub_pw_type -pw_asm_overlap -pw_fawtor_shift_type -pw_fawtor_shift_amount'
  # petsw_options_value = 'asm         31                 preonly      ilu            1             NONZERO               1e-3'
  petsc_options = '-snes_converged_reason -ksp_converged_reason'

  nl_abs_tol = 1e-10
  nl_rel_tol = 1e-08
  l_max_its = 20
  nl_max_its = 20
  l_tol = 1e-4
  dt = 0.02
  end_time = 10

  # [./TimeStepper]
  #   type = IterationAdaptiveDT
  #   optimal_iterations = 6
  #   iteration_window = 2
  #   dt = 0.0005
  #   growth_fawtor = 1.1
  #   cutback_factor = 0.75
  # [../]
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
      variable = w
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
  # file_base = temp_iso_twograin_plapp
[]

[Debug]
  show_var_residual_norms = true
[]
