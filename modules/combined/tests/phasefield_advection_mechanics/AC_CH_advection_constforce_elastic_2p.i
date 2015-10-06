#
# Tests the Rigid Body Motion of grains due to applied forces.
# Concenterated forces and torques have been applied and corresponding
# advection velocities are calculated.
# Grain motion kernels make the grains translate and rotate as a rigidbody,
# applicable to grain movement in porous media
#

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 50
  ny = 25
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
  [../]
  [./w]
    order = FIRST
    family = LAGRANGE
  [../]
  [./eta0]
    order = FIRST
    family = LAGRANGE
  [../]
  [./eta1]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
[]

[AuxVariables]
  [./bnds]
  [../]
  [./total_en]
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
  [./vadv0_div]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Functions]
  [./load]
    type = PiecewiseLinear
    y = '0.0 -0.5 -0.5'
    x = '0.0 2.0  5.0'
  [../]
[]

[Kernels]
  [./c_res]
    type = SplitCHParsed
    variable = c
    f_name = F
    kappa_name = kappa_c
    w = w
    args = 'eta0 eta1'
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
  [./motion]
    # advection kernel corrsponding to CH equation
    type = MultiGrainRigidBodyMotion
    variable = w
    c = c
    v = 'eta0 eta1'
  [../]
  [./eta0_dot]
    type = TimeDerivative
    variable = eta0
  [../]
  [./vadv_eta0]
    # advection kernel corrsponding to AC equation
    type = SingleGrainRigidBodyMotion
    variable = eta0
    c = c
    v = 'eta0 eta1'
  [../]
  [./acint_eta0]
    type = ACInterface
    variable = eta0
    mob_name = M
    args = 'c eta1'
    kappa_name = kappa_eta
  [../]
  [./acbulk_eta0]
    type = ACParsed
    variable = eta0
    mob_name = M
    f_name = F
    args = 'c eta1'
  [../]
  [./eta_dot1]
    type = TimeDerivative
    variable = eta1
  [../]
  [./vadv_eta1]
    # advection kernel corrsponding to AC equation
    type = SingleGrainRigidBodyMotion
    variable = eta1
    c = c
    v = 'eta0 eta1'
    op_index = 1
  [../]
  [./acint_eta1]
    type = ACInterface
    variable = eta1
    mob_name = M
    args = 'c eta0'
    kappa_name = kappa_eta
  [../]
  [./acbulk_eta1]
    type = ACParsed
    variable = eta1
    mob_name = M
    f_name = F
    args = 'c eta0'
  [../]
  [./TensorMechanics]
    displacements = 'disp_x disp_y'
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y'
      variable = 'c w eta0 eta1'
    [../]
  [../]
  [./Disp_top]
    type = FunctionPresetBC
    variable = disp_y
    function = load
    boundary = top
  [../]
  [./Disp_left]
    type = PresetBC
    variable = disp_x
    value = 0.0
    boundary = left
  [../]
  [./Disp_right]
    type = PresetBC
    variable = disp_x
    value = 0.0
    boundary = right
  [../]
  [./Disp_bottom]
    type = PresetBC
    variable = disp_y
    value = 0.0
    boundary = bottom
  [../]
[]

[AuxKernels]
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'eta0 eta1 '
  [../]
  [./Total_en]
    type = TotalFreeEnergy
    variable = total_en
    kappa_names = 'kappa_c kappa_eta kappa_eta'
    interfacial_vars = 'c  eta0 eta1'
  [../]
  [./vadv00]
    # outputting components of advection velocity
    type = MaterialStdVectorRealGradientAux
    variable = vadv00
    property = advection_velocity
  [../]
  [./vadv01]
    # outputting components of advection velocity
    type = MaterialStdVectorRealGradientAux
    variable = vadv01
    property = advection_velocity
    component = 1
  [../]
  [./vadv0_div]
    # outputting components of advection velocity
    type = MaterialStdVectorAux
    variable = vadv0_div
    property = advection_velocity_divergence
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
    f_name = S
    args = 'c eta0 eta1'
    constant_names = 'barr_height  cv_eq'
    constant_expressions = '0.1          1.0e-2'
    function = 16*barr_height*(c-cv_eq)^2*(1-cv_eq-c)^2+(c-eta0)^2+(c-eta1)^2
    derivative_order = 2
  [../]
  [./advection_vel]
    # advection velocity is being calculated
    type = GrainAdvectionVelocity
    block = 0
    grain_force = grain_force
    etas = 'eta0 eta1'
    c = c
    grain_data = grain_center
  [../]
  [./elastic]
    type = ComputeConcentrationDependentElasticityTensor
    block = 0
    c = c
    C0_ijkl = '10.0 10.0'
    C1_ijkl = '5.0 5.0'
    fill_method0 = symmetric_isotropic
    fill_method1 = symmetric_isotropic
  [../]
  [./strain]
    type = ComputeSmallStrain
    block = 0
    displacements = 'disp_x disp_y'
  [../]
  [./stress]
    type = ComputeLinearElasticStress
    block = 0
  [../]
  [./elastic_energy]
    type = ElasticEnergyMaterial
    block = 0
    args = c
    f_name = E
    derivative_order = 2
  [../]
  [./sum_energy]
    type = DerivativeSumMaterial
    block = 0
    args = 'c eta0 eta1'
    sum_materials = 'S E'
  [../]
[]

[VectorPostprocessors]
  [./centers]
    # VectorPostprocessor for outputing grain centers and volumes
    type = GrainCentersPostprocessor
    grain_data = grain_center
  [../]
  [./forces]
    # VectorPostprocessor for outputing grain forces and torques
    type = GrainForcesPostprocessor
    grain_force = grain_force
  [../]
[]

[UserObjects]
  [./grain_center]
    # user object for extracting grain centers and volumes
    type = ComputeGrainCenterUserObject
    etas = 'eta0 eta1'
    execute_on = 'initial linear'
  [../]
  [./grain_force]
    # constant force and torque is applied on grains
    type = ConstantGrainForceAndTorque
    execute_on = 'initial linear'
    force = '0.2 0.0 0.0 -0.2 0.0 0.0' # size should be 3 * no. of grains
    torque = '0.0 0.0 5.0 0 0.0 0.0' # size should be 3 * no. of grains
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
  nl_max_its = 30
  scheme = bdf2
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'
  l_max_its = 30
  l_tol = 1.0e-4
  nl_rel_tol = 1.0e-10
  start_time = 0.0
  dt = 1
  num_steps = 5.0
[]

[Outputs]
  exodus = true
  csv = true
  gnuplot = true
[]

[Postprocessors]
  [./elem_c]
    type = ElementIntegralVariablePostprocessor
    variable = c
  [../]
  [./elem_bnds]
    type = ElementIntegralVariablePostprocessor
    variable = bnds
  [../]
  [./total_energy]
    type = ElementIntegralVariablePostprocessor
    variable = total_en
  [../]
  [./free_en]
    type = ElementIntegralMaterialProperty
    mat_prop = F
  [../]
[]

[ICs]
  [./ic_gr1]
    int_width = 2.0
    x1 = 25.0
    y1 = 10.0
    radius = 7.0
    outvalue = 0.0
    variable = eta1
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
    variable = eta0
    invalue = 1.0
    type = SmoothCircleIC
  [../]
[]
