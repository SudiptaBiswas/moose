[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 50
  ny = 10
  xmin = -7
  xmax = 7
  ymax = 1
  ymin = -1
  elem_type = QUAD4
  # uniform_refine = 2
[]

[Variables]
  [./w]
  [../]
  [./etaa0]
  [../]
  [./etab0]
  [../]
  [./etad0]
  [../]
[]

[ICs]
  [./IC_etaa0]
    type = RandomIC
    variable = etaa0
    # function = ic_func_etaa0
  [../]
  [./IC_etab0]
    type = RandomIC
    variable = etab0
    # function = ic_func_etab0
  [../]
  [./IC_w]
    type = RandomIC
    # value = 0
    variable = w
  [../]
  [./IC_etad0]
    type = RandomIC
    # value = 0.1
    variable = etad0
  [../]
[]

[Functions]
  [./ic_func_etaa0]
    type = ParsedFunction
    value = '(1-0.1)*0.5*(1.0-tanh((x)/sqrt(2.0)))'
  [../]
  [./ic_func_etab0]
    type = ParsedFunction
    value = '(1-0.1)*0.5*(1.0+tanh((x)/sqrt(2.0)))'
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
    v = 'etaa0 etab0 etad0'
  [../]
[]

[Kernels]
# Order parameter eta_alpha0
  [./ACa0_bulk]
    type = ACGrGrMulti
    variable = etaa0
    v =           'etab0 etad0'
    gamma_names = 'gab  gab'
  [../]
  [./ACa0_sw]
    type = ACSwitching
    variable = etaa0
    Fj_names  = 'omegaa omegab omegad'
    hj_names  = 'ha     hb hd'
    args = 'etab0 w etad0'
  [../]
  # [./ACa0_int]
  #   type = ACInterface
  #   variable = etaa0
  #   kappa_name = kappa
  # [../]
  [./ACa0_int1]
    type = ACInterface2DMultiPhase1
    variable = etaa0
    etas = 'etab0 etad0'
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    d2kappadgrad_etaa_name = d2kappadgrad_etaa
  [../]
  [./ACa0_int2]
    type = ACInterface2DMultiPhase2
    variable = etaa0
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    args = 'etab0 etad0'
  [../]
  [./ea0_dot]
    type = TimeDerivative
    variable = etaa0
  [../]
  [./etaa0_kappa]
    type = ACKappaFunction
    variable = etaa0
    mob_name = L
    kappa_name = kappaa
    v = 'etab0 etad0'
  [../]
# Order parameter eta_beta0
  [./ACb0_bulk]
    type = ACGrGrMulti
    variable = etab0
    v =           'etaa0 etad0'
    gamma_names = 'gab    gab'
  [../]
  [./ACb0_sw]
    type = ACSwitching
    variable = etab0
    Fj_names  = 'omegaa omegab omegad'
    hj_names  = 'ha     hb     hd'
    args = 'etaa0 w etad0'
  [../]
  # [./ACb0_int]
  #   type = ACInterface
  #   variable = etab0
  #   kappa_name = kappa
  # [../]
  [./ACb0_int1]
    type = ACInterface2DMultiPhase1
    variable = etab0
    etas = 'etaa0 etad0'
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
    d2kappadgrad_etaa_name = d2kappadgrad_etab
  [../]
  [./ACb0_int2]
    type = ACInterface2DMultiPhase2
    variable = etab0
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
    args = 'etaa0 etad0'
  [../]
  [./eb0_dot]
    type = TimeDerivative
    variable = etab0
  [../]
  [./etab0_kappa]
    type = ACKappaFunction
    variable = etab0
    mob_name = L
    kappa_name = kappab
    v = 'etad0 etaa0'
  [../]
  [./ACd0_bulk]
    type = ACGrGrMulti
    variable = etad0
    v =           'etaa0 etab0'
    gamma_names = 'gab gab'
  [../]
  [./ACd0_sw]
    type = ACSwitching
    variable = etad0
    Fj_names  = 'omegaa omegab omegad'
    hj_names  = 'ha     hb    hd'
    args = 'etaa0 w etab0'
  [../]
  # [./ACd0_int]
  #   type = ACInterface
  #   variable = etad0
  #   kappa_name = kappa
  # [../]
  [./ACd0_int1]
    type = ACInterface2DMultiPhase1
    variable = etad0
    etas = 'etaa0 etab0'
    kappa_name = kappad
    dkappadgrad_etaa_name = dkappadgrad_etad
    d2kappadgrad_etaa_name = d2kappadgrad_etad
  [../]
  [./ACd0_int2]
    type = ACInterface2DMultiPhase2
    variable = etad0
    kappa_name = kappad
    dkappadgrad_etaa_name = dkappadgrad_etad
    args = 'etaa0 etab0'
  [../]
  [./ed0_dot]
    type = TimeDerivative
    variable = etad0
  [../]
  [./etad0_kappa]
    type = ACKappaFunction
    variable = etad0
    mob_name = L
    kappa_name = kappad
    v = 'etab0 etaa0'
  [../]
#Chemical potential
  [./w_dot]
    type = SusceptibilityTimeDerivative
    variable = w
    f_name = chi
    args = '' # in this case chi (the susceptibility) is simply a constant
  [../]
  [./Diffusion]
    type = MatDiffusion
    variable = w
    D_name = Dchi
    args = ''
  [../]
  [./coupled_etaa0dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etaa0
    Fj_names = 'rhoa rhob rhod'
    hj_names = 'ha   hb   hd'
    args = 'etaa0 etab0  etad0'
  [../]
  [./coupled_etab0dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etab0
    Fj_names = 'rhoa rhob rhod'
    hj_names = 'ha   hb  hd'
    args = 'etaa0 etab0 etad0'
  [../]
  [./coupled_etad0dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etad0
    Fj_names = 'rhoa rhob rhod'
    hj_names = 'ha   hb  hd'
    args = 'etaa0 etab0 etad0'
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
    all_etas = 'etaa0 etab0 etad0'
    phase_etas = 'etaa0'
    # outputs = exodus
    output_properties = 'ha'
  [../]
  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'etaa0 etab0 etad0'
    phase_etas = 'etab0'
    # outputs = exodus
    output_properties = 'hb'
  [../]
  [./hd]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hd
    all_etas = 'etaa0 etab0 etad0'
    phase_etas = 'etad0'
    # outputs = exodus
    output_properties = 'hd'
  [../]
  [./omegaa]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = omegaa
    material_property_names = 'Vm ka caeq'
    function = '-0.5*w^2/Vm^2/ka-w/Vm*caeq'
    derivative_order = 2
    enable_jit = false
    # outputs = exodus
    output_properties = 'omegaa'
  [../]
  [./omegab]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = omegab
    material_property_names = 'Vm kb cbeq S Tm'
    function = '-0.5*w^2/Vm^2/kb-w/Vm*cbeq-S*(T-Tm)'
    derivative_order = 2
    # enable_jit = false
    # outputs = exodus
    output_properties = 'omegab'
  [../]
  [./omegad]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = omegad
    material_property_names = 'Vm kd cdeq'
    function = '-0.5*w^2/Vm^2/kd-w/Vm*cdeq'
    derivative_order = 2
    # enable_jit = false
    # outputs = exodus
    output_properties = 'omegad'
  [../]
  [./rhoa]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = rhoa
    material_property_names = 'Vm ka caeq'
    function = 'w/Vm^2/ka + caeq/Vm'
    derivative_order = 2
    # enable_jit = false
    # outputs = exodus
    output_properties = 'rhoa'
  [../]
  [./rhob]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = rhob
    material_property_names = 'Vm kb cbeq'
    function = 'w/Vm^2/kb + cbeq/Vm'
    derivative_order = 2
    # enable_jit = false
    # outputs = exodus
    output_properties = 'rhob'
  [../]
  [./rhod]
    type = DerivativeParsedMaterial
    args = 'w'
    f_name = rhod
    material_property_names = 'Vm kd cdeq'
    function = 'w/Vm^2/kd + cdeq/Vm'
    derivative_order = 2
    # enable_jit = false
    # outputs = exodus
    output_properties = 'rhod'
  [../]
  [./c]
    type = ParsedMaterial
    material_property_names = 'Vm rhoa rhob rhod ha hb hd'
    function = 'Vm * (ha * rhoa + hb * rhob + hd * rhod)'
    f_name = c
    # outputs = exodus
  [../]
  [./kappaa]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    d2kappadgrad_etaa_name = d2kappadgrad_etaa
    etaa = etaa0
    etab = 'etab0 etad0'
    anisotropy_strength = 0.05
    kappa_bar = 0.8
    reference_angle = 0
    # outputs = exodus
    # output_properties = 'kappaa'
  [../]
  [./kappab]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
    d2kappadgrad_etaa_name = d2kappadgrad_etab
    etaa = etab0
    etab = 'etaa0 etad0'
    anisotropy_strength = 0.05
    reference_angle = 0
    kappa_bar = 0.8
    # outputs = exodus
    # output_properties = 'kappab'
  [../]
  [./kappad]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappad
    dkappadgrad_etaa_name = dkappadgrad_etad
    d2kappadgrad_etaa_name = d2kappadgrad_etad
    etaa = etad0
    etab = 'etaa0 etab0'
    anisotropy_strength = 0.05
    kappa_bar = 0.8
    reference_angle = 0
    # outputs = exodus
    # output_properties = 'kappad'
  [../]
  [./const]
    type = GenericConstantMaterial
    prop_names =  'kappa   L      D    Vm   ka    caeq kb  kd   cbeq cdeq gab mu   S   Tm  '
    prop_values = '0.01     1.0    1.0  1.0  10.0  0.1 10.0 10.0  0.9  0.5 1.5 10.0 1.0 0.0'
    # outputs = exodus
  [../]
  [./chi]
    type = DerivativeParsedMaterial
    f_name = chi
    material_property_names = 'Vm ha ka hb kb hd kd'
    function = '(ha/ka + hb/kb + hd/kd) / Vm^2'
    derivative_order = 2
    # outputs = exodus
  [../]
  [./Mobility]
    type = DerivativeParsedMaterial
    f_name = Dchi
    material_property_names = 'D chi'
    function = 'D*chi'
    derivative_order = 2
    # enable_jit = false
    # outputs = exodus
    # output_properties = 'Dchi'
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
  [./etad0]
    type = ElementIntegralVariablePostprocessor
    variable = etad0
  [../]
  [./w]
    type = ElementIntegralVariablePostprocessor
    variable = w
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
  # petsc_options_iname = -pc_type
  # petsc_options_value = asm
  # petsc_options_iname = '-pc_type -sub_pc_type -sub_ksp_type -pc_asm_overlap'
  # petsc_options_value = ' asm      ilu           preonly       1    '
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre    boomeramg      31'
  l_tol = 1.0e-3
  l_max_its = 30
  nl_max_its = 15
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-10
  end_time = 20.0
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.0005
    cutback_factor = 0.7
    growth_factor = 1.2
    optimal_iterations = 6
  [../]
 []

[Outputs]
  # exodus = true
  # csv = true
[]
