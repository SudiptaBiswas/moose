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
  #uniform_refine = 2
[]

[GlobalParams]
  block = 0
  derivative_order = 2
  op_num = 2
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
[]

[Functions]
  [./ic_c_func]
    type = ParsedFunction
    value = '0.45+0.01*cos(0.1*(sqrt(2.0)*x+sqrt(3.0)*y))'
  [../]
  [./ic_eta0]
    type = ParsedFunction
    value = '0.01*0.979285*cos(0.01*(sqrt(23.0)*x+sqrt(149.0)*y))*cos(0.01*(sqrt(23.0)*x+sqrt(149.0)*y))'
  [../]
  [./ic_eta1]
    type = ParsedFunction
    value = '0.01*0.219812*cos(0.01*(sqrt(24.0)*x+sqrt(150.0)*y))*cos(0.01*(sqrt(24.0)*x+sqrt(1.0)*y))'
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
    args = 'c eta0 eta1'
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
    gamma = gamma
    c = c
  [../]
[]

[AuxKernels]
  [./free_en]
    type = TotalFreeEnergy
    variable = free_en
    f_name = F
    kappa_names = 'kappa_c kappa_op kappa_op'
    interfacial_vars = 'c eta0 eta1'
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
    prop_names = 'kappa_c M L kappa_op'
    prop_values = '2.0 1.0 1.0 2.0'
  [../]
  [./gamma]
    type = ParsedMaterial
    f_name = gamma
    constant_names = 'C_alpha C_beta'
    constant_expressions = '0.05 0.95'
    function = 2.0/((C_beta-C_alpha)*(C_beta-C_alpha))
  [../]
  [./fen1]
    type = DerivativeParsedMaterial
    f_name = f1
    args = c
    constant_names = 'A C_alpha C_beta C_m B'
    constant_expressions = '2.0 0.05 0.95 0.5*(C_alpha+C_beta)  A/((C_alpha-C_m)*(C_alpha-C_m))'
    function = '-0.5*A*(c-C_m)*(c-C_m)+0.25*B*(c-C_m)*(c-C_m)*(c-C_m)*(c-C_m)+
                0.25*C_alpha*(c-C_alpha)*(c-C_alpha)*(c-C_alpha)*(c-C_alpha)+
                0.25*C_beta*(c-C_beta)*(c-C_beta)*(c-C_beta)*(c-C_beta)'
  [../]
  [./fen2]
    type = OstRipFreeEnergy
    f_name = f2
    c = c
    v = 'eta0 eta1'
    gamma = gamma
  [../]
  [./loacal_fen]
    type = DerivativeSumMaterial
    args = 'c eta0 eta1'
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
  # Preconditioned JFNK (default)
  type = Transient
  scheme = bdf2
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   ilu      1'
  l_max_its = 20
  nl_max_its = 20
  l_tol = 1.0e-4
  nl_rel_tol = 1.0e-6
  start_time = 0.0
  num_steps = 1500
  nl_abs_tol = 1e-8
  [./TimeStepper]
    type = IterationAdaptiveDT
    cutback_factor = 0.5
    dt = 0.01
    growth_factor = 1.2
    optimal_iterations = 8
  [../]
  [./Adaptivity]
    refine_fraction = 0.7
    coarsen_fraction = 0.1
    max_h_level = 2
    initial_adaptivity = 2
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
