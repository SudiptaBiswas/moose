[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  xmax = 10.0
  ymax = 10.0
  # uniform_refine = 4
[]

[Variables]
  [./w]
  [../]
  [./eta0]
  [../]
  [./eta1]
  [../]
[]

[AuxVariables]
  [./total_en_w]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./total_en_eta]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./bnds]
  [../]
[]

[AuxKernels]
  [./total_en_w]
    type = TotalFreeEnergy
    variable = total_en_w
    kappa_names = 'kappa_op'
    interfacial_vars = 'w'
  [../]
  [./bnds]
    type = BndsCalcAux
    v = 'eta0 eta1'
    variable = bnds
  [../]
  [./total_en]
    type = TotalFreeEnergy
    variable = total_en_eta
    kappa_names = 'int_coeff int_coeff'
    interfacial_vars = 'eta0 eta1'
    f_name = 0.0
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
  [./eta0]
    type = SmoothCircleIC
    variable = eta0
    int_width = 0.1
    x1 = 3.0
    y1 = 5.0
    radius = 0.8
    outvalue = 0
    invalue = 1.0
  [../]
  [./eta1]
    type = SmoothCircleIC
    variable = eta1
    int_width = 0.1
    x1 = 6.0
    y1 = 5.
    radius = 0.8
    outvalue = 0
    invalue = -1.0
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
    # args = T
  [../]
  [./w2_eta0]
    type = HigherCoupledACInterface
    variable = w
    v = eta0
    f_name = int_coeff
  [../]
  [./w2_eta1]
    type = HigherCoupledACInterface
    variable = w
    v = eta1
    f_name = int_coeff
  [../]

  [./eta0_dot]
    type = TimeDerivative
    variable = eta0
  [../]
  [./Awinterfawe_eta0]
    type = SusceptibilityACInterface
    variable = eta0
    args = 'w'
    f_name = int_coeff
    mob_name = L_theta
  [../]
  [./eta1_dot]
    type = TimeDerivative
    variable = eta1
  [../]
  [./Awinterfawe_eta1]
    type = SusceptibilityACInterface
    variable = eta1
    args = 'w'
    f_name = int_coeff
    mob_name = L_theta
  [../]
[]

[Materials]
  [./bulk_en]
    type = DerivativeParsedMaterial
    args = 'w '
    function = 'w^2 * (1-w)^2 + 0.5 * (1 - 20*w^3 + 45*w^4 - 36*w^5 + 10*w^6)'
    # constant_names = 'pi T'
    # constant_expressions = '4*atan(1) -0.5'
    # function = 'm:=0.9 * atan(10 * (1 - T)) / pi; 1/4*w^4 - (1/2 - m/3) * w^3 + (1/4 - m/2) * w^2'
    # outputs = exodus
  [../]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'L     kappa_op kappa_theta L_eta'
    prop_values = '0.9   0.0223      0.01     10'
  [../]
  [./int_coeff]
    type = DerivativeParsedMaterial
    f_name = int_coeff
    args = w
    # function = 'd:=(1-w)^2; n:=7*w^3-6*w^4; if(d>0.01, n/d, 0)'
    function = 'd:=(1-w)^2; n:=7*w^3-6*w^4; n/d'
    # outputs = exodus
  [../]
  [./material]
    type = InterfaceOrientation
    op = w
    mode_number = 4
    # anisotropy_strength = 0.1
    eps_bar = 0.1
    orientation = bnds
  [../]
  [./L_theta]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = L_theta
    constant_names = 'M_s M_l'
    constant_expressions = '0.1 10.0'
    function = 'p:= w^3 * (10 - 15*w + 6*w^2); M_s * p +  M_l * (1-p)'
    # function = 'm:=alpha/pi * atan(gamma * (T_e - T)); 1/4*w^4 - (1/2 - m/3) * w^3 + (1/4 - m/2) * w^2'
    # outputs = exodus
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
  [./energy]
    type = ElementIntegralVariablePostprocessor
    variable = total_en_eta
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
      variable = bnds
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
  # file_base = 2018_07_12_orientation_mob_test
[]

[Debug]
  show_var_residual_norms = true
[]
