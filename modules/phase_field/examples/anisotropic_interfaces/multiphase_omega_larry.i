[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 20
  ny = 16
  xmin = 0
  xmax = 240
  ymin = 0
  ymax = 192
[]

[GlobalParams]
  #int_width = 3.0
  #block = 0
  op_num = 2
  var_name_base = etam
[]

[Variables]
  [./wv]
  [../]
  [./wg]
  [../]
  [./etab0]
  [../]
  [./etam0]
  [../]
  [./etam1]
  [../]
[]

[AuxVariables]
  [./bnds]
    order = FIRST
    family = LAGRANGE
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
    variable = etam0
    function = ic_func_etam0
  [../]
  [./IC_etam1]
    type = FunctionIC
    variable = etam1
    function = ic_func_etam1
  [../]
  [./IC_wv]
    type = ConstantIC
    value = 0
    variable = wv
  [../]
  [./IC_wg]
    type = ConstantIC
    value = 0
    variable = wg
  [../]
[]

[Functions]
  [./ic_func_etab0]
    type = ParsedFunction
    vars = 'kappa   mu       x0  y0  rad'
    vals = '0.5273  0.004688 120 96  44'
    value = 'r:=sqrt((x-x0)^2+(y-y0)^2);0.5*(1.0-tanh((r-rad)*sqrt(mu/2.0/kappa)))'
  [../]
  [./ic_func_etam0]
    type = ParsedFunction
    vars = 'kappa   mu       x0  y0  rad'
    vals = '0.5273  0.004688 120 96  44'
    value = 'r:=sqrt((x-x0)^2+(y-y0)^2);0.5*(1.0+tanh((r-rad)*sqrt(mu/2.0/kappa)))*0.5*(1.0+tanh((y-y0)*sqrt(mu/2.0/kappa)))'
  [../]
  [./ic_func_etam1]
    type = ParsedFunction
    vars = 'kappa   mu       x0  y0  rad'
    vals = '0.5273  0.004688 120 96  44'
    value = 'r:=sqrt((x-x0)^2+(y-y0)^2);0.5*(1.0+tanh((r-rad)*sqrt(mu/2.0/kappa)))*0.5*(1.0-tanh((y-y0)*sqrt(mu/2.0/kappa)))'
  [../]
[]

#[Functions]
#  [./ic_func_etab0]
#    type = ParsedFunction
#    value = 'r:=sqrt(x^2+y^2);0.5*(1.0-tanh((r-10.0)/sqrt(2.0)))'
#  [../]
#  [./ic_func_etam0]
#    type = ParsedFunction
#    value = 'r:=sqrt(x^2+y^2);0.5*(1.0+tanh((r-10)/sqrt(2.0)))*(1.0+tanh((y)/sqrt(2.0)))' #TODO put in another factor of 0.5
#  [../]
#  [./ic_func_etam1]
#    type = ParsedFunction
#    value = 'r:=sqrt(x^2+y^2);0.5*(1.0+tanh((r-10)/sqrt(2.0)))*(1.0-tanh((y)/sqrt(2.0)))' #TODO put in another factor of 0.5
#  [../]
#[]


[BCs]
[]

[Kernels]
# Order parameter eta_b0 for bubble phase
  [./ACb0_bulk]
    type = ACGrGrMulti
    variable = etab0
    v =           'etam0 etam1'
    gamma_names = 'gmb   gmb'
  [../]
  [./ACb0_sw]
    type = ACSwitching
    variable = etab0
    Fj_names  = 'omegab omegam'
    hj_names  = 'hb     hm'
    args = 'etam0 etam1 wv wg'
  [../]
  [./ACb0_int]
    type = ACInterface
    variable = etab0
    kappa_name = kappa
  [../]
  [./eb0_dot]
    type = TimeDerivative
    variable = etab0
  [../]
# Order parameter eta_m0 for matrix grain 1
  [./ACm0_bulk]
    type = ACGrGrMulti
    variable = etam0
    v =           'etab0 etam1'
    gamma_names = 'gmb   gmm'
  [../]
  [./ACm0_sw]
    type = ACSwitching
    variable = etam0
    Fj_names  = 'omegab omegam'
    hj_names  = 'hb     hm'
    args = 'etab0 etam1 wv wg'
  [../]
  [./ACm0_int]
    type = ACInterface
    variable = etam0
    kappa_name = kappa
  [../]
  [./em0_dot]
    type = TimeDerivative
    variable = etam0
  [../]
# Order parameter eta_m1 for matrix grain 2
  [./ACm1_bulk]
    type = ACGrGrMulti
    variable = etam1
    v =           'etab0 etam0'
    gamma_names = 'gmb   gmm'
  [../]
  [./ACm1_sw]
    type = ACSwitching
    variable = etam1
    Fj_names  = 'omegab omegam'
    hj_names  = 'hb     hm'
    args = 'etab0 etam0 wv wg'
  [../]
  [./ACm1_int]
    type = ACInterface
    variable = etam1
    kappa_name = kappa
  [../]
  [./em1_dot]
    type = TimeDerivative
    variable = etam1
  [../]
#Chemical potential for vacancies
  [./wv_dot]
    type = SusceptibilityTimeDerivative
    variable = wv
    f_name = chiv
    args = '' # in this case chi (the susceptibility) is simply a constant
  [../]
  [./Diffusion_v]
    type = MatDiffusion
    variable = wv
    D_name = Dchiv
    args = ''
  [../]
  [./coupled_v_etab0dot]
    type = CoupledSwitchingTimeDerivative
    variable = wv
    v = etab0
    Fj_names = 'rhovbub rhovmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1'
  [../]
  [./coupled_v_etam0dot]
    type = CoupledSwitchingTimeDerivative
    variable = wv
    v = etam0
    Fj_names = 'rhovbub rhovmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1'
  [../]
  [./coupled_v_etam1dot]
    type = CoupledSwitchingTimeDerivative
    variable = wv
    v = etam1
    Fj_names = 'rhovbub rhovmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1'
  [../]
#Chemical potential for gas atoms
  [./wg_dot]
    type = SusceptibilityTimeDerivative
    variable = wg
    f_name = chig
    args = '' # in this case chi (the susceptibility) is simply a constant
  [../]
  [./Diffusion_g]
    type = MatDiffusion
    variable = wg
    D_name = Dchig
    args = ''
  [../]
  [./coupled_g_etab0dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = etab0
    Fj_names = 'rhogbub rhogmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1'
  [../]
  [./coupled_g_etam0dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = etam0
    Fj_names = 'rhogbub rhogmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1'
  [../]
  [./coupled_g_etam1dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = etam1
    Fj_names = 'rhogbub rhogmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1'
  [../]
[]

[AuxKernels]
  [./BndsCalc]
    type = BndsCalcAux
    variable = bnds
    execute_on = timestep_end
  [../]
[]

[Materials]
  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'etab0 etam0 etam1'
    phase_etas = 'etab0'
    #outputs = exodus
  [../]
  [./hm]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hm
    all_etas = 'etab0 etam0 etam1'
    phase_etas = 'etam0 etam1'
    #outputs = exodus
  [../]
  [./omegab]
    type = DerivativeParsedMaterial
    args = 'wv wg'
    f_name = omegab
    material_property_names = 'Va kvbub cvbubeq kgbub cgbubeq'
    function = '-0.5*wv^2/Va^2/kvbub-wv/Va*cvbubeq-0.5*wg^2/Va^2/kgbub-wg/Va*cgbubeq'
    derivative_order = 2
    #outputs = exodus
  [../]
  [./omegam]
    type = DerivativeParsedMaterial
    args = 'wv wg'
    f_name = omegam
    material_property_names = 'kTbar Va Efvbar Efgbar'
    function = '-kTbar / Va * (log(1 + exp((wv - Efvbar)/kTbar)) + log(1 + exp((wg - Efgbar)/kTbar)) )'
    derivative_order = 2
    #outputs = exodus
  [../]
  [./rhovbub]
    type = DerivativeParsedMaterial
    args = 'wv'
    f_name = rhovbub
    material_property_names = 'Va kvbub cvbubeq'
    function = 'wv/Va^2/kvbub + cvbubeq/Va'
    derivative_order = 2
    #outputs = exodus
  [../]
  [./rhovmatrix]
    type = DerivativeParsedMaterial
    args = 'wv'
    f_name = rhovmatrix
    material_property_names = 'Va Efvbar kTbar'
    function = 'exp((wv - Efvbar)/kTbar) / (1 + exp((wv - Efvbar)/kTbar)) / Va'
    derivative_order = 2
    #outputs = exodus
  [../]
  [./rhogbub]
    type = DerivativeParsedMaterial
    args = 'wg'
    f_name = rhogbub
    material_property_names = 'Va kgbub cgbubeq'
    function = 'wg/Va^2/kgbub + cgbubeq/Va'
    derivative_order = 2
    #outputs = exodus
  [../]
  [./rhogmatrix]
    type = DerivativeParsedMaterial
    args = 'wg'
    f_name = rhogmatrix
    material_property_names = 'Va Efgbar kTbar'
    function = 'exp((wg - Efgbar)/kTbar) / (1 + exp((wg - Efgbar)/kTbar)) / Va'
    derivative_order = 2
    #outputs = exodus
  [../]
  [./const]
    type = GenericConstantMaterial
    prop_names =  'kappa   mu       L   D    Va      cvbubeq cgbubeq gmb    gmm T    Efvbar    Efgbar    kTbar     tgrad_corr_mult'
    prop_values = '0.5273  0.004688 1.0 0.01 0.04092 0.3     0.7     0.9218 1.5 1200 7.505e-3  7.505e-3  2.588e-4  0.0'
  [../]
  [./cvmatrixeq]    #For values, see Li et al., Nuc. Inst. Methods in Phys. Res. B, 303, 62-27 (2013).
    type = ParsedMaterial
    f_name = cvmatrixeq
    material_property_names = 'T'
    constant_names        = 'kB           Efv'
    constant_expressions  = '8.6173324e-5 3.0'
    function = 'exp(-Efv/(kB*T))'
  [../]
  [./cgmatrixeq]
    type = ParsedMaterial
    f_name = cgmatrixeq
    material_property_names = 'T'
    constant_names        = 'kB           Efg'
    constant_expressions  = '8.6173324e-5 3.0'
    function = 'exp(-Efg/(kB*T))'
  [../]
  [./kvmatrix_parabola]
    type = ParsedMaterial
    f_name = kvmatrix
    material_property_names = 'T  cvmatrixeq'
    constant_names        = 'c0v  c0g  a1                                               a2'
    constant_expressions  = '0.01 0.01 0.178605-0.0030782*log(1-c0v)+0.0030782*log(c0v) 0.178605-0.00923461*log(1-c0v)+0.00923461*log(c0v)'
    function = '((-a2+3*a1)/(4*(c0v-cvmatrixeq))+(a2-a1)/(2400*(c0v-cvmatrixeq))*T)'
    outputs = exodus
  [../]
  [./kgmatrix_parabola]
    type = ParsedMaterial
    f_name = kgmatrix
    material_property_names = 'kvmatrix'
    function = 'kvmatrix'
  [../]
  [./kgbub_parabola]
    type = ParsedMaterial
    f_name = kgbub
    material_property_names = 'kvmatrix  cgmatrixeq cgbubeq'
    constant_names        = 'fcross'
    constant_expressions  = '0.5'   #Scaled by C44
    function = 'kvmatrix * fcross/(sqrt(kvmatrix)*(cgmatrixeq-cgbubeq) + sqrt(fcross))^2'
    outputs = exodus
  [../]
  [./kvbub_parabola]
    type = ParsedMaterial
    f_name = kvbub
    material_property_names = 'kgbub'
    function = 'kgbub'
  [../]
  [./Mobility_v]
    type = DerivativeParsedMaterial
    f_name = Dchiv
    material_property_names = 'D chiv'
    function = 'D*chiv'
    derivative_order = 2
    #outputs = exodus
  [../]
  [./Mobility_g]
    type = DerivativeParsedMaterial
    f_name = Dchig
    material_property_names = 'D chig'
    function = 'D*chig'
    derivative_order = 2
    #outputs = exodus
  [../]
  [./chiv]
    type = DerivativeParsedMaterial
    f_name = chiv
    args = 'wv'
    material_property_names = 'Va hb kvbub hm Efvbar kTbar'
    function = 'hm * exp((wv - Efvbar)/kTbar) / (1 + exp((wv - Efvbar)/kTbar))^2 / kTbar / Va + (hb/kvbub) / Va^2'
    derivative_order = 2
    outputs = exodus
  [../]
  [./chig]
    type = DerivativeParsedMaterial
    f_name = chig
    args = 'wg'
    material_property_names = 'Va hb kgbub hm Efgbar kTbar'
    function = 'hm * exp((wg - Efgbar)/kTbar) / (1 + exp((wg - Efgbar)/kTbar))^2 / kTbar / Va + (hb/kgbub) / Va^2'
    derivative_order = 2
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
  # Preconditioned JFNK (default)
  type = Transient
  nl_max_its = 15
  scheme = bdf2
  #solve_type = NEWTON
  solve_type = PJFNK
  petsc_options_iname = -pc_type
  petsc_options_value = asm
  l_max_its = 15
  l_tol = 1.0e-3
  nl_rel_tol = 1.0e-8
  start_time = 0.0
  num_steps = 1000
  nl_abs_tol = 1e-11
  [./TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt = 0.5
  [../]
[]

[Outputs]
  [./exodus]
    type = Exodus
    interval = 50
  [../]
  checkpoint = true
[]
