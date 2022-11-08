[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 75
  ny = 75
  xmax = 960
  ymax = 960
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
    type = SmoothCircleIC
    variable = w
    int_width = 4.0
    x1 = 0.0
    y1 = 0.0
    radius = 8.0
    outvalue = -1
    invalue = 1
  [../]
  [T_ic]
    type = ConstantIC
    variable = T
    value = -0.3
  []
[]

[Kernels]
  [./w_dot]
    type = TimeDerivative
    variable = w
  [../]
  [./anisoACinterface1]
    type = ACInterfaceKobayashi1
    variable = w
    mob_name = 1
  [../]
  [./anisoACinterface2]
    type = ACInterfaceKobayashi2
    variable = w
    mob_name = 1
  [../]
  [./AllenCahn]
    type = AllenCahn
    variable = w
    mob_name = 1
    f_name = fbulk
    args = T
  [../]
  [./T_dot]
    type = TimeDerivative
    variable = T
  [../]
  [./CoefDiffusion]
    type = HeatConduction
    variable = T
    diffusion_coefficient = D
  [../]
  [./w_dot_T]
    type = CoefCoupledTimeDerivative
    variable = T
    v = w
    coef = -0.5
  [../]
[]

[Materials]
  # [./free_energy]
  #   type = DerivativeParsedMaterial
  #   f_name = fbulk
  #   args = 'w T'
  #   constant_names = pi
  #   constant_expressions = 4*atan(1)
  #   function = 'm:=0.9 * atan(10 * (1 - T)) / pi; 1/4*w^4 - (1/2 - m/3) * w^3 + (1/4 - m/2) * w^2'
  #   derivative_order = 2
  #   outputs = exodus
  # [../]
  [./lambda]
    type = ParsedMaterial
    f_name = lambda
    constant_names = 't0 W0'
    constant_expressions = '1.0 1.0'
    material_property_names = 'D'
    function = 'D*t0/(0.6267*W0^2)'
    outputs = exodus
  [../]
  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = fbulk
    args = 'w T'
    constant_names = pi
    constant_expressions = 4*atan(1)
    material_property_names = 'lambda'
    function = '(-1/2*w^2+1/4*w^4+T*lambda*w*(1-2/3*w^2+1/5*w^4))'
    derivative_order = 2
    outputs = exodus
  [../]
  [./material]
    type = InterfaceOrientationMaterial
    op = w
    mode_number = 4
    eps_bar = 1.0
    anisotropy_strength = 0.05
    reference_angle = 0
  [../]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'D'
    prop_values = '10.0'
  [../]
[]

[Postprocessors]
  [solid]
    type = ElementIntegralVariablePostprocessor
    variable = w
  []
  [tipx]
    type = FindValueOnLine
    start_point = '0.0 0.0 0.0'
    end_point = '960.0 0.0 0.0'
    v = w
    target = 0.0
    tol = 0.1
  []
  [tipy]
    type = FindValueOnLine
    start_point = '0.0 0.0 0.0'
    end_point = '0.0 960.0 0.0'
    v = w
    target = 0.0
    tol = 0.1
  []
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

  end_time = 1500.0
  dtmax = 0.3
  [./TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 6
    iteration_window = 2
    dt = 0.003
    growth_factor = 1.1
    cutback_factor = 0.75
  [../]
  [./Adaptivity]
    initial_adaptivity = 3 # Number of times mesh is adapted to initial condition
    refine_fraction = 0.7 # Fraction of high error that will be refined
    coarsen_fraction = 0.1 # Fraction of low error that will coarsened
    max_h_level = 6 # Max number of refinements used, starting from initial mesh (before uniform refinement)
    weight_names = 'w T'
    weight_values = '1 0.5'
  [../]
[]

[Outputs]
  interval = 5
  sync_times = '15 75 150 300 600 900 1200 1500'
  exodus = true
  csv = true
  perf_graph = true
  # file_base = snow_45_refine1
[]
