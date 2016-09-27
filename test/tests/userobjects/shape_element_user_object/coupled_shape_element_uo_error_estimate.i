[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 30
  ny = 30
  #nz = 10
  #elem_type = QUAD9
[]

[Variables]
  [./u]
    #order = SECOND
    order = FIRST
    family = LAGRANGE
    #[./InitialCondition]
    #  type = ConstantIC
    #  value = 0
    #[../]
    [./InitialCondition]
      type = FunctionIC
      function = (x-0.5)^2
    [../]
  [../]
  [./v]
    #order = SECOND
    order = FIRST
    family = LAGRANGE
    #[./InitialCondition]
    #  type = ConstantIC
    #  value = 0
    #[../]
    [./InitialCondition]
      type = FunctionIC
      function = (x-0.5)^2
    [../]
  [../]
[]

#[Functions]
#  [./forcing_fn]
#    type = ParsedFunction
#    # dudt = 3*t^2*(x^2 + y^2)
#    value = 3*t*t*((x*x)+(y*y))-(4*t*t*t)-t*t*t*x*y*((x*x)+(y*y))/3
#  [../]
#
#  [./exact_fn]
#    type = ParsedFunction
#    value = t*t*t*((x*x)+(y*y))
#  [../]
#[]

[Kernels]
  [./diff_u]
    type = Diffusion
    variable = u
  [../]
  [./time_u]
    type = TimeDerivative
    variable = u
  [../]
  [./shape_u]
    type = SimpleTestShapeElementKernel
    user_object = example_uo
    variable = u
  [../]
  #[./ffn]
  #  type = UserForcingFunction
  #  variable = u
  #  function = forcing_fn
  #[../]

  [./diff_v]
    type = Diffusion
    variable = v
  [../]
  [./time_v]
    type = TimeDerivative
    variable = v
  [../]
  #[./shape_w]
  #  type = ExampleShapeElementKernel
  #  user_object = example_uo
  #  v = v
  #  variable = u
  #[../]
  [./adv_v]
    type = Advection
    advector = u
    variable = v
  [../]
[]

[UserObjects]
  [./example_uo]
    type = SimpleTestShapeElementUserObject
    u = u
    # as this userobject computes quantities for both the residual AND the jacobian
    # it needs to have these execute_on flags set.
    execute_on = 'linear nonlinear'
    #compute_jacobians = false
  [../]
  #[./example_uo]
  #  type = ExampleShapeElementUserObject
  #  u = u
  #  v = v
  #  # as this userobject computes quantities for both the residual AND the jacobian
  #  # it needs to have these execute_on flags set.
  #  execute_on = 'linear nonlinear'
  #  #compute_jacobians = false
  #[../]
[]


[Postprocessors]
  #[./l2_err]
  #  type = ElementL2Error
  #  variable = u
  #  function = exact_fn
  #[../]
  #
  #[./h1_err]
  #  type = ElementH1Error
  #  variable = u
  #  function = exact_fn
  #[../]
  #
  #[./dt]
  #  type = TimestepSize
  #[../]
  #
  #[./H1Semierror]
  #  type = ElementH1SemiError
  #  variable = u
  #  function = exact_fn
  #[../]
  #
  #[./norm]
  #  type = NodalL2Norm
  #  variable = u
  #[../]

  [./dofs]
    type = NumDOFs
  [../]
  [./tstep]
    type = TimestepSize
  [../]
  [./nonlinear_iterations]
    type = NumNonlinearIterations
  [../]
  [./linear_iterations]
    type = NumLinearIterations
  [../]
  [./elapsed_alive]
    type = PerformanceData
    event = 'ALIVE'
  [../]
  [./elapsed_active]
    type = PerformanceData
    event = 'ACTIVE'
  [../]
[]

[Preconditioning]
  [./smp]
    type = SMP
    #full = true
    off_diag_row =    'v'
    off_diag_column = 'u'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = NEWTON

  #petsc_options = '-snes_test_display'
  #petsc_options_iname = '-snes_type'
  #petsc_options_value = 'test'

  scheme = bdf2
  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'
  dt = 0.1
  num_steps = 10
[]

[Outputs]
  exodus = true
  print_perf_log = true
  csv = true
  file_base = coupled_30elem
[]
