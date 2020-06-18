[Mesh]
  [./mesh]
  type = FileMeshGenerator
  # file = unitcell_Vf47_refine.e
  # file = square_hex20_coarse.e
  file = square_hex8_coarse1.e
  # uniform_refine = 1
  # file = unitcell_Vf47_refine.e
  [../]
  [./cnode]
    type = ExtraNodesetGenerator
    input = mesh
    coord = '0 0 0'
    new_boundary = 100
  [../]
[]

# [Variables]
#   [./global_strain]
#     order = SIXTH
#     family = SCALAR
#   [../]
# []

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  block = '1 2'
[]

[AuxVariables]
  [./C11]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C12]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C13]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C14]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C15]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C16]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C22]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C23]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C24]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C25]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C26]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C33]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C34]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C35]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C36]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C44]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C45]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C46]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C55]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C56]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C66]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./matl_C11]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 0
    index_j = 0
    index_k = 0
    index_l = 0
    variable = C11
  [../]
  [./matl_C12]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 0
    index_j = 0
    index_k = 1
    index_l = 1
    variable = C12
  [../]
  [./matl_C13]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 0
    index_j = 0
    index_k = 2
    index_l = 2
    variable = C13
  [../]
  [./matl_C14]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 0
    index_j = 0
    index_k = 1
    index_l = 2
    variable = C14
  [../]
  [./matl_C15]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 0
    index_j = 0
    index_k = 0
    index_l = 2
    variable = C15
  [../]
  [./matl_C16]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 0
    index_j = 0
    index_k = 0
    index_l = 1
    variable = C16
  [../]
  [./matl_C22]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 1
    index_j = 1
    index_k = 1
    index_l = 1
    variable = C22
  [../]
  [./matl_C23]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 1
    index_j = 1
    index_k = 2
    index_l = 2
    variable = C23
  [../]
  [./matl_C24]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 1
    index_j = 1
    index_k = 1
    index_l = 2
    variable = C24
  [../]
  [./matl_C25]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 1
    index_j = 1
    index_k = 0
    index_l = 2
    variable = C25
  [../]
  [./matl_C26]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 1
    index_j = 1
    index_k = 0
    index_l = 1
    variable = C26
  [../]
 [./matl_C33]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 2
    index_j = 2
    index_k = 2
    index_l = 2
    variable = C33
  [../]
  [./matl_C34]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 2
    index_j = 2
    index_k = 1
    index_l = 2
    variable = C34
  [../]
  [./matl_C35]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 2
    index_j = 2
    index_k = 0
    index_l = 2
    variable = C35
  [../]
  [./matl_C36]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 2
    index_j = 2
    index_k = 0
    index_l = 1
    variable = C36
  [../]
  [./matl_C44]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 1
    index_j = 2
    index_k = 1
    index_l = 2
    variable = C44
  [../]
  [./matl_C45]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 1
    index_j = 2
    index_k = 0
    index_l = 2
    variable = C45
  [../]
  [./matl_C46]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 1
    index_j = 2
    index_k = 0
    index_l = 1
    variable = C46
  [../]
  [./matl_C55]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 0
    index_j = 2
    index_k = 0
    index_l = 2
    variable = C55
  [../]
  [./matl_C56]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 0
    index_j = 2
    index_k = 0
    index_l = 1
    variable = C56
  [../]
  [./matl_C66]
    type = RankFourAux
    rank_four_tensor = elasticity_tensor
    index_i = 0
    index_j = 1
    index_k = 0
    index_l = 1
    variable = C66
  [../]
[]

[Modules]
  [./TensorMechanics]
    [./Master]
      [./stress_div]
        strain = SMALL
        add_variables = true
        # eigenstrain_names = 'eigen'
        # global_strain = global_strain
        generate_output = 'strain_xx strain_xy strain_yy strain_yz strain_zz strain_xz
                           stress_xx stress_xy stress_yy stress_xz stress_yz stress_zz
                           vonmises_stress hydrostatic_stress'

      [../]
    [../]
  [../]
[]

[BCs]
  # [./Periodic]
  #   [./all]
  #     auto_direction = 'x z'
  #     # variable = 'disp_x disp_y disp_z'
  #     variable = 'disp_x disp_z'
  #   [../]
  # [../]

  # fix center point location
  # [./fix_x]
  #   type = DirichletBC
  #   boundary = 3
  #   variable = disp_x
  #   value = 0
  # [../]
  # [./appl_x]
  #   type = PresetBC
  #   boundary = 4
  #   variable = disp_x
  #   value = 0.05
  # [../]
  [./fix_y]
    type = DirichletBC
    boundary = 4 #5
    variable = disp_y
    value = 0
  [../]
  [./fix_x]
    type = DirichletBC
    boundary = 4
    variable = disp_x
    value = 0
  [../]
  [./appl_y]
    type = DirichletBC
    boundary = 3 #5
    variable = disp_y
    value = -0.01
  [../]
  [./appl_z]
    type = DirichletBC
    boundary = 4 #6
    variable = disp_z
    value = 0
  [../]
