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
  nx = 25
  ny = 13
  nz = 0
  xmax = 50
  ymax = 25
  zmax = 0
  elem_type = QUAD4
[]

[Variables]
  [./eta]
    order = FIRST
    family = LAGRANGE
  [../]
  [./c]
    order = THIRD
    family = HERMITE
  [../]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
[]

[AuxVariables]
  [./vadv00]
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
  [./c_dot]
    type = TimeDerivative
    variable = c
  [../]
  [./motion]
    # advection kernel corrsponding to CH equation
    type = MultiGrainRigidBodyMotion
    variable = c
    c = c
    v = eta
  [../]
  [./eta_dot]
    type = TimeDerivative
    variable = eta
  [../]
  [./vadv_eta]
    # advection kernel corrsponding to AC equation
    type = SingleGrainRigidBodyMotion
    variable = eta
    c = c
    v = eta
  [../]
  [./TensorMechanics]
    displacements = 'disp_x disp_y'
  [../]
[]

[AuxKernels]
  [./vadv00]
    # outputting components of advection velocity
    type = MaterialStdVectorRealGradientAux
    variable = vadv00
    property = advection_velocity
  [../]
  [./vadv0_div]
    # outputting components of advection velocity
    type = MaterialStdVectorAux
    variable = vadv0_div
    property = advection_velocity_divergence
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y'
      variable = 'c eta'
    [../]
  [../]
  [./Disp_top]
    type = FunctionPresetBC
    variable = disp_y
    #value = 0.2
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


[Materials]
  [./advection_vel]
    # advection velocity is being calculated
    type = GrainAdvectionVelocity
    block = 0
    grain_force = grain_force
    etas = eta
    c = c
    grain_data = grain_center
  [../]
  [./elastic]
    type = ComputeConcentrationDependentElasticityTensor
    block = 0
    c = c
    C0_ijkl = '7.0 7.0'
    C1_ijkl = '1.0 1.0'
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
    derivative_order = 2
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
    etas = eta
    execute_on = 'initial linear'
  [../]
  [./grain_force]
    # constant force and torque is applied on grains
    type = ConstantGrainForceAndTorque
    execute_on = 'initial linear'
    force = '0.2 0.0 0.0 ' # size should be 3 * no. of grains
    torque = '0.0 0.0 0.0 ' # size should be 3 * no. of grains
  [../]
[]

[Postprocessors]
  [./Conc]
    type = ElementIntegralVariablePostprocessor
    variable = c
    execute_on = initial
    use_displaced_mesh = true
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
  dt = 0.5
  end_time = 2.0
[]

[Outputs]
  exodus = true
  csv = true
  gnuplot = true
[]

[ICs]
  [./rect_c]
    y2 = 20.0
    y1 = 5.0
    inside = 1.0
    x2 = 30.0
    variable = c
    x1 = 10.0
    type = BoundingBoxIC
  [../]
  [./rect_eta]
    y2 = 20.0
    y1 = 5.0
    inside = 1.0
    x2 = 30.0
    variable = eta
    x1 = 10.0
    type = BoundingBoxIC
  [../]
[]
