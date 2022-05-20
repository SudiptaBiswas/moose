
# input file for bubble groeth and pressure build up in HbS structure
# For model parameterization, time scale = 1 sec, length scale  = 1 nm, energy density scale = 1 eV/nm^3, int_width = 10 nm
# domain size is scaled for reducing computational cost
[Mesh]
  [gmg]
    type = DistributedRectilinearMeshGenerator
    dim = 3
    nx = 100
    ny = 100
    nz = 100
    partition = square
  []
[]

[GlobalParams]
  op_num = 20
  var_name_base = gr
  int_width = 0.03
[]

[Variables]
  [./PolycrystalVariables]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ICs]
  [./PolycrystalICs]
    [./PolycrystalColoringIC]
      polycrystal_ic_uo = voronoi
    [../]
  [../]
  [bnds]
    type = BndsCalcIC
    variable = bnds
  []
[]

[AuxVariables]
  [bnds]
    order = FIRST
    family = LAGRANGE
  []
  [unique_grains]
    order = CONSTANT
    family = MONOMIAL
  []
  [var_indices]
    order = CONSTANT
    family = MONOMIAL
  []
  [halos]
    order = CONSTANT
    family = MONOMIAL
  []
  [./time]
  [../]
[]

[Kernels]
  [./PolycrystalKernel]
  [../]
[]

[AuxKernels]
  [BndsCalc]
    type = BndsCalcAux
    variable = bnds
    execute_on = 'timestep_end'
  []
  [unique_grains_calc]
    type = FeatureFloodCountAux
    variable = unique_grains
    flood_counter = grain_tracker
    field_display = UNIQUE_REGION
    execute_on = 'initial timestep_end'
  []
  [var_indices_calc]
    type = FeatureFloodCountAux
    variable = var_indices
    flood_counter = grain_tracker
    field_display = VARIABLE_COLORING
    execute_on = 'initial timestep_end'
  []
  [halos]
    type = FeatureFloodCountAux
    variable = halos
    flood_counter = grain_tracker
    field_display = HALOS
    execute_on = 'initial timestep_end'
  []
  [./time]
    type = FunctionAux
    variable = time
    function = 't'
  [../]
[]

[Materials]
  [./CuGrGr]
    # Material properties
    type = GBEvolution
    T = 450 # Constant temperature of the simulation (for mobility calculation)
    wGB = 125 # Width of the diffuse GB
    GBmob0 = 2.5e-6 #m^4(Js) for copper from Schoenfelder1997
    Q = 0.23 #eV for copper from Schoenfelder1997
    GBenergy = 0.708 #J/m^2 from Schoenfelder1997
  [../]
[]

[UserObjects]
  [voronoi]
    type = PolycrystalVoronoi
    rand_seed = 123
    file_name = 3d_fracture_grains30.txt
    coloring_algorithm = jp
  []
  [grain_tracker]
    type = GrainTracker
    compute_var_to_feature_map = true
    execute_on = 'initial timestep_begin'
    halo_level = 3
    remap_grains = true
    compute_halo_maps = true
    threshold = 0.2
    connecting_threshold = 0.08
    polycrystal_ic_uo = voronoi
  []
[]

[BCs]
  [Periodic]
    [all]
      auto_direction = 'x y z'
    []
  []
[]
#
# [Adaptivity]
#   initial_steps = 3
#   max_h_level = 3
#   marker = err
#   [Markers]
#     [err_bnds]
#       type = ErrorFractionMarker
#       coarsen = 0.01
#       refine = 0.8
#       indicator = ind_bnds
#     []
#     [err_b]
#       type = ErrorFractionMarker
#       coarsen = 0.01
#       refine = 0.8
#       indicator = ind_b
#     []
#     [err]
#       type = ComboMarker
#       markers = 'err_bnds err_b'
#     []
#   []
#   [Indicators]
#     [ind_bnds]
#       type = GradientJumpIndicator
#       variable = bnds
#     []
#     [ind_b]
#       type = GradientJumpIndicator
#       variable = etab
#     []
#   []
# []

# [Preconditioning]
#   [SMP]
#     type = SMP
#     full = true
#   []
# []

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

  # Uses newton iteration to solve the problem.
  petsc_options_iname = '-pc_type -sub_pc_type'
  petsc_options_value = 'asm      ilu'

  l_max_its = 20 # Max number of linear iterations
  l_tol = 1e-4 # Relative tolerance for linear solves
  nl_max_its = 10 # Max number of nonlinear iterations
  nl_rel_tol = 1e-10 # Absolute tolerance for nonlienar solves

  start_time = 0.0
  end_time = 4000

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1 # Initial time step.  In this simulation it changes.
    optimal_iterations = 6 # Time step will adapt to maintain this number of nonlinear iterations
  [../]
[]


[Outputs]
  csv = true
  checkpoint = true
  [./exodus]
    type = Exodus
    execute_on = 'INITIAL TIMESTEP_END'
  [../]
  [./perf_graph]
    type = PerfGraphOutput
    execute_on = 'initial final'  # Default is "final"
    level = 2                     # Default is 1
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]
