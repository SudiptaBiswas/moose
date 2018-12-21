#
# Example 1
# Illustrating the coupling between chemical and mechanical (elastic) driving forces.
# An oversized precipitate deforms under a uniaxial compressive stress
# Check the file below for comments and suggestions for parameter modifications.
#

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 10
  ny = 10
  nz = 10
  xmin = -10
  xmax = 10
  ymin = -10
  ymax = 10
  zmin = -10
  zmax = 10
  # elem_type = HEX8
  uniform_refine = 2
[]

[MeshModifiers]
  [./cnode]
    type = AddExtraNodeset
    coord = '0 0 0'
    new_boundary = 100
  [../]
  [./cnode2]
    type = AddExtraNodeset
    coord = '-10.0 0.0 0.0'
    new_boundary = 101
  [../]
  [./cnode3]
    type = AddExtraNodeset
    coord = '0.0 0.0 -10.0'
    new_boundary = 102
  [../]
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  block = 0
[]

[AuxVariables]
  [./local_energy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./local_energy]
    type = TotalFreeEnergy
    variable = local_energy
    f_name = F
    interfacial_vars = c
    kappa_names = kappa_c
    execute_on = timestep_end
  [../]
[]

[Variables]
  [./c]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      type = RandomIC
      min = 0.4
      max = 0.6
      # seed = 1235
    [../]
  [../]
  [./w]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Modules]
  [./TensorMechanics]
    [./Master]
      [./stress_div]
        strain = SMALL
        add_variables = true
        eigenstrain_names = 'eigenstrain'
        generate_output = 'strain_xx strain_xy strain_yy stress_xx stress_xy
                           stress_yy vonmises_stress'
      [../]
    [../]
  [../]
[]

[Kernels]
  [./c_res]
    type = SplitCHParsed
    variable = c
    f_name = F
    kappa_name = kappa_c
    w = w
  [../]
  [./w_res]
    type = SplitCHWRes
    variable = w
    mob_name = M
  [../]
  [./time]
    type = CoupledTimeDerivative
    variable = w
    v = c
  [../]
[]

[Materials]
  [./pfmobility]
    type = GenericConstantMaterial
    prop_names  = 'M kappa_c'
    prop_values = '1.0 1.0  '
    block = 0
  [../]

  # simple chemical free energy with a miscibility gap
  [./chemical_free_energy]
    type = DerivativeParsedMaterial
    block = 0
    f_name = Fc
    args = 'c'
    function = 2.5*c^4-5*c^3+2.75*c^2-0.25*c
    enable_jit = true
    derivative_order = 2
    outputs = exodus
  [../]

  # [./h_eta]
  #   type = DerivativeParsedMaterial
  #   f_name = h
  #   function = (c-0.5)
  #   args = 'c'
  # [../]

  [./h_c]
    type = SwitchingFunctionMaterial
    h_order = SIMPLE
    eta = c
  [../]
  [./one_minus_h]
    type = DerivativeParsedMaterial
    f_name = one_minus_h
    args = c
    material_property_names = 'h'
    function = (1.0-h)
    outputs = exodus
  [../]
  [./elasticity_tensor0]
    type = ComputeElasticityTensor
    block = 0
    base_name = phase0
    C_ijkl = '112.4 67.2 67.2 112.4 67.2 112.4 56.9 56.9 56.9'
    fill_method = symmetric9
  [../]
  [./elasticity_tensor1]
    type = ComputeElasticityTensor
    block = 0
    base_name = phase1
    C_ijkl = '196.6 123.2 123.2 196.6 123.2 196.6 100.9 100.9 100.9'
    fill_method = symmetric9
  [../]

  [./C]
    type = CompositeElasticityTensor
    args = c
    tensors = 'phase0        phase1'
    weights = 'one_minus_h   h'
  [../]
  [./stress]
    type = ComputeLinearElasticStress
    block = 0
  [../]
  # [./var_dependence]
  #   type = DerivativeParsedMaterial
  #   block = 0
  #   function = 0.1*c
  #   args = c
  #   f_name = var_dep
  #   enable_jit = true
  #   derivative_order = 2
  # [../]
  [./eigenstrain]
    type = ComputeVariableEigenstrain
    block = 0
    eigen_base = '0.005 0.005 0.005 0 0 0.0'
    prefactor = h
    outputs = exodus
    args = 'c'
    eigenstrain_name = eigenstrain
  [../]

  # [./eigenstrain]
  #   type = CompositeEigenstrain
  #   tensors = 'shear1  shear2  expand3'
  #   weights = 'weight1 weight2 weight3'
  #   args = c
  #   eigenstrain_name = eigenstrain
  # [../]

  [./elastic_free_energy]
    type = ElasticEnergyMaterial
    f_name = Fe
    block = 0
    args = 'c'
    derivative_order = 2
    outputs = exodus
  [../]

  # Sum up chemical and elastic contributions
  [./free_energy]
    type = DerivativeSumMaterial
    block = 0
    f_name = F
    sum_materials = 'Fc Fe'
    args = 'c'
    derivative_order = 2
    outputs = exodus
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y z'
      variable = 'c w disp_x disp_y disp_z'
    [../]
  [../]
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
  [./centerfix_z]
    type = PresetBC
    boundary = 100
    variable = disp_z
    value = 0
  [../]
  # [./appl_y]
  #   type = PresetBC
  #   boundary = top
  #   variable = disp_y
  #   value = 0.033
  # [../]
  # [./fix_x]
  #   type = PresetBC
  #   boundary = 102
  #   variable = disp_x
  #   value = 0
  # [../]
  # [./fix_zz]
  #   type = PresetBC
  #   boundary = 101
  #   variable = disp_y
  #   value = 0
  # [../]
[]

[Postprocessors]
  [./top]
    type = SideIntegralVariablePostprocessor
    variable = c
    boundary = top
  [../]
  [./total_free_energy]
    type = ElementIntegralVariablePostprocessor
    variable = local_energy
  [../]
  [./c_total]
    type = ElementIntegralVariablePostprocessor
    variable = c
  [../]
[]

[Preconditioning]
  # active = ' '
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  scheme = bdf2

  solve_type = 'PJFNK'
  # petsc_options_iname = '-pc_type  -sub_pc_type '
  # petsc_options_value = 'asm       lu'

  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly      ilu      1'

  l_max_its = 30
  nl_max_its = 10
  l_tol = 1.0e-4
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1.0e-10
  start_time = 0.0
  # dt = 0.1
  end_time = 4000.0
  # num_steps = 50
  [./TimeStepper]
   type = IterationAdaptiveDT
   dt = 0.01
   growth_factor = 1.5
  [../]
[]

[Adaptivity]
 initial_steps = 3
 max_h_level = 2
 marker = EFM
[./Markers]
   [./EFM]
     type = ErrorFractionMarker
     coarsen = 0.2
     refine = 0.8
     indicator = GJI
   [../]
 [../]
 [./Indicators]
   [./GJI]
     type = GradientJumpIndicator
     variable = c
    [../]
 [../]
[]

[Outputs]
  exodus = true
  # file_base = VoidGrowth_elasticity_undersize_global
[]

[Debug]
  show_var_residual_norms = true
[]
