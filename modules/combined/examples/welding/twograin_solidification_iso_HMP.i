[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  xmax = 10.0
  ymax = 10.0
  uniform_refine = 4
[]

[Variables]
  # [./eta0]
  # [../]
  # [./eta1]
  # [../]
  [./w]
  [../]
  # [./T]
  #   initial_condition = -0.5
  # [../]
[]

# [AuxVariables]
#   [./bnds]
#   [../]
# []

# [AuxKernels]
#   [./bnds]
#     type = BndsCalcAux
#     v = 'eta0 eta1'
#     variable = bnds
#   [../]
# []

[ICs]
  # [./eta0]
  #   type = SmoothCircleIC
  #   variable = eta0
  #   int_width = 0.1
  #   x1 = 2.5
  #   y1 = 5.0
  #   radius = 0.8
  #   outvalue = 0
  #   invalue = 0.95
  # [../]
  [./w]
    type = SpecifiedSmoothCircleIC
    variable = w
    int_width = 0.1
    x_positions = '2.5 7.5'
    y_positions = '5. 5.'
    z_positions = '0 0'
    radii = '0.8 0.8'
    outvalue = 0
    invalue = 0.95
  [../]
  # [./eta1]
  #   type = SmoothCircleIC
  #   variable = eta1
  #   int_width = 0.1
  #   x1 = 7.5
  #   y1 = 5.
  #   radius = 0.8
  #   outvalue = 0
  #   invalue = 0.95
  # [../]
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
  # [./w2_eta0]
  #   type = HigherCoupledACInterface
  #   variable = w
  #   v = eta0
  #   f_name = int_coeff
  #   # kappa_name = kappa_theta
  # [../]
  #
  # [./w2_eta1]
  #   type = HigherCoupledACInterface
  #   variable = w
  #   v = eta1
  #   f_name = int_coeff
  #   # kappa_name = kappa_theta
  # [../]

  # [./eta0_dot]
  #   type = TimeDerivative
  #   variable = eta0
  #   # f_name = time_coeff
  #   # args = 'w'
  # [../]
  # [./Awinterfawe_eta0]
  #   type = SusceptibilityACInterface
  #   variable = eta0
  #   f_name = int_coeff
  #   args = 'w'
  # [../]
  # [./eta1_dot]
  #   type = TimeDerivative
  #   variable = eta1
  #   # f_name = time_coeff
  #   # args = 'w'
  # [../]
  # [./Awinterfawe_eta1]
  #   type = SusceptibilityACInterface
  #   variable = eta1
  #   f_name = int_coeff
  #   args = 'w'
  # [../]
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
  # [./coefDiffusion]
  #   type = MatDiffusion
  #   variable = T
  # [../]
  # [./w_dot_T]
  #   type = CoupledTimeDerivative
  #   variable = T
  #   v = w
  #   # woef = -1.8
  # [../]
  # [./T_src]
  #   type = BodyForce
  #   function = -10*t
  #   variable = T
  # [../]
[]

[Materials]
  [./bulk_en]
    type = DerivativeParsedMaterial
    args = 'w'
    function = 'w^2 * (1-w)^2 + 0.5 * (1 - 20*w^3 + 45*w^4 - 36*w^5 + 10*w^6)'
    # function = 'm:=alpha/pi * atan(gamma * (T_e - T)); 1/4*w^4 - (1/2 - m/3) * w^3 + (1/4 - m/2) * w^2'
    # outputs = exodus
  [../]

  # [./time_coeff]
  #   type = DerivativeParsedMaterial
  #   args = w
  #   function = 'w^4'
  #   f_name = time_coeff
  #   outputs = exodus
  # [../]
  [./int_coeff]
    type = DerivativeParsedMaterial
    f_name = int_coeff
    args = w
    function = 'd:=(1-w)^3; n:=7*w^3-6*w^4; if(d>1e-6, n/d, 0)'
    # function = 'd:=(1-w)^2; n:=7*w^3-6*w^4; n/d'
    # outputs = exodus
  [../]
  # [./int_coeff1]
  #   type = DerivativeParsedMaterial
  #   f_name = int_coeff2
  #   material_property_names = 'int_coeff time_coeff'
  #   function = if(time_coeff>1e-6,int_coeff/time_coeff,int_coeff)
  #   args = w
  # [../]
  [./wonsts]
    type = GenericConstantMaterial
    prop_names  = 'L     kappa_op D    kappa_theta'
    prop_values = '0.9   0.00223    2.25   1.0'
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
  # line_search = basic
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
  # dt = 0.02
  end_time = 10

  [./TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 6
    iteration_window = 2
    dt = 5e-4
    growth_factor = 1.2
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
  file_base = consttemp_iso_twograin_plapp2
[]

[Debug]
  show_var_residual_norms = true
[]
