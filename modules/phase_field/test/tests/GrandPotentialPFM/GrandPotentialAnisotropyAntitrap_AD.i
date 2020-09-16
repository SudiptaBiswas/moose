[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 15
  ny = 15
  xmin = -2
  xmax = 2
  ymin = -2
  ymax = 2
[]

[GlobalParams]
  radius = 1.0
  int_width = 0.8
  x1 = 0
  y1 = 0
  enable_jit = true
  derivative_order = 2
[]

[Variables]
  [./w]
  [../]
  [./etaa0]
  [../]
  [./etab0]
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
  [./w]
    type = SmoothCircleIC
    variable = w
    outvalue = -4.0
    invalue = 0.0
  [../]
  [./etaa0]
    type = SmoothCircleIC
    variable = etaa0
    #Solid phase
    outvalue = 0.0
    invalue = 1.0
  [../]
  [./etab0]
    type = SmoothCircleIC
    variable = etab0
    #Liquid phase
    outvalue = 1.0
    invalue = 0.0
  [../]
[]

[Kernels]
# Order parameter eta_alpha0
  [./ACa0_bulk]
    type = ADACGrGrMulti
    variable = etaa0
    v =           'etab0'
    gamma_names = 'gab'
  [../]
  [./ACa0_sw]
    type = ADACSwitching
    variable = etaa0
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
  [../]
  [./ACa0_int1]
    type = ADACInterface2DMultiPhase1
    variable = etaa0
    etas = 'etab0'
    kappa_name = kappa_etaa0_etab0
    dkappadgrad_etaa_name = dkappadgrad_etaa0_etab0
    variable_L = false
  [../]
  [./ACa0_int2]
    type = ADACInterface
    variable = etaa0
    kappa_name = kappa_etaa0_etab0
    args = 'etab0'
    variable_L = false
  [../]
  [./ea0_dot]
    type = ADTimeDerivative
    variable = etaa0
  [../]
# Order parameter eta_beta0
  [./ACb0_bulk]
    type = ADACGrGrMulti
    variable = etab0
    v =           'etaa0'
    gamma_names = 'gab'
  [../]
  [./ACb0_sw]
    type = ADACSwitching
    variable = etab0
    Fj_names  = 'omegaa omegab'
    hj_names  = 'ha     hb'
  [../]
  [./ACb0_int1]
    type = ADACInterface2DMultiPhase1
    variable = etab0
    etas = 'etaa0'
    kappa_name = kappa_etab0_etaa0
    dkappadgrad_etaa_name = dkappadgrad_etab0_etaa0
    variable_L = false
  [../]
  [./ACb0_int2]
    type = ADACInterface
    variable = etab0
    kappa_name = kappa_etab0_etaa0
    # dkappadgrad_etaa_name = dkappadgrad_etab0_etaa0
    args = 'etaa0'
    variable_L = false
  [../]
  [./eb0_dot]
    type = ADTimeDerivative
    variable = etab0
  [../]
#Chemical potential
  [./w_dot]
    type = ADSusceptibilityTimeDerivative
    variable = w
    f_name = chi
  [../]
  [./Diffusion]
    type = ADMatDiffusion
    variable = w
    diffusivity = Dchi
  [../]
  [./coupled_etaa0dot]
    type = ADCoupledSwitchingTimeDerivative
    variable = w
    v = etaa0
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0'
  [../]
  [./coupled_etab0dot]
    type = ADCoupledSwitchingTimeDerivative
    variable = w
    v = etab0
    Fj_names = 'rhoa rhob'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0'
  [../]
  [./coupled_etaa0dot_int]
    type = ADAntitrappingCurrent
    variable = w
    v = etaa0
    f_name = rhodiff
  [../]
  [./coupled_etab0dot_int]
    type = ADAntitrappingCurrent
    variable = w
    v = etab0
    f_name = rhodiff
  [../]
[]

[Materials]
  [./ha]
    type = ADSwitchingFunctionMultiPhaseMaterial
    h_name = ha
    all_etas = 'etaa0 etab0'
    phase_etas = 'etaa0'
  [../]
  [./hb]
    type = ADSwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'etaa0 etab0'
    phase_etas = 'etab0'
  [../]
  [./omegaa]
    type = ADDerivativeParsedMaterial
    args = 'w'
    f_name = omegaa
    material_property_names = 'Vm ka caeq'
    function = '-0.5*w^2/Vm^2/ka-w/Vm*caeq'
  [../]
  [./omegab]
    type = ADDerivativeParsedMaterial
    args = 'w'
    f_name = omegab
    material_property_names = 'Vm kb cbeq'
    function = '-0.5*w^2/Vm^2/kb-w/Vm*cbeq'
  [../]
  [./rhoa]
    type = ADDerivativeParsedMaterial
    args = 'w'
    f_name = rhoa
    material_property_names = 'Vm ka caeq'
    function = 'w/Vm^2/ka + caeq/Vm'
  [../]
  [./rhob]
    type = ADDerivativeParsedMaterial
    args = 'w'
    f_name = rhob
    material_property_names = 'Vm kb cbeq'
    function = 'w/Vm^2/kb + cbeq/Vm'
  [../]
  [./int]
    type = ADDerivativeParsedMaterial
    args = 'w'
    f_name = rhodiff
    material_property_names = 'rhoa rhob'
    constant_names = 'int_width'
    constant_expressions = '0.8'
    function = 'int_width*(rhob-rhoa)'
  [../]
  [./kappaa]
    type = ADInterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    etaa = etaa0
    etab = etab0
  [../]
  [./kappab]
    type = ADInterfaceOrientationMultiphaseMaterial
    kappa_name = kappa
    dkappadgrad_etaa_name = dkappadgrad
    etaa = etab0
    etab = etaa0
  [../]
  [./const]
    type = ADGenericConstantMaterial
    prop_names =  'L   D    chi  Vm   ka    caeq kb    cbeq  gab mu'
    prop_values = '1.0 1.0  0.1  1.0  10.0  0.1  10.0  0.9   4.5 10.0'
  [../]
  [./Mobility]
    type = ADParsedMaterial
    f_name = Dchi
    material_property_names = 'D chi'
    function = 'D*chi'
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
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist '
  l_tol = 1.0e-3
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-8
  num_steps = 3
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.001
  [../]
[]

[Outputs]
  exodus = true
  # file_base = GrandPotentialAnisotropyAntitrap_out
[]
