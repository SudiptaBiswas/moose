#
# Test from:
#   Multiple Scale Analysis of Heterogeneous Elastic Structures Using
#   Homogenization Theory and Voronoi Cell Finite Element Method
#   by S.Ghosh et. al, Int J. Solids Structures, Vol. 32, No. 1,
#   pp. 27-62, 1995.
#
# From that paper, elastic constants should be:
# E1111: 136.1
# E2222: 245.8
# E1212:  46.85
# E1122:  36.08
#

[Mesh]
  file = anisoLongFiber.e
[]

[Variables]
  [./dx_xx]
    order = SECOND
    family = LAGRANGE
  [../]
  [./dy_xx]
    order = SECOND
    family = LAGRANGE
  [../]
  [./dx_yy]
    order = SECOND
    family = LAGRANGE
  [../]
  [./dy_yy]
    order = SECOND
    family = LAGRANGE
  [../]
  [./dx_xy]
    order = SECOND
    family = LAGRANGE
  [../]
  [./dy_xy]
    order = SECOND
    family = LAGRANGE
  [../]
[]

[GlobalParams]
  displacements = 'dx_xx dx_yy'
  block = '1 2'
[]

# [Modules/TensorMechanics/Master]
#   displacements = 'dx_xx dy_xx'
#   [./all_xx]
#     strain = SMALL
#     incremental = false
#     add_variables = true
#     displacements = 'dx_xx dy_xx'
#     block = '1 2'
#   [../]
# []
# [Modules/TensorMechanics/Master]
#   displacements = 'dx_yy dy_yy'
#   [./all_yy]
#     strain = SMALL
#     incremental = false
#     add_variables = true
#     displacements = 'dx_yy dy_yy'
#     block = '1 2'
#   [../]
# []
# [Modules/TensorMechanics/Master]
#   displacements = 'dx_xy dy_xy'
#   [./all_xy]
#     strain = SMALL
#     incremental = false
#     add_variables = true
#     displacements = 'dx_xy dy_xy'
#     block = '1 2'
#   [../]
# []

# [Modules]
#   [./TensorMechanics]
#     [./Master]
#       displacements = 'dx_xx dy_xx'
#       [./stress_div_xx]
#         strain = SMALL
#         add_variables = true
#         displacements = 'dx_xx dy_xx'
#         base_name = xx
#         block = '1 2'
#         # eigenstrain_names = 'eigen'
#         # global_strain = global_strain
#         generate_output = 'strain_xx strain_xy strain_yy stress_xx stress_xy stress_yy
#                            vonmises_stress hydrostatic_stress'
#
#       [../]
#       [./stress_div_yy]
#         strain = SMALL
#         add_variables = true
#         displacements = 'dx_yy dy_yy'
#         base_name = yy
#         block = '1 2'
#         # eigenstrain_names = 'eigen'
#         # global_strain = global_strain
#         generate_output = 'strain_xx strain_xy strain_yy stress_xx stress_xy stress_yy
#                            vonmises_stress hydrostatic_stress'
#
#       [../]
#       [./stress_div_xy]
#         strain = SMALL
#         add_variables = true
#         displacements = 'dx_xy dy_xy'
#         base_name = xy
#         block = '1 2'
#         # eigenstrain_names = 'eigen'
#         # global_strain = global_strain
#         generate_output = 'strain_xx strain_xy strain_yy stress_xx stress_xy stress_yy
#                            vonmises_stress hydrostatic_stress'
#
#       [../]
#     [../]
#     # [./GlobalStrain]
#     #   [./global_strain]
#     #     scalar_global_strain = global_strain
#     #     applied_stress_tensor = '5.0 0.0 0.0 0.0 0.0 0.0'
#     #     displacements = 'u_x u_y u_z'
#     #     auxiliary_displacements = 'disp_x disp_y disp_z'
#     #   [../]
#     # [../]
#   [../]
# []


