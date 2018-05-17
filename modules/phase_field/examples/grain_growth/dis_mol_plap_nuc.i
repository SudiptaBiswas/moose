[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 32
  ny = 128
  xmin = 0
  xmax = 256
  ymin = 0
  ymax = 1024
  uniform_refine = 1
[]

[GlobalParams]
  int_width = 3.0
  block = 0
  op_num = 5
  var_name_base = eta
[]

[Variables]
  [./c]
  [../]
  [./w]
  [../]
  [./eta1]
  [../]
  [./eta2]
  [../]
  [./eta3]
  [../]
  [./eta0]
  [../]
  [./eta4]
  [../]
  [./etab]
  [../]
[]

[AuxVariables]
  [./total_F]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./bnds]
    order = First
    family = LAGRANGE
  [../]
[]

[ICs]
  [./IC_eta1]
    x1 = 128
    y1 = 0
    x2 = 256.0
    y2 = 1024.0
    inside = 1.0
    outside = 0.0
    type = BoundingBoxIC
    variable = eta1
  [../]
  [./IC_eta0]
    x1 = 0
    y1 = 0
    x2 = 128.0
    y2 = 1024.0
    inside = 1.0
    outside = 0.0
    type = BoundingBoxIC
    variable = eta0
  [../]
  [./IC_c]
    x1 = 64.0
    y1 = 512.0
    radius = 25.0
    outvalue = 0.0005
    variable = c
    invalue = 1.0
    type = SmoothCircleIC
  [../]
  [./IC_etab]
    x1 = 64
    y1 = 512
    radius = 25.0
    outvalue = 0.0
    variable = etab
    invalue = 1.0
    type = SmoothCircleIC
  [../]
  [./IC_eta4]
    variable = eta4
    seed = 12345
    type = RandomIC
    max = 2e-2
    min = 1e-2
  [../]
  [./IC_eta3]
    variable = eta3
    seed = 894635
    type = RandomIC
    max = 2e-2
    min = 1e-2
  [../]
  [./IC_eta2]
    variable = eta2
    seed = 531879
    type = RandomIC
    max = 2e-2
    min = 1e-2
  [../]
[]

[BCs]

[]

[Kernels]
  [./c_dot]
    type = CoupledTimeDerivative
    variable = w
    v = c
  [../]
  [./c_res]
    type = SplitCHParsed
    variable = c
    f_name = F
    kappa_name = kappa_c
    w = w
    args = 'eta1 eta2 eta3 eta0 eta4 etab'
  [../]
  [./w_res]
    # args = 'c'
    type = SplitCHWRes
    variable = w
    mob_name = M
  [../]
  [./AC1_bulk]
    type = AllenCahn
    variable = eta1
    f_name = F
    args = 'c eta2 eta3 eta0 eta4 etab'
  [../]
  [./AC1_int]
    type = ACInterface
    variable = eta1
    kappa_name = kappa_s
  [../]
  [./e1_dot]
    type = TimeDerivative
    variable = eta1
  [../]
  [./AC2_bulk]
    type = AllenCahn
    variable = eta2
    f_name = F
    args = 'c eta1 eta3 eta0 eta4 etab'
  [../]
  [./AC2_int]
    type = ACInterface
    variable = eta2
  [../]
  [./e2_dot]
    type = TimeDerivative
    variable = eta2
  [../]
  [./AC3_bulk]
    type = AllenCahn
    variable = eta3
    f_name = F
    args = 'c eta2 eta1 eta0 eta4 etab'
  [../]
  [./AC3_int]
    type = ACInterface
    variable = eta3
  [../]
  [./e3_dot]
    type = TimeDerivative
    variable = eta3
  [../]
  [./AC4_bulk]
    type = AllenCahn
    variable = eta0
    f_name = F
    args = 'c eta2 eta3 eta1 eta4 etab'
  [../]
  [./AC4_int]
    type = ACInterface
    variable = eta0
  [../]
  [./e4_dot]
    type = TimeDerivative
    variable = eta0
  [../]
  [./AC5_bulk]
    type = AllenCahn
    variable = eta4
    f_name = F
    args = 'c eta2 eta3 eta1 eta0 etab'
  [../]
  [./AC5_int]
    type = ACInterface
    variable = eta4
  [../]
  [./e5_dot]
    type = TimeDerivative
    variable = eta4
  [../]
  [./ACb_bulk]
    type = AllenCahn
    variable = etab
    f_name = F
    args = 'c eta2 eta3 eta1 eta4 eta0'
  [../]
  [./ACb_int]
    type = ACInterface
    variable = etab
  [../]
  [./eb_dot]
    type = TimeDerivative
    variable = etab
  [../]