[]

[Functions]
  [./C11_calc]
    type = ParsedFunction
    value = 379.3/(1-0.1*0.1)*0.47+(1-0.47)*68.3/(1-0.3*0.3)
  [../]
  [./C12_calc]
    type = ParsedFunction
    value = 0.1*379.3/(1-0.1*0.1)*0.47+0.3*(1-0.47)*68.3/(1-0.3*0.3)
  [../]
  [./C66_calc]
    type = ParsedFunction
    value = 379.3/2/(1+0.1)*0.47+(1-0.47)*68.3/2/(1+0.3)
  [../]
  [./E1_calc]
    type = ParsedFunction
    value = 379.3*0.47+(1-0.47)*68.3
  [../]
  [./E2_calc]
    type = ParsedFunction
    value = 379.3*0.47+(1-0.47)*68.3
  [../]
  [./ndisp_calc]
    type = ParsedFunction
    value = 0.1*0.47+(1-0.47)*0.3
  [../]
[]

[Materials]
  [./elasticity_tensor1]
    type = ComputeElasticityTensor
    block = 2
    C_ijkl = '379.3 0.1'
    fill_method = symmetric_isotropic_E_nu
  [../]
  [./elasticity_tensor2]
    type = ComputeElasticityTensor
    block = 1
    C_ijkl = '68.3 0.3'
    fill_method = symmetric_isotropic_E_nu
  [../]
  [./stress]
    type = ComputeLinearElasticStress
  [../]
  [./strain_energy]
    type = StrainEnergyDensity
    incremental = false
  [../]
  # [./eigen]
  #   type = ComputeEigenstrain
  #   eigenstrain_name = eigen
  #   eigen_base = '0.001 0.0 0.0 0.0 0.0 0.0'
  # [../]
[]

[Postprocessors]
  [./n_elements]
    type = NumElems
    execute_on = 'initial timestep_end'
  [../]
  [./n_nodes]
    type = NumNodes
    execute_on = 'initial timestep_end'
  [../]
  [./DOFs]
    type = NumDOFs
    system = NL
  [../]
  [./C11]
    type = ElementAverageValue
    variable = C11
  [../]
  [./C11_error]
    type = ElementL2Error
    variable = C11
    # block = 1
    function=C11_calc
  [../]
  [./C12]
    type = ElementAverageValue
    variable = C12
  [../]
  [./C12_error]
    type = ElementL2Error
    variable = C12
    # block = 1
    function=C12_calc
  [../]
  [./C13]
    type = ElementAverageValue
    variable = C13
  [../]
  [./C22]
    type = ElementAverageValue
    variable = C22
  [../]
  [./C23]
    type = ElementAverageValue
    variable = C23
  [../]
  [./C33]
    type = ElementAverageValue
    variable = C33
  [../]
  [./C44]
    type = ElementAverageValue
    variable = C44
  [../]
  [./C55]
    type = ElementAverageValue
    variable = C55
  [../]
  [./C66]
    type = ElementAverageValue
    variable = C66
  [../]
  [./C66_error]
    type = ElementL2Error
    variable = C66
    # block = 1
    function=C66_calc
  [../]
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
  [./strain_energy]
    type = ElementIntegralMaterialProperty
    mat_prop = strain_energy_density
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
  [./run_time]
    type = PerfGraphData
    section_name = "Root"
    data_type = total
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
  scheme = bdf2
  solve_type = 'PJFNK'

  # line_search = basic
  # petsc_options_iname = '-pc_type'
  # petsc_options_value = 'lu'
  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   ilu      1'
  # petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type'
  # petsc_options_value = '70 hypre boomeramg'

  l_max_its = 30
  nl_max_its = 12

  l_tol = 1.0e-4

  nl_rel_tol = 1.0e-6
  nl_abs_tol = 1.0e-8

  start_time = 0.0
  num_steps = 1
  dt = 1.0
[]

[Outputs]
  file_base = square_hex8_coarse1_xx_test_out
  csv = true
  perf_graph = true
  [./exo]
    type = Exodus
    elemental_as_nodal = true
  [../]
[]

[Debug]
  show_var_residual_norms = true
[../]
