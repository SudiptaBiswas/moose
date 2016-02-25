[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  nz = 0
  xmin = 0
  xmax = 20
  ymin = 0
  ymax = 20
  elem_type = QUAD4
[]

[Variables]
  [./c]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./gr0]
    order = FIRST
    family = LAGRANGE
  [../]
  [./gr1]
    order = FIRST
    family = LAGRANGE
  [../]
  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxKernels]
  [./bnds]
    type = BndsCalcAux
    v = 'gr0 gr1'
    variable = bnds
  [../]
[]

[ICs]
  [./gr0]
    type = BoundingBoxIC
    variable = gr0
    x1 = 0
    x2 = 10
    y1 = 0
    y2 = 20
  [../]
  [./gr0]
    type = BoundingBoxIC
    variable = gr1
    x1 = 10
    x2 = 20
    y1 = 0
    y2 = 20
  [../]
[]
[BCs]
  [./left]
    type = DirichletBC
    boundary = left
    variable = c
    value = 0
  [../]
  [./right]
    type = DirichletBC
    boundary = right
    variable = c
    value = 1
  [../]
  [./Periodic]
    [./all]
      auto_direction = y
    [../]
  [../]
[]

[Kernels]
  [./c]
    type = Diffusion
    #D_name = F
    variable = c
  [../]
  [./dt]
    type = TimeDerivative
    variable = c
  [../]
[]

[Materials]
  [./nucleation]
    type = PolyDiscreteNucleation
    op_names  = c
    op_values = 1
    block = 0
    map = map
    v = 'gr0 gr1'
    outputs = exodus
  [../]
[]

[UserObjects]
  [./inserter]
    type = DiscreteNucleationInserter
    hold_time = 1
    probability = 0.01
  [../]
  [./map]
    type = DiscreteNucleationMap
    radius = 3.27
    periodic = c
    inserter = inserter
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  num_steps = 10
  dt = 0.1
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
  hide = c
[]
