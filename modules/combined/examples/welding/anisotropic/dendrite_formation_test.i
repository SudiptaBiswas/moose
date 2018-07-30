[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 30
  ny = 40
  xmax = 15
  ymax = 9
  uniform_refine = 3
[]

[Variables]
  [./w]
  [../]
  [./T]
  [../]
[]

[ICs]
  [./wIC]
    type = SpecifiedSmoothCircleIC
    variable = w
    int_width = 0.1
    x_positions = '5.0 10.0'
    y_positions = '4.5 4.5'
    z_positions = '0 0'
    radii = '0.07 0.07'
    outvalue = 0
    invalue = 1
  [../]
[]

[AuxVariables]
  [./total_en_w]
    order = CONSTANT
    family = MONOMIAL
  [../]
  # [./total_en_eta]
  #   order = CONSTANT
  #   family = MONOMIAL
  # [../]
  [./bnds]
  [../]
[]

[AuxKernels]
  [./total_en_w]
    type = TotalFreeEnergy
    variable = total_en_w
    f_name = fbulk
    kappa_names = 'eps'
    interfacial_vars = 'w'
  [../]
  # [./bnds]
  #   type = BndsCalcAux
  #   v = 'eta0 eta1'
  #   variable = bnds
  # [../]
  [./bnds]
    type = ConstantAux
    variable = bnds
    value = 0.0
  [../]
  # [./total_en]
  #   type = TotalFreeEnergy
  #   variable = total_en_eta
  #   kappa_names = 'int_coeff int_coeff'
  #   interfacial_vars = 'eta0 eta1'
  #   f_name = 0.0
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
  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = fbulk
    args = 'w T'
    constant_names = pi
    constant_expressions = 4*atan(1)
    function = 'm:=0.9 * atan(10 * (1 - T)) / pi; 1/4*w^4 - (1/2 - m/3) * w^3 + (1/4 - m/2) * w^2'
    derivative_order = 2
    outputs = exodus
  [../]
  [./material]
    type = InterfaceOrientation
    op = w
    orientation = 'bnds'
  [../]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'M kappa_op'
    prop_values = '3333.33 1.0'
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
  max_h_level = 5
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
      coarsen = 0.1
      refine = 0.7
    [../]
  [../]
[]

[Outputs]
  # interval = 5
  exodus = true
[]

[Debug]
  show_var_residual_norms = true
[]
