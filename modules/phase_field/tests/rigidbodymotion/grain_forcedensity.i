# test file for showing reaction forces between particles
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 25
  ny = 10
  nz = 0
  xmax = 50
  ymax = 25
  zmax = 0
  elem_type = QUAD4
[]

[Variables]
  [./c]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      type = SpecifiedSmoothCircleIC
      invalue = 1.0
      outvalue = 0.1
      int_width = 6.0
      x_positions = '20.0 30.0 '
      z_positions = '0.0 0.0 '
      y_positions = '0.0 25.0 '
      radii = '14.0 14.0'
      3D_spheres = false
      variable = c
      block = 0
    [../]
  [../]
  [./w]
    order = FIRST
    family = LAGRANGE
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
    block = 0
    prop_names = 'M    kappa_c  kappa_eta'
    prop_values = '1.0  2.0      0.1'
  [../]
  [./free_energy]
    type = DerivativeParsedMaterial
    block = 0
    f_name = F
    args = c
    constant_names = 'barr_height  cv_eq'
    constant_expressions = '0.1          1.0e-2'
    function = 16*barr_height*(c-cv_eq)^2*(1-cv_eq-c)^2
    derivative_order = 2
  [../]
  [./force_density]
    type = ForceDensityMaterial
    block = 0
    c = c
    etas ='eta0 eta1'
  [../]
  [./advection_vel]
    type = GrainAdvectionVelocity
    block = 0
    grain_force = grain_force
    etas = 'eta0 eta1'
    c = c
    grain_data = grain_center
  [../]
[]

[AuxVariables]
  [./eta0]
  [../]
  [./eta1]
  [../]
  [./bnds]
  [../]
  [./df00]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./df01]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./df10]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./df11]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./vadv00]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./vadv01]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./vadv10]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./vadv11]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./vadv0_div]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./vadv1_div]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    var_name_base = eta
    op_num = 2.0
    v = 'eta0 eta1'
    block = 0
  [../]
  [./df01]
    type = MaterialStdVectorRealGradientAux
    variable = df01
    index = 0
    component = 1
    property = force_density
  [../]
  [./df11]
    type = MaterialStdVectorRealGradientAux
    variable = df11
    index = 1
    component = 1
    property = force_density
  [../]
  [./df00]
    type = MaterialStdVectorRealGradientAux
    variable = df00
    index = 0
    component = 0
    property = force_density
  [../]
  [./df10]
    type = MaterialStdVectorRealGradientAux
    variable = df10
    index = 1
    component = 0
    property = force_density
  [../]
  [./vadv00]
    type = MaterialStdVectorRealGradientAux
    variable = vadv00
    property = advection_velocity
  [../]
  [./vadv01]
    type = MaterialStdVectorRealGradientAux
    variable = vadv01
    property = advection_velocity
    component = 1
  [../]
  [./vadv10]
    type = MaterialStdVectorRealGradientAux
    variable = vadv10
    index = 1
    property = advection_velocity
  [../]
  [./vadv11]
    type = MaterialStdVectorRealGradientAux
    variable = vadv11
    property = advection_velocity
    index = 1
    component = 1
  [../]
  [./vadv0_div]
    type = MaterialStdVectorAux
    variable = vadv0_div
    property = advection_velocity_divergence
  [../]
  [./vadv1_div]
    type = MaterialStdVectorAux
    variable = vadv1_div
    property = advection_velocity_divergence
    index = 1
  [../]
[]

[ICs]
  [./ic_eta0]
    int_width = 6.0
    x1 = 20.0
    y1 = 0.0
    radius = 14.0
    outvalue = 0.0
    variable = eta0
    invalue = 1.0
    type = SmoothCircleIC
  [../]
  [./IC_eta1]
    int_width = 6.0
    x1 = 30.0
    y1 = 25.0
    radius = 14.0
    outvalue = 0.0
    variable = eta1
    invalue = 1.0
    type = SmoothCircleIC
  [../]
[]
[Postprocessors]
  [./NumDOFs]
    type = NumDOFs
    execute_on = 'initial timestep_begin'
  [../]
[]

[VectorPostprocessors]
  [./centers]
    type = GrainCentersPostprocessor
    grain_data = grain_center
  [../]
  [./forces]
    type = GrainForcesPostprocessor
    grain_force = grain_force
  [../]
[]

[UserObjects]
  [./grain_center]
    type = ComputeGrainCenterUserObject
    etas = 'eta0 eta1'
    execute_on = 'initial linear'
  [../]
  [./grain_force]
    type = ComputeGrainForceAndTorque
    execute_on = 'linear nonlinear'
    grain_data = grain_center
    force_density = force_density
    c = c
  [../]
  #[./test]
  #  type = ShapeTestUserObject
  #  u = c
  #  # first order lagrange variables have 4 DOFs per element
  #  u_dofs = 4
  #  v = w
  #  # third order hermite variables have 16 DOFs per element
  #  v_dofs = 4
  #  # as this userobject computes quantities for both the residual AND the jacobian
  #  # it needs to have these execute_on flags set.
  #  execute_on = 'linear nonlinear'
  #[../]
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
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   ilu      1'
  l_max_its = 30
  l_tol = 1.0e-4
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-10
  start_time = 0.0
  num_steps = 2
  dt = 1
[]

[Outputs]
  exodus = true
  csv = true
[]