[Kernels]
  # [./TensorMechanics]
  #   # displacements = 'dx_xx dy_xx'
  #   [./xx]
  #     displacements = 'dx_xx dy_xx'
  #     base_name = xx
  #   [../]
  # # [../]
  # # [./TensorMechanics]
  # #   displacements = 'dx_yy dy_yy'
  #
  #   [./yy]
  #     displacements = 'dx_yy dy_yy'
  #     base_name = yy
  #   [../]
  # # [../]
  # # [./TensorMechanics]
  # #   displacements = 'dx_xy dy_xy'
  #
  #   [./xy]
  #     displacements = 'dx_xy dy_xy'
  #     base_name = xy
  #   [../]
  # [../]
  [./dx_xx]
    type = StressDivergenceTensors
    component = 0
    displacements = 'dx_xx dy_xx'
    variable = dx_xx
    base_name = xx
  [../]
  [./dy_xx]
    type = StressDivergenceTensors
    component = 1
    displacements = 'dx_xx dy_xx'
    variable = dy_xx
    base_name = xx
  [../]
  [./dx_yy]
    type = StressDivergenceTensors
    component = 0
    displacements = 'dx_yy dy_yy'
    variable = dx_yy
    base_name = yy
  [../]
  [./dy_yy]
    type = StressDivergenceTensors
    component = 1
    displacements = 'dx_yy dy_yy'
    variable = dy_yy
    base_name = xx
  [../]
  [./dx_xy]
    type = StressDivergenceTensors
    component = 0
    displacements = 'dx_xy dy_xy'
    variable = dx_xy
    base_name = xy
  [../]
  [./dy_xy]
    type = StressDivergenceTensors
    component = 1
    displacements = 'dx_xy dy_xy'
    variable = dy_xy
    base_name = xy
  [../]

  [./homo_dx_xx]
    type = HomogenizationTensor
    variable = dx_xx
    base_name = xx
    component = 0
    index_k = 0
    index_l = 0
  [../]
  [./homo_dy_xx]
    type = HomogenizationTensor
    variable = dy_xx
    base_name = xx
    component = 1
    index_k = 0
    index_l = 0
  [../]

  [./homo_dx_yy]
   type = HomogenizationTensor
   variable = dx_yy
   base_name = yy
   component = 0
   index_k = 1
   index_l = 1
  [../]

  [./homo_dy_yy]
    type = HomogenizationTensor
    variable = dy_yy
    base_name = yy
    component = 1
    index_k = 1
    index_l = 1
  [../]

  [./homo_dx_xy]
    type = HomogenizationTensor
    variable = dx_xy
    base_name = xy
    component = 0
    index_k = 0
    index_l = 1
  [../]
  [./homo_dy_xy]
    type = HomogenizationTensor
    variable = dy_xy
    base_name = xy
    component = 1
    index_k = 0
    index_l = 1
  [../]
[]

[BCs]

  [./Periodic]
    [./top_bottom]
      primary = 30
      secondary = 40
      translation = '0 1 0'
    [../]

    [./left_right]
      primary = 10
      secondary = 20
      translation = '1 0 0'
    [../]
  [../]

  [./dx_xx_anchor]
    type = DirichletBC
    variable = dx_xx
    boundary = 1
    value = 0.0
  [../]

 [./dy_xx_anchor]
    type = DirichletBC
    variable = dy_xx
    boundary = 1
    value = 0.0
 [../]

 [./dx_yy_anchor]
   type = DirichletBC
   variable = dx_yy
   boundary = 1
   value = 0.0
 [../]

 [./dy_yy_anchor]
   type = DirichletBC
   variable = dy_yy
   boundary = 1
   value = 0.0
 [../]

  [./dx_xy_anchor]
     type = DirichletBC
     variable = dx_xy
     boundary = 1
     value = 0.0
  [../]
  [./dy_xy_anchor]
     type = DirichletBC
     variable = dy_xy
     boundary = 1
     value = 0.0
  [../]
[]

[Materials]
  [./block1]
   type =  ComputeElasticityTensor
   block = 1
   base_name = xx
   fill_method = symmetric9
   C_ijkl = '81.360117 26.848839 0.0 81.360117 0.0 27.255639 0.0 0.0 0.0 '
  [../]
  [./block2]
    type =  ComputeElasticityTensor
    block = 1
    base_name = yy
    fill_method = symmetric9
    C_ijkl = '81.360117 26.848839 0.0 81.360117 0.0 27.255639 0.0 0.0 0.0 '
  [../]
  [./block3]
    type =  ComputeElasticityTensor
    block = 1
    base_name = xy
    fill_method = symmetric9
    C_ijkl = '81.360117 26.848839 0.0 81.360117 0.0 27.255639 0.0 0.0 0.0 '
  [../]
  [./block4]
    type =  ComputeElasticityTensor
    block = 2
    base_name = xx
    fill_method = symmetric9
    C_ijkl = '416.66667 83.333333 0.0 416.66667 0.0 166.66667 0.0 0.0 0.0 '
  [../]
  [./block5]
    type =  ComputeElasticityTensor
    block = 2
    base_name = yy
    fill_method = symmetric9
    C_ijkl = '416.66667 83.333333 0.0 416.66667 0.0 166.66667 0.0 0.0 0.0 '
  [../]
  [./block6]
    type =  ComputeElasticityTensor
    block = 2
    base_name = xy
    fill_method = symmetric9
    C_ijkl = '416.66667 83.333333 0.0 416.66667 0.0 166.66667 0.0 0.0 0.0 '
  [../]

  [./stress_xx]
   type = ComputeLinearElasticStress
   base_name = xx
  [../]
  [./stress_yy]
   type = ComputeLinearElasticStress
   base_name = yy
  [../]
  [./stress_xy]
   type = ComputeLinearElasticStress
   base_name = xy
  [../]
  [./strain_xx]
   type = ComputeSmallStrain
   base_name = xx
  [../]
  [./strain_yy]
   type = ComputeSmallStrain
   base_name = yy
  [../]
  [./strain_xy]
   type = ComputeSmallStrain
   base_name = xy
  [../]
