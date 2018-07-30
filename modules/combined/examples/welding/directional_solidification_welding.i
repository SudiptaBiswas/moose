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
  # [./T]
  # [../]
[]

[Functions]
  [./temp]
    type = MobilityProfile
    x1 = 0
    y1 = 4.5
    z1 = 0
    r1 = 1.0
    haz = 0.5
    vp = 2.5
    factor = 1.0
    invalue = 1.0
    outvalue = -1.2
    weldpool_shape = circular
  [../]
  [./mob]
    type = MobilityProfile
    x1 = 0
    y1 = 4.5
    z1 = 0
    r1 = 1.0
    haz = 0.5
    vp = 2.5
    factor = 1.0
    invalue = 1.1
    outvalue = 0.0
    weldpool_shape = circular
  [../]
[]

[AuxVariables]
  [./T]
  [../]
[]

[AuxKernels]
  [./T]
    type = FunctionAux
    variable = T
    function = temp
  [../]
[]

[ICs]
  # [./wIC]
  #   type = SmoothCircleIC
  #   variable = w
  #   int_width = 0.1
  #   x1 = 0
  #   y1 = 4.5
  #   radius = 1.0
  #   outvalue = 0.0
  #   invalue = 1.0
  # [../]

  [./wIC]
    type = FunctionIC
    variable = w
    function = mob
  [../]

  # [./wIC_bi]
  #   type = BoundingBoxIC
  #   variable = w
  #   x1 = 0
  #   y1 = 0
  #   x2 = 9
  #   y2 = 4.5
  #   inside = 1
  #   outside = 0
  # [../]
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
  # [./T_dot]
  #   type = TimeDerivative
  #   variable = T
  # [../]
  # [./CoefDiffusion]
  #   type = Diffusion
  #   variable = T
  #   # D_name = D
  #   # args = 'w'
  # [../]
  # [./CoefDiffusion]
  #   type = MatDiffusion
  #   variable = T
  #   D_name = D
  #   args = 'w'
  # [../]
  # [./w_dot_T]
  #   type = CoefCoupledTimeDerivative
  #   variable = T
  #   v = w
  #   coef = -1.8
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
    outputs = exodus
  [../]
  # [./D]
  #   type = DerivativeParsedMaterial
  #   f_name = D
  #   args = 'w'
  #   function = '(1- w)/2'
  #   derivative_order = 2
  #   # outputs = exodus
  # [../]
  [./material]
    type = InterfaceOrientationMaterial
    op = w
    mode_number = 6
    anisotropy_strength = 0.04
    reference_angle = 90

  [../]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'M'
    prop_values = '3333.333'
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
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre    boomeramg      31'

  nl_abs_tol = 1e-10
  nl_rel_tol = 1e-08
  l_max_its = 20
  nl_max_its = 20
  l_tol = 1e-4

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
    weight_names = 'w'
    weight_values = '1'
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]

[Outputs]
  # interval = 5
  exodus = true
  # file_base = directional_solidification2
[]
