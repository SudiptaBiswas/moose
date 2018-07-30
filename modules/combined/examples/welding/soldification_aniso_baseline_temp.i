[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  xmax = 10.0
  ymax = 10.0
  uniform_refine = 4
[]

[Variables]
  [./w]
  [../]
  [./T]
    initial_condition = -0.5
  [../]
[]

[AuxVariables]
  [./total_en_w]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./total_en_w]
    type = TotalFreeEnergy
    variable = total_en_w
    kappa_names = 'eps'
    interfacial_vars = 'w'
  [../]
[]

[ICs]
  [./w]
    type = SpecifiedSmoothCircleIC
    variable = w
    int_width = 0.1
    x_positions = '3.0 6.0'
    y_positions = '5. 5.'
    z_positions = '0 0'
    radii = '0.8 0.8'
    outvalue = 0
    invalue = 0.95
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
  # [../]
  [./anisoACinterface1]
    type = ACInterfaceKobayashi1
    variable = w
  [../]
  [./anisoACinterface2]
    type = ACInterfaceKobayashi2
    variable = w
  [../]
  [./w_bulk]
    type = AllenCahn
    variable = w
    f_name = F
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
    coef = -1.0
  [../]
[]

[Materials]
  [./bulk_en]
    type = DerivativeParsedMaterial
    args = 'w T'
    function = 'w^2 * (1-w)^2 - T * (1 - 20*w^3 + 45*w^4 - 36*w^5 + 10*w^6)'
    # constant_names = 'pi T'
    # constant_expressions = '4*atan(1) -0.5'
    # function = 'm:=0.9 * atan(10 * (1 - T)) / pi; 1/4*w^4 - (1/2 - m/3) * w^3 + (1/4 - m/2) * w^2'
    outputs = exodus
  [../]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'L    '
    prop_values = '33.33  '
  [../]
  [./material]
    type = InterfaceOrientationMaterial
    op = w
    mode_number = 4
    # anisotropy_strength = 0.1
    eps_bar = 0.1
  [../]
[]
#
# [BCs]
#   [./Periodic]
#     [./all]
#     auto_direction = 'x y'
#     variable = 'w eta0 eta1'
#   [../]
# [../]
# []

[Postprocessors]
  [./energy_w]
    type = ElementIntegralVariablePostprocessor
    variable = total_en_w
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
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_fawtor_shift_type'
  petsc_options_value = 'hypre    boomeramg      31 NONZERO '
  petsc_options = '-snes_converged_reason -ksp_converged_reason'

  nl_abs_tol = 1e-10
  nl_rel_tol = 1e-08
  l_max_its = 20
  nl_max_its = 20
  l_tol = 1e-4
  # dt = 0.02
  end_time = 20

  [./TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 6
    iteration_window = 2
    dt = 5e-4
    growth_factor = 1.2
    cutback_factor = 0.75
  [../]
[]

[Adaptivity]
  marker = err
  max_h_level = 6
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
      coarsen = 0.2
      refine = 0.75
    [../]
  [../]
[]

[Outputs]
  exodus = true
  # file_base = 2018_07_12_soldification_aniso_baseline
[]

[Debug]
  show_var_residual_norms = true
[]
