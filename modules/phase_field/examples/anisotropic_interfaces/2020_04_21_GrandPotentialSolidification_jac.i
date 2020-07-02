[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 20
  ny = 20
  xmin = -10
  xmax = 10
  ymin = -10
  ymax = 10
  elem_type = QUAD4
  # uniform_refine =
[]

[Variables]
  # [./w]
  #   # scaling = 10
  # [../]
  [./etaa0]
  [../]
  # [./etaa1]
  # [../]
  [./etab0]
  [../]
  # [./T]
  # [../]
[]

# [GlobalParams]
#   radius = 0.5
#   int_width = 0.2
#   x1 = 0.0
#   y1 = 0.0
#   # derivative_order = 2
# []

[ICs]
  [./etaa0]
    type = RandomIC
    variable = etaa0
  [../]
  [./etab0]
    type = RandomIC
    variable = etab0
  [../]
  # [./etaa0]
  #   type = SmoothCircleIC
  #   variable = etaa0
  #   #Solid phase
  #   outvalue = 0.0
  #   invalue = 1.0
  # [../]
  # [./etab0]
  #   type = SmoothCircleIC
  #   variable = etab0
  #   #Liquid phase
  #   outvalue = 1.0
  #   invalue = 0.0
  # [../]
[]

[Kernels]
  # [./ACa0_int1]
  #   type = ACInterface2DMultiPhase1
  #   variable = etaa0
  #   etas = 'etab0 '
  #   # args = 'etaa1 etab0'
  #   kappa_name = kappaa
  #   dkappadgrad_etaa_name = dkappadgrad_etaa
  #   d2kappadgrad_etaa_name = d2kappadgrad_etaa
  #   variable_L = false
  # [../]
  [./ACa0_int2]
    type = ACInterface2DMultiPhase2
    variable = etaa0
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    args = ' etab0 '
    variable_L = false
  [../]
  # [./ea0_dot]
  #   type = TimeDerivative
  #   variable = etaa0
  # [../]
  [./etaa0_kappa]
    type = ACKappaFunction
    variable = etaa0
    mob_name = L
    kappa_name = kappaa
    v = ' etab0'
  [../]
# Order parameter eta_beta0
  # [./ACb0_int1]
  #   type = ACInterface2DMultiPhase1
  #   variable = etab0
  #   etas = 'etaa0 '
  #   # args = 'etaa0 etaa1'
  #   kappa_name = kappab
  #   dkappadgrad_etaa_name = dkappadgrad_etab
  #   d2kappadgrad_etaa_name = d2kappadgrad_etab
  #   variable_L = false
  # [../]
  # [./ACb0_int2]
  #   type = ACInterface2DMultiPhase2
  #   variable = etab0
  #   kappa_name = kappab
  #   dkappadgrad_etaa_name = dkappadgrad_etab
  #   args = 'etaa0 '
  #   variable_L = false
  # [../]
  [./eb0_dot]
    type = TimeDerivative
    variable = etab0
  [../]
  # [./etab0_kappa]
  #   type = ACKappaFunction
  #   variable = etab0
  #   mob_name = L
  #   kappa_name = kappab
  #   v = ' etaa0'
  # [../]
[]

[Materials]

  [./kappaa]
    type = InterfaceOrientationMultiphaseMaterial2
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    d2kappadgrad_etaa_name = d2kappadgrad_etaa
    etaa = etaa0
    etab = '  etab0'
    reference_angle = 0
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    # outputs = exodus
    # output_properties = 'kappaa'
  [../]
  [./kappaa1]
    type = InterfaceOrientationMultiphaseMaterial2
    kappa_name = kappaa1
    dkappadgrad_etaa_name = dkappadgrad_etaa1
    d2kappadgrad_etaa_name = d2kappadgrad_etaa1
    etaa = etaa0
    etab = 'etab0'
    anisotropy_strength = 0.05
    kappa_bar = 0.05
    reference_angle = 0
    # outputs = exodus
    # output_properties = 'kappaa1'
  [../]
  [./kappab]
    type = InterfaceOrientationMultiphaseMaterial2
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
    d2kappadgrad_etaa_name = d2kappadgrad_etab
    etaa = etab0
    etab = 'etaa0 '
    anisotropy_strength = 0.05
    reference_angle = 0
    kappa_bar = 0.05
    # outputs = exodus
    output_properties = 'kappab'
  [../]
  [./const]
    type = GenericConstantMaterial
    prop_names =  'L     D    chi  Vm   ka    caeq kb    cbeq  gab mu   S   Tm   kappa'
    prop_values = '333.33 1.0  0.1  1.0  10.0  0.1  10.0  0.9   4.5 10.0 1.0 1.0  0.1'
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
  solve_type = PJFNK
  # automatic_scaling = true
  # line_search = basic
  # petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_factor_shift_type'
  # petsc_options_value = 'hypre    boomeramg      31 nonzero'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist'
  # petsc_options_iname = '-pc_type -pc_factor_shift_type'
  # petsc_options_value = 'lu       nonzero '
  # petsc_options = '-ksp_converged_reason -snes_converged_reason -snes_linesearch_monitor -ksp_monitor_true_residual'

  # petsc_options = '-ksp_monitor_true_residual'
  # petsc_options_iname = '-ksp_gmres_restart -pc_type -mg_levels_pc_type -mg_levels_sub_pc_type -ksp_type -mg_levels_ksp_type -mat_mffd_type -mat_mffd_err'
  # petsc_options_value = '201                hmg      bjacobi            sor                    fgmres    gmres               ds             1e-4'
  # automatic_scaling = true

  l_tol = 1.0e-3
  l_max_its = 20
  nl_max_its = 20
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-8
  end_time = 20.0
  dt = 0.001
[]
