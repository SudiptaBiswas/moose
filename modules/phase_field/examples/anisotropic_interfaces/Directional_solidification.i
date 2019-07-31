[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 14
  ny = 14
  xmax = 9
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

  # [./wIC]
  #   type = SmoothCircleIC
  #   variable = w
  #   int_width = 0.1
  #   x1 = 4.5
  #   y1 = 4.5
  #   radius = 0.07
  #   outvalue = 0
  #   invalue = 1
  # [../]
  [./wIC]
    type = BoundingBoxIC
    x1 = 0
    y1 = 0
    x2 = 2
    y2 = 9
    int_width = 0.1
    inside = 0
    outside = 1
    variable = w
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
    # outputs = exodus
  [../]
  [./material]
    type = InterfaceOrientationMaterial
    op = w
  [../]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'M'
    prop_values = '333.333'
  [../]
  # [./mob]
  #   type = DerivativeParsedMaterial
  #   f_name = M
  #   args = 'w'
  #   constant_names = 'M_s M_l'
  #   constant_expressions = '10.0 333.33'
  #   function = 'p:= w^3 * (10 - 15*w + 6*w^2); M_s * p +  M_l * (1-p)'
  #   derivative_order = 2
  #   # outputs = exodus
  # [../]

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
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre    boomeramg      31'

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
  [./Adaptivity]
    initial_adaptivity = 3 # Number of times mesh is adapted to initial condition
    refine_fraction = 0.7 # Fraction of high error that will be refined
    coarsen_fraction = 0.1 # Fraction of low error that will coarsened
    max_h_level = 5 # Max number of refinements used, starting from initial mesh (before uniform refinement)
    weight_names = 'w T'
    weight_values = '1 0.5'
  [../]
[]

# [Adaptivity]
#  initial_steps = 3
#  max_h_level = 5
#  # initial_marker = err_eta
#  marker = err_bnds
# [./Markers]
#    # [./err_eta]
#    #   type = ErrorFractionMarker
#    #   coarsen = 0.3
#    #   refine = 0.9
#    #   indicator = ind_eta
#    # [../]
#    [./err_bnds]
#      type = ErrorFractionMarker
#      coarsen = 0.3
#      refine = 0.9
#      indicator = ind_bnds
#    [../]
#  [../]
#  [./Indicators]
#    # [./ind_eta]
#    #   type = GradientJumpIndicator
#    #   variable = w
#    #  [../]
#     [./ind_bnds]
#       type = GradientJumpIndicator
#       variable = w
#    [../]
#  [../]
# []

[Outputs]
  # interval = 5
  exodus = true
[]
