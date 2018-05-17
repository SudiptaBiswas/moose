# This simulation predicts GB migration of a 2D copper polycrystal with 100 grains represented with 18 order parameters
# Mesh adaptivity and time step adaptivity are used
# An AuxVariable is used to calculate the grain boundary locations
# Postprocessors are used to record time step and the number of grains

[Mesh]
  # Mesh block.  Meshes can be read in or automatically generated
  type = GeneratedMesh
  dim = 2 # Problem dimension
  nx = 15 # Number of elements in the x-direction
  ny = 6 # Number of elements in the y-direction
  xmin = 0    # minimum x-coordinate of the mesh
  xmax = 1500 # maximum x-coordinate of the mesh
  ymin = 0    # minimum y-coordinate of the mesh
  ymax = 600 # maximum y-coordinate of the mesh
  elem_type = QUAD4  # Type of elements used in the mesh
  uniform_refine = 3 # Initial uniform refinement of the mesh

  parallel_type = replicated # Periodic BCs
[]

[GlobalParams]
  # Parameters used by several kernels that are defined globally to simplify input file
  op_num = 10 # Number of order parameters used
  var_name_base = gr # Base name of grains
  # grain_num = 50
[]

# [Functions]
#   [./mob]
#     type = MobilityProfile
#     x1 = 260
#     y1 = 300
#     z1 = 0
#     r1 = 100
#     haz = 150
#     vp = 1.0
#     factor = 10.0
#     weldpool_shape = circular
#   [../]
# []

[Variables]
  # Variable block, where all variables in the simulation are declared
  [./PolycrystalVariables]
  [../]
[]

[UserObjects]
  # [./voronoi]
  #   type = PolycrystalVoronoi
  #   grain_num = 120 # Number of grains
  #   rand_seed = 10
  # [../]
  # [./grain_tracker]
  #   type = GrainTracker
  #   threshold = 0.2
  #   connecting_threshold = 0.08
  #   compute_halo_maps = true # Only necessary for displaying HALOS
  # [../]
[]

[ICs]
  [./PolycrystalICs]
    [./PolycrystalRandomIC]
      random_type = continuous
    [../]
  [../]

  # [./IC_eta5]
  #   variable = gr5
  #   type = RandomIC
  #   max = 2e-2
  #   min = 1e-2
  # [../]
  # [./IC_eta6]
  #   variable = gr6
  #   seed = 1000
  #   type = RandomIC
  #   max = 2e-2
  #   min = 1e-2
  # [../]
  #
  # [./IC_eta7]
  #   variable = gr7
  #   seed = 798011
  #   type = RandomIC
  #   max = 2e-2
  #   min = 1e-2
  # [../]
  # [./IC_eta8]
  #   variable = gr8
  #   seed = 123321
  #   type = RandomIC
  #   max = 2e-2
  #   min = 1e-2
  # [../]
  #
  # [./IC_eta9]
  #   variable = gr9
  #   seed = 1001058
  #   type = RandomIC
  #   max = 2e-2
  #   min = 1e-2
  # [../]
[]

[AuxVariables]
  # Dependent variables
  [./bnds]
    # Variable used to visualize the grain boundaries in the simulation
  [../]
[]

[Kernels]
  # Kernel block, where the kernels defining the residual equations are set up.
  [./PolycrystalKernel]
    # Custom action creating all necessary kernels for grain growth.  All input parameters are up in GlobalParams
  [../]
[]

[AuxKernels]
  # AuxKernel block, defining the equations used to calculate the auxvars
  [./bnds_aux]
    # AuxKernel that calculates the GB term
    type = BndsCalcAux
    variable = bnds
    execute_on = 'initial timestep_end'
  [../]
  # [./unique_grains]
  #   type = FeatureFloodCountAux
  #   variable = unique_grains
  #   flood_counter = grain_tracker
  #   field_display = UNIQUE_REGION
  #   execute_on = 'initial timestep_end'
  # [../]
  # [./var_indices]
  #   type = FeatureFloodCountAux
  #   variable = var_indices
  #   flood_counter = grain_tracker
  #   field_display = VARIABLE_COLORING
  #   execute_on = 'initial timestep_end'
  # [../]
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
    type = FunctionGBEvolution
    # Constant temperature of the simulation (for mobility calculation)
    wGB = 14 # Width of the diffuse GB
    GBMobility = 10.0 #m^4(Js) for copper from Schoenfelder1997
    GBenergy = 0.7 #J/m^2 from Schoenfelder1997
    t0 = 3.0
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
  file_base = grain_growth_renew_test3
  [./console]
    type = Console
    max_rows = 20 # Will print the 20 most recent postprocessor values to the screen
  [../]
[]
