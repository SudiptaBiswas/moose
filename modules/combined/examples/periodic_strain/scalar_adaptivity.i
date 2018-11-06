[Mesh]
  type = GeneratedMesh
  dim = 1
[]

[Variables]
  [./dummy]
    family = SCALAR
    order = THIRD
  [../]
  [./u]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ScalarKernels]
  [./d1]
    type = ODETimeDerivative
    variable = dummy
  [../]
[]

[Kernels]
  [./ie]
    type = TimeDerivative
    variable = u
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 2
[]

[Adaptivity]
  marker = uniform
  [./Markers]
    [./uniform]
      type = UniformMarker
      mark = REFINE
    [../]
  [../]
[]
