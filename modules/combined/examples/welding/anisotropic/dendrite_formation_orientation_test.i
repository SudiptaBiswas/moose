[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 30
  ny = 30
  xmax = 9
  ymax = 9
  # uniform_refine = 3
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
[]

[AuxVariables]
  [./total_en_w]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./total_en_eta]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./bnds]
  [../]
[]

[AuxKernels]
  [./total_en_w]
    type = TotalFreeEnergy
    variable = total_en_w
    kappa_names = 'eps'
    interfacial_vars = 'w'
    f_name = fbulk
  [../]
  [./bnds]
    type = BndsCalcAux
    v = 'eta0 eta1'
    variable = bnds
  [../]
  # [./bnds]
  #   type = ConstantAux
  #   variable = bnds
  #   value = 0.0
  # [../]
  # [./total_en]
  #   type = TotalFreeEnergy
  #   variable = total_en_eta
  #   kappa_names = 'int_coeff int_coeff'
  #   interfacial_vars = 'eta0 eta1'
  #   f_name = 0.0
  # [../]
[]
#
# [BCs]
#   [./Periodic]
#     [./all]
#       auto_direction = 'x y'
#       variable = 'w eta0 eta1'
#     [../]
#   [../]
# []

[ICs]
  [./wIC]
    type = SpecifiedSmoothCircleIC
    variable = w
    int_width = 0.1
    x_positions = '3.0 6.0'
    y_positions = '4.5 4.5'
    z_positions = '0 0'
    radii = '0.07 0.07'
    outvalue = 0
    invalue = 1
  [../]

  [./eta0]
    type = SmoothCircleIC
    variable = eta0
    int_width = 0.1
    x1 = 3.0
    y1 = 4.5
    radius = 0.07
    outvalue = 0
    invalue = 1.0
  [../]
  [./eta1]
    type = SmoothCircleIC
    variable = eta1
    int_width = 0.1
    x1 = 6.0
    y1 = 4.5
    radius = 0.07
    outvalue = 0
    invalue = -1.0
  [../]
[]

[Kernels]
  [./w_dot]
    type = TimeDerivative
    variable = w
  [../]
  # [./w_int]
  #   type = ACInterface
  #   variable = w
  #   mob_name = M
  # [../]
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
    args = T
  [../]

  # [./w2_eta0]
  #   type = HigherCoupledACInterface
  #   variable = w
  #   v = eta0
  #   f_name = int_coeff
  #   mob_name = M
  # [../]
  # [./w2_eta1]
  #   type = HigherCoupledACInterface
  #   variable = w
  #   v = eta1
  #   f_name = int_coeff
  #   mob_name = M
  #
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
    type = TimeDerivative
    variable = eta0
  [../]
  [./Awinterfawe_eta0]
    type = SusceptibilityACInterface
    variable = eta0
    args = 'w'
    f_name = int_coeff
    # kappa_name = eps

    mob_name = L_theta
    # mob_name = L_eta
    # kappa_name = kappa_theta
  [../]
  # # [./couple_int_eta0]
  # #   type = CoupledAnisotropicInterfaceEnergy
  # #   variable = eta0
  # #   v = w
  # #   # args = eta1
  # # [../]
  [./eta1_dot]
    type = TimeDerivative
    variable = eta1
  [../]
  [./Awinterfawe_eta1]
    type = SusceptibilityACInterface
    variable = eta1
    args = 'w'
    f_name = int_coeff
    mob_name = L_theta
    # mob_name = L_eta
    # kappa_name = kappa_theta
    # kappa_name = eps
  [../]
  # [./couple_int_eta1]
  #   type = CoupledAnisotropicInterfaceEnergy
  #   variable = eta1
  #   v = w
  #   # args = eta0
  #   # eps_name = eps
  # [../]
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
    type = InterfaceOrientation
    op = w
    orientation = 'eta0 eta1'
  [../]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'M        kappa_op    L'
    prop_values = '333.33   0.1        0.9'
  [../]

  [./int_coeff]
    type = DerivativeParsedMaterial
    f_name = int_coeff
    args = w
    # function = 'd:=(1-w)^2; n:=7*w^3-6*w^4; if(d>1e-8, n/d, 0)'
    function = 'd:=(1-w)^2; n:=7*w^3-6*w^4; n/d'
    # outputs = exodus
  [../]
  # [./material]
  #   type = InterfaceOrientation
  #   op = w
  #   # mode_number = 4
  #   # anisotropy_strength = 0.05
  #   # eps_bar = 0.02
  #   # eps_bar = 0.01
  #   orientation = 'eta0 eta1'
  #   # orientation = 'bnds'
  #   # max_orientation = 'max_eta0 max_eta1'
  #   outputs = exodus
  # [../]
  [./L_theta]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = L_theta
    constant_names = 'M_s M_l'
    constant_expressions = '0.1 5.0'
    function = 'p:= w^3 * (10 - 15*w + 6*w^2); M_s * p +  M_l * (1-p)'
    # function = 'm:=alpha/pi * atan(gamma * (T_e - T)); 1/4*w^4 - (1/2 - m/3) * w^3 + (1/4 - m/2) * w^2'
    # outputs = exodus
  [../]
[]

[Postprocessors]
  [./energy_w]
    type = ElementIntegralVariablePostprocessor
    variable = total_en_w
  [../]
  [./energy]
    type = ElementIntegralVariablePostprocessor
    variable = total_en_eta
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
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_factor_shift_type'
  petsc_options_value = 'hypre    boomeramg      31   NONZERO'

  nl_abs_tol = 1e-10
  nl_rel_tol = 1e-08
  l_max_its = 30

  end_time = 10

  [./TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 6
    iteration_window = 2
    dt = 0.00005
    growth_factor = 1.1
    cutback_factor = 0.75
  [../]
  # [./Adaptivity]
  #   initial_adaptivity = 3 # Number of times mesh is adapted to initial condition
  #   refine_fraction = 0.7 # Fraction of high error that will be refined
  #   coarsen_fraction = 0.1 # Fraction of low error that will coarsened
  #   max_h_level = 5 # Max number of refinements used, starting from initial mesh (before uniform refinement)
  #   weight_names = 'w T '
  #   weight_values = '1 0.5 '
  # [../]
[]

# [Adaptivity]
#   marker = err
#   max_h_level = 5
#   [./Indicators]
#     [./error]
#       type = GradientJumpIndicator
#       variable = w
#     [../]
#   [../]
#   [./Markers]
#     [./bound_adapt]
#       type = ValueRangeMarker
#       lower_bound = 0.1
#       upper_bound = 0.99
#       variable = w
#     [../]
#     [./err]
#       type = ErrorFractionMarker
#       indicator = error
#       coarsen = 0.1
#       refine = 0.7
#     [../]
#   [../]
# []

[Outputs]
  # interval = 5
  exodus = true
  file_base = 2018_078_26_dendrite_orientation
[]

[Debug]
  show_var_residual_norms = true
[]
