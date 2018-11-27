#
# Example 2
# Phase change driven by a mechanical (elastic) driving force.
# An oversized phase inclusion grows under a uniaxial tensile stress.
# Check the file below for comments and suggestions for parameter modifications.
#

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 40
  ny = 40
  nz = 0
  xmin = -20
  xmax = 20
  ymin = -20
  ymax = 20
  zmin = 0
  zmax = 0
  elem_type = QUAD4
  uniform_refine = 2
[]

[MeshModifiers]
  [./cnode]
    type = AddExtraNodeset
    coord = '0 0'
    new_boundary = 100
  [../]
[]

[GlobalParams]
  displacements = 'u_x u_y'
  block = 0
[]

[Variables]
  [./eta]
  [../]
  [./w]
  [../]
  [./global_strain]
    order = THIRD
    family = SCALAR
  [../]
[]

[ICs]
  # [./eta]
  #   type = MultiSmoothSuperellipsoidIC
  #   variable = eta
  #   invalue = 1.0
  #   outvalue = 0.1
  #   bubspac = '5 5'
  #   numbub = '6 5'
  #   semiaxis_b_variation = '0.2 0.2'
  #   semiaxis_variation_type = uniform
  #   semiaxis_a_variation = '0.1 0.05'
  #   semiaxis_a = '1 1'
  #   semiaxis_b = '3 4'
  #   exponent = '2 2'
  #   prevent_overlap = true
  #   semiaxis_c_variation = '0 0'
  #   semiaxis_c = '1 1'
  #   rand_seed = 0
  # [../]
  [./eta]
    type = SmoothCircleIC
    variable = eta
    invalue = 1.0
    outvalue = 0.1
    x1 = 0.0
    y1 = 0.0
    radius = 3.0
    int_width = 0.2
  [../]
[]

[Modules]
  [./TensorMechanics]
    [./Master]
      [./stress_div]
        strain = SMALL
        add_variables = true
        eigenstrain_names = 'eigenstrain_ppt'
        global_strain = global_strain #global strain contribution
        generate_output = 'strain_xx strain_xy strain_yy stress_xx stress_xy
                           stress_yy vonmises_stress'
      [../]
    [../]
    [./GlobalStrain]
      [./global_strain]
        scalar_global_strain = global_strain
        displacements = 'u_x u_y'
        auxiliary_displacements = 'disp_x disp_y'
      [../]
    [../]
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y'
      variable = 'eta u_x u_y'
    [../]
  [../]

  # fix center point location
  [./centerfix_x]
    type = PresetBC
    boundary = 100
    variable = u_x
    value = 0
  [../]
  [./fix_y]
    type = PresetBC
    boundary = 100
    variable = u_y
    value = 0
  [../]
[]

[Kernels]
  [./cres]
    type = SplitCHParsed
    variable = eta
    kappa_name = kappa_op
    w = w
    f_name = F
  [../]
  [./wres]
    type = SplitCHWRes
    variable = w
    mob_name = L
  [../]
  [./time]
    type = CoupledTimeDerivative
    variable = w
    v = eta
  [../]
[]

[AuxVariables]
  [./total_en]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./Total_en]
    type = TotalFreeEnergy
    variable = total_en
    kappa_names = 'kappa_op'
    interfacial_vars = 'eta'
  [../]
[]

