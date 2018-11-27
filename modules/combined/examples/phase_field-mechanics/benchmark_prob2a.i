[GlobalParams]
  block = 0
  #use_displaced_mesh = true
  outputs = exodus
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
  type = GeneratedMesh
  elem_type = HEX8
  dim = 3
  nx = 10
  ny = 10
  nz = 10
  xmin = 0.0
  xmax = 1.0
  ymin = 0.0
  ymax = 1.0
  zmin = 0.0
  zmax = 1.0
  uniform_refine = 2
[]

[MeshModifiers]
  [./cnode]
    type = AddExtraNodeset
    coord = '0.0 0.0 0.0'
    new_boundary = 6
  [../]
  [./snode]
    type = AddExtraNodeset
    coord = '1.0 0.0 0.0'
    new_boundary = 7
  [../]
[]

[Variables]
  [./c]
  [../]
  [./w]
  [../]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
[]

[AuxVariables]
  [./total_en]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./S11]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./S22]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
    #off_diag_column = 'c w c   c   gr0 gr1 disp_x disp_y'
    #off_diag_row    = 'w c gr0 gr1 c   c   disp_y disp_x'
  [../]
[]

[Kernels]
  [./cres]
    type = SplitCHParsed
    variable = c
    kappa_name = kappa_c
    w = w
    f_name = F
  [../]
  [./wres]
    type = SplitCHWRes
    variable = w
    mob_name = D
  [../]
  [./time]
    type = CoupledTimeDerivative
    variable = w
    v = c
  [../]
  [./TensorMechanics]
  [../]
[]

[AuxKernels]
  [./Total_en]
    type = TotalFreeEnergy
    variable = total_en
    kappa_names = 'kappa_c'
    interfacial_vars = 'c'
  [../]
  [./S11]
    type = RankTwoAux
    variable = S11
    rank_two_tensor = stress
    index_j = 0
    index_i = 0
    block = 0
  [../]
  [./S22]
    type = RankTwoAux
    variable = S22
    rank_two_tensor = stress
    index_j = 1
    index_i = 1
    block = 0
  [../]
[]

[BCs]
  [./bottom3]
    type = PresetBC
    variable = z_disp
    boundary = 0
    value = 0.0
  [../]
  [./top]
    type = FunctionPresetBC
    variable = z_disp
    boundary = 5
    function = load
  [../]
  [./corner1]
    type = PresetBC
    variable = x_disp
    boundary = 6
    value = 0.0
  [../]
  [./corner2]
    type = PresetBC
    variable = y_disp
    boundary = 6
    value = 0.0
  [../]
  [./corner3]
    type = PresetBC
    variable = z_disp
    boundary = 6
    value = 0.0
  [../]

  [./side1]
    type = PresetBC
    variable = y_disp
    boundary = 7
    value = 0.0
  [../]
  [./side2]
    type = PresetBC
    variable = z_disp
    boundary = 7
    value = 0.0
  [../]
[]

[Materials]
  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = S
    args = 'c'
    constant_names = 'h0'
    constant_expressions = '1.4979622423920003'
    function = 'h0*c^2*(c-1)^2'
    derivative_order = 2
    outputs = console
  [../]
  [./constant_mat]
    type = GenericConstantMaterial
    block = 0
    prop_names = 'A B L  kappa_op kappa_c'
    prop_values = '16.0 1.0 10.0 1.0 10.0'
  [../]
  #elastic properties for phase with c =1
  [./elasticity_tensor_phase1]
    type = ComputeElasticityTensor
    base_name = phase1
    block = 0
    fill_method = symmetric_isotropic
    C_ijkl = '30.141 35.46'
  [../]
  [./smallstrain_phase1]
    type = ComputeSmallStrain
    base_name = phase1
    block = 0
    displacements = 'disp_x disp_y'
  [../]
  [./stress_phase1]
    type = ComputeLinearElasticStress
    base_name = phase1
    block = 0
  [../]
  [./elstc_en_phase1]
    type = ElasticEnergyMaterial
    base_name = phase1
    f_name = Fe1
    block = 0
    args = 'c'
    derivative_order = 2
  [../]
  #elastic properties for phase with c = 0
  [./elasticity_tensor_phase0]
    type = ComputeElasticityTensor
    base_name = phase0
    block = 0
    fill_method = symmetric_isotropic
    C_ijkl = '2.0 2.0'
  [../]
  [./smallstrain_phase0]
    type = ComputeSmallStrain
    base_name = phase0
    block = 0
    displacements = 'disp_x disp_y'
  [../]
  [./stress_phase0]
    type = ComputeLinearElasticStress
    base_name = phase0
    block = 0
  [../]
  [./elstc_en_phase0]
    type = ElasticEnergyMaterial
    base_name = phase0
    f_name = Fe0
    block = 0
    args = 'c'
    derivative_order = 2
  [../]
  #switching function for elastic energy calculation
  [./switching]
    type = SwitchingFunctionMaterial
    block = 0
    function_name = h
    eta = c
    h_order = SIMPLE
  [../]
  # total elastic energy calculation
  [./total_elastc_en]
    type = DerivativeTwoPhaseMaterial
    block = 0
    h = h
    g = 0.0
    W = 0.0
    eta = c
    f_name = E
    fa_name = Fe1
    fb_name = Fe0
    derivative_order = 2
  [../]
  # gloabal Stress
  [./global_stress]
    type = TwoPhaseStressMaterial
    block = 0
    base_A = phase1
    base_B = phase0
    h = h
  [../]
  # total energy
  [./sum]
    type = DerivativeSumMaterial
    block = 0
    sum_materials = 'S E'
    args = 'c gr0 gr1'
    derivative_order = 2
  [../]
