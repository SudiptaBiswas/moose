[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 20
  ny = 20
  xmin = 0
  xmax = 10
  ymin = 0
  ymax = 10
  # uniform_refine = 2
[]

[Variables]
  [./phi]
  [../]
  [./u]
  [../]
[]

[ICs]
  [./phi_IC]
    type = SmoothCircleIC
    variable = phi
    block = 0
    int_width = 0.2
    x1 = 5.0
    y1 = 5.0
    radius = 2.0
    outvalue = 0
    invalue = 1
  [../]
  # [./u_IC]
  #   type = ConstantIC
  #   value = -0.3
  #   variable = u
  # [../]
[]

[BCs]
  #[./Periodic]
  #  [./All]
  #    auto_direction = 'x y'
  #    variable = 'c w gr0 gr1'
  #  [../]
  #[../]
  # [./bottom_y]
  #   type = PresetBC
  #   variable = u
  #   boundary = bottom
  #   value = -0.05
  # [../]
  # [./left_x]
  #   type = PresetBC
  #   variable = u
  #   boundary = left
  #   value = -0.05
  # [../]
  # [./right_x]
  #   type = PresetBC
  #   variable = u
  #   boundary = right
  #   value = -0.05
  # [../]
  # [./top_y]
  #   type = PresetBC
  #   variable = u
  #   boundary = top
  #   value = -0.05
  # [../]
[]

[Kernels]
  [./phi_dot]
    type = TimeDerivative
    variable = phi
  [../]
  [./anisoACinterface1]
    type = ACInterfaceKobayashi1
    variable = phi
    mob_name = M
  [../]
  [./anisoACinterface2]
    type = ACInterfaceKobayashi2
    variable = phi
    mob_name = M
  [../]
  [./AllenCahn]
    type = AllenCahn
    variable = phi
    mob_name = M
    f_name = fbulk
    args = 'u'
  [../]
  [./u_dot]
    type = TimeDerivative
    variable = u
  [../]
  [./CoefDiffusion]
    type = MatDiffusion
    variable = u
    D_name = D
  [../]
  [./w_dot_T]
    type = CoefCoupledTimeDerivative
    variable = u
    v = phi
    coef = 0.5 #This is -K from kobayashi's paper
  [../]
[]

[Materials]
  [./free_energy]
    type = DerivativeParsedMaterial
    block = 0
    f_name = fbulk
    args = 'phi u'
    # constant_names = 'D lambda'
    # constant_expressions = '10.0 D/0.6267'
    # function = '-phi^2/2+phi^4/4+lambda*u*phi*(1-2/3*phi^2+phi^4/5)'
    constant_names = 'alpha gamma T_e pi'
    constant_expressions = '0.9 10 1 4*atan(1)'
    function = 'm:=alpha/pi * atan(gamma * (T_e - u)); 1/4*phi^4 - (1/2 - m/3) * phi^3 + (1/4 - m/2) * phi^2'
    derivative_order = 2
    outputs = exodus
  [../]
  [./material]
    type = InterfaceOrientationMaterial
    block = 0
    op = phi
    mode_number = 4
    anisotropy_strength = 0.05
    eps_bar = 1.0
    reference_angle = 0
  [../]
  [./consts]
    type = GenericConstantMaterial
    block = 0
    prop_names  = 'D M'
    prop_values = '10.0 1.0'
  [../]
[]

[Postprocessors]
  [./elem_phi]
    type = ElementIntegralVariablePostprocessor
    variable = phi
  [../]
  [./elem_u]
    type = ElementIntegralVariablePostprocessor
    variable = u
  [../]
  [./free_en]
    type = ElementIntegralMaterialProperty
    mat_prop = fbulk
  [../]
[]

[VectorPostprocessors]
  # [./velocity]
  #   type = LineValueSampler
  #   variable = 'u phi'
  #   start_point = '0.0 0.0 0.0'
  #   end_point = '9.0 0.0 0.0'
  #   sort_by = id
  #   num_points = 40
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
  solve_type = PJFNK
  scheme = bdf2
  #petsc_options_iname = '-pc_type'
  #petsc_options_value = 'lu'
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   ilu      1'

  nl_rel_tol = 1e-08
  nl_abs_tol = 1e-11
  l_tol = 1e-4
  l_max_its = 30

  #dt = 0.001
  end_time = 1000
  dtmax = 0.3
  # [./Adaptivity]
  #   refine_fraction = 0.7
  #   coarsen_fraction = 0.1
  #   max_h_level = 2
  #   initial_adaptivity = 1
  # [../]
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.003
    # timestep_limiting_function = 0.3
    growth_factor = 1.05
    optimal_iterations = 4
  [../]
[]

[Adaptivity]
  marker = bound_adapt
  max_h_level = 2
  [./Indicators]
    [./error]
      type = GradientJumpIndicator
      variable = phi
    [../]
  [../]
  [./Markers]
    [./bound_adapt]
      type = ErrorFractionMarker
      indicator = error
      coarsen = 0.2
      refine = 0.75
    [../]
  [../]
[]

[Outputs]
  exodus = true
  gnuplot = true
  print_perf_log = true
  # file_base = prob1a_quart_2
[]
