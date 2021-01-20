[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 60
  ny = 1
  xmin = -15
  xmax = 15
  ymax = 1
  ymin = -1
  elem_type = QUAD4
  # uniform_refine = 2
[]

[Variables]
  [./w]
    # initial_condition = 0.1
  [../]
  [./etaa0]
    # [./InitialCondition]
    #   type = BoundingBoxIC
    #   x1 = -50.0
    #   x2 = 0.0
    #   y1 = -1
    #   y2 = 1
    #   inside = 1
    # [../]
  [../]
  [./etab0]
    # [./InitialCondition]
    #   type = BoundingBoxIC
    #   x1 = 0.0
    #   x2 = 50.0
    #   y1 = -1
    #   y2 = 1
    #   inside = 1
    # [../]
  [../]
[]

[ICs]
  [./IC_etab0]
    type = FunctionIC
    variable = etab0
    function = ic_func_etab0
  [../]
  [./IC_etam0]
    type = FunctionIC
    variable = etaa0
    function = ic_func_etaa0
  [../]
[]

[Functions]
  [./ic_func_etaa0]
    type = ParsedFunction
    vars = 'kappa   mu       '
    vals = '1.0  1.0'
    value = '0.5*(1.0-tanh((x)*sqrt(mu/2.0/kappa)))'
  [../]
  [./ic_func_etab0]
    type = ParsedFunction
    vars = 'kappa   mu  '
    vals = '1.0  1.0'
    value = '0.5*(1.0+tanh((x)*sqrt(mu/2.0/kappa)))'
  [../]
[]

[AuxVariables]
  [./bnds]
  [../]
  [./T]
    initial_condition = -1.0
  [../]
[]

[AuxKernels]
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'etaa0 etab0'
  [../]
[]

[Kernels]
# Order parameter eta_alpha0
  [./ACa0_bulk]
    type = ACGrGrMulti
    variable = etaa0
    v =           'etab0'
    gamma_names = 'gab'
  [../]
  [./ACa0_sw]
    type = ACSwitching
    variable = etaa0
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etab0 w'
  [../]
  [./ACa0_int1]
    type = ACInterface2DMultiPhase1
    variable = etaa0
    etas = 'etab0'
    kappa_name = kappa_etaa0_etab0
    dkappadgrad_etaa_name = dkappadgrad_etaa0_etab0
    d2kappadgrad_etaa_name = d2kappadgrad_etaa0_etab0
  [../]
  [./ACa0_int2]
    type = ACInterface2DMultiPhase2
    variable = etaa0
    kappa_name = kappa_etaa0_etab0
    dkappadgrad_etaa_name = dkappadgrad_etaa0_etab0
  [../]
  [./ea0_dot]
    type = TimeDerivative
    variable = etaa0
  [../]
# Order parameter eta_beta0
  [./ACb0_bulk]
    type = ACGrGrMulti
    variable = etab0
    v =           'etaa0'
    gamma_names = 'gab'
  [../]
  [./ACb0_sw]
    type = ACSwitching
    variable = etab0
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
    args = 'etaa0 w'
  [../]
  [./ACb0_int1]
    type = ACInterface2DMultiPhase1
    variable = etab0
    etas = 'etaa0'
    kappa_name = kappa_etab0_etaa0
    dkappadgrad_etaa_name = dkappadgrad_etab0_etaa0
    d2kappadgrad_etaa_name = d2kappadgrad_etab0_etaa0
  [../]
  [./ACb0_int2]
    type = ACInterface2DMultiPhase2
    variable = etab0
    kappa_name = kappa_etab0_etaa0
    dkappadgrad_etaa_name = dkappadgrad_etab0_etaa0
  [../]
  [./eb0_dot]
    type = TimeDerivative
    variable = etab0
  [../]
#Chemical potential
  [./w_dot]
    type = SusceptibilityTimeDerivative
    variable = w
    f_name = chi
    # args = '' # in this case chi (the susceptibility) is simply a constant
  [../]
  [./Diffusion]
    type = MatDiffusion
    variable = w
    D_name = Dchi
    # args = ''
  [../]
  [./coupled_etaa0dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etaa0
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0'
  [../]
  [./coupled_etab0dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etab0
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0'
  [../]
  # [./T_dot]
  #   type = TimeDerivative
  #   variable = T
  # [../]
  # [./CoefDiffusion]
  #   type = Diffusion
  #   variable = T
  # [../]
  # [./etaa0_dot_T]
  #   type = CoefCoupledTimeDerivative
  #   variable = T
  #   v = etaa0
  #   coef = -5.0
  # [../]
[]


[Materials]
  [./ha]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = ha
    all_etas = 'etaa0 etab0'
    phase_etas = 'etaa0'
    outputs = exodus
    output_properties = 'ha'
  [../]
  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'etaa0 etab0'
    phase_etas = 'etab0'
    outputs = exodus
    output_properties = 'hb'
  [../]
  [./omegaa]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = omegaa
    material_property_names = 'Vm ka caeq'
    function = '-0.5*w^2/Vm^2/ka-w/Vm*caeq'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'omegaa'
  [../]
  [./omegab]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = omegab
    material_property_names = 'Vm kb cbeq S Tm'
    function = '-0.5*w^2/Vm^2/kb-w/Vm*cbeq-S*(T-Tm)'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'omegab'
  [../]
  [./rhoa]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = rhoa
    material_property_names = 'Vm ka caeq'
    function = 'w/Vm^2/ka + caeq/Vm'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'rhoa'
  [../]
  [./rhob]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = rhob
    material_property_names = 'Vm kb cbeq'
    function = 'w/Vm^2/kb + cbeq/Vm'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'rhob'
  [../]
  [./kappaa]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    d2kappadgrad_etaa_name = d2kappadgrad
    etaa = etaa0
    etab = etab0
    kappa_bar = 1.0
    anisotropy_strength = 0.05
    reference_angle = 0
    outputs = exodus
    # output_properties = 'kappaa'
  [../]
  [./kappab]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    d2kappadgrad_etaa_name = d2kappadgrad
    etaa = etab0
    etab = etaa0
    anisotropy_strength = 0.05
    kappa_bar = 1.0
    reference_angle = 0
    outputs = exodus
    # output_properties = 'kappab'
  [../]
  [./const]
    type = GenericConstantMaterial
    prop_names =  'kappa_c   L      D    chi  Vm   ka    caeq kb    cbeq  gab mu   S   Tm'
    prop_values = '0         1.0    1.0  0.1  1.0  10.0  0.1  10.0  0.9   1.5 1.0 1.0 1.0'
    outputs = exodus
  [../]
  [./Mobility]
    type = DerivativeParsedMaterial
    f_name = Dchi
    material_property_names = 'D chi'
    function = 'D*chi'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'Dchi'
  [../]
[]

[Postprocessors]
  [./ndof]
    type = NumDOFs
  [../]
  [./etaa0]
    type = ElementIntegralVariablePostprocessor
    variable = etaa0
  [../]
  [./w]
    type = ElementIntegralVariablePostprocessor
    variable = w
  [../]
[]

[VectorPostprocessors]
  [./etaa]
    type = LineValueSampler
    start_point = '-5 0.5 0.0'
    end_point = '5 0.5 0.0'
    sort_by = x
    num_points = 20
    variable = etaa0
  [../]
  [./etab]
    type = LineValueSampler
    start_point = '-5 0.5 0.0'
    end_point = '5 0.5 0.0'
    sort_by = x
    num_points = 20
    variable = etab0
  [../]
[]

# [Adaptivity]
#  initial_steps = 2
#  max_h_level = 2
#  initial_marker = err_eta
#  marker = err_bnds
# [./Markers]
#    [./err_eta]
#      type = ErrorFractionMarker
#      coarsen = 0.3
#      refine = 0.9
#      indicator = ind_eta
#    [../]
#    [./err_bnds]
#      type = ErrorFractionMarker
#      coarsen = 0.3
#      refine = 0.9
#      indicator = ind_bnds
#    [../]
#  [../]
#  [./Indicators]
#    [./ind_eta]
#      type = GradientJumpIndicator
#      variable = etaa0
#     [../]
#     [./ind_bnds]
#       type = GradientJumpIndicator
#       variable = bnds
#    [../]
#  [../]
# []

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

  petsc_options_iname = '-pc_type -sub_pc_type -sub_ksp_type -pc_asm_overlap'
  petsc_options_value = ' asm      ilu           preonly       1    '
  l_tol = 1.0e-3
  l_max_its = 30
  nl_max_its = 15
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-10
  # dt = 0.1
  end_time = 10.0
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.0005
    cutback_factor = 0.7
    growth_factor = 1.2
    optimal_iterations = 6
  [../]
 []

[Outputs]
  exodus = true
  csv = true
  # file_base = grandpotential_1D_verification_adaptive
[]
