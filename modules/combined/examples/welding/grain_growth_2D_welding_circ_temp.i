# This simulation predicts GB migration of a 2D copper polycrystal with 100 grains represented with 18 order parameters
# Mesh adaptivity and time step adaptivity are used
# An AuxVariable is used to calculate the grain boundary locations
# Postprocessors are used to record time step and the number of grains

[Mesh]
  # Mesh block.  Meshes can be read in or automatically generated
  type = FileMesh
  file = weld_IC_op20_gr150.e-s023
  parallel_type = replicated # Periodic BCs
[]

[GlobalParams]
  # Parameters used by several kernels that are defined globally to simplify input file
  op_num = 20 # Number of order parameters used
  var_name_base = gr # Base name of grains
[]

[Functions]
  # [./mob]
  #   type = MobilityProfile
  #   x1 = 0
  #   y1 = 300
  #   z1 = 0
  #   r1 = 100
  #   haz = 160
  #   vp = 2.5
  #   factor = 1.0
  #   invalue = 800
  #   outvalue = 300
  #   weldpool_shape = circular
  # [../]
  [./temp]
    type = HeatSourceProfile
    x1 = 0
    y1 = 300
    z1 = 0
    r1 = 100
    vp = 2.5
    heat_source_value = 10.0
    weldpool_shape = circular
  [../]
  [./gr0_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr0
  [../]
  [./gr1_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr1
  [../]
  [./gr2_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr2
  [../]
  [./gr3_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr3
  [../]
  [./gr4_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr4
  [../]
  [./gr5_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr5
  [../]
  [./gr6_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr6
  [../]
  [./gr7_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr7
  [../]
  [./gr8_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr8
  [../]
  [./gr9_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr9
  [../]
  [./gr10_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr10
  [../]
  [./gr11_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr11
  [../]
  [./gr12_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr12
  [../]
  [./gr13_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr13
  [../]
  [./gr14_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr14
  [../]
  [./gr15_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr15
  [../]
  [./gr16_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr16
  [../]
  [./gr17_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr17
  [../]
  [./gr18_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr18
  [../]
  [./gr19_fn]
    type = SolutionFunction
    solution = initial_grain
    from_variable = gr19
  [../]
[]

[Variables]
  # Variable block, where all variables in the simulation are declared
  [./PolycrystalVariables]
  [../]
  [./T]
    # scaling = 1e-6
    initial_condition = 300
  [../]
[]

[UserObjects]
  [./initial_grain]
    type = SolutionUserObject
    mesh = weld_IC_op20_gr150.e-s023
    timestep = LATEST
  [../]
  [./grain_tracker]
    type = GrainTracker
    threshold = 0.2
    connecting_threshold = 0.08
    compute_halo_maps = true # Only necessary for displaying HALOS
  [../]
[]

[ICs]
  [./gr0]
    type = FunctionIC
    function = gr0_fn
    variable = gr0
  [../]
  [./gr1]
    type = FunctionIC
    function = gr1_fn
    variable = gr1
  [../]
  [./gr2]
    type = FunctionIC
    function = gr2_fn
    variable = gr2
  [../]
  [./gr3]
    type = FunctionIC
    function = gr3_fn
    variable = gr3
  [../]
  [./gr4]
    type = FunctionIC
    function = gr4_fn
    variable = gr4
  [../]
  [./gr5]
    type = FunctionIC
    function = gr5_fn
    variable = gr5
  [../]
  [./gr6]
    type = FunctionIC
    function = gr6_fn
    variable = gr6
  [../]
  [./gr7]
    type = FunctionIC
    function = gr7_fn
    variable = gr7
  [../]
  [./gr8]
    type = FunctionIC
    function = gr8_fn
    variable = gr8
  [../]
  [./gr9]
    type = FunctionIC
    function = gr9_fn
    variable = gr9
  [../]
  [./gr10]
    type = FunctionIC
    function = gr10_fn
    variable = gr10
  [../]
  [./gr11]
    type = FunctionIC
    function = gr11_fn
    variable = gr11
  [../]
  [./gr12]
    type = FunctionIC
    function = gr12_fn
    variable = gr12
  [../]
  [./gr13]
    type = FunctionIC
    function = gr13_fn
    variable = gr13
  [../]
  [./gr14]
    type = FunctionIC
    function = gr14_fn
    variable = gr14
  [../]
  [./gr15]
    type = FunctionIC
    function = gr15_fn
    variable = gr15
  [../]
  [./gr16]
    type = FunctionIC
    function = gr16_fn
    variable = gr16
  [../]
  [./gr17]
    type = FunctionIC
    function = gr17_fn
    variable = gr17
  [../]
  [./gr18]
    type = FunctionIC
    function = gr18_fn
    variable = gr18
  [../]
  [./gr19]
    type = FunctionIC
    function = gr19_fn
    variable = gr19
  [../]
[]

[AuxVariables]
  # Dependent variables
  [./bnds]
    # Variable used to visualize the grain boundaries in the simulation
  [../]
  [./unique_grains]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./var_indices]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  # Kernel block, where the kernels defining the residual equations are set up.
  [./PolycrystalKernel]
    # Custom action creating all necessary kernels for grain growth.  All input parameters are up in GlobalParams
    args = T
  [../]
  [./T_dot]
    type = TimeDerivative
    variable = T
  [../]
  [./CoefDiffusion]
    type = Diffusion
    variable = T
  [../]
  [./source]
    type = BodyForce
    variable = T
    function = temp
  [../]
  # [./w_dot_T]
  #   type = CoefCoupledTimeDerivative
  #   variable = T
  #   v = w
  #   coef = -1.8
  # [../]
[]

[AuxKernels]
  # AuxKernel block, defining the equations used to calculate the auxvars
  [./bnds_aux]
    # AuxKernel that calculates the GB term
    type = BndsCalcAux
    variable = bnds
    execute_on = 'initial timestep_end'
  [../]
  [./unique_grains]
    type = FeatureFloodCountAux
    variable = unique_grains
    flood_counter = grain_tracker
    field_display = UNIQUE_REGION
    execute_on = 'initial timestep_end'
  [../]
  [./var_indices]
    type = FeatureFloodCountAux
    variable = var_indices
    flood_counter = grain_tracker
    field_display = VARIABLE_COLORING
    execute_on = 'initial timestep_end'
  [../]
[]

[BCs]
  # Boundary Condition block
  [./Periodic]
    [./top_bottom]
      auto_direction = 'x y' # Makes problem periodic in the x and y directions
    [../]
  [../]
[]

[Materials]
  [./CuGrGr]
    # Material properties
    type = GBEvolution
    # Constant temperature of the simulation (for mobility calculation)
    T = T
    wGB = 14 # Width of the diffuse GB
    GBmob0 = 2.5e-6 #Mobility prefactor for Cu from Schonfelder1997
    GBenergy = 0.708 #GB energy for Cu from Schonfelder1997
    Q = 0.23  #J/m^2 from Schoenfelder1997
    # t0 = 3.0
    outputs = exodus
  [../]
[]

[Postprocessors]
  # Scalar postprocessors
  [./dt]
    # Outputs the current time step
    type = TimestepSize
  [../]
[]

[Executioner]
  type = Transient # Type of executioner, here it is transient with an adaptive time step
  scheme = bdf2 # Type of time integration (2nd order backward euler), defaults to 1st order backward euler

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'

  l_max_its = 20 # Max number of linear iterations
  l_tol = 1e-4 # Relative tolerance for linear solves
  nl_max_its = 20 # Max number of nonlinear iterations
  nl_rel_tol = 1e-10 # Absolute tolerance for nonlienar solves

  start_time = 0.0
  end_time = 1000

  # [./TimeStepper]
  #   type = IterationAdaptiveDT
  #   dt = 1.0 # Initial time step.  In this simulation it changes.
  #   optimal_iterations = 6 # Time step will adapt to maintain this number of nonlinear iterations
  # [../]
[]

[Adaptivity]
  marker = bound_adapt
  max_h_level = 4
  [./Indicators]
    [./error]
      type = GradientJumpIndicator
      variable = bnds
    [../]
  [../]
  [./Markers]
    [./bound_adapt]
      type = ValueRangeMarker
      lower_bound = 0.1
      upper_bound = 0.99
      variable = bnds
    [../]
  [../]
[]


[Outputs]
  exodus = true # Exodus file will be outputted
  csv = true
  # file_base = weld_circ_vp25_temp2
  [./console]
    type = Console
    max_rows = 20 # Will print the 20 most recent postprocessor values to the screen
  [../]
[]
