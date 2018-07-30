#This is an input file for Benchmark II problem set, dendritic growth.

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  xmin = -500
  xmax = 500
  ymin = -500
  ymax = 500

  elem_type = QUAD4
[]

#[GlobalParams]
#[]

[Variables]
  #phase field variable
  [./w]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      type = SmoothCircleIC
      invalue = 1
      outvalue = -1
      radius = 8
      int_width = 1
      x1 = 0
      y1 = 0
    [../]
  [../]

  #nondimensional temperature
  [./T]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      type = ConstantIC
      value = -0.3
    [../]
  [../]
[]

[AuxVariables]
  [./bulk_energy]
    order = CONSTANT
    family = MONOMIAL
  [../]

[./gradient_energy]
    order = CONSTANT
    family = MONOMIAL
  [../]

[./total_energy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  [./dndt]
    type = TimeDerivative
    variable = w
  [../]
  [./anisoACinterface1]
    type = ACInterfaceKobayashi1
    variable = w
    mob_name = M
  [../]
  [./anisoACinterface2]
    type = ACInterfaceKobayashi2
    variable = w
    mob_name = M
  [../]
  [./AllenCahn]
    type = AllenCahn
    variable = w
    mob_name = M
    f_name = fbulk
    args = T
  [../]
  # [./bulk_energy]
  #   type = SolidificationBulk
  #   variable = n
  # [../]
  #
  # [./int_energy_1]
  #   type = SolidificationInterface1
  #   variable = n
  # [../]
  #
  # [./int_energy_2]
  #   type = SolidificationInterface2
  #   variable = n
  # [../]

  [./dudt]
    type = TimeDerivative
    variable = T
  [../]

  # [./diffusion]
  #   type = SolidificationDiffusion
  #   variable = u
  # [../]
  #
  # [./source_term]
  #   type = SolidificationSourceTerm
  #   variable = u
  #   v = n
  # [../]
  [./CoefDiffusion]
    type = CoefDiffusion
    variable = T
    coef = 10.0
  [../]
  [./w_dot_T]
    type = CoefCoupledTimeDerivative
    variable = T
    v = w
    coef = -0.5
  [../]
[]

[AuxKernels]
  [./total_energy_calc]
      type = TotalFreeEnergy
      variable = total_energy
      kappa_names = 'eps'
      interfacial_vars = 'w'
      f_name = fbulk
  [../]

  # [./bulk_energy_calc]
  #     type = BulkEnergy
  #     variable = bulk_energy
  # [../]
  #
  # [./gradient_energy_calc]
  #     type = GradientEnergy
  #     variable = gradient_energy
  # [../]
[]

[Materials]
  # [./system]
  #   type = SolidificationMaterial
  #
  #   Tm = 0 #this needs to be defined in the benchmark problem for completeness
  #   Cp = 1 #this needs to be defined in the benchmark problem for completeness
  #   latent_heat = 1 #this needs to be defined in the benchmark problem for completeness
  #
  #   theta_0 = 0 #0.7853975
  #   m = 4
  #   epsilon = 0.05
  #   tau_0 = 1
  #   D = 10
  #   W_0 = 1
  #
  #   temperature = u
  #   order_parameter = n
  # [../]
  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = fbulk
    args = 'w T'
    constant_names = 'lambda pi'
    constant_expressions = '10/0.6267 4*atan(1)'
    function = '-1/2*w^2 + 1/4*w^4 + lambda * T * w * (1 - 2/3*w^2 + 0.2*w^4)'
    # function = '1/4*w^4 - 1/2*w^2 + 16 * T * (w - 2/3 * w^3 + 1/5 * w^5)'
    derivative_order = 2
    outputs = exodus
  [../]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'M       kappa_op    L'
    prop_values = '1.0 0.0001       3.333'
    outputs = exodus
  [../]
  [./material]
    type = InterfaceOrientationMaterial
    op = w
    anisotropy_strength = 0.05
    eps_bar = 1.0
    mode_number = 4
    # orientation = 'eta0 eta1'
    reference_angle = 0
    outputs = exodus
  [../]
[]

[BCs]
#  [./temp_bc]
#    type = DirichletBC
#    value = -0.3
#    variable = u
#    boundary = '0 1 2 3'
#  [../]
[]

[Postprocessors]
  [./numDOFs]
    type = NumDOFs
  [../]
  [./TotalEnergy]
    type = ElementIntegralVariablePostprocessor
    variable = total_energy
  [../]
  [./dt]
    type = TimestepSize
  [../]
  [./NL_iter]
    type = NumNonlinearIterations
  [../]
  [./Volume]
    type = VolumePostprocessor
    execute_on = initial
  [../]
  [./feature_counter]
    type = FeatureFloodCount
    variable = w
    threshold = 0
    compute_var_to_feature_map = true
    use_displaced_mesh = false
    execute_on = timestep_end
  [../]
  [./VolumeFraction]
    type = FeatureVolumeFraction
    mesh_volume = Volume
    feature_volumes = feature_volumes
    use_displaced_mesh = false
    execute_on = timestep_end
  [../]
[]

[VectorPostprocessors]
  [./feature_volumes]
    type = FeatureVolumeVectorPostprocessor
    flood_counter = feature_counter
    outputs = none
    execute_on = timestep_end
  [../]
[]

[Adaptivity]
  initial_steps = 5
  max_h_level = 5
  initial_marker = EFM_1
  marker = combo
 [./Markers]
    [./EFM_1]
      type = ErrorFractionMarker
      coarsen = 0.02
      refine = 0.75
      indicator = GJI_1
    [../]
    [./EFM_2]
      type = ErrorFractionMarker
      coarsen = 0.02
      refine = 0.75
      indicator = GJI_2
    [../]
    [./combo]
      type = ComboMarker
      markers = 'EFM_1 EFM_2'
    [../]
  [../]

  [./Indicators]
    [./GJI_1]
     type = GradientJumpIndicator
     variable = w
    [../]
   [./GJI_2]
     type = GradientJumpIndicator
     variable = T
    [../]
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
  scheme = bdf2
  end_time = 1000
  dtmin = 0.003
  dtmax = 0.3

  solve_type = 'PJFNK'
  # petsc_options_iname = '-pc_type -sub_pc_type -sub_ksp_type -pc_asm_overlap -pc_factor_levels -sub_pc_factor_levels'
  # petsc_options_value = ' asm      ilu           preonly       1    10'
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre    boomeramg      31'

  timestep_tolerance = 1e-5
  l_max_its = 100
  nl_max_its = 10
  nl_abs_tol = 1e-10
  # nl_rel_tol = 1e-08
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.003
    cutback_factor = 0.95
    growth_factor = 1.05
    optimal_iterations = 4
    iteration_window = 0
    linear_iteration_ratio = 100
  [../]
[]

[Outputs]
  exodus = true
  # interval = 50
  csv = true
  file_base = solidification_test

  checkpoint = true
  sync_times = '15 75 150 300 600 900 1000'

[./console]
    type = Console
    perf_log = true
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]
