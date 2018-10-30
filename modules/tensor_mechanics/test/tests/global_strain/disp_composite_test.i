[Mesh]
  type = FileMesh
  # file = unitcell_Vf47_refine.e
  file = unitcell_Vf47x.e
[]

[MeshModifiers]
  [./cnode]
    type = AddExtraNodeset
    coord = '0 0 0'
    new_boundary = 100
  [../]
[]

[Variables]
  [./global_strain]
    order = SIXTH
    family = SCALAR
  [../]
[]

[GlobalParams]
  displacements = 'u_x u_y u_z'
  block = '1 2'
[]

[Modules]
  [./TensorMechanics]
    [./Master]
      [./stress_div]
        strain = SMALL
        add_variables = true
        # eigenstrain_names = 'eigen'
        global_strain = global_strain
        generate_output = 'strain_xx strain_xy strain_yy strain_yz strain_zz strain_xz
                           stress_xx stress_xy stress_yy stress_xz stress_yz stress_zz
                           vonmises_stress hydrostatic_stress'

      [../]
    [../]
    [./GlobalStrain]
      [./global_strain]
        scalar_global_strain = global_strain
        applied_stress_tensor = '0.0 0.0 0.0 0.0 0.0 1.0'
        displacements = 'u_x u_y u_z'
        auxiliary_displacements = 'disp_x disp_y disp_z'
      [../]
    [../]
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y z'
      # variable = 'disp_x disp_y disp_z'
      variable = 'u_x u_y u_z'
    [../]
  [../]

  # fix center point location
  [./fix_x]
    type = PresetBC
    boundary = 100 #3
    variable = u_x
    value = 0
  [../]
  # [./appl_x]
  #   type = PresetBC
  #   boundary = 4
  #   variable = u_x
  #   value = 0.05
  # [../]
  [./fix_y]
    type = PresetBC
    boundary = 100
    variable = u_y
    value = 0
  [../]
  [./fix_z]
    type = PresetBC
    boundary = 100
    variable = u_z
    value = 0
  [../]
  # [./appl_y]
  #   type = PresetBC
  #   boundary = 6
  #   variable = u_y
  #   value = 0.02
  # [../]
  # [./appl_z]
  #   type = PresetBC
  #   boundary = 2
  #   variable = u_z
  #   value = 0.02
  # [../]
[]

# [Kernels]
#   [./homo_dx_xx]
#     type = HomogenizationTensor
#     variable = disp_x
#     component = 0
#     index_k = 0
#     index_l = 0
#   [../]
#   [./homo_dy_xx]
#     type = HomogenizationTensor
#     variable = disp_y
#     component = 1
#     index_k = 0
#     index_l = 0
#   [../]
#   [./homo_dz_xx]
#     type = HomogenizationTensor
#     variable = disp_z
#     component = 1
#     index_k = 0
#     index_l = 0
#   [../]
# []

[Materials]
  [./elasticity_tensor1]
    type = ComputeElasticityTensor
    block = 1
    C_ijkl = '379.3 0.1'
    fill_method = symmetric_isotropic_E_nu
  [../]
  [./elasticity_tensor2]
    type = ComputeElasticityTensor
    block = 2
    C_ijkl = '68.3 0.3'
    fill_method = symmetric_isotropic_E_nu
  [../]
  [./stress]
    type = ComputeLinearElasticStress
  [../]
  # [./eigen]
  #   type = ComputeEigenstrain
  #   eigenstrain_name = eigen
  #   eigen_base = '0.001 0.0 0.0 0.0 0.0 0.0'
  # [../]
[]

