[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 50
  ny = 50
  xmin = -50
  xmax = 50
  ymin = -50
  ymax = 50
  elem_type = QUAD4
  uniform_refine = 2
[]

[GlobalParams]
  # radius = 0.5
  # int_width = 0.3
  # x1 = 0.0
  # y1 = 0.0
  x1 = -50
  y1 = -50
  x2 = 50
  y2 = -15
[]

[Variables]
  [./w]
  [../]
  [./etaa0]
  [../]
  [./etab0]
  [../]
  [./T]
    initial_condition = 2.0
  [../]
[]

[AuxVariables]
  [./bnds]
  [../]
[]

[AuxKernels]
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'etaa0 etab0'
  [../]
[]

[ICs]
  # [./w]
  #   type = SmoothCircleIC
  #   variable = w
  #   # note w = A*(c-cleq), A = 1.0, cleq = 0.0 ,i.e., w = c (in the matrix/liquid phase)
  #   outvalue = 0.5
  #   invalue = 0.0
  # [../]
  # [./etaa0]
  #   type = SmoothCircleIC
  #   variable = etaa0
  #   #Solid phase
  #   outvalue = 0.0
  #   invalue = 1.0
  # [../]
  # [./etab0]
  #   type = SmoothCircleIC
  #   variable = etab0
  #   #Liquid phase
  #   outvalue = 1.0
  #   invalue = 0.0
  # [../]

  [./w]
    type = BoundingBoxIC
    variable = w
    # note w = A*(c-cleq), A = 1.0, cleq = 0.0 ,i.e., w = c (in the matrix/liquid phase)
    outside = -4.0
    inside = 0.0
  [../]
  [./etaa0]
    type = BoundingBoxIC
    variable = etaa0
    #Solid phase
    outside = 0.0
    inside = 1.0
  [../]
  [./etab0]
    type = BoundingBoxIC
    variable = etab0
    #Liquid phase
    outside = 1.0
    inside = 0.0
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
    args = 'etab0 w T'
  [../]
  [./ACa0_int1]
    type = ACInterface2DMultiPhase1
    variable = etaa0
    etas = 'etab0'
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    d2kappadgrad_etaa_name = d2kappadgrad_etaa
  [../]
  [./ACa0_int2]
    type = ACInterface2DMultiPhase2
    variable = etaa0
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
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
    args = 'etaa0 w T'
  [../]
  [./ACb0_int1]
    type = ACInterface2DMultiPhase1
    variable = etab0
    etas = 'etaa0'
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
    d2kappadgrad_etaa_name = d2kappadgrad_etab
  [../]
  [./ACb0_int2]
    type = ACInterface2DMultiPhase2
    variable = etab0
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
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
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0 T'
  [../]
  [./coupled_etab0dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etab0
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0 T'
  [../]
  [./T_dot]
    type = TimeDerivative
    variable = T
  [../]
  [./CoefDiffusion]
    type = Diffusion
    variable = T
  [../]
  [./etaa0_dot_T]
    type = CoefCoupledTimeDerivative
    variable = T
    v = etaa0
    coef = -2.0
  [../]
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
    args = 'w T'
    f_name = omegaa
    material_property_names = 'k_b Va Ea '
    # function = '-0.5*w^2/Vm^2/ka-w/Vm*caeq'
    function = '-k_b*T/Va * plog((1+exp((w-Ea)/k_b/T)), 1e-3)'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'omegaa'
  [../]
  [./omegab]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = omegab
    material_property_names = 'Vm ka Ea'
    function = '-ka*T/Vm*log(1+exp((w-Ea)/ka/T))'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'omegab'
  [../]
  [./rhoa]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = rhoa
    material_property_names = 'Vm ka Ea'
    function = '-1.0/Vm*exp((w-Ea)/ka/T)/(1+exp((w-Ea)/ka/T))'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'rhoa'
  [../]
  [./rhob]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = rhob
    material_property_names = 'Vm ka Ea'
    function = '-1.0/Vm*exp((w-Ea)/ka/T)/(1+exp((w-Ea)/ka/T))'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'rhob'
  [../]
  [./Ea]
    type = DerivativeParsedMaterial
    args = 'T'
    f_name = Ea
    material_property_names = 'Va La Tma '
    function = 'Va*La*(T-Tma)/Tma'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'Ea'
  [../]
  [./Eb]
    type = DerivativeParsedMaterial
    args = 'T'
    f_name = Eb
    material_property_names = ' Vb Lb Tmb '
    function = 'Vb*Lb*(T-Tmb)/Tmb'
    derivative_order = 2
    enable_jit = false
    outputs = exodus
    output_properties = 'Eb'
  [../]
  [./kappaa]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    d2kappadgrad_etaa_name = d2kappadgrad_etaa
    etaa = etaa0
    etab = etab0
    anisotropy_strength = 0.05
    # kappa_bar = 1.0
    reference_angle = 0
    outputs = exodus
    output_properties = 'kappaa'
  [../]
  [./kappab]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
    d2kappadgrad_etaa_name = d2kappadgrad_etab
    etaa = etab0
    etab = etaa0
    anisotropy_strength = 0.05
    # kappa_bar = 1.0
    reference_angle = 0
    outputs = exodus
    output_properties = 'kappab'
  [../]
  [./const]
    type = GenericConstantMaterial
    prop_names =  ' L   D    chi  Va   k_b    gab  mu   Tma  Tmb  La   Lb'
    prop_values = ' 1.0 1.0  0.1  1.0  10.0   0.9  4.5  1.0  1.0  1.0  1.0 '
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
  petsc_options_iname = '-pc_type -sub_pc_type -sub_ksp_type -pc_asm_overlap '
  petsc_options_value = ' asm      ilu           preonly       1    '
  # petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  # petsc_options_value = 'hypre    boomeramg      31'
  l_tol = 1.0e-3
  l_max_its = 30
  nl_max_its = 15
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-10
  dtmin = 1e-5
  dt = 5e-4
  end_time = 1000.0
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.0005
    cutback_factor = 0.95
    growth_factor = 1.05
    optimal_iterations = 4
    iteration_window = 0
    linear_iteration_ratio = 100
  [../]
 []

[Adaptivity]
 initial_steps = 5
 max_h_level = 6
 initial_marker = EFM_3
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
   [./combo]
     type = ComboMarker
     markers = 'EFM_1 EFM_2 EFM_3'
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
     variable = bnds
    [../]
 [../]
[]

[Outputs]
  # interval = 20
  exodus = true
  # file_base = grandpotential_solidification_k1
[]
