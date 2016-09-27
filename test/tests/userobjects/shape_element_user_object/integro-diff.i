[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 500
  #ny = 10
  #nz = 2
[]

[Variables]
  [./u]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      #type = BoundingBoxIC
      #y2 = 0.4
      #y1 = 0.2
      #inside = 1.0
      #x2 = 0.4
      #variable = u
      #x1 = 0.2
      type = FunctionIC
      function = x*(1-x)*sin(x)
    [../]
  [../]
[]

[BCs]
  [./bc]
    type = DirichletBC
    boundary = 'left right'
    variable = u
    value = 0
  [../]
[]

[Functions]
  [./force]
    # Defines the force on the grains in the x-direction
    type = ParsedFunction
    value = x*(1-x)*cos(x+t)-((1+11/60*t-1/8*sin(t)*cos(t)-1/8*cos(t+1)*sin(t+1)+1/8*cos(1)*sin(1))*(-2*sin(x+t)+2*(1-x)*cos(x+t)-2*x*cos(x+t)-x*(1-x)*sin(x+t)))
  [../]
  [./exact_fn]
    type = ParsedFunction
    value = x*(1-x)*sin(x+t)
  [../]
[]

[Kernels]
  #[./diff_u]
  #  type = Diffusion
  #  variable = u
  #[../]
  [./time_u]
    type = TimeDerivative
    variable = u
  [../]
  [./shape_u]
    type = IntegroDiffKernel
    user_object = example_uo
    variable = u
  [../]
  [./forcing]
    type = UserForcingFunction
    variable = u
    function = force
  [../]
[]

[UserObjects]
  [./example_uo]
    type = ShapeElementUserObjectTest
    u = u
    # as this userobject computes quantities for both the residual AND the jacobian
    # it needs to have these execute_on flags set.
    execute_on = 'linear nonlinear'
    #compute_jacobians = false
  [../]
[]

[Postprocessors]
  [./l2_err]
    type = ElementL2Error
    variable = u
    function = exact_fn
  [../]

  [./h1_err]
    type = ElementH1Error
    variable = u
    function = exact_fn
  [../]

  [./dt]
    type = TimestepSize
  [../]

  [./H1Semierror]
    type = ElementH1SemiError
    variable = u
    function = exact_fn
  [../]

  [./norm]
    type = NodalL2Norm
    variable = u
  [../]
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
    #off_diag_row =    'u'
    #off_diag_column = 'v'
  [../]
  #[./smp]
  #  type = FDP
  #  full = true
  #  #off_diag_row =    'u'
  #  #off_diag_column = 'v'
  #[../]
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
  dt = 0.01
  num_steps = 100
[]

[Outputs]
  exodus = true
  print_perf_log = true
  gnuplot = true
[]
