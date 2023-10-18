# This simulation predicts GB migration of a 2D copper polycrystal with 15 grains
# Mesh adaptivity (new system) and time step adaptivity are used
# An AuxVariable is used to calculate the grain boundary locations
# Postprocessors are used to record time step and the number of grains
# We are not using the GrainTracker in this example so the number
# of order paramaters must match the number of grains.

[Mesh]
  # Mesh block.  Meshes can be read in or automatically generated
  type = GeneratedMesh
  dim = 2 # Problem dimension
  nx = 100 # Number of elements in the x-direction
  ny = 100 # Number of elements in the y-direction
  nz = 0 # Number of elements in the z-direction
  xmin = 0    # minimum x-coordinate of the mesh
  xmax = 1000 # maximum x-coordinate of the mesh
  ymin = 0    # minimum y-coordinate of the mesh
  ymax = 1000 # maximum y-coordinate of the mesh
  zmin = 0
  zmax = 0
  elem_type = QUAD4 # Type of elements used in the mesh
  uniform_refine = 2 # Initial uniform refinement of the mesh

  parallel_type = replicated # Periodic BCs
[]

[GlobalParams]
  # Parameters used by several kernels that are defined globally to simplify input file
  op_num = 15 # Number of grains
  var_name_base = gr # Base name of grains
[]

[UserObjects]
  [./voronoi]
    type = PolycrystalVoronoi
    grain_num = 100
    rand_seed = 42
    coloring_algorithm = bt # We must use bt to force the UserObject to assign one grain to each op
  [../]
[]

[ICs]
  [./PolycrystalICs]
    [./PolycrystalColoringIC]
      polycrystal_ic_uo = voronoi
    [../]
  [../]
[]

[Variables]
  # Variable block, where all variables in the simulation are declared
  [./PolycrystalVariables]
    # Custom action that created all of the grain variables and sets their initial condition
  [../]
  [./temp]
    initial_condition = 300.0
  [../]
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
  [./HeatDiff]
    type = ADHeatConduction
    variable = temp
    thermal_conductivity = thermal_conductivity
  [../]
  [./heat_dt]
    type = ADHeatConductionTimeDerivative
    variable = temp
    specific_heat = thermal_conductivity
    density_name = density
  [../]
  [./heatsource]
    type = HeatSourceNucleation
    material_property = 0.01
    map = map
    variable = temp
    # scalar = 10
  [../]
  # [./c]
  #   type = ADDiffusion
  #   variable = c
  # [../]
[]

[AuxKernels]
  # AuxKernel block, defining the equations used to calculate the auxvars
  [./bnds_aux]
    # AuxKernel that calculates the GB term
    type = BndsCalcAux
    variable = bnds
    execute_on = timestep_end
  [../]
[]

[BCs]
  # Boundary Condition block
  [./Periodic]
    [./top_bottom]
      auto_direction = 'x y' # Makes problem periodic in the x and y directions
    [../]
  [../]
  # [./lefttemp]
  #   type = DirichletBC
  #   boundary = left
  #   variable = temp
  #   value = 450
  # [../]
[]

[Materials]
  [./CuGrGr]
    # Material properties
    type = GBEvolution # Quantitative material properties for copper grain growth.  Dimensions are nm and ns
    GBmob0 = 2.5e-6 # Mobility prefactor for Cu from Schonfelder1997
    GBenergy = 0.708 # GB energy for Cu from Schonfelder1997
    Q = 0.23 # Activation energy for grain growth from Schonfelder 1997
    T = temp # Constant temperature of the simulation (for mobility calculation)
    wGB = 14 # Width of the diffuse GB
  [../]
  [./density]
    type = ADGenericConstantMaterial
    prop_names = 'density  thermal_conductivity volumetric_heat  specific_heat'
    prop_values = '10970    0.1                  3.8e7           0.7925e-3  '
  [../]
  # [./probability]
  #   # This is a made up toy nucleation rate it should be replaced by
  #   # classical nucleation theory in a real simulation.
  #   type = ADParsedMaterial
  #   property_name = Fn
  #   coupled_variables = temp
  #   expression = '1000*temp'
  #   outputs = exodus
  # [../]
  # [./nucleation]
  #   # The nucleation material is configured to insert nuclei into the free energy
  #   # tht force the concentration to go to 0.95, and holds this enforcement for 500
  #   # time units.
  #   type = DiscreteNucleation
  #   property_name = Fn
  #   op_names  = temp
  #   op_values = 5
  #   # penalty = 5
  #   # penalty_mode = MIN
  #   map = map
  #   outputs = exodus
  # [../]
