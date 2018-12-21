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
[]

[Variables]
  [./c]
    order = FIRST
    family = LAGRANGE
  [../]
  [./w]
  [../]
[]

[ICs]
  [./c_IC]
    type = FunctionIC
    variable = c
    function = ic_c_func
  [../]
[]

[Functions]
  [./ic_c_func]
    type = ParsedFunction
    value = '0.45+0.01*cos(sqrt(2)*x+sqrt(3)*y)'
  [../]
[]

[AuxVariables]
  [./free_en]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  [./c_res]
    type = SplitCHParsed
    variable = c
    kappa_name = kappa_c
    w = w
    f_name = F
    args = 'c'
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
[]

[AuxKernels]
  [./free_en]
    type = TotalFreeEnergy
    variable = free_en
    f_name = F
    kappa_names = 'kappa_c'
    interfacial_vars = c
    execute_on = 'initial timestep_end'
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
    prop_names = 'kappa_c M'
    prop_values = '2.0 2.22'
  [../]
  [./local_fen]
    type = DerivativeParsedMaterial
    f_name = F
    args = c
    constant_names = 'A C_alpha C_beta C_m B'
    constant_expressions = '2.0 0.05 0.95 0.5*(C_alpha+C_beta)  A/((C_alpha-C_m)*(C_alpha-C_m))'
    function = '-0.5*A*(c-C_m)*(c-C_m)+0.25*B*(c-C_m)*(c-C_m)*(c-C_m)*(c-C_m)+
                0.25*C_alpha*(c-C_alpha)*(c-C_alpha)*(c-C_alpha)*(c-C_alpha)+
                0.25*C_beta*(c-C_beta)*(c-C_beta)*(c-C_beta)*(c-C_beta)'
  [../]
[]

[Postprocessors]
  [./Total_Free_Energy]
    type = ElementIntegralVariablePostprocessor
    variable = free_en
  [../]
  [./dt]
    type = TimestepSize
  [../]
  [./nodes]
    type = NumNodes
  [../]
  # [./active_time]
  #   type = RunTime
  #   time_type = active
  # [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
#    off_diag_row = 'c w'
#    off_diag_column = 'w c'
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  nl_max_its = 20
  scheme = bdf2
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   ilu      1'
  l_max_its = 30
  l_tol = 1.0e-4
  nl_rel_tol = 1.0e-9
  start_time = 0.0
  num_steps = 200
  nl_abs_tol = 1e-8
  [./TimeStepper]
    type = IterationAdaptiveDT
    cutback_factor = .75
    dt = 10
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
  interval = 1
  print_mesh_changed_info = true
  print_perf_log = true
[]
