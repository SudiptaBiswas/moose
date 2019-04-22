[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 50
  ny = 50
  xmin = 0
  xmax = 500
  ymin = 0
  ymax = 500
  uniform_refine = 2
[]

[GlobalParams]
  radius = 20
  int_width = 2.32
  x1 = 0
  y1 = 0
  derivative_order = 2
[]

[Variables]
  [./w]
  [../]
  [./etaa0]
  [../]
  [./etab0]
  [../]
[]

[AuxVariables]
  [./bnds]
  [../]
  [./T]
    [./InitialCondition]
      type = ConstantIC
      value = 1710
    [../]
  [../]
[]

[AuxKernels]
  [./bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'etaa0 etab0'
  [../]
[]

[ICs]
  [./w]
    type = SmoothCircleIC
    variable = w
    # note w = A*(c-cleq), A = 1.0, cleq = 0.0 ,i.e., w = c (in the matrix/liquid phase)
    outvalue = -4.9e-4
    invalue = -5.135e-4
  [../]
  [./etaa0]
    type = SmoothCircleIC
    variable = etaa0
    #Solid phase
    outvalue = 0.0
    invalue = 1.0
  [../]
  [./etab0]
    type = SmoothCircleIC
    variable = etab0
    #Liquid phase
    outvalue = 1.0
    invalue = 0.0
  [../]
[]

[BCs]
  # [./Periodic]
  #   [./all]
  #     auto_direction = 'x y'
  #   [../]
  # [../]
[]

[Kernels]
# Order parameter eta_alpha0
  [./ACa0_bulk]
    type = ACGrGrMulti
    variable = etaa0
    v =           'etab0'
    gamma_names = 'gab'
  [../]
  [./ACa0_sw]
    type = ACSwitching
    variable = etaa0
    Fj_names  = 'omegas omegal'
    hj_names  = 'ha     hb'
    args = 'etab0 w'
  [../]
  [./ACa0_int1]
    type = ACInterface2DMultiPhase1
    variable = etaa0
    etas = 'etab0'
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    d2kappadgrad_etaa_name = d2kappadgrad_etaa
  [../]
  [./ACa0_int2]
    type = ACInterface2DMultiPhase2
    variable = etaa0
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
  [../]
  [./ea0_dot]
    type = TimeDerivative
    variable = etaa0
  [../]
# Order parameter eta_beta0
  [./ACb0_bulk]
    type = ACGrGrMulti
    variable = etab0
    v =           'etaa0'
    gamma_names = 'gab'
  [../]
  [./ACb0_sw]
    type = ACSwitching
    variable = etab0
    Fj_names  = 'omegas omegal'
    hj_names  = 'ha     hb'
    args = 'etaa0 w'
  [../]
  [./ACb0_int1]
    type = ACInterface2DMultiPhase1
    variable = etab0
    etas = 'etaa0'
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
    d2kappadgrad_etaa_name = d2kappadgrad_etab
  [../]
  [./ACb0_int2]
    type = ACInterface2DMultiPhase2
    variable = etab0
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
  [../]
  [./eb0_dot]
    type = TimeDerivative
    variable = etab0
  [../]
#Chemical potential
  [./w_dot]
    type = SusceptibilityTimeDerivative
    variable = w
    f_name = chi
  [../]
  [./Diffusion]
    type = MatDiffusion
    variable = w
    D_name = Dchi
  [../]
  [./coupled_etaa0dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etaa0
    Fj_names = 'rhos rhol'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0'
  [../]
  [./coupled_etab0dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etab0
    Fj_names = 'rhos rhol'
    hj_names = 'ha   hb'
    args = 'etaa0 etab0'
  [../]
[]

[Materials]
  [./ha]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = ha
    all_etas = 'etaa0 etab0'
    phase_etas = 'etaa0'
  [../]
  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'etaa0 etab0'
    phase_etas = 'etab0'
  [../]
  # [./Es]
  #   type = DerivativeParsedMaterial
  #   args = 'w T'
  #   f_name = Es
  #   material_property_names = 'Vm'
  #   constant_names = 'Tm_cu Tm_Ni L_ni L_cu'
  #   constant_expressions = '1358 1728 0.147 0.108'
  #   function = 'Vm*(L_cu/Tm_cu*(T-Tm_cu)-L_ni/Tm_Ni*(T-Tm_Ni))'
  # [../]
  [./omegas]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = omegas
    material_property_names = 'Vm kB Es fsni'
    function = 'fsni-kB*T/Vm*plog(1+exp((w-Es)/kB/T),1e-2)'
  [../]
  [./omegal]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = omegal
    material_property_names = 'Vm kB'
    function = '-kB*T/Vm*plog(1+exp(w/kB/T),1e-2)'
  [../]
  [./rhos]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = rhos
    material_property_names = 'Vm kB Es'
    function = '1.0/Vm*exp((w-Es)/kB/T)/(1+exp((w-Es)/kB/T))'
  [../]
  [./rhol]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = rhol
    material_property_names = 'Vm kB'
    function = '1.0/Vm*exp(w/kB/T)/(1+exp(w/kB/T))'
  [../]
  [./chis]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = chis
    material_property_names = 'Vm kB Es'
    function = '1.0/Vm/T/kB*exp((w-Es)/kB/T)/(1+exp((w-Es)/kB/T))/(1+exp((w-Es)/kB/T))'
  [../]
  [./chil]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = chil
    material_property_names = 'Vm kB'
    function = '1.0/Vm/T/kB*exp((w)/kB/T)/(1+exp((w)/kB/T))/(1+exp((w)/kB/T))'
  [../]
  [./chi]
    type = DerivativeParsedMaterial
    args = 'w T'
    f_name = chi
    material_property_names = 'chis chil ha hb'
    function = 'ha*chis+hb*chil'
  [../]
  [./kappaa]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappaa
    dkappadgrad_etaa_name = dkappadgrad_etaa
    d2kappadgrad_etaa_name = d2kappadgrad_etaa
    etaa = etaa0
    etab = etab0
    anisotropy_strength = 0.05
    kappa_bar = 0.0224
    outputs = exodus
    output_properties = 'kappaa'
  [../]
  [./kappab]
    type = InterfaceOrientationMultiphaseMaterial
    kappa_name = kappab
    dkappadgrad_etaa_name = dkappadgrad_etab
    d2kappadgrad_etaa_name = d2kappadgrad_etab
    etaa = etab0
    etab = etaa0
    anisotropy_strength = 0.05
    kappa_bar = 0.0224
    outputs = exodus
    output_properties = 'kappab'
  [../]
  [./const]
    type = GenericConstantMaterial
    # prop_names =  'L    D    Vm       kB         caeq       cbeq      mu    gab '
    # prop_values = '0.1 1.0 1.23  8.62e-1   0.045988   0.058098 1.79 1.5'
    # prop_names =  'L      D    Vm       ka       kB   gab   mu    fsni       Es'
    # prop_values = '0.1 0.1  1.232e-7 1.38e-9 1.38e-9  1.5 0.287 -2.44  5.82e-7'
    prop_names =  'L    D    Vm       ka       kB       gab   mu    fsni       Es'
    prop_values = '0.01 0.01  0.01232 1.078e-7 1.078e-7  1.5 1.33e-4 -1.9124e-4  4.546e-5'
  [../]
  # [./diffusion]
  #   type = DerivativeParsedMaterial
  #   args = 'w'
  #   constant_names = 'Dl Ds'
  #   constant_expressions = ''
  # [../]

  [./Mobility]
    type = DerivativeParsedMaterial
    f_name = Dchi
    material_property_names = 'D chi'
    function = 'D*chi'
  [../]
[]

[Postprocessors]
  [./numDOFs]
    type = NumDOFs
  [../]
  # [./TotalEnergy]
  #   type = ElementIntegralVariablePostprocessor
  #   variable = total_energy
  # [../]
  [./dt]
    type = TimestepSize
  [../]
  [./Volume]
    type = VolumePostprocessor
    execute_on = initial
  [../]
  [./feature_counter]
    type = FeatureFloodCount
    variable = etaa0
    threshold = 0
    compute_var_to_feature_map = true
    use_displaced_mesh = false
    execute_on = timestep_end
  [../]
  [./VolumeFraction]
    type = FeatureVolumeFraction
    mesh_volume = Volume
    feature_volumes = feature_volumes
    use_displaced_mesh = false
    execute_on = timestep_end
  [../]
  [./interface]
    type = FindValueOnLine
    v = etaa0
    target = 0.5
    start_point = '0 0 0'
    end_point = '100 0 0'
    depth = 50
  [../]
[]

[VectorPostprocessors]
  [./feature_volumes]
    type = FeatureVolumeVectorPostprocessor
    flood_counter = feature_counter
    outputs = none
    execute_on = timestep_end
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
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_factor_shift_type  '
  petsc_options_value = 'hypre    boomeramg      31                  NONZERO'
  l_tol = 1.0e-3
  l_max_its = 30
  nl_max_its = 15
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-8
  end_time = 1000.0
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.001
    cutback_factor = 0.7
    growth_factor = 1.2
  [../]
[]

[Adaptivity]
 initial_steps = 5
 max_h_level = 3
 initial_marker = err_eta
 marker = err_bnds
[./Markers]
   [./err_eta]
     type = ErrorFractionMarker
     coarsen = 0.3
     refine = 0.95
     indicator = ind_eta
   [../]
   [./err_bnds]
     type = ErrorFractionMarker
     coarsen = 0.3
     refine = 0.95
     indicator = ind_bnds
   [../]
 [../]
 [./Indicators]
   [./ind_eta]
     type = GradientJumpIndicator
     variable = etaa0
    [../]
    [./ind_bnds]
      type = GradientJumpIndicator
      variable = bnds
   [../]
 [../]
[]

[Outputs]
  # interval = 10
  exodus = true
[]