[]


[AuxKernels]
  [./total_F]
    type = TotalFreeEnergy
    variable = total_F
    interfacial_vars = 'eta1 eta2 eta3 eta0 eta4 etab'
    kappa_names = 'kappa_s kappa_op kappa_op kappa_op kappa_op kappa_op'
  [../]
  [./BndsCalc]
    type = BndsCalcAux
    variable = bnds
    execute_on = timestep_end
  [../]
[]

[Materials]
  [./FreeEng]
    type = DerivativeParsedMaterial
    args = 'c eta1 eta2 eta3 eta0 eta4 etab'
    f_name = F
    constant_names = 'a s g b d e'
    constant_expressions = '1.0 2.0 1.0 0.40 1.0 0.17'
    function = 'sumeta:=eta0^2+eta1^2+eta2^2+eta3^2+eta4^2+etab^2;f0:=etab^2/sumeta;f2:=a*(c-f0)^2;f3:=1.0/4.0+1.0/4.0*eta1^4-1.0/2.0*eta1^2+1.0/4.0*eta2^4-1.0/2.0*eta2^2+1.0/4.0*eta3^4-1.0/2.0*eta3^2+1.0/4.0*eta0^4-1.0/2.0*eta0^2+1.0/4.0*eta4^4-1.0/2.0*eta4^2+1.0/4.0*etab^4-1.0/2.0*etab^2 ;f4:=s*(etab^2*eta0^2+etab^2*eta1^2+etab^2*eta2^2+etab^2*eta3^2+etab^2*eta4^2)+g*(eta0^2*eta1^2+eta0^2*eta2^2+eta0^2*eta3^2+eta0^2*eta4^2+eta1^2*eta2^2+eta1^2*eta3^2+eta1^2*eta4^2+eta2^2*eta3^2+eta2^2*eta4^2+eta3^2*eta4^2);f1:=e*((eta0^2+eta1^2)/sumeta);f:=f1+f2+b*(f3+f4);f'
    derivative_order = 2
  #  outputs = exodus
  [../]
  [./const]
    type = GenericConstantMaterial
    prop_names = 'kappa_c kappa_s kappa_op L M'
    prop_values = '0.0 1.50 1.50 1.0 1.0'
  #  outputs = exodus
  [../]
  [./disloc_indicator]
    type = ParsedMaterial
    f_name = rho
    args = 'eta0 eta1 eta2 eta3 eta4 etab'
    constant_names = 'e'
    constant_expressions = '2.0e-1'
    function = e*((eta0^2+eta1^2)/(eta0^2+eta1^2+eta2^2+eta3^2+eta4^2+etab^2))
    outputs = exodus
  [../]
[]

[Postprocessors]
  [./ElementInt_c]
    type = ElementIntegralVariablePostprocessor
    variable = c
  [../]
  [./Element_int_eta4]
    type = ElementIntegralVariablePostprocessor
    variable = eta4
  [../]
  [./total_F]
    type = ElementIntegralVariablePostprocessor
    variable = total_F
  [../]
  [./dt]
    type = TimestepSize
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
  solve_type = NEWTON
  petsc_options_iname = -pc_type
  petsc_options_value = asm
  l_max_its = 15
  l_tol = 1.0e-3
  nl_rel_tol = 1.0e-7
  start_time = 0.0
  num_steps = 150000
  nl_abs_tol = 1e-8
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1.0e-2
  [../]
[]

[Outputs]
  exodus = true
  csv = true
  interval = 1
  print_perf_log = true
[]