[Materials]
  # [./free_energy]
  #   type = DerivativeParsedMaterial
  #   f_name = S
  #   args = 'eta'
  #   constant_names = 'h0'
  #   constant_expressions = '1.5'
  #   function = 'h0*eta^2*(eta-1)^2'
  #   derivative_order = 2
  #   outputs = console
  # [../]
  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = S
    args = 'eta'
    constant_names = '       w   a2            a3           a4           a5            a6            a7           a8           a9            a10 '
    constant_expressions = ' 0.1 8.072789087  -81.24549382  408.0297321  -1244.129167  2444.046270  -3120.635139  2506.663551  -1151.003178  230.2006355'
    function = 'w*(a2*eta^2+a3*eta^3+a4*eta^4+a5*eta^5+a6*eta^6+a7*eta^7+a8*eta^8+a9*eta^9+a10*eta^10)'
    derivative_order = 2
    outputs = console
  [../]
  [./constant_mat]
    type = GenericConstantMaterial
    prop_names = 'L    kappa_op'
    prop_values = '5   0.3 '
  [../]

  [./h_eta]
    type = SwitchingFunctionMaterial
    h_order = HIGH
    eta = eta
  [../]

  # 1- h(eta), putting in function explicitly
  [./one_minus_h_eta_explicit]
    type = DerivativeParsedMaterial
    f_name = one_minus_h_explicit
    args = eta
    function = 1-eta^3*(6*eta^2-15*eta+10)
    outputs = exodus
  [../]

  #elastic properties for phase with c =1
  [./elasticity_tensor_phase1]
    type = ComputeElasticityTensor
    base_name = C_matrix
    # base_name = phase0
    fill_method = symmetric_isotropic_E_nu
    C_ijkl = '75.0 0.3'
  [../]
  #elastic properties for phase with c = 0
  [./elasticity_tensor_phase0]
    type = ComputeElasticityTensor
    base_name = C_ppt
    # base_name = phase1
    fill_method = symmetric_isotropic_E_nu
    C_ijkl = '140.0 0.27'
  [../]

  [./C]
    type = CompositeElasticityTensor
    args = eta
    tensors = 'C_matrix               C_ppt'
    weights = 'one_minus_h_explicit   h'
  [../]
  [./stress]
    type = ComputeLinearElasticStress
  [../]

  [./eigen_strain]
    type = ComputeVariableEigenstrain
    eigen_base = '0.001 0.005 0.0 0 0 0'
    # base_name = phase1
    prefactor = h
    args = eta
    eigenstrain_name = 'eigenstrain_ppt'
  [../]

  [./elstc_en]
    type = ElasticEnergyMaterial
    f_name = E
    args = 'eta'
    derivative_order = 2
  [../]

  # total energy
  [./sum]
    type = DerivativeSumMaterial
    sum_materials = 'S E'
    args = 'eta'
    derivative_order = 2
  [../]
[]

[Postprocessors]
  [./elem_c]
    type = ElementIntegralVariablePostprocessor
    variable = eta
    use_displaced_mesh = false
  [../]
  [./s11]
    type = ElementIntegralVariablePostprocessor
    variable = stress_xx
  [../]
  [./s22]
    type = ElementIntegralVariablePostprocessor
    variable = stress_yy
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
  [./elstc_en]
    type = ElementIntegralMaterialProperty
    mat_prop = E
  [../]
[]

[Preconditioning]
  # active = ' '
  [./SMP]
    type = SMP
    full = true
    # coupled_groups = 'eta,w eta,disp_x,disp_y'
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  scheme = BDF2
  solve_type = NEWTON
  # line_search = basic
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'
  l_max_its = 20
  nl_max_its = 20
  l_tol = 1.0e-3
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-10
  end_time = 100
  dt = 0.005

  [./TimeStepper]
   type = IterationAdaptiveDT
   dt = 0.01
   growth_factor = 1.5
  [../]
[]

# [Adaptivity]
#  initial_steps = 2
#  max_h_level = 2
#  marker = EFM
# [./Markers]
#    [./EFM]
#      type = ErrorFractionMarker
#      coarsen = 0.2
#      refine = 0.8
#      indicator = GJI
#    [../]
#  [../]
#  [./Indicators]
#    [./GJI]
#      type = GradientJumpIndicator
#      variable = eta
#     [../]
#  [../]
# []

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
  file_base = benchmark_global
[]

[Debug]
  show_var_residual_norms = true
[]
