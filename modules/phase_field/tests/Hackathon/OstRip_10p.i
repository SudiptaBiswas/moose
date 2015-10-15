[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 50
  ny = 50
  nz = 0
  xmax = 200
  ymax = 200
  zmax = 0
  elem_type = QUAD4
  uniform_refine = 2
[]

[GlobalParams]
  block = 0
  derivative_order = 2
  op_num = 10
  var_name_base = eta
[]

[Variables]
  [./c]
  [../]
  [./w]
  [../]
  [./PolycrystalVariables]
  [../]
[]

[ICs]
  [./c_IC]
    type = FunctionIC
    variable = c
    function = ic_c_func
  [../]
  [./eta0_IC]
    type = FunctionIC
    variable = eta0
    function = ic_eta0
  [../]
  [./eta1_IC]
    type = FunctionIC
    variable = eta1
    function = ic_eta1
  [../]
  [./eta2_IC]
    type = FunctionIC
    variable = eta2
    function = ic_eta2
  [../]
  [./eta3_IC]
    type = FunctionIC
    variable = eta3
    function = ic_eta3
  [../]
  [./eta4_IC]
    type = FunctionIC
    variable = eta4
    function = ic_eta4
  [../]
  [./eta5_IC]
    type = FunctionIC
    variable = eta5
    function = ic_eta5
  [../]
  [./eta6_IC]
    type = FunctionIC
    variable = eta6
    function = ic_eta6
  [../]
  [./eta7_IC]
    type = FunctionIC
    variable = eta7
    function = ic_eta7
  [../]
  [./eta8_IC]
    type = FunctionIC
    variable = eta8
    function = ic_eta8
  [../]
  [./eta9_IC]
    type = FunctionIC
    variable = eta9
    function = ic_eta9
  [../]
[]

[Functions]
  [./ic_c_func]
    type = ParsedFunction
    value = '0.5+0.01*cos(0.1*(sqrt(2.0)*x+sqrt(3.0)*y))'
  [../]
  [./ic_eta0]
    type = ParsedFunction
    value = '0.01*0.979285*cos(0.01*(sqrt(23.0)*x+sqrt(149.0)*y))^2'
  [../]
  [./ic_eta1]
    type = ParsedFunction
    value = '0.01*0.219812*cos(0.01*(sqrt(24.0)*x+sqrt(150.0)*y))^2'
  [../]
  [./ic_eta2]
    type = ParsedFunction
    value = '0.01*0.837709*cos(0.01*(sqrt(25.0)*x+sqrt(151.0)*y))^2'
  [../]
  [./ic_eta3]
    type = ParsedFunction
    value = '0.01*0.695603*cos(0.01*(sqrt(26.0)*x+sqrt(152.0)*y))^2'
  [../]
  [./ic_eta4]
    type = ParsedFunction
    value = '0.01*0.225115*cos(0.01*(sqrt(27.0)*x+sqrt(153.0)*y))^2'
  [../]
  [./ic_eta5]
    type = ParsedFunction
    value = '0.01*0.389266*cos(0.01*(sqrt(28.0)*x+sqrt(154.0)*y))^2'
  [../]
  [./ic_eta6]
    type = ParsedFunction
    value = '0.01*0.585953*cos(0.01*(sqrt(29.0)*x+sqrt(155.0)*y))^2'
  [../]
  [./ic_eta7]
    type = ParsedFunction
    value = '0.01*0.614471*cos(0.01*(sqrt(30.0)*x+sqrt(156.0)*y))^2'
  [../]
  [./ic_eta8]
    type = ParsedFunction
    value = '0.01*0.918038*cos(0.01*(sqrt(31.0)*x+sqrt(157.0)*y))^2'
  [../]
  [./ic_eta9]
    type = ParsedFunction
    value = '0.01*0.518569*cos(0.01*(sqrt(32.0)*x+sqrt(158.0)*y))^2'
  [../]
[]

[AuxVariables]
  [./free_en]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./bnds]
  [../]
[]

[Kernels]
  [./c_res]
    type = SplitCHParsed
    variable = c
    kappa_name = kappa_c
    w = w
    f_name = F
    args = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9'
  [../]
  [./w_res]
    type = SplitCHWRes
    variable = w
    mob_name = M
  [../]
  [./time]
    type = CoupledTimeDerivative
    variable = w
    v = c
  [../]
  [./OstRipACKernel]
    c = c
  [../]
[]

[AuxKernels]
  [./free_en]
    type = TotalFreeEnergy
    variable = free_en
    f_name = F
    kappa_names = 'kappa_c kappa_op kappa_op kappa_op kappa_op kappa_op kappa_op kappa_op kappa_op kappa_op kappa_op'
    interfacial_vars = 'c  eta0     eta1     eta2     eta3      eta4     eta5     eta6     eta7     eta8      eta9'
    execute_on = 'initial timestep_end'
  [../]
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'eta0 eta1'
  [../]
[]

[BCs]
 [./Periodic]
  [./all]
   auto_direction = 'x y'
  [../]
 [../]
[]

[Materials]
  [./constants]
    type = GenericConstantMaterial
    prop_names  = 'kappa_c M   L   kappa_op'
    prop_values = '2.0     1.0 1.0 2.0'
  [../]
  [./gamma]
    type = ParsedMaterial
    f_name = gamma
    constant_names = 'C_alpha C_beta'
    constant_expressions = '0.05 0.95'
    function = 2.0/(C_beta-C_alpha)^2
  [../]
  [./fen1]
    type = DerivativeParsedMaterial
    f_name = f1
    args = c
    constant_names       = 'A   C_alpha C_beta                     C_m B'
    constant_expressions = '2.0 0.05    0.95 0.5*(C_alpha+C_beta)  A/(C_alpha-C_m)^2'
    function = '-0.5*A*(c-C_m)^2+0.25*B*(c-C_m)^4+
                0.25*gamma*(c-C_alpha)^4+
                0.25*gamma*(c-C_beta)^4'
    material_property_names = gamma
  [../]
  [./fen2]
    type = OstRipFreeEnergy
    f_name = f2
    c = c
    v = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9'
    gamma = gamma
  [../]
  [./loacal_fen]
    type = DerivativeSumMaterial
    f_name = F
    args = 'c eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9'
    sum_materials = 'f1 f2'
  [../]
[]

[Postprocessors]
  [./Total_Free_Energy]
    type = ElementIntegralVariablePostprocessor
    variable = free_en
    execute_on = 'initial TIMESTEP_END'
  [../]
  [./dt]
    type = TimestepSize
  [../]
  [./nodes]
    type = NumNodes
  [../]
  [./active_time]
    type = RunTime
    time_type = active
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
    #off_diag_row = 'c w eta0 eta1 c c'
    #off_diag_column = 'w c c c eta0 eta1'
  [../]
[]

[Executioner]
  type = Transient
  scheme = bdf2
  solve_type = NEWTON

  l_max_its = 20
  nl_max_its = 20
  l_tol = 1.0e-3
  nl_rel_tol = 1.0e-8
  start_time = 0.0
  num_steps = 1500
  nl_abs_tol = 1e-10

  [./TimeStepper]
    type = IterationAdaptiveDT
    cutback_factor = 0.5
    dt = 0.1
    growth_factor = 1.2
    optimal_iterations = 8
  [../]
[]

[Outputs]
  #output_initial = true
  exodus = true
  csv = true
  #interval = 1
  gnuplot = true
  print_mesh_changed_info = true
  print_perf_log = true
[]
