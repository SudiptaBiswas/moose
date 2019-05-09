[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  parallel_type = DISTRIBUTED
[]

[Variables]
  [./u]
  [../]
[]

[Kernels]
  [./diff]
    type = CoefDiffusion
    variable = u
    coef = 0.1
  [../]
  [./time]
    type = TimeDerivative
    variable = u
  [../]
[]

[BCs]
  [./left]
    type = DirichletBC
    variable = u
    boundary = left
    value = 0
  [../]
  [./right]
    type = DirichletBC
    variable = u
    boundary = right
    value = 1
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 10
  dt = 0.1
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Adaptivity]
 marker = err
 max_h_level = 2
 [./Indicators]
   [./error]
     type = GradientJumpIndicator
     variable = u
   [../]
 [../]
 [./Markers]
   [./err]
     type = ErrorFractionMarker
     coarsen = 0.7
     refine = 0.3
     indicator = error
   [../]
 [../]
[]

[Outputs]
  nemesis = true
  checkpoint= true
  file_base = nemesis_adaptivity
[]
