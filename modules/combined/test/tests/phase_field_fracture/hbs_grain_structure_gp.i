[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 280
  ny = 280
  xmax = 2.8
  ymax = 2.8
  elem_type = QUAD4
[]

[GlobalParams]
  op_num = 8
  var_name_base = gr
  int_width = 0.025
  # numbub = 1
  # radius = 0.5
  # bubspac = 2.0
  polycrystal_ic_uo = voronoi
[]

[Variables]
  [./PolycrystalVariables]
  [../]
  # [c]
  # []
  # [./w]
  #   order = FIRST
  #   family = LAGRANGE
  # [../]
[]

[ICs]
  [./PolycrystalICs]
    [./PolycrystalColoringIC]
      polycrystal_ic_uo = voronoi
    [../]
  [../]
  # [PolycrystalICs]
  #   [PolycrystalVoronoiVoidIC]
  #     invalue = 1.0
  #     outvalue = 0.0
  #     rand_seed = 18765
  #   []
  # []
  # [bubble_IC]
  #   variable = c
  #   type = PolycrystalVoronoiVoidIC
  #   structure_type = voids
  #   rand_seed = 18765
  #   invalue = 1.0
  #   outvalue = 0.0
  # []
  [bnds]
    type = BndsCalcIC
    variable = bnds
  []
[]

[AuxVariables]
  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]
  [./unique_grains]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./var_indices]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./active_bounds_elemental]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Modules]
  [./PhaseField]
    [./GrandPotential]
      switching_function_names = 'hb hm'
      anisotropic = 'false false'

      chemical_potentials = 'wv wg'
      mobilities = 'Dchiv Dchig'
      susceptibilities = 'chiv chig'
      free_energies_w = 'rhovbub rhovmatrix rhogbub rhogmatrix'

      # chemical_potentials = 'wg'
      # mobilities = 'Dchig'
      # susceptibilities = 'chig'
      # free_energies_w = 'rhogbub rhogmatrix'

      # gamma_gr = gamma
      gamma_gr = gmm
      mobility_name_gr = L
      kappa_gr = kappa
      free_energies_gr = 'omegab omegam'

      additional_ops = 'etab0'
      gamma_grxop = gmb
      mobility_name_op = L
      kappa_op = kappa
      free_energies_op = 'omegab omegam'
    [../]
  [../]
[]

[AuxKernels]
  [./bnds_aux]
    type = BndsCalcAux
    variable = bnds
    execute_on = timestep_end
  [../]
  [./unique_grains]
    type = FeatureFloodCountAux
    variable = unique_grains
    flood_counter = grain_tracker
    execute_on = 'initial timestep_begin'
    field_display = UNIQUE_REGION
  [../]
  [./var_indices]
    type = FeatureFloodCountAux
    variable = var_indices
    flood_counter = grain_tracker
    execute_on = 'initial timestep_begin'
    field_display = VARIABLE_COLORING
  [../]
  [./active_bounds_elemental]
    type = FeatureFloodCountAux
    variable = active_bounds_elemental
    field_display = ACTIVE_BOUNDS
    execute_on = 'initial timestep_begin'
    flood_counter = grain_tracker
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
  [./Copper]
    type = GBEvolution
    block = 0
    T = 500 # K
    wGB = 0.025 # nm
    GBmob0 = 2.5e-6 #m^4/(Js) from Schoenfelder 1997
    Q = 0.23 #Migration energy in eV
    GBenergy = 0.708 #GB energy in J/m^2
    # time_scale = 1.0e-6
    length_scale = 1.0e-6
    time_scale = 1.0e-6
    outputs = exodus
  [../]
  # [./pfmobility]
  #   type = GenericConstantMaterial
  #   prop_names  = 'M kappa_c'
  #   prop_values = '1.0 0.4'
  # [../]
  #
  # [./free_energy]
  #   # equivalent to `MathFreeEnergy`
  #   type = DerivativeParsedMaterial
  #   f_name = F
  #   args = 'c'
  #   function = '0.25*(1+c)^2*(1-c)^2'
  #   derivative_order = 2
  # [../]
[]

[UserObjects]
  [voronoi]
    type = PolycrystalVoronoi
    rand_seed = 123
    file_name = hbs_fracture_234.txt
  []
  [./grain_tracker]
    type = GrainTracker
    flood_entity_type = elemental
    outputs = none
    compute_var_to_feature_map = true
    execute_on = 'initial timestep_begin'
  [../]
[]

[Preconditioning]
  [./SMP]
   type = SMP
   full = true
  [../]
[]

[Executioner]
  type = Transient
  scheme = 'bdf2'
  solve_type = 'PJFNK'
  line_search = none
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 31'
  automatic_scaling = true
  l_tol = 1.0e-4
  l_max_its = 30
  nl_max_its = 20
  nl_rel_tol = 1.0e-9
  start_time = 0.0
  num_steps = 10
  dt = 1.0
[]

[Outputs]
  exodus = true
  perf_graph = true
[]

[Debug]
  show_var_residual_norms = true
[]
