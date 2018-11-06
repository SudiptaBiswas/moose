[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  xmin = -0.5
  xmax = 0.5
  ymin = -0.5
  ymax = 0.5
[]

[MeshModifiers]
  [./cnode]
    type = AddExtraNodeset
    coord = '0.0 0.0'
    new_boundary = 100
  [../]
[]

[Variables]
  [./u_x]
  [../]
  [./u_y]
  [../]
  [./global_strain]
    order = THIRD
    family = SCALAR
  [../]
  [./c]
    [./InitialCondition]
      type = FunctionIC
      function = 'sin(2*x*pi)*sin(2*y*pi)*0.05+0.6'
    [../]
  [../]
  [./w]
  [../]
[]

[GlobalParams]
  derivative_order = 2
  enable_jit = true
  displacements = 'u_x u_y'
  block = 0
[]

[Kernels]
  [./TensorMechanics]
  [../]
  [./c_dot]
    type = CoupledTimeDerivative
    variable = w
    v = c
  [../]
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
[]

[ScalarKernels]
  [./global_strain]
    type = GlobalStrain
    variable = global_strain
    global_strain_uo = global_strain_uo
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y'
      variable = 'c w u_x u_y'
    [../]
  [../]
  [./centerfix_x]
    type = PresetBC
    boundary = 100
    variable = u_x
    value = 0
  [../]
  [./centerfix_y]
    type = PresetBC
    boundary = 100
    variable = u_y
    value = 0
  [../]
[]

[Materials]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'M   kappa_c'
    prop_values = '0.2 0.01   '
  [../]
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    C_ijkl = '1 1'
    fill_method = symmetric_isotropic
  [../]
  [./strain]
    type = ComputeSmallStrain
    global_strain = global_strain
  [../]
  [./global_strain]
    type = ComputeGlobalStrain
    scalar_global_strain = global_strain
    global_strain_uo = global_strain_uo
  [../]
  [./stress]
    type = ComputeLinearElasticStress
  [../]
  [./chemical_free_energy]
    type = DerivativeParsedMaterial
    function = '4*c^2*(1-c)^2'
    args = 'c'
    outputs = exodus
  [../]
[]

[UserObjects]
  [./global_strain_uo]
    type = GlobalStrainUserObject
    execute_on = 'Initial Linear Nonlinear'
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
  solve_type = 'PJFNK'
  line_search = basic
  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'
  l_max_its = 30
  nl_max_its = 12
  l_tol = 1.0e-4
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1.0e-10
  start_time = 0.0
  end_time = 2.0
[]

[Adaptivity]
 initial_steps = 2
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
[]
