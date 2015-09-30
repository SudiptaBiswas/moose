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
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'
  l_max_its = 30
  l_tol = 1.0e-4
  nl_rel_tol = 1.0e-10
  start_time = 0.0
  dt = 1
  num_steps = 2
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
