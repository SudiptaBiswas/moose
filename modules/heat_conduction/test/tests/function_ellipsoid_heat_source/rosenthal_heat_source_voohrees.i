[Mesh]
  type = GeneratedMesh
  dim = 2
  # xmin = -10.0
  xmax = 2.0
  nx = 2

  ymin = -1
  ymax = 1
  ny = 2

  # zmin = 0.0
  # zmax = 1.0
  # nz = 1
[]

[Variables]
  [temp]
    initial_condition = 300
  []
[]

[AuxVariables]
  [temp_src]
    order = FIRST
    family = MONOMIAL
  []
[]

[AuxKernels]
  [temp_src]
    type = ADMaterialRealAux
    variable = temp_src
    property = temp_source
  []
[]

[Kernels]
  [time]
    type = ADHeatConductionTimeDerivative
    variable = temp
  []
  [heat_conduct]
    type = ADHeatConduction
    variable = temp
    thermal_conductivity = thermal_conductivity
  []
  # [./heat_source]
  #   type = ADMatHeatSource
  #   material_property = meltpool_heat
  #   variable = temp
  # [../]
[]

# [BCs]
#   [./temp_bottom_fix]
#     type = ADDirichletBC
#     variable = temp
#     boundary = 1
#     value = 300
#   [../]
# []

[Materials]
  [heat]
    type = ADHeatConductionMaterial
    specific_heat = 650
    thermal_conductivity = 2.7e-5
  []
  [density]
    type = ADGenericConstantMaterial
    prop_names = 'density'
    prop_values = '8e-15'
  []
  [meltpool_heat]
    type = ADRosenthalHeatSource
    power = 25
    velocity = 1e6
    absorptivity = 1.0
    melting_temperature = 1700
    ambient_temperature = 300
    outputs = exodus
  []
[]

[Postprocessors]
  [meltpool_depth]
    type = ADElementAverageMaterialProperty
    mat_prop = meltpool_depth
  []
  [meltpool_width]
    type = ADElementAverageMaterialProperty
    mat_prop = meltpool_width
  []
[]

[Preconditioning]
  [full]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  solve_type = PJFNK

  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-6

  petsc_options_iname = '-ksp_type -pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'preonly lu       superlu_dist'

  l_max_its = 100

  # end_time = 20
  num_steps = 2
  dt = 0.1
  dtmin = 1e-4
[]

[Outputs]
  exodus = true
[]
