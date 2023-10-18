# This is a simple 1D test of the volumetric heat source with material properties
# of a representative ceramic material.  A bar is uniformly heated, and a temperature
# boundary condition is applied to the left side of the bar.

# Important properties of problem:
# Length: 0.01 m
# Thermal conductivity = 3.0 W/(mK)
# Specific heat = 300.0 J/K
# density = 10431.0 kg/m^3
# Prescribed temperature on left side: 600 K

# When it has reached steady state, the temperature as a function of position is:
#  T = -q/(2*k) (x^2 - 2*x*length) + 600
#  or
#  T = -6.3333e+7 * (x^2 - 0.02*x) + 600
#  on left side: T=600, on right side, T=6933.3

[Mesh]
  type = GeneratedMesh
  dim = 2
  xmax = 10000
  ymax = 10000
  nx = 100
  ny = 100
  uniform_refine = 2
[]

[Adaptivity]
  [./Indicators]
    [./jump]
      type = GradientJumpIndicator
      variable = temp
    [../]
  [../]
  [./Markers]
    [./nuc]
      type = DiscreteNucleationMarker
      map = map
    [../]
    [./grad]
      type = ValueThresholdMarker
      variable = jump
      coarsen = 0.1
      refine = 0.2
    [../]
    [./combo]
      type = ComboMarker
      markers = 'nuc grad'
    [../]
  [../]
  marker = nuc
  cycles_per_step = 3
  recompute_markers_during_cycles = true
  max_h_level = 3
[]

[Variables]
  [./temp]
    initial_condition = 300.0
  [../]
[]

[Kernels]
  [./heat]
    type = ADHeatConduction
    variable = temp
    thermal_conductivity = thermal_conductivity
  [../]
  [./heat_dt]
    type = ADHeatConductionTimeDerivative
    variable = temp
    specific_heat = specific_heat
    density_name = density
  [../]
  [./heatsource]
    type = HeatSourceNucleation
    material_property = 0.01 #increases the temperature when this value is increased
    map = map
    variable = temp
    # scalar = 10
  [../]
[]

[UserObjects]
  [./inserter]
    type = DiscreteNucleationInserter
    hold_time = 200
    probability = 1e-12
    radius = 200
    # int_width = 20
    # outputs = exodus
  [../]
  [./map]
    type = DiscreteNucleationMap
    periodic = temp
    inserter = inserter
    # outputs = exodus
  [../]
[]

[BCs]
  # [./lefttemp]
  #   type = DirichletBC
  #   boundary = left
  #   variable = temp
  #   value = 600
  # [../]
[]

[Materials]
  [./density]
    type = ADGenericConstantMaterial
    prop_names = 'density  thermal_conductivity volumetric_heat  specific_heat'
    prop_values = '10970    0.01                 3.8e7           0.7925e-3  '
  [../]
  # [./nucleation]
  #   type = DiscreteNucleation
  #   property_name = Fn
  #   op_names  = temp
  #   op_values = 1e-8
  #   map = map
  #   outputs = exodus
  # [../]
[]

[Preconditioning]
  [./full]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient # Type of executioner, here it is transient with an adaptive time step
  scheme = bdf2 # Type of time integration (2nd order backward euler), defaults to 1st order backward euler

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -mat_mffd_type'
  petsc_options_value = 'hypre    boomeramg      101                ds'

  l_max_its = 20 # Max number of linear iterations
  l_tol = 1e-4 # Relative tolerance for linear solves
  nl_max_its = 10 # Max number of nonlinear iterations
  nl_abs_tol = 1e-9 # Relative tolerance for nonlienar solves
  nl_rel_tol = 1e-8 # Absolute tolerance for nonlienar solves
  line_search = 'none'
  automatic_scaling = true
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1 # Initial time step.  In this simulation it changes.
    optimal_iterations = 6
  [../]

  start_time = 0.0
  end_time = 1e6
  # num_steps = 3
[]

[Postprocessors]
  [./right]
    type = SideAverageValue
    variable = temp
    boundary = right
  [../]
  [nnuc]
    type = DiscreteNucleationData
    inserter = inserter
  []
  [./rate]
    type = DiscreteNucleationData
    value = RATE
    inserter = inserter
  [../]
  [./update]
    type = DiscreteNucleationData
    value = UPDATE
    inserter = inserter
  [../]

  # [./error]
  #   type = NodalL2Error
  #   function = '-3.8e+8/(2*3) * (x^2 - 2*x*0.01) + 600'
  #   variable = temp
  # [../]
[]

[Outputs]
  # execute_on =
  exodus = true
[]
