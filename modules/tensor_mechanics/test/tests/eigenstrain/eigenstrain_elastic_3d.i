[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  volumetric_locking_correction = false
[]

[Mesh]
  type = FileMesh
  file = cylinder.e
  # uniform_refine = 1
[]

[Functions]
  [./exponential1]
    type = ParsedFunction
    value = 'r:=sqrt(x^2+y^2); if(r>0.01, 0.01*exp(1-1/r), 0)'
  [../]
  [./exponential2]
    type = ParsedFunction
    value = 'r:=sqrt(x^2+y^2); 0.01*exp(-r)'
  [../]
[]

[AuxVariables]
  [./effective_strain]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./hoop_stress]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./vol_strain]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./exx]
    order = FIRST
    family = MONOMIAL
  [../]
  [./eyy]
    order = FIRST
    family = MONOMIAL
  [../]
  [./ezz]
    order = FIRST
    family = MONOMIAL
  [../]
[]

[Modules]
  [./TensorMechanics]
    [./Master]
      [./all]
        add_variables = true
        strain = SMALL
        eigenstrain_names = 'eigenstrain'
        generate_output = 'strain_xx strain_yy strain_zz stress_xx stress_yy stress_zz vonmises_stress hydrostatic_stress'
      [../]
    [../]
  [../]
[]

[AuxKernels]
  [./hoop_stress]
    type = RankTwoScalarAux
    variable = hoop_stress
    rank_two_tensor = stress
    scalar_type = HoopStress
    point1 = '0 0 0'
    point2 = '0 1 0'
    direction = '0 0 1'
  [../]
  [./exx]
    type = RankTwoAux
    variable = exx
    rank_two_tensor = eigenstrain
    index_i = 0
    index_j = 0
  [../]
  [./eyy]
    type = RankTwoAux
    variable = eyy
    rank_two_tensor = eigenstrain
    index_i = 1
    index_j = 1
  [../]
  [./ezz]
    type = RankTwoAux
    variable = eyy
    rank_two_tensor = eigenstrain
    index_i = 2
    index_j = 2
  [../]
  [./effective_strain]
    type = RankTwoScalarAux
    variable = effective_strain
    rank_two_tensor = total_strain
    scalar_type = EffectiveStrain
  [../]
  [./vol_strain]
    type = RankTwoScalarAux
    variable = vol_strain
    rank_two_tensor = total_strain
    scalar_type = VolumetricStrain
    point1 = '0 0 0'
    point2 = '0 1 0'
    direction = '0 0 1'
  [../]
[]

[BCs]
  [./no_x]
    type = PresetBC
    variable = disp_x
    boundary = 200
    value = 0.0
  [../]
  [./no_y]
    type = PresetBC
    variable = disp_y
    boundary = 200
    value = 0.0
  [../]
  [./no_z]
    type = PresetBC
    variable = disp_z
    boundary = 3
    value = 0.0
  [../]
[]


[Materials]
  [./stress]
    type = ComputeLinearElasticStress
    block = 1
  [../]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 2000
    poissons_ratio = 0.3
    block = 1
  [../]
  [./reduced_order_eigenstrain]
    type = ComputeIncrementalEigenstrain
    eigenstrain_name = 'eigenstrain'
    eigenstrain_rate_functions = 'exponential1'
    block = 1
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
  solve_type = 'PJFNK'
  scheme = bdf2
  # petsc_options_iname = '-pc_type -pc_asm_overlap -sub_pc_type -ksp_type -ksp_gmres_restart'
  # petsc_options_value = ' asm      2              ilu            gmres     200             '
  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type'
  petsc_options_value = '70 hypre boomeramg'
  # l_max_its = 20
  num_steps = 10
  nl_rel_tol = 1e-8
  l_tol = 1e-04
  nl_abs_tol = 1e-10
[]

[Postprocessors]
  [./vol_avg_side]
    type = SideAverageValue
    boundary = 1
    variable = vol_strain
  [../]
  [./vol_avg_top]
    type = SideAverageValue
    boundary = 1
    variable = vol_strain
  [../]
  [./dz_top_avg]
    type = SideAverageValue
    boundary = 2
    variable = disp_z
  [../]
  [./dx_max]
    type = NodalMaxValue
    variable = disp_x
  [../]
  [./dy_max]
    type = NodalMaxValue
    variable = disp_y
  [../]
  [./dz_max]
    type = NodalMaxValue
    variable = disp_z
  [../]
  [./ex_right]
    type = SideAverageValue
    boundary = 1
    variable = strain_xx
  [../]
  [./ez_top]
    type = SideAverageValue
    boundary = 2
    variable = strain_zz
  [../]
  [./ey_side]
    type = SideAverageValue
    boundary = 1
    variable = strain_yy
  [../]
  [./ex_max]
    type = ElementExtremeValue
    variable = strain_xx
  [../]
  [./ez_max]
    type = ElementExtremeValue
    variable = strain_zz
  [../]
  [./ey_max]
    type = ElementExtremeValue
    variable = strain_yy
  [../]
[]

# [VectorPostprocessors]
# [./d_x]
#   type = LineValueSampler
#
# []

[Outputs]
  exodus = true
  csv = true
  file_base = exp1_3D
  gnuplot = true
[]
