# Anisotropic growth observed, no dendride formation, precipitates collide with each other
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
  # [./eta3]
  # [../]
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
    type = SpecifiedSmoothCircleIC
    variable = eta0
    int_width = 0.2
    x_positions = '4.5 4.5'
    y_positions = '4.5 10.0'
    z_positions = '0.0 0.0'
    radii = '0.07 0.07'
    outvalue = 0
    invalue = 1
  [../]
  # [./eta0]
  #   type = SmoothCircleIC
  #   variable = eta0
  #   int_width = 0.2
  #   x1 = 4.5
  #   y1 = 4.5
  #   radius = 0.07
  #   outvalue = 0
  #   invalue = 1
  # [../]
  [./eta1]
    type = SmoothCircleIC
    variable = eta1
    int_width = 0.2
    x1 = 10.0
    y1 = 4.5
    radius = 0.07
    outvalue = 0
    invalue = 1
  [../]
  # [./eta2]
  #   type = SmoothCircleIC
  #   variable = eta2
  #   int_width = 0.1
  #   x1 = 10.0
  #   y1 = 4.5
  #   radius = 0.07
  #   outvalue = 0
  #   invalue = 1
  # [../]
  [./eta2]
    type = SmoothCircleIC
    variable = eta2
    int_width = 0.2
    x1 = 10.0
    y1 = 10.0
    radius = 0.07
    outvalue = 0
    invalue = 1
  [../]
[]

[Kernels]
  [./eta0_dot]
    type = TimeDerivative
    variable = eta0
  [../]
  [./anisoACinterface1_eta0]
    type = ACInterfaceKobayashi1
    variable = eta0
    mob_name = M
  [../]
  [./anisoACinterface2_eta0]
    type = ACInterfaceKobayashi2
    variable = eta0
    mob_name = M
  [../]
  [./AllenCahn_eta0]
    type = AllenCahn
    variable = eta0
    mob_name = M
    f_name = fbulk
    # args = T
  [../]
  [./eta1_dot]
    type = TimeDerivative
    variable = eta1
  [../]
  [./anisoACinterface1_eta1]
    type = ACInterfaceKobayashi1
    variable = eta1
    mob_name = M
  [../]
  [./anisoACinterface2_eta1]
    type = ACInterfaceKobayashi2
    variable = eta1
    mob_name = M
  [../]
  [./AllenCahn_eta1]
    type = AllenCahn
    variable = eta1
    mob_name = M
    f_name = fbulk
    # args = T
  [../]
  [./eta2_dot]
    type = TimeDerivative
    variable = eta2
  [../]
  [./anisoACinterface1_eta2]
    type = ACInterfaceKobayashi1
    variable = eta2
    mob_name = M
  [../]
  [./anisoACinterface2_eta2]
    type = ACInterfaceKobayashi2
    variable = eta2
    mob_name = M
  [../]
  [./AllenCahn_eta2]
    type = AllenCahn
    variable = eta2
    mob_name = M
    f_name = fbulk
    # args = T
  [../]

  # [./T_dot]
  #   type = TimeDerivative
  #   variable = T
  # [../]
  # [./CoefDiffusion]
  #   type = Diffusion
  #   variable = T
  # [../]
  # [./w_dot_T]
  #   type = CoefCoupledTimeDerivative
  #   variable = T
  #   v = w
  #   coef = -1.8
  # [../]
  # [./eta0_dot]
  #   type = TimeDerivative
  #   variable = eta0
  # [../]
  # [./eta1_dot]
  #   type = TimeDerivative
  #   variable = eta1
  # [../]
  # [./eta2_dot]
  #   type = TimeDerivative
  #   variable = eta2
  # [../]
  # [./eta3_dot]
  #   type = TimeDerivative
  #   variable = eta3
  # [../]
[]

[Materials]
  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = fbulk
    args = 'eta0 eta1 eta2'
    constant_names = m
    constant_expressions = 0.3
    function = '  1/4*eta0^4 - (1/2 - m/3) * eta0^3 + (1/4 - m/2) * eta0^2
                + 1/4*eta1^4 - (1/2 - m/3) * eta1^3 + (1/4 - m/2) * eta1^2
                + 1/4 * eta2^4 - (1/2 - m/3) * eta2^3 + (1/4 - m/2) * eta2^2'
    derivative_order = 2
    outputs = exodus
  [../]
  # [./free_energy_eta1]
  #   type = DerivativeParsedMaterial
  #   f_name = fbulk_eta1
  #   args = 'eta1'
  #   constant_names = m
  #   constant_expressions = 0.3
  #   function = '1/4*eta1^4 - (1/2 - m/3) * eta1^3 + (1/4 - m/2) * eta1^2'
  #   derivative_order = 2
  #   outputs = exodus
  # [../]
  # [./free_energy_eta2]
  #   type = DerivativeParsedMaterial
  #   f_name = fbulk_eta2
  #   args = 'eta2'
  #   constant_names = m
  #   constant_expressions = 0.3
  #   function = '1/4*eta2^4 - (1/2 - m/3) * eta2^3 + (1/4 - m/2) * eta2^2'
  #   derivative_order = 2
  #   outputs = exodus
  # [../]
  # [./int_eta2]
  #   type = DerivativeParsedMaterial
  #   f_name = eps
  #   args = 'eta2'
  #   constant_names = m
  #   constant_expressions = 0.3
  #   function = '1/4*eta2^4 - (1/2 - m/3) * eta2^3 + (1/4 - m/2) * eta2^2'
  #   derivative_order = 2
  #   outputs = exodus
  # [../]
  # [./int_eta0]
  #   type = InterfaceOrientationMaterial
  #   op = eta0
  #   # mode_number = 0
  #   anisotropy_strength = 0
  #   eps_bar = 0.01
  # [../]
  # [./int_eta1]
  #   type = InterfaceOrientationMaterial
  #   op = eta1
  #   # mode_number = 0
  #   anisotropy_strength = 0
  #   eps_bar = 0.01
  # [../]
  [./int_eta2]
    type = InterfaceOrientationMaterial
    op = eta0
    # mode_number = 0
    anisotropy_strength = 0
    eps_bar = 0.01
  [../]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'M       '
    prop_values = '3333.333 '
  [../]
[]

[AuxKernels]
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'eta0 eta1 eta2'
    execute_on = timestep_end
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
    weight_names = 'eta0 eta1 eta2'
    weight_values = '1 1 1'
  [../]
[]

[Outputs]
  interval = 5
  exodus = true
  file_base = notemp_iso_multi_test2
[]