[]

 [Postprocessors]

  [./E1111]
    type = HomogenizedElasticityTensor
    variable = dx_xx
    base_name = xx
    # row = 0
    # column = 0
    # dx_xx = dx_xx
    # dy_xx = dy_xx
    # dx_yy = dx_yy
    # dy_yy = dy_yy
    # dx_xy = dx_xy
    # dy_xy = dy_xy
    index_i = 0
    index_j = 0
    index_l = 0
    index_k = 0
    execute_on = 'initial timestep_end'
  [../]

  [./E2222]
    type = HomogenizedElasticityTensor
    variable = dx_xx
    base_name = xx
    # row = 0
    # column = 1
    # dx_xx = dx_xx
    # dy_xx = dy_xx
    # dx_yy = dx_yy
    # dy_yy = dy_yy
    # dx_xy = dx_xy
    # dy_xy = dy_xy
    index_i = 1
    index_j = 1
    index_l = 1
    index_k = 1
    execute_on = 'initial timestep_end'
  [../]

  [./E1122]
    type = HomogenizedElasticityTensor
    variable = dx_xx
    base_name = xx
    # row = 0
    # column = 1
    # dx_xx = dx_xx
    # dy_xx = dy_xx
    # dx_yy = dx_yy
    # dy_yy = dy_yy
    # dx_xy = dx_xy
    # dy_xy = dy_xy
    index_i = 0
    index_j = 0
    index_l = 1
    index_k = 1
    execute_on = 'initial timestep_end'
  [../]


  [./E2211]
    type = HomogenizedElasticityTensor
    variable = dx_xx
    base_name = xx
    # row = 0
    # column = 0
    # dx_xx = dx_xx
    # dy_xx = dy_xx
    # dx_yy = dx_yy
    # dy_yy = dy_yy
    # dx_xy = dx_xy
    # dy_xy = dy_xy
    index_i = 1
    index_j = 1
    index_l = 0
    index_k = 0
    execute_on = 'initial timestep_end'
  [../]


  [./E1212]
    type = HomogenizedElasticityTensor
    variable = dx_xx
    base_name = xx
    # row = 0
    # column = 5
    # dx_xx = dx_xx
    # dy_xx = dy_xx
    # dx_yy = dx_yy
    # dy_yy = dy_yy
    # dx_xy = dx_xy
    # dy_xy = dy_xy
    index_i = 0
    index_j = 1
    index_l = 0
    index_k = 1
    execute_on = 'initial timestep_end'
  [../]

[]

[Preconditioning]

 [./SMP]
  type = SMP
  # full = true
  coupled_groups = 'dx_xx,dy_xx dx_yy,dy_yy dx_xy,dy_xy'
 [../]

[]


[Executioner]

 type = Transient


  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'


 petsc_options = '-ksp_gmres_modifiedgramschmidt'
 petsc_options_iname = '-ksp_gmres_restart -pc_type   -pc_hypre_type -pc_hypre_boomeramg_max_iter -pc_hypre_boomeramg_grid_sweeps_all -ksp_type -mat_mffd_type'
 petsc_options_value = '201                 hypre       boomeramg      2                            2                                   fgmres    ds'


  # line_search = 'none'


  l_tol = 1e-4
  l_max_its = 40
  nl_max_its = 40
  nl_abs_tol = 1e-10
  nl_rel_tol = 1e-8
  #
  start_time = 0.0
  end_time = 10.0
  num_steps = 1
  dt = 10

[]


[Outputs]
  exodus = true
  csv = true
[]
