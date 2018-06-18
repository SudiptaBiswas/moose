[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 32
  ny = 32
  xmax = 10.0
  ymax = 10.0
[]

[Variables]
  [./w]
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

[ICs]
  [./wIC]
    type = SpecifiedSmoothCircleIC
    variable = w
    int_width = 0.5
    x_positions = '0.0 10.0 10.0 0.0'
    y_positions = '0.0 0.0  10.0 10.0 '
    z_positions = '0.0 0.0  0.0  0.0 '
    radii = '2.0 4.0 3.0 3.0'
    outvalue = 0
    invalue = 1
  [../]
  [./eta0]
    type = SmoothCircleIC
    variable = eta0
    int_width = 0.5
    x1 = 0.0
    y1 = 0.0
    radius = 2.0
    outvalue = 0
    invalue = 1
  [../]
  [./eta1]
    type = SmoothCircleIC
    variable = eta1
    int_width = 0.5
    x1 = 10.0
    y1 = 0.0
    radius = 4.0
    outvalue = 0
    invalue = 1
  [../]
  [./eta2]
    type = SmoothCircleIC
    variable = eta2
    int_width = 0.5
    x1 = 10.0
    y1 = 10.0
    radius = 3.0
    outvalue = 0
    invalue = 1
  [../]
  [./eta3]
    type = SmoothCircleIC
    variable = eta3
    int_width = 0.5
    x1 = 0.0
    y1 = 10.0
    radius = 3.0
    outvalue = 0
    invalue = 1
  [../]
[]

[Kernels]
  [./w_dot]
    type = TimeDerivative
    variable = w
    # Coefficient = 3e-4
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
    # args = 'T'
  [../]
  [./eta0_dot]
    type = TimeDerivative
    variable = eta0
  [../]
  [./eta1_dot]
    type = TimeDerivative
    variable = eta1
  [../]
  [./eta2_dot]
    type = TimeDerivative
    variable = eta2
  [../]
  [./eta3_dot]
    type = TimeDerivative
    variable = eta3
  [../]
  # [./CoefDiffusion]
  #   type = Diffusion
  #   variable = T
  # [../]
  # [./w_dot_T]
  #   type = CoefCoupledTimeDerivative
  #   variable = T
  #   v = w
  #   coef = -1.8 #This is -K from kobayashi's paper
  # [../]
[]

[Materials]
  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = fbulk
    args = 'w'
    constant_names = 'm'
    constant_expressions = '0.3'
    function = 'w * (1 - w) * (w - 1/2 + m)'
    derivative_order = 2
    outputs = exodus
  [../]
  [./material]
    type = InterfaceOrientationMaterial
    op = w
    anisotropy_strength = 0.0
    eps_bar = 0.01
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
  solve_type = PJFNK
  scheme = bdf2
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre    boomeramg      31'

  nl_rel_tol = 1e-08
  l_tol = 1e-4
  l_max_its = 30

  end_time = 1

  [./TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 6
    iteration_window = 2
    dt = 0.001
    growth_factor = 1.1
    cutback_factor = 0.75
  [../]
[]

[Outputs]
  exodus = true
  print_perf_log = true
  execute_on = 'INITIAL FINAL'
[]