[]

[Postprocessors]
  [./mat_D]
    type = ElementIntegralMaterialProperty
    mat_prop = D
  [../]
  [./elem_c]
    type = ElementIntegralVariablePostprocessor
    variable = c
    use_displaced_mesh = false
  [../]
  [./elem_bnds]
    type = ElementIntegralVariablePostprocessor
    variable = bnds
    use_displaced_mesh = false
  [../]
  [./s11]
    type = ElementIntegralVariablePostprocessor
    variable = S11
  [../]
  [./s22]
    type = ElementIntegralVariablePostprocessor
    variable = S22
  [../]
  [./total_energy]
    type = ElementIntegralVariablePostprocessor
    variable = total_en
  [../]
  [./free_en]
    type = ElementIntegralMaterialProperty
    mat_prop = F
  [../]
  [./chem_free_en]
    type = ElementIntegralMaterialProperty
    mat_prop = S
  [../]
  [./elstc_en0]
    type = ElementIntegralMaterialProperty
    mat_prop = Fe0
  [../]
  [./elstc_en1]
    type = ElementIntegralMaterialProperty
    mat_prop = Fe1
  [../]
[]

[VectorPostprocessors]
  [./neck]
    type = LineValueSampler
    variable = 'c bnds'
    start_point = '20.0 0.0 0.0'
    end_point = '20.0 20.0 0.0'
    sort_by = id
    num_points = 40
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  scheme = BDF2
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   ilu      1'
  l_max_its = 20
  nl_max_its = 20
  l_tol = 1.0e-3
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-10
  end_time = 100
  dt = 0.005
  [./Adaptivity]
    refine_fraction = 0.7
    coarsen_fraction = 0.1
    max_h_level = 2
    initial_adaptivity = 1
  [../]
  #[./TimeStepper]
  #  type = IterationAdaptiveDT
  #  dt = 0.01
  #  growth_factor = 1.5
  #[../]
[]

[Outputs]
  exodus = true
  output_on = 'initial timestep_end'
  print_linear_residuals = true
  csv = true
  gnuplot = true
  interval = 100
  [./console]
    type = Console
    perf_log = true
    output_on = 'initial timestep_end failed nonlinear linear'
  [../]
[]

[ICs]
  [./ic_gr1]
    int_width = 2.0
    x1 = 25.0
    y1 = 10.0
    radius = 7.0
    outvalue = 0.0
    variable = gr1
    invalue = 1.0
    type = SmoothCircleIC
  [../]
  [./multip]
    x_positions = '10.0 25.0'
    int_width = 2.0
    z_positions = '0 0'
    y_positions = '10.0 10.0 '
    radii = '7.0 7.0'
    3D_spheres = false
    outvalue = 0.001
    variable = c
    invalue = 0.999
    type = SpecifiedSmoothCircleIC
    block = 0
  [../]
  [./ic_gr0]
    int_width = 2.0
    x1 = 10.0
    y1 = 10.0
    radius = 7.0
    outvalue = 0.0
    variable = gr0
    invalue = 1.0
    type = SmoothCircleIC
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]