[]

[UserObjects]
  [./inserter]
    type = DiscreteNucleationInserter
    hold_time = 200
    probability = 1e-11
    radius = 20
    # outputs = exodus
  [../]
  [./map]
    type = DiscreteNucleationMap
    periodic = temp
    inserter = inserter
    # radius = 20
    int_width = 2.0
    # outputs = exodus
  [../]
    # [inserter]
    #   # The inserter runs at the end of each time step to add nucleation events
    #   # that happend during the timestep (if it converged) to the list of nuclei
    #   type = DiscreteNucleationInserter
    #   hold_time = 0
    #   time_dependent_statistics = false
    #   probability = nucleation_rate
    #   radius = 20
    # []
    # [map]
    #   # The map UO runs at the beginning of a timestep and generates a per-element/qp
    #   # map of nucleus locations. The map is only regenerated if the mesh changed or
    #   # the list of nuclei was modified.
    #   # The map converts the nucleation points into finite area objects with a given radius.
    #   type = DiscreteNucleationMap
    #   # radius = 20
    #   int_width = 20
    #   periodic = eta0
    #   inserter = inserter
    # []
[]



[Postprocessors]
  # Scalar postprocessors
  [./dt]
    # Outputs the current time step
    type = TimestepSize
  [../]
  [./right]
    type = SideAverageValue
    variable = temp
    boundary = right
  [../]
    [./rate]
      type = DiscreteNucleationData
      value = RATE
      inserter = inserter
    [../]
    [./dtnuc]
      type = DiscreteNucleationTimeStep
      inserter = inserter
      p2nucleus = 0.0005
      dt_max = 10
    [../]
    [./update]
      type = DiscreteNucleationData
      value = UPDATE
      inserter = inserter
    [../]
    [./count]
      type = DiscreteNucleationData
      value = COUNT
      inserter = inserter
    [../]
[]

[Executioner]
  type = Transient # Type of executioner, here it is transient with an adaptive time step
  scheme = bdf2 # Type of time integration (2nd order backward euler), defaults to 1st order backward euler

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -mat_mffd_type'
  petsc_options_value = 'hypre    boomeramg      101                ds'

  l_max_its = 30 # Max number of linear iterations
  l_tol = 1e-4 # Relative tolerance for linear solves
  nl_max_its = 40 # Max number of nonlinear iterations
  nl_abs_tol = 1e-11 # Relative tolerance for nonlienar solves
  nl_rel_tol = 1e-10 # Absolute tolerance for nonlienar solves

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 25 # Initial time step.  In this simulation it changes.
    optimal_iterations = 6
  [../]

  start_time = 0.0
  end_time = 1e6
  # num_steps = 3
[]

[Adaptivity]
  marker = errorfrac
  max_h_level = 3
  [./Indicators]
    [./error]
      type = GradientJumpIndicator
      variable = bnds
    [../]
  [../]
  [./Markers]
    [./errorfrac]
      type = ErrorFractionMarker
      coarsen = 0.1
      indicator = error
      refine = 0.8
    [../]
  [../]
[]

[Outputs]
  exodus = true
  csv = true
  [./console]
    type = Console
    max_rows = 20
  [../]
[]
