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
  xmax = 150 0# maximum x-coordinate of the mesh
  ymin = 0    # minimum y-coordinate of the mesh
  ymax = 600 # maximum y-coordinate of the mesh
  elem_type = QUAD4  # Type of elements used in the mesh
  uniform_refine = 3 # Initial uniform refinement of the mesh

  parallel_type = replicated # Periodic BCs
[]

[GlobalParams]
  # Parameters used by several kernels that are defined globally to simplify input file
  op_num = 21 # Number of order parameters used
  var_name_base = gr # Base name of grains.
  grain_num = 120
[]

[Functions]
  [./mob]
    type = MobilityProfile
    x1 = 0
    y1 = 300
    z1 = 0
    r1 = 100
    haz = 150
    vp = 2.5
    factor = 10.0
    invalue = 1.0
    outvalue = 1e-3
    weldpool_shape = circular
  [../]
[]

[Variables]
  # Variable block, where all variables in the simulation are declared
  [./PolycrystalVariables]
  [../]
[]

[ICs]
  [./PolycrystalICs]
    [./PolycrystalColoringIC]
      polycrystal_ic_uo = voronoi
      op_num = 18
    [../]
    # [./PolycrystalRandomIC]
    #   random_type = discrete
    #   op_num = 3
    # [../]
  [../]

  [./IC_eta18]
    variable = gr18
    type = RandomIC
    max = 1.0
    min = 1e-2
  [../]
  [./IC_eta19]
    type = RandomIC
    variable = gr19
    seed = 1000
    max = 1.0
    min = 1e-2
  [../]

  [./IC_eta20]
    type = RandomIC
    variable = gr20
    seed = 798011
    max = 1.0
    min = 1e-2
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
  [./ghost_regions]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./halos]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  # Kernel block, where the kernels defining the residual equations are set up.
  [./PolycrystalKernel]
    # Custom action creating all necessary kernels for grain growth.  All input parameters are up in GlobalParams
  [../]
[]

# [Modules]
#   [./PhaseField]
#     [./Nonconserved]
#       free_energy = f
#     [../]
#   [../]
# []

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
    [./all]
      auto_direction = 'x y' # Makes problem periodic in the x and y directions
    [../]
  [../]
[]

[Materials]
  # [./FreeEng]
  #   type = DerivativeParsedMaterial
  #   args = 'eta1 eta2 eta3 eta0 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11'
  #   material_property_names = 'dis_den'
  #   function = 'sumeta:=eta0^2+eta1^2+eta2^2+eta3^2+eta4^2+eta5^2+eta6^2+eta7^2+eta8^2+eta9^2+eta10^2+eta11^2+eta12^2+eta13^2+eta14^2+eta15^2+eta16^2+eta17^2+eta18^2+eta19^2;
  #               f:=dis_den*((eta0^2+eta1^2+eta2^2+eta3^2+eta4^2+eta5^2+eta6^2+eta7^2)/sumeta);f'
  #   derivative_order = 2
  #   enable_jit = true
  #
  # [../]
  #
  # [./dis_den]
  #   type = ParsedMaterial
  #   f_name = dis_den
  #   args = 'unique_grains'
  #   constant_names = 'e'
  #   constant_expressions = '1.0'
  #   function = if(unique_grains>119,0,e)
  #
  #  # dislocation density equals e in the deformed grain and zero in the recrystallized grain
  #  # All existing grains are assumed to be damaged/deformed
  #  # Note that unique_grains runs from 0 to grain_num - 1
  # [../]
  [./CuGrGr]
    # Material properties
    type = FunctionGBEvolution
    # Constant temperature of the simulation (for mobility calculation)
    wGB = 14 # Width of the diffuse GB
    GBMobility = mob #m^4(Js) for copper from Schoenfelder1997
    GBenergy = 0.7 #J/m^2 from Schoenfelder1997
    t0 = 3.0
    outputs = exodus
  [../]
[]

[UserObjects]
  [./grain_tracker]
    type = GrainTracker
    threshold = 0.6
    connecting_threshold = 0.4
    compute_var_to_feature_map = true
    flood_entity_type = elemental
    execute_on = ' initial timestep_begin'
    halo_level = 3
    op_num = 18
  [../]
  [./voronoi]
    type = PolycrystalVoronoi
    op_num = 18
    rand_seed = 81
    coloring_algorithm = bt
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

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1.0 # Initial time step.  In this simulation it changes.
    optimal_iterations = 6 # Time step will adapt to maintain this number of nonlinear iterations
  [../]
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
      lower_bound = 0.01
      upper_bound = 0.99
      variable = bnds
    [../]
  [../]
[]


[Outputs]
  exodus = true # Exodus file will be outputted
  csv = true
  file_base = weld_recrys_vp25
  [./console]
    type = Console
    max_rows = 20 # Will print the 20 most recent postprocessor values to the screen
  [../]
[]
