#creates fancy dendride growth with secondary arms, images used in ldrd proposal
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 15
  ny = 15
  xmax = 15.0
  ymax = 15.0
  uniform_refine = 2
[]

[Variables]
  [./w]
  [../]
  [./T]
  [../]
  [./eta0]
  [../]
  [./eta1]
  [../]
  [./eta2]
  [../]
  [./eta3]
  [../]
[]

[AuxVariables]
  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ICs]
  [./wIC]
    type = SpecifiedSmoothCircleIC
    variable = w
    int_width = 0.1
    x_positions = '4.5 10.0 10.0 4.5'
    y_positions = '4.5 10.0 4.5 10.0'
    z_positions = '0.0 0.0 0.0 0.0'
    radii = '0.07 0.07 0.07 0.07'
    outvalue = 0
    invalue = 1
  [../]
  [./eta0]
    type = SmoothCircleIC
    variable = eta0
    int_width = 0.1
    x1 = 4.5
    y1 = 4.5
    radius = 0.07
    outvalue = 0
    invalue = 1
  [../]
  [./eta1]
    type = SmoothCircleIC
    variable = eta1
    int_width = 0.1
    x1 = 4.5
    y1 = 10.0
    radius = 0.07
    outvalue = 0
    invalue = 1
  [../]
  [./eta2]
    type = SmoothCircleIC
    variable = eta2
    int_width = 0.1
    x1 = 10.0
    y1 = 4.5
    radius = 0.07
    outvalue = 0
    invalue = 1
  [../]
  [./eta3]
    type = SmoothCircleIC
    variable = eta3
    int_width = 0.1
    x1 = 10.0
    y1 = 10.0
    radius = 0.07
    outvalue = 0
    invalue = 1
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
    auto_direction = 'x y'
    variable = 'w eta0 eta1 eta2 eta3'
  [../]
[../]
[]

[Kernels]
  [./w_dot]
    type = TimeDerivative
    variable = w
  [../]
  [./anisoACinterface1]
    type = ACInterfaceKobayashi1
    variable = w
  [../]
  [./anisoACinterface2]
    type = ACInterfaceKobayashi2
    variable = w
  [../]
  [./AllenCahn]
    type = AllenCahn
    variable = w
    f_name = fbulk
    args = T
  [../]
  # [./w_eta0]
  #   type = SusceptibilityCoupledACInterface
  #   variable = w
  #   v = eta0
  #   f_name = int_coeff
  # [../]
  # [./w1_eta0]
  #   type = HigherCoupledACInterface
  #   variable = w
  #   v = eta0
  #   f_name = int_coeff
  # [../]
  # [./w_eta1]
  #   type = SusceptibilityCoupledACInterface
  #   variable = w
  #   v = eta1
  #   f_name = int_coeff
  # [../]
  # [./w2_eta1]
  #   type = HigherCoupledACInterface
  #   variable = w
  #   v = eta1
  #   f_name = int_coeff
  # [../]
  # [./w_eta2]
  #   type = SusceptibilityCoupledACInterface
  #   variable = w
  #   v = eta2
  #   f_name = int_coeff
  # [../]
  # [./w2_eta2]
  #   type = HigherCoupledACInterface
  #   variable = w
  #   v = eta2
  #   f_name = int_coeff
  # [../]
  # [./w_eta3]
  #   type = SusceptibilityCoupledACInterface
  #   variable = w
  #   v = eta3
  #   f_name = int_coeff
  # [../]
  # [./w2_eta3]
  #   type = HigherCoupledACInterface
  #   variable = w
  #   v = eta3
  #   f_name = int_coeff
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
  [./eta0_dot]
    type = SusceptibilityTimeDerivative
    variable = eta0
    f_name = time_coeff
    args = 'w'
  [../]
  [./ACinterface_eta0]
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
  [./ACinterface_eta1]
    type = SusceptibilityACInterface
    variable = eta1
    f_name = int_coeff
    args = 'w'
  [../]
  [./eta2_dot]
    type = SusceptibilityTimeDerivative
    variable = eta2
    f_name = time_coeff
    args = 'w'
  [../]
  [./ACinterface_eta2]
    type = SusceptibilityACInterface
    variable = eta2
    f_name = int_coeff
    args = 'w'
  [../]
  [./eta3_dot]
    type = SusceptibilityTimeDerivative
    variable = eta3
    f_name = time_coeff
    args = 'w'
  [../]
  [./ACinterface_eta3]
    type = SusceptibilityACInterface
    variable = eta3
    f_name = int_coeff
    args = 'w'
  [../]
[]

[Materials]
  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = fbulk
    args = 'w T'
    constant_names = pi
    constant_expressions = 4*atan(1)
    function = 'm:=0.9 * atan(10 * (1 - T)) / pi; 1/4*w^4 - (1/2 - m/3) * w^3 + (1/4 - m/2) * w^2'
    derivative_order = 2
    # outputs = exodus
  [../]
  [./material]
    type = InterfaceOrientationMaterial
    op = w
  [../]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'L          kappa_op'
    prop_values = '3333.333    0.005'
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
[]

[AuxKernels]
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'eta0 eta1 eta2 eta3'
    execute_on = timestep_end
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    # full = true
    coupled_groups = 'w,T w,eta0 w,eta1 w,eta2 w,eta3'
  [../]
[]

[Executioner]
  type = Transient
  scheme = bdf2
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre    boomeramg      31'

  nl_abs_tol = 1e-10
  nl_rel_tol = 1e-08
  nl_max_its = 20
  l_tol = 1e-03
  l_max_its = 30

  end_time = 1

  [./TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 6
    iteration_window = 2
    dt = 0.0005
    growth_factor = 1.1
    cutback_factor = 0.75
  [../]
  # [./Adaptivity]
  #   initial_adaptivity = 3 # Number of times mesh is adapted to initial condition
  #   refine_fraction = 0.7 # Fraction of high error that will be refined
  #   coarsen_fraction = 0.1 # Fraction of low error that will coarsened
  #   max_h_level = 5 # Max number of refinements used, starting from initial mesh (before uniform refinement)
  #   weight_names = 'w T'
  #   weight_values = '1 0.5'
  # [../]
[]

[Adaptivity]
  marker = err
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
    [./err]
      type = ErrorFractionMarker
      indicator = error
    [../]
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]

[Outputs]
  # interval = 5
  exodus = true
  file_base = snow_grain_multi_test
[]
