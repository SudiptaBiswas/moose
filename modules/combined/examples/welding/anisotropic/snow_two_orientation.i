[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 200
  ny = 200
  xmin = -1000
  xmax = 1000
  ymin = -1000
  ymax = 1000
  # uniform_refine = 3
[]

[Variables]
  [./w]
  [../]
  [./T]
    initial_condition = -1.0
  [../]
  [./eta0]
  [../]
  [./eta1]
  [../]
[]

[ICs]
  [./wIC]
    type = SpecifiedSmoothCircleIC
    variable = w
    int_width = 0.05
    x_positions = '6.0 140.0'
    y_positions = '0.0 0.0'
    z_positions = '0 0'
    radii = '0.07 0.07'
    outvalue = 0
    invalue = 0.99
  [../]
  # [./w]
  #   type = SmoothCircleIC
  #   variable = w
  #   int_width = 0.1
  #   x1 = 4.0
  #   y1 = 3.0
  #   radius = 0.07
  #   outvalue = 0
  #   invalue = 1.0
  # [../]
  [./eta0]
    type = SmoothCircleIC
    variable = eta0
    int_width = 0.05
    x1 = 6.0
    y1 = 0.0
    radius = 0.07
    outvalue = 0
    invalue = 0.9
  [../]
  [./eta1]
    type = SmoothCircleIC
    variable = eta1
    int_width = 0.05
    x1 = 140.0
    y1 = 0.0
    radius = 0.07
    outvalue = 0
    invalue = -0.6
  [../]
  # [./wIC]
  #   type = RandomIC
  #   variable = w
  # [../]
  #
  # [./eta0]
  #   type = RandomIC
  #   variable = eta0
  # [../]
  # [./eta1]
  #   type = RandomIC
  #   variable = eta1
  # [../]
[]

# [BCs]
#   # [./Periodic]
#   #   [./all]
#   #     auto_direction = 'x y'
#   #     variable = 'w eta0 eta1'
#   #   [../]
#   # [../]
#   [./temp]
#     type = NeumannBC
#     variable = T
#     value = -0.01
#     boundary = right
#   [../]
# []

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
  [./w2_eta0]
    type = HigherCoupledACInterface
    variable = w
    v = eta0
    f_name = int_coeff
    mob_name = M
  [../]
  [./w2_eta1]
    type = HigherCoupledACInterface
    variable = w
    v = eta1
    f_name = int_coeff
    mob_name = M
  [../]
  [./T_dot]
    type = TimeDerivative
    variable = T
  [../]
  [./CoefDiffusion]
    type = CoefDiffusion
    variable = T
    coef = 0.1
  [../]
  [./w_dot_T]
    type = CoefCoupledTimeDerivative
    variable = T
    v = w
    coef = -2.0
  [../]
  [./eta0_dot]
    type = TimeDerivative
    variable = eta0
  [../]
  [./Awinterfawe_eta0]
    type = SusceptibilityACInterface
    variable = eta0
    mob_name = L_theta
    f_name = int_coeff
    args = 'w'
  [../]
  [./couple_int_eta0]
    type = CoupledAnisotropicInterfaceEnergy
    variable = eta0
    v = w
    mob_name = L_theta
  [../]
  [./eta1_dot]
    type = TimeDerivative
    variable = eta1
  [../]
  [./Awinterfawe_eta1]
    type = SusceptibilityACInterface
    variable = eta1
    mob_name = L_theta
    f_name = int_coeff
    args = 'w'
  [../]
  [./couple_int_eta1]
    type = CoupledAnisotropicInterfaceEnergy
    variable = eta1
    v = w
    mob_name = L_theta
  [../]
[]

[Materials]
  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = fbulk
    args = 'w T'
    constant_names = pi
    constant_expressions = 4*atan(1)
    function = 'm:=0.9 * atan(10 * (1-T)) / pi; 1/4*w^4 - (1/2 - m/3) * w^3 + (1/4 - m/2) * w^2'
    # function = '1/4*w^4 - 1/2*w^2 + 16 * T * (w - 2/3 * w^3 + 1/5 * w^5)'
    derivative_order = 2
    outputs = exodus
  [../]
  [./material]
    type = InterfaceOrientation
    op = w
    anisotropy_strength = 0.05
    # eps_bar = 0.001
    mode_number = 4
    orientation = 'eta0 eta1'
    outputs = exodus
  [../]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'M       kappa_op    L'
    prop_values = '3.333 0.0001       3.333'
    outputs = exodus
  [../]
  [./int_coeff]
    type = DerivativeParsedMaterial
    f_name = int_coeff
    args = w
    function = 'd:=(1-w)^2; n:=7*w^3-6*w^4; if(d>1e-9, n/d, 1e9)'
    # function = 'd:=(1-w)^2; n:=7*w^3-6*w^4; n/d'
    outputs = exodus
  [../]
  [./L_theta]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = L_theta
    constant_names = 'M_s M_l'
    constant_expressions = '0.1 50.0'
    function = 'p:= w^3 * (10 - 15*w + 6*w^2); M_s * p +  M_l * (1-p)'
    # function = 'm:=alpha/pi * atan(gamma * (T_e - T)); 1/4*w^4 - (1/2 - m/3) * w^3 + (1/4 - m/2) * w^2'
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
  l_tol = 1e-04
  l_max_its = 20
  nl_max_its = 20

  end_time = 10000.0

  [./TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 6
    iteration_window = 2
    dt = 0.001
    growth_factor = 1.1
    cutback_factor = 0.75
  [../]
  # [./Adaptivity]
  #   initial_adaptivity = 3 # Number of times mesh is adapted to initial condition
  #   refine_fraction = 0.7 # Fraction of high error that will be refined
  #   coarsen_fraction = 0.1 # Fraction of low error that will coarsened
  #   max_h_level = 5 # Max number of refinements used, starting from initial mesh (before uniform refinement)
  #   weight_names = 'w T eta0 eta1'
  #   weight_values = '1 1 1 1'
  # [../]
[]

[Adaptivity]
  initial_steps = 5
  max_h_level = 5
  initial_marker = EFM_1
  marker = combo
 [./Markers]
    [./EFM_1]
      type = ErrorFractionMarker
      coarsen = 0.02
      refine = 0.75
      indicator = GJI_1
    [../]
    [./EFM_2]
      type = ErrorFractionMarker
      coarsen = 0.02
      refine = 0.75
      indicator = GJI_2
    [../]
    [./EFM_3]
      type = ErrorFractionMarker
      coarsen = 0.02
      refine = 0.75
      indicator = GJI_3
    [../]
    [./EFM_4]
      type = ErrorFractionMarker
      coarsen = 0.02
      refine = 0.75
      indicator = GJI_4
    [../]
    [./combo]
      type = ComboMarker
      markers = 'EFM_1 EFM_2 EFM_3 EFM_4'
    [../]
  [../]

  [./Indicators]
    [./GJI_1]
     type = GradientJumpIndicator
     variable = w
    [../]
   [./GJI_2]
     type = GradientJumpIndicator
     variable = T
    [../]
    [./GJI_3]
      type = GradientJumpIndicator
      variable = eta0
     [../]
     [./GJI_4]
       type = GradientJumpIndicator
       variable = eta1
      [../]
  [../]
[]

[Outputs]
  # interval = 5
  exodus = true
  file_base = 2018_08_1_coupled_orientation_dendrite
[]

[Debug]
  show_var_residual_norms = true
[]
