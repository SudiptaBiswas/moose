# This simulation creates the initial grain structure with diffused interface
# that will be used an initial condition for different welding grain growth simulations
# total 15 order parameters are used and 120 grains are created in this simulation.

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 15
  ny = 6
  xmin = 0
  xmax = 1500
  ymin = 0
  ymax = 600
  elem_type = QUAD4
  uniform_refine = 3
  parallel_type = replicated # Periodic BCs
[]

[GlobalParams]
  op_num = 20
  var_name_base = gr
[]


[Variables]
  [./PolycrystalVariables]
  [../]
[]

[UserObjects]
  [./voronoi]
    type = PolycrystalVoronoi
    grain_num = 150
    rand_seed = 10
  [../]
  [./grain_tracker]
    type = GrainTracker
    threshold = 0.2
    connecting_threshold = 0.08
    compute_var_to_feature_map = true
    remap_grains = false
    polycrystal_ic_uo = voronoi
  [../]
[]

[ICs]
  [./PolycrystalICs]
    [./PolycrystalColoringIC]
      polycrystal_ic_uo = voronoi
    [../]
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
  [./PolycrystalKernel]
  [../]
[]

[AuxKernels]
  [./bnds_aux]
    type = BndsCalcAux
    variable = bnds
    execute_on = 'timestep_end'
  [../]
  [./unique_grains]
    type = FeatureFloodCountAux
    variable = unique_grains
    flood_counter = grain_tracker
    field_display = UNIQUE_REGION
    execute_on = 'timestep_end'
  [../]
  [./var_indices]
    type = FeatureFloodCountAux
    variable = var_indices
    flood_counter = grain_tracker
    field_display = VARIABLE_COLORING
    execute_on = 'timestep_end'
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
    T = 500
    wGB = 14 # Width of the diffuse GB
    GBmob0 = 2.5e-6 #Mobility prefactor for Cu from Schonfelder1997
    GBenergy = 0.708 #GB energy for Cu from Schonfelder1997
    Q = 0.23  #J/m^2 from Schoenfelder1997
    # t0 = 3.0
    outputs = exodus
  [../]
[]

[Executioner]
  type = Transient
  scheme = bdf2
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'

  l_max_its = 20
  l_tol = 1e-4
  nl_max_its = 20
  nl_rel_tol = 1e-10

  start_time = 0.0
  num_steps = 30
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
  exodus = true
  csv = true
  print_perf_log = true
  file_base = weld_IC_op20_gr150
[]