[Postprocessors]
  [./s00]
    type = ElementIntegralVariablePostprocessor
    variable = stress_xx
  [../]
  [./s11]
    type = ElementIntegralVariablePostprocessor
    variable = stress_yy
  [../]
  [./s01]
    type = ElementIntegralVariablePostprocessor
    variable = stress_xy
  [../]
  [./s12]
    type = ElementIntegralVariablePostprocessor
    variable = stress_yz
  [../]
  [./s02]
    type = ElementIntegralVariablePostprocessor
    variable = stress_xz
  [../]
  [./s22]
    type = ElementIntegralVariablePostprocessor
    variable = stress_zz
  [../]
  [./e00]
    type = ElementIntegralVariablePostprocessor
    variable = strain_xx
  [../]
  [./e11]
    type = ElementIntegralVariablePostprocessor
    variable = strain_yy
  [../]
  [./e01]
    type = ElementIntegralVariablePostprocessor
    variable = strain_xy
  [../]
  [./e12]
    type = ElementIntegralVariablePostprocessor
    variable = strain_yz
  [../]
  [./e02]
    type = ElementIntegralVariablePostprocessor
    variable = strain_xz
  [../]
  [./e22]
    type = ElementIntegralVariablePostprocessor
    variable = strain_zz
  [../]
  [./dispx_1]
    type = SideIntegralVariablePostprocessor
    variable = disp_x
    boundary = 1
  [../]
  [./dispx_2]
    type = SideIntegralVariablePostprocessor
    variable = disp_x
    boundary = 2
  [../]
  [./dispx_3]
    type = SideIntegralVariablePostprocessor
    variable = disp_x
    boundary = 3
  [../]
  [./dispx_4]
    type = SideIntegralVariablePostprocessor
    variable = disp_x
    boundary = 4
  [../]
  [./dispx_5]
    type = SideIntegralVariablePostprocessor
    variable = disp_x
    boundary = 5
  [../]
  [./dispx_6]
    type = SideIntegralVariablePostprocessor
    variable = disp_x
    boundary = 6
  [../]
  [./dispy_1]
    type = SideIntegralVariablePostprocessor
    variable = disp_y
    boundary = 1
  [../]
  [./dispy_2]
    type = SideIntegralVariablePostprocessor
    variable = disp_y
    boundary = 2
  [../]
  [./dispy_3]
    type = SideIntegralVariablePostprocessor
    variable = disp_y
    boundary = 3
  [../]
  [./dispy_4]
    type = SideIntegralVariablePostprocessor
    variable = disp_y
    boundary = 4
  [../]
  [./dispy_5]
    type = SideIntegralVariablePostprocessor
    variable = disp_y
    boundary = 5
  [../]
  [./dispy_6]
    type = SideIntegralVariablePostprocessor
    variable = disp_y
    boundary = 6
  [../]
  [./dispz_1]
    type = SideIntegralVariablePostprocessor
    variable = disp_z
    boundary = 1
  [../]
  [./dispz_2]
    type = SideIntegralVariablePostprocessor
    variable = disp_z
    boundary = 2
  [../]
  [./dispz_3]
    type = SideIntegralVariablePostprocessor
    variable = disp_z
    boundary = 3
  [../]
  [./dispz_4]
    type = SideIntegralVariablePostprocessor
    variable = disp_z
    boundary = 4
  [../]
  [./dispz_5]
    type = SideIntegralVariablePostprocessor
    variable = disp_z
    boundary = 5
  [../]
  [./dispz_6]
    type = SideIntegralVariablePostprocessor
    variable = disp_z
    boundary = 6
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Steady
  # scheme = bdf2
  solve_type = 'PJFNK'

  # line_search = basic

  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   ilu      1'
  # petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type'
  # petsc_options_value = '70 hypre boomeramg'

  l_max_its = 30
  nl_max_its = 12

  l_tol = 1.0e-4

  nl_rel_tol = 1.0e-6
  nl_abs_tol = 1.0e-8

  # start_time = 0.0
  # num_steps = 2
  # dt = 0.1
[]

[Outputs]
  file_base = axialxy_fiberx
  [./exo]
    type = Exodus
    elemental_as_nodal = true
  [../]
[]

[Debug]
  show_var_residual_norms = true
[../]
