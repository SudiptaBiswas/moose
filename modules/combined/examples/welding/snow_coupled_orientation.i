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
  [./eta0]
  [../]
  [./eta1]
  [../]
[]

[AuxVariables]
  # [./theta]
  # [../]
  [./bnds]
  [../]
  [./total_en_w]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./total_en]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  # [./theta]
  #   type = ConstantAux
  #   variable = theta
  #   value = 1.5
  # [../]
  [./bnds]
    type = BndsCalcAux
    v = 'eta0 eta1'
    variable = bnds
  [../]
  [./total_en_w]
    type = TotalFreeEnergy
    variable = total_en_w
    kappa_names = 'eps'
    interfacial_vars = 'w'
  [../]
  [./total_en]
    type = TotalFreeEnergy
    variable = total_en
    kappa_names = 'int_coeff int_coeff'
    interfacial_vars = 'eta0 eta1'
    f_name = 0.0
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
  [./eta0]
    type = SmoothCircleIC
    variable = eta0
    int_width = 0.2
    x1 = 3.0
    y1 = 4.5
    radius = 0.8
    outvalue = 0
    invalue = 0.8
  [../]
  [./eta1]
    type = SmoothCircleIC
    variable = eta1
    int_width = 0.2
    x1 = 6.0
    y1 = 4.5
    radius = 0.8
    outvalue = 0
    invalue = -0.8
  [../]
  [./w]
    type = SpecifiedSmoothCircleIC
    variable = w
    int_width = 0.2
    x_positions = '3.0 6.0'
    y_positions = '4.5 4.5'
    z_positions = '0 0'
    radii = '0.8 0.8'
    outvalue = 0
    invalue = 0.95
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
  [../]
  [./anisoACinterface2]
    type = ACInterfaceKobayashi2
    variable = w
  [../]
  [./AllenCahn]
    type = AllenCahn
    variable = w
    f_name = F
    args = T
  [../]
  [./w2_eta0]
    type = HigherCoupledACInterface
    variable = w
    v = eta0
    f_name = int_coeff
    kappa_name = kappa_dummy
  [../]

  [./w2_eta1]
    type = HigherCoupledACInterface
    variable = w
    v = eta1
    f_name = int_coeff
    kappa_name = kappa_dummy
  [../]
  [./T_dot]
    type = TimeDerivative
    variable = T
  [../]
  [./CoefDiffusion]
    type = Diffusion
    variable = T
    # D_name = D
    # args = 'w'
  [../]
  # [./CoefDiffusion]
  #   type = MatDiffusion
  #   variable = T
  #   D_name = D
  #   args = 'w'
  # [../]
  [./w_dot_T]
    type = CoefCoupledTimeDerivative
    variable = T
    v = w
    coef = 0.8
  [../]

  [./eta0_dot]
    type = TimeDerivative
    variable = eta0
  [../]
  [./Awinterfawe_eta0]
    type = ACInterface
    variable = eta0
    args = 'w'
    kappa_name = int_coeff
  [../]
  [./eta1_dot]
    type = TimeDerivative
    variable = eta1
  [../]
  [./Awinterfawe_eta1]
    type = ACInterface
    variable = eta1
    args = 'w'
    kappa_name = int_coeff
  [../]
[]

[Materials]
  [./free_energy]
    type = DerivativeParsedMaterial
    # f_name = fbulk
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
    type = InterfaceOrientation
    op = w
    orientation = bnds
    anisotropy_strength = 0.09
    mode_number = 6
    outputs = exodus
  [../]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'L       kappa_op kappa_dummy'
    prop_values = '3.3   0.0223    1.0'
  [../]
  [./int_coeff]
    type = DerivativeParsedMaterial
    f_name = int_coeff
    args = w
    constant_names = kappa_theta
    constant_expressions = 0.01
    # function = 'd:=(1-w)^2; n:=7*w^3-6*w^4; if(d>0.01, kappa_theta*n/d, 0)'
    function = 'd:=(1-w)^2; n:=7*w^3-6*w^4; kappa_theta*n/d'
    outputs = exodus
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
    weight_names = 'w T'
    weight_values = '1 0.5'
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]

[Outputs]
  # interval = 5
  exodus = true
  file_base = solidification_coupled_orientation
[]
