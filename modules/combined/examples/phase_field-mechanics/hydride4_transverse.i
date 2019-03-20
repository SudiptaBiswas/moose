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
  ny = 100
  nz = 0
  xmin = -10
  xmax = 10
  ymin = -25
  ymax = 25
  zmin = 0
  zmax = 0
  elem_type = QUAD4
  uniform_refine = 1
[]

[MeshModifiers]
  [./cnode]
    type = AddExtraNodeset
    coord = '0 0'
    new_boundary = 100
  [../]
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
  block = 0
[]

[Variables]
  [./eta]
  [../]
  # [./c]
  # [../]
  [./w]
  [../]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  # [./global_strain]
  #   order = THIRD
  #   family = SCALAR
  # [../]
[]

[ICs]
  [./eta]
    type = MultiSmoothSuperellipsoidIC
    variable = eta
    invalue = 1.0
    outvalue = 0.1
    bubspac = '4 4'
    numbub = '10 15'
    semiaxis_b_variation = '0.2 0.2'
    semiaxis_variation_type = uniform
    semiaxis_a_variation = '0.1 0.05'
    semiaxis_a = '3 4'
    semiaxis_b = '1 1'
    exponent = '2 2'
    prevent_overlap = true
    semiaxis_c_variation = '0 0'
    semiaxis_c = '1 1'
    rand_seed = 558
  [../]
  # [./eta]
  #   type = SmoothCircleIC
  #   variable = eta
  #   invalue = 1.0
  #   outvalue = 0.1
  #   x1 = 0.0
  #   y1 = 0.0
  #   radius = 3.0
  #   int_width = 0.2
  # [../]
[]

[Modules]
  [./TensorMechanics]
    [./Master]
      [./stress_div]
        strain = SMALL
        add_variables = true
        eigenstrain_names = 'eigenstrain_ppt'
        # global_strain = global_strain #global strain contribution

        generate_output = 'strain_xx strain_xy strain_yy stress_xx stress_xy
                           stress_yy vonmises_stress'
      [../]
    [../]
#     # [./GlobalStrain]
#     #   [./global_strain]
#     #     scalar_global_strain = global_strain
#     #     displacements = 'u_x u_y u_z'
#     #     auxiliary_displacements = 'disp_x disp_y disp_z'
#     #   [../]
#     # [../]
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y'
      variable = 'eta disp_x disp_y'
    [../]
  [../]

  # fix center point location
  [./centerfix_x]
    type = PresetBC
    boundary = 100
    variable = disp_x
    value = 0
  [../]
  [./fix_y]
    type = PresetBC
    boundary = 100
    variable = disp_y
    value = 0
  [../]
[]

[Kernels]
  # [./eta_bulk]
  #   type = AllenCahn
  #   variable = eta
  #   f_name = F
  # [../]
  # [./eta_interface]
  #   type = ACInterface
  #   variable = eta
  #   kappa_name = kappa_op
  # [../]
  # [./time]
  #   type = TimeDerivative
  #   variable = eta
  # [../]
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
  # [./TensorMechanics]
  # [../]
[]

[AuxVariables]
  [./total_en]
    order = CONSTANT
    family = MONOMIAL
  [../]
  # [./S11]
  #   order = CONSTANT
  #   family = MONOMIAL
  # [../]
  # [./S22]
  #   order = CONSTANT
  #   family = MONOMIAL
  # [../]
[]

[AuxKernels]
  [./Total_en]
    type = TotalFreeEnergy
    variable = total_en
    kappa_names = 'kappa_op'
    interfacial_vars = 'eta'
  [../]
  # [./S11]
  #   type = RankTwoAux
  #   variable = S11
  #   rank_two_tensor = stress
  #   index_j = 0
  #   index_i = 0
  #   block = 0
  # [../]
  # [./S22]
  #   type = RankTwoAux
  #   variable = S22
  #   rank_two_tensor = stress
  #   index_j = 1
  #   index_i = 1
  #   block = 0
  # [../]
[]

[Materials]
  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = S
    args = 'eta'
    constant_names = 'h0'
    constant_expressions = '1.5'
    function = 'h0*eta^2*(eta-1)^2'
    derivative_order = 2
    outputs = console
  [../]
  [./constant_mat]
    type = GenericConstantMaterial
    prop_names = 'L    kappa_op'
    prop_values = '0.5 0.02 '
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
  # [./strain]
  #   type = ComputeSmallStrain
  #   eigenstrain_names = 'eigenstrain_ppt'
  # [../]
  [./eigen_strain]
    type = ComputeVariableEigenstrain
    eigen_base = '0.005 0.005 0.0 0 0 0'
    # base_name = phase1
    prefactor = h
    args = eta
    eigenstrain_name = 'eigenstrain_ppt'
  [../]

  # [./smallstrain_phase1]
  #   type = ComputeSmallStrain
  #   # eigenstrain_names = 'eigenstrain_ppt'
  #   base_name = phase1
  # [../]
  # [./stress_phase1]
  #   type = ComputeLinearElasticStress
  #   base_name = phase1
  #   block = 0
  # [../]
  # [./elstc_en_phase1]
  #   type = ElasticEnergyMaterial
  #   base_name = phase1
  #   f_name = Fe1
  #   args = 'eta'
  #   derivative_order = 2
  # [../]
  #
  # [./smallstrain_phase0]
  #   type = ComputeSmallStrain
  #   base_name = phase0
  #   # eigenstrain_names = 'eigenstrain_ppt'
  # [../]
  # [./stress_phase0]
  #   type = ComputeLinearElasticStress
  #   base_name = phase0
  # [../]
  # [./elstc_en_phase0]
  #   type = ElasticEnergyMaterial
  #   base_name = phase0
  #   f_name = Fe0
  #   args = 'eta'
  #   derivative_order = 2
  # [../]

  [./elstc_en]
    type = ElasticEnergyMaterial
    f_name = E
    args = 'eta'
    derivative_order = 2
  [../]

  # [./total_elastc_en]
  #   type = DerivativeTwoPhaseMaterial
  #   block = 0
  #   h = h
  #   g = 0.0
  #   W = 0.0
  #   eta = eta
  #   f_name = E
  #   fa_name = Fe1
  #   fb_name = Fe0
  #   derivative_order = 2
  # [../]
  #
  # [./global_stress]
  #   type = TwoPhaseStressMaterial
  #   block = 0
  #   base_A = phase1
  #   base_B = phase0
  #   h = h
  # [../]

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
  [./hydride]
    type = Porosity
    variable = eta
    execute_on = 'initial timestep_end'
    cutoff = 0.5
  [../]
[]

[Preconditioning]
  # active = ' '
  [./SMP]
    type = SMP
    # full = true
    coupled_groups = 'eta,w eta,disp_x,disp_y'
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
  end_time = 1.0
  dt = 0.005

  [./TimeStepper]
   type = IterationAdaptiveDT
   dt = 0.01
   growth_factor = 1.5
  [../]
[]

[Adaptivity]
 initial_steps = 2
 max_h_level = 2
 marker = EFM
[./Markers]
   [./EFM]
     type = ErrorFractionMarker
     coarsen = 0.2
     refine = 0.9
     indicator = GJI
   [../]
 [../]
 [./Indicators]
   [./GJI]
     type = GradientJumpIndicator
     variable = eta
    [../]
 [../]
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
  # file_base = eigen_effect_hydride5
[]

[Debug]
  show_var_residual_norms = true
[]
