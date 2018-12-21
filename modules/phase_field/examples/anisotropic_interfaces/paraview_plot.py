# state file generated using paraview version 5.5.0

# ----------------------------------------------------------------
# setup views used in the visualization
# ----------------------------------------------------------------

# trace generated using paraview version 5.5.0

#### import the simple module from the paraview
from paraview.simple import *
#### disable automatic camera reset on 'Show'
paraview.simple._DisableFirstRenderCameraReset()

# Create a new 'Line Chart View'
lineChartView1 = CreateView('XYChartView')
lineChartView1.ViewSize = [1546, 1220]
lineChartView1.ChartTitle = 'Dendrite Growth'
lineChartView1.ChartTitleFontFamily = 'Times'
lineChartView1.ChartTitleFontFile = ''
lineChartView1.ChartTitleFontSize = 18
lineChartView1.LegendPosition = [1180, 1058]
lineChartView1.LegendFontFamily = 'Times'
lineChartView1.LeftAxisTitle = 'Order Parameter'
lineChartView1.LeftAxisTitleFontFamily = 'Times'
lineChartView1.LeftAxisTitleFontFile = ''
lineChartView1.LeftAxisTitleFontSize = 14
lineChartView1.LeftAxisUseCustomLabels = 1
lineChartView1.LeftAxisLabels = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
lineChartView1.LeftAxisLabelFontFamily = 'Times'
lineChartView1.LeftAxisLabelFontFile = ''
lineChartView1.BottomAxisTitle = 'Distance'
lineChartView1.BottomAxisTitleFontFamily = 'Times'
lineChartView1.BottomAxisTitleFontFile = ''
lineChartView1.BottomAxisTitleFontSize = 14
lineChartView1.BottomAxisUseCustomRange = 1
lineChartView1.BottomAxisRangeMaximum = 60.0
lineChartView1.BottomAxisUseCustomLabels = 1
lineChartView1.BottomAxisLabels = [0.0, 0.0, 5.0, 10.0, 15.0, 20.0, 25.0, 30.0, 35.0, 40.0, 45.0, 50.0, 55.0, 60.0]
lineChartView1.BottomAxisLabelFontFamily = 'Times'
lineChartView1.BottomAxisLabelFontFile = ''
lineChartView1.RightAxisRangeMaximum = 6.66
lineChartView1.RightAxisLabelFontFile = ''
lineChartView1.TopAxisTitleFontFile = ''
lineChartView1.TopAxisRangeMaximum = 6.66
lineChartView1.TopAxisLabelFontFamily = 'Times'
lineChartView1.TopAxisLabelFontFile = ''

# get the material library
materialLibrary1 = GetMaterialLibrary()

# Create a new 'Render View'
renderView1 = CreateView('RenderView')
renderView1.ViewSize = [1546, 1220]
renderView1.AnnotationColor = [0.0, 0.0, 0.0]
renderView1.InteractionMode = '2D'
renderView1.AxesGrid = 'GridAxes3DActor'
renderView1.OrientationAxesVisibility = 0
renderView1.OrientationAxesLabelColor = [0.0, 0.0, 0.0]
renderView1.StereoType = 0
renderView1.CameraPosition = [0.0, 0.0, 109.2820323027551]
renderView1.CameraParallelScale = 28.284271247461902
renderView1.Background = [1.0, 1.0, 1.0]
renderView1.OSPRayMaterialLibrary = materialLibrary1

# init the 'GridAxes3DActor' selected for 'AxesGrid'
renderView1.AxesGrid.XTitleColor = [0.0, 0.0, 0.0]
renderView1.AxesGrid.XTitleFontFile = ''
renderView1.AxesGrid.YTitleColor = [0.0, 0.0, 0.0]
renderView1.AxesGrid.YTitleFontFile = ''
renderView1.AxesGrid.ZTitleColor = [0.0, 0.0, 0.0]
renderView1.AxesGrid.ZTitleFontFile = ''
renderView1.AxesGrid.XLabelColor = [0.0, 0.0, 0.0]
renderView1.AxesGrid.XLabelFontFile = ''
renderView1.AxesGrid.YLabelColor = [0.0, 0.0, 0.0]
renderView1.AxesGrid.YLabelFontFile = ''
renderView1.AxesGrid.ZLabelColor = [0.0, 0.0, 0.0]
renderView1.AxesGrid.ZLabelFontFile = ''

# ----------------------------------------------------------------
# restore active view
SetActiveView(lineChartView1)
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# setup the data processing pipelines
# ----------------------------------------------------------------

# create a new 'ExodusIIReader'
dendrite_growth_orientatione = ExodusIIReader(FileName=['/Users/bisws/Programs/moose/modules/phase_field/examples/anisotropic_interfaces/dendrite_growth_orientation.e'])
dendrite_growth_orientatione.ElementVariables = ['EFM_3', 'EFM_4', 'GJI_3', 'GJI_4', 'D', 'Dchi', 'L', 'S', 'Tm', 'Vm', 'caeq', 'cbeq', 'chi', 'gab', 'ha', 'hb', 'ka', 'kappa_c', 'kappaa', 'kappab', 'kb', 'mu', 'omegaa', 'omegab', 'rhoa', 'rhob']
dendrite_growth_orientatione.PointVariables = ['T', 'bnds', 'etaa0', 'etab0', 'w']
dendrite_growth_orientatione.GlobalVariables = ['active_time', 'alive_time', 'elapsed', 'etaa0', 'memory', 'ndof', 'w']
dendrite_growth_orientatione.NodeSetArrayStatus = []
dendrite_growth_orientatione.SideSetArrayStatus = []
dendrite_growth_orientatione.ElementBlocks = ['Unnamed block ID: 0 Type: QUAD4']

# create a new 'Plot Over Line'
plotOverLine4 = PlotOverLine(Input=dendrite_growth_orientatione,
    Source='High Resolution Line Source')

# init the 'High Resolution Line Source' selected for 'Source'
plotOverLine4.Source.Point1 = [0.0, -20.0, 0.0]
plotOverLine4.Source.Point2 = [0.0, 20.0, 0.0]

# create a new 'Annotate Time Filter'
annotateTimeFilter1 = AnnotateTimeFilter(Input=dendrite_growth_orientatione)
annotateTimeFilter1.Format = 'Time: %2f'

# create a new 'Plot Over Line'
plotOverLine1 = PlotOverLine(Input=dendrite_growth_orientatione,
    Source='High Resolution Line Source')

# init the 'High Resolution Line Source' selected for 'Source'
plotOverLine1.Source.Point1 = [-20.0, -20.0, 0.0]
plotOverLine1.Source.Point2 = [20.0, 20.0, 0.0]

# create a new 'Plot Over Line'
plotOverLine2 = PlotOverLine(Input=dendrite_growth_orientatione,
    Source='High Resolution Line Source')

# init the 'High Resolution Line Source' selected for 'Source'
plotOverLine2.Source.Point1 = [-20.0, 20.0, 0.0]
plotOverLine2.Source.Point2 = [20.0, -20.0, 0.0]

# create a new 'Plot Over Line'
plotOverLine3 = PlotOverLine(Input=dendrite_growth_orientatione,
    Source='High Resolution Line Source')

# init the 'High Resolution Line Source' selected for 'Source'
plotOverLine3.Source.Point1 = [-20.0, 0.0, 0.0]
plotOverLine3.Source.Point2 = [20.0, 0.0, 0.0]

# ----------------------------------------------------------------
# setup the visualization in view 'lineChartView1'
# ----------------------------------------------------------------

# show data from plotOverLine1
plotOverLine1Display = Show(plotOverLine1, lineChartView1)

# trace defaults for the display properties.
plotOverLine1Display.CompositeDataSetIndex = [0]
plotOverLine1Display.UseIndexForXAxis = 0
plotOverLine1Display.XArrayName = 'arc_length'
plotOverLine1Display.SeriesVisibility = ['etaa0']
plotOverLine1Display.SeriesLabel = ['arc_length', 'arc_length', 'bnds', 'bnds', 'caeq', 'caeq', 'cbeq', 'cbeq', 'chi', 'chi', 'D', 'D', 'Dchi', 'Dchi', 'EFM_3', 'EFM_3', 'EFM_4', 'EFM_4', 'etaa0', 'Diagonal Starting bottom-left', 'etab0', 'etab0', 'gab', 'gab', 'GJI_3', 'GJI_3', 'GJI_4', 'GJI_4', 'ha', 'ha', 'hb', 'hb', 'ka', 'ka', 'kappa_c', 'kappa_c', 'kappaa', 'kappaa', 'kappab', 'kappab', 'kb', 'kb', 'L', 'L', 'mu', 'mu', 'ObjectId', 'ObjectId', 'omegaa', 'omegaa', 'omegab', 'omegab', 'rhoa', 'rhoa', 'rhob', 'rhob', 'S', 'S', 'T', 'T', 'Tm', 'Tm', 'Vm', 'Vm', 'vtkValidPointMask', 'vtkValidPointMask', 'w', 'w', 'Points_X', 'Points_X', 'Points_Y', 'Points_Y', 'Points_Z', 'Points_Z', 'Points_Magnitude', 'Points_Magnitude']
plotOverLine1Display.SeriesColor = ['arc_length', '0', '0', '0', 'bnds', '0.889998', '0.100008', '0.110002', 'caeq', '0.220005', '0.489998', '0.719997', 'cbeq', '0.300008', '0.689998', '0.289998', 'chi', '0.6', '0.310002', '0.639994', 'D', '1', '0.500008', '0', 'Dchi', '0.650004', '0.340002', '0.160006', 'EFM_3', '0', '0', '0', 'EFM_4', '0.889998', '0.100008', '0.110002', 'etaa0', '0.333333', '0.666667', '0', 'etab0', '0.300008', '0.689998', '0.289998', 'gab', '0.6', '0.310002', '0.639994', 'GJI_3', '1', '0.500008', '0', 'GJI_4', '0.650004', '0.340002', '0.160006', 'ha', '0', '0', '0', 'hb', '0.889998', '0.100008', '0.110002', 'ka', '0.220005', '0.489998', '0.719997', 'kappa_c', '0.300008', '0.689998', '0.289998', 'kappaa', '0.6', '0.310002', '0.639994', 'kappab', '1', '0.500008', '0', 'kb', '0.650004', '0.340002', '0.160006', 'L', '0', '0', '0', 'mu', '0.889998', '0.100008', '0.110002', 'ObjectId', '0.220005', '0.489998', '0.719997', 'omegaa', '0.300008', '0.689998', '0.289998', 'omegab', '0.6', '0.310002', '0.639994', 'rhoa', '1', '0.500008', '0', 'rhob', '0.650004', '0.340002', '0.160006', 'S', '0', '0', '0', 'T', '0.889998', '0.100008', '0.110002', 'Tm', '0.220005', '0.489998', '0.719997', 'Vm', '0.300008', '0.689998', '0.289998', 'vtkValidPointMask', '0.6', '0.310002', '0.639994', 'w', '1', '0.500008', '0', 'Points_X', '0.650004', '0.340002', '0.160006', 'Points_Y', '0', '0', '0', 'Points_Z', '0.889998', '0.100008', '0.110002', 'Points_Magnitude', '0.220005', '0.489998', '0.719997']
plotOverLine1Display.SeriesPlotCorner = ['D', '0', 'Dchi', '0', 'EFM_3', '0', 'EFM_4', '0', 'GJI_3', '0', 'GJI_4', '0', 'L', '0', 'ObjectId', '0', 'Points_Magnitude', '0', 'Points_X', '0', 'Points_Y', '0', 'Points_Z', '0', 'S', '0', 'T', '0', 'Tm', '0', 'Vm', '0', 'arc_length', '0', 'bnds', '0', 'caeq', '0', 'cbeq', '0', 'chi', '0', 'etaa0', '0', 'etab0', '0', 'gab', '0', 'ha', '0', 'hb', '0', 'ka', '0', 'kappa_c', '0', 'kappaa', '0', 'kappab', '0', 'kb', '0', 'mu', '0', 'omegaa', '0', 'omegab', '0', 'rhoa', '0', 'rhob', '0', 'vtkValidPointMask', '0', 'w', '0']
plotOverLine1Display.SeriesLabelPrefix = ''
plotOverLine1Display.SeriesLineStyle = ['D', '1', 'Dchi', '1', 'EFM_3', '1', 'EFM_4', '1', 'GJI_3', '1', 'GJI_4', '1', 'L', '1', 'ObjectId', '1', 'Points_Magnitude', '1', 'Points_X', '1', 'Points_Y', '1', 'Points_Z', '1', 'S', '1', 'T', '1', 'Tm', '1', 'Vm', '1', 'arc_length', '1', 'bnds', '1', 'caeq', '1', 'cbeq', '1', 'chi', '1', 'etaa0', '1', 'etab0', '1', 'gab', '1', 'ha', '1', 'hb', '1', 'ka', '1', 'kappa_c', '1', 'kappaa', '1', 'kappab', '1', 'kb', '1', 'mu', '1', 'omegaa', '1', 'omegab', '1', 'rhoa', '1', 'rhob', '1', 'vtkValidPointMask', '1', 'w', '1']
plotOverLine1Display.SeriesLineThickness = ['D', '2', 'Dchi', '2', 'EFM_3', '2', 'EFM_4', '2', 'GJI_3', '2', 'GJI_4', '2', 'L', '2', 'ObjectId', '2', 'Points_Magnitude', '2', 'Points_X', '2', 'Points_Y', '2', 'Points_Z', '2', 'S', '2', 'T', '2', 'Tm', '2', 'Vm', '2', 'arc_length', '2', 'bnds', '2', 'caeq', '2', 'cbeq', '2', 'chi', '2', 'etaa0', '4', 'etab0', '2', 'gab', '2', 'ha', '2', 'hb', '2', 'ka', '2', 'kappa_c', '2', 'kappaa', '2', 'kappab', '2', 'kb', '2', 'mu', '2', 'omegaa', '2', 'omegab', '2', 'rhoa', '2', 'rhob', '2', 'vtkValidPointMask', '2', 'w', '2']
plotOverLine1Display.SeriesMarkerStyle = ['D', '0', 'Dchi', '0', 'EFM_3', '0', 'EFM_4', '0', 'GJI_3', '0', 'GJI_4', '0', 'L', '0', 'ObjectId', '0', 'Points_Magnitude', '0', 'Points_X', '0', 'Points_Y', '0', 'Points_Z', '0', 'S', '0', 'T', '0', 'Tm', '0', 'Vm', '0', 'arc_length', '0', 'bnds', '0', 'caeq', '0', 'cbeq', '0', 'chi', '0', 'etaa0', '0', 'etab0', '0', 'gab', '0', 'ha', '0', 'hb', '0', 'ka', '0', 'kappa_c', '0', 'kappaa', '0', 'kappab', '0', 'kb', '0', 'mu', '0', 'omegaa', '0', 'omegab', '0', 'rhoa', '0', 'rhob', '0', 'vtkValidPointMask', '0', 'w', '0']

# show data from plotOverLine2
plotOverLine2Display = Show(plotOverLine2, lineChartView1)

# trace defaults for the display properties.
plotOverLine2Display.CompositeDataSetIndex = [0]
plotOverLine2Display.UseIndexForXAxis = 0
plotOverLine2Display.XArrayName = 'arc_length'
plotOverLine2Display.SeriesVisibility = ['etaa0']
plotOverLine2Display.SeriesLabel = ['arc_length', 'arc_length', 'bnds', 'bnds', 'caeq', 'caeq', 'cbeq', 'cbeq', 'chi', 'chi', 'D', 'D', 'Dchi', 'Dchi', 'EFM_3', 'EFM_3', 'EFM_4', 'EFM_4', 'etaa0', 'Diagonal starting top-left', 'etab0', 'etab0', 'gab', 'gab', 'GJI_3', 'GJI_3', 'GJI_4', 'GJI_4', 'ha', 'ha', 'hb', 'hb', 'ka', 'ka', 'kappa_c', 'kappa_c', 'kappaa', 'kappaa', 'kappab', 'kappab', 'kb', 'kb', 'L', 'L', 'mu', 'mu', 'ObjectId', 'ObjectId', 'omegaa', 'omegaa', 'omegab', 'omegab', 'rhoa', 'rhoa', 'rhob', 'rhob', 'S', 'S', 'T', 'T', 'Tm', 'Tm', 'Vm', 'Vm', 'vtkValidPointMask', 'vtkValidPointMask', 'w', 'w', 'Points_X', 'Points_X', 'Points_Y', 'Points_Y', 'Points_Z', 'Points_Z', 'Points_Magnitude', 'Points_Magnitude']
plotOverLine2Display.SeriesColor = ['arc_length', '0', '0', '0', 'bnds', '0.889998', '0.100008', '0.110002', 'caeq', '0.220005', '0.489998', '0.719997', 'cbeq', '0.300008', '0.689998', '0.289998', 'chi', '0.6', '0.310002', '0.639994', 'D', '1', '0.500008', '0', 'Dchi', '0.650004', '0.340002', '0.160006', 'EFM_3', '0', '0', '0', 'EFM_4', '0.889998', '0.100008', '0.110002', 'etaa0', '0.333333', '0', '0', 'etab0', '0.300008', '0.689998', '0.289998', 'gab', '0.6', '0.310002', '0.639994', 'GJI_3', '1', '0.500008', '0', 'GJI_4', '0.650004', '0.340002', '0.160006', 'ha', '0', '0', '0', 'hb', '0.889998', '0.100008', '0.110002', 'ka', '0.220005', '0.489998', '0.719997', 'kappa_c', '0.300008', '0.689998', '0.289998', 'kappaa', '0.6', '0.310002', '0.639994', 'kappab', '1', '0.500008', '0', 'kb', '0.650004', '0.340002', '0.160006', 'L', '0', '0', '0', 'mu', '0.889998', '0.100008', '0.110002', 'ObjectId', '0.220005', '0.489998', '0.719997', 'omegaa', '0.300008', '0.689998', '0.289998', 'omegab', '0.6', '0.310002', '0.639994', 'rhoa', '1', '0.500008', '0', 'rhob', '0.650004', '0.340002', '0.160006', 'S', '0', '0', '0', 'T', '0.889998', '0.100008', '0.110002', 'Tm', '0.220005', '0.489998', '0.719997', 'Vm', '0.300008', '0.689998', '0.289998', 'vtkValidPointMask', '0.6', '0.310002', '0.639994', 'w', '1', '0.500008', '0', 'Points_X', '0.650004', '0.340002', '0.160006', 'Points_Y', '0', '0', '0', 'Points_Z', '0.889998', '0.100008', '0.110002', 'Points_Magnitude', '0.220005', '0.489998', '0.719997']
plotOverLine2Display.SeriesPlotCorner = ['D', '0', 'Dchi', '0', 'EFM_3', '0', 'EFM_4', '0', 'GJI_3', '0', 'GJI_4', '0', 'L', '0', 'ObjectId', '0', 'Points_Magnitude', '0', 'Points_X', '0', 'Points_Y', '0', 'Points_Z', '0', 'S', '0', 'T', '0', 'Tm', '0', 'Vm', '0', 'arc_length', '0', 'bnds', '0', 'caeq', '0', 'cbeq', '0', 'chi', '0', 'etaa0', '0', 'etab0', '0', 'gab', '0', 'ha', '0', 'hb', '0', 'ka', '0', 'kappa_c', '0', 'kappaa', '0', 'kappab', '0', 'kb', '0', 'mu', '0', 'omegaa', '0', 'omegab', '0', 'rhoa', '0', 'rhob', '0', 'vtkValidPointMask', '0', 'w', '0']
plotOverLine2Display.SeriesLabelPrefix = ''
plotOverLine2Display.SeriesLineStyle = ['D', '1', 'Dchi', '1', 'EFM_3', '1', 'EFM_4', '1', 'GJI_3', '1', 'GJI_4', '1', 'L', '1', 'ObjectId', '1', 'Points_Magnitude', '1', 'Points_X', '1', 'Points_Y', '1', 'Points_Z', '1', 'S', '1', 'T', '1', 'Tm', '1', 'Vm', '1', 'arc_length', '1', 'bnds', '1', 'caeq', '1', 'cbeq', '1', 'chi', '1', 'etaa0', '2', 'etab0', '1', 'gab', '1', 'ha', '1', 'hb', '1', 'ka', '1', 'kappa_c', '1', 'kappaa', '1', 'kappab', '1', 'kb', '1', 'mu', '1', 'omegaa', '1', 'omegab', '1', 'rhoa', '1', 'rhob', '1', 'vtkValidPointMask', '1', 'w', '1']
plotOverLine2Display.SeriesLineThickness = ['D', '2', 'Dchi', '2', 'EFM_3', '2', 'EFM_4', '2', 'GJI_3', '2', 'GJI_4', '2', 'L', '2', 'ObjectId', '2', 'Points_Magnitude', '2', 'Points_X', '2', 'Points_Y', '2', 'Points_Z', '2', 'S', '2', 'T', '2', 'Tm', '2', 'Vm', '2', 'arc_length', '2', 'bnds', '2', 'caeq', '2', 'cbeq', '2', 'chi', '2', 'etaa0', '10', 'etab0', '2', 'gab', '2', 'ha', '2', 'hb', '2', 'ka', '2', 'kappa_c', '2', 'kappaa', '2', 'kappab', '2', 'kb', '2', 'mu', '2', 'omegaa', '2', 'omegab', '2', 'rhoa', '2', 'rhob', '2', 'vtkValidPointMask', '2', 'w', '2']
plotOverLine2Display.SeriesMarkerStyle = ['D', '0', 'Dchi', '0', 'EFM_3', '0', 'EFM_4', '0', 'GJI_3', '0', 'GJI_4', '0', 'L', '0', 'ObjectId', '0', 'Points_Magnitude', '0', 'Points_X', '0', 'Points_Y', '0', 'Points_Z', '0', 'S', '0', 'T', '0', 'Tm', '0', 'Vm', '0', 'arc_length', '0', 'bnds', '0', 'caeq', '0', 'cbeq', '0', 'chi', '0', 'etaa0', '0', 'etab0', '0', 'gab', '0', 'ha', '0', 'hb', '0', 'ka', '0', 'kappa_c', '0', 'kappaa', '0', 'kappab', '0', 'kb', '0', 'mu', '0', 'omegaa', '0', 'omegab', '0', 'rhoa', '0', 'rhob', '0', 'vtkValidPointMask', '0', 'w', '0']

# show data from plotOverLine3
plotOverLine3Display = Show(plotOverLine3, lineChartView1)

# trace defaults for the display properties.
plotOverLine3Display.CompositeDataSetIndex = [0]
plotOverLine3Display.UseIndexForXAxis = 0
plotOverLine3Display.XArrayName = 'arc_length'
plotOverLine3Display.SeriesVisibility = ['etaa0']
plotOverLine3Display.SeriesLabel = ['arc_length', 'arc_length', 'bnds', 'bnds', 'caeq', 'caeq', 'cbeq', 'cbeq', 'chi', 'chi', 'D', 'D', 'Dchi', 'Dchi', 'EFM_3', 'EFM_3', 'EFM_4', 'EFM_4', 'etaa0', 'Growth in x-direction', 'etab0', 'etab0', 'gab', 'gab', 'GJI_3', 'GJI_3', 'GJI_4', 'GJI_4', 'ha', 'ha', 'hb', 'hb', 'ka', 'ka', 'kappa_c', 'kappa_c', 'kappaa', 'kappaa', 'kappab', 'kappab', 'kb', 'kb', 'L', 'L', 'mu', 'mu', 'ObjectId', 'ObjectId', 'omegaa', 'omegaa', 'omegab', 'omegab', 'rhoa', 'rhoa', 'rhob', 'rhob', 'S', 'S', 'T', 'T', 'Tm', 'Tm', 'Vm', 'Vm', 'vtkValidPointMask', 'vtkValidPointMask', 'w', 'w', 'Points_X', 'Points_X', 'Points_Y', 'Points_Y', 'Points_Z', 'Points_Z', 'Points_Magnitude', 'Points_Magnitude']
plotOverLine3Display.SeriesColor = ['arc_length', '0', '0', '0', 'bnds', '0.889998', '0.100008', '0.110002', 'caeq', '0.220005', '0.489998', '0.719997', 'cbeq', '0.300008', '0.689998', '0.289998', 'chi', '0.6', '0.310002', '0.639994', 'D', '1', '0.500008', '0', 'Dchi', '0.650004', '0.340002', '0.160006', 'EFM_3', '0', '0', '0', 'EFM_4', '0.889998', '0.100008', '0.110002', 'etaa0', '0.333333', '0', '1', 'etab0', '0.300008', '0.689998', '0.289998', 'gab', '0.6', '0.310002', '0.639994', 'GJI_3', '1', '0.500008', '0', 'GJI_4', '0.650004', '0.340002', '0.160006', 'ha', '0', '0', '0', 'hb', '0.889998', '0.100008', '0.110002', 'ka', '0.220005', '0.489998', '0.719997', 'kappa_c', '0.300008', '0.689998', '0.289998', 'kappaa', '0.6', '0.310002', '0.639994', 'kappab', '1', '0.500008', '0', 'kb', '0.650004', '0.340002', '0.160006', 'L', '0', '0', '0', 'mu', '0.889998', '0.100008', '0.110002', 'ObjectId', '0.220005', '0.489998', '0.719997', 'omegaa', '0.300008', '0.689998', '0.289998', 'omegab', '0.6', '0.310002', '0.639994', 'rhoa', '1', '0.500008', '0', 'rhob', '0.650004', '0.340002', '0.160006', 'S', '0', '0', '0', 'T', '0.889998', '0.100008', '0.110002', 'Tm', '0.220005', '0.489998', '0.719997', 'Vm', '0.300008', '0.689998', '0.289998', 'vtkValidPointMask', '0.6', '0.310002', '0.639994', 'w', '1', '0.500008', '0', 'Points_X', '0.650004', '0.340002', '0.160006', 'Points_Y', '0', '0', '0', 'Points_Z', '0.889998', '0.100008', '0.110002', 'Points_Magnitude', '0.220005', '0.489998', '0.719997']
plotOverLine3Display.SeriesPlotCorner = ['D', '0', 'Dchi', '0', 'EFM_3', '0', 'EFM_4', '0', 'GJI_3', '0', 'GJI_4', '0', 'L', '0', 'ObjectId', '0', 'Points_Magnitude', '0', 'Points_X', '0', 'Points_Y', '0', 'Points_Z', '0', 'S', '0', 'T', '0', 'Tm', '0', 'Vm', '0', 'arc_length', '0', 'bnds', '0', 'caeq', '0', 'cbeq', '0', 'chi', '0', 'etaa0', '0', 'etab0', '0', 'gab', '0', 'ha', '0', 'hb', '0', 'ka', '0', 'kappa_c', '0', 'kappaa', '0', 'kappab', '0', 'kb', '0', 'mu', '0', 'omegaa', '0', 'omegab', '0', 'rhoa', '0', 'rhob', '0', 'vtkValidPointMask', '0', 'w', '0']
plotOverLine3Display.SeriesLabelPrefix = ''
plotOverLine3Display.SeriesLineStyle = ['D', '1', 'Dchi', '1', 'EFM_3', '1', 'EFM_4', '1', 'GJI_3', '1', 'GJI_4', '1', 'L', '1', 'ObjectId', '1', 'Points_Magnitude', '1', 'Points_X', '1', 'Points_Y', '1', 'Points_Z', '1', 'S', '1', 'T', '1', 'Tm', '1', 'Vm', '1', 'arc_length', '1', 'bnds', '1', 'caeq', '1', 'cbeq', '1', 'chi', '1', 'etaa0', '1', 'etab0', '1', 'gab', '1', 'ha', '1', 'hb', '1', 'ka', '1', 'kappa_c', '1', 'kappaa', '1', 'kappab', '1', 'kb', '1', 'mu', '1', 'omegaa', '1', 'omegab', '1', 'rhoa', '1', 'rhob', '1', 'vtkValidPointMask', '1', 'w', '1']
plotOverLine3Display.SeriesLineThickness = ['D', '2', 'Dchi', '2', 'EFM_3', '2', 'EFM_4', '2', 'GJI_3', '2', 'GJI_4', '2', 'L', '2', 'ObjectId', '2', 'Points_Magnitude', '2', 'Points_X', '2', 'Points_Y', '2', 'Points_Z', '2', 'S', '2', 'T', '2', 'Tm', '2', 'Vm', '2', 'arc_length', '2', 'bnds', '2', 'caeq', '2', 'cbeq', '2', 'chi', '2', 'etaa0', '4', 'etab0', '2', 'gab', '2', 'ha', '2', 'hb', '2', 'ka', '2', 'kappa_c', '2', 'kappaa', '2', 'kappab', '2', 'kb', '2', 'mu', '2', 'omegaa', '2', 'omegab', '2', 'rhoa', '2', 'rhob', '2', 'vtkValidPointMask', '2', 'w', '2']
plotOverLine3Display.SeriesMarkerStyle = ['D', '0', 'Dchi', '0', 'EFM_3', '0', 'EFM_4', '0', 'GJI_3', '0', 'GJI_4', '0', 'L', '0', 'ObjectId', '0', 'Points_Magnitude', '0', 'Points_X', '0', 'Points_Y', '0', 'Points_Z', '0', 'S', '0', 'T', '0', 'Tm', '0', 'Vm', '0', 'arc_length', '0', 'bnds', '0', 'caeq', '0', 'cbeq', '0', 'chi', '0', 'etaa0', '0', 'etab0', '0', 'gab', '0', 'ha', '0', 'hb', '0', 'ka', '0', 'kappa_c', '0', 'kappaa', '0', 'kappab', '0', 'kb', '0', 'mu', '0', 'omegaa', '0', 'omegab', '0', 'rhoa', '0', 'rhob', '0', 'vtkValidPointMask', '0', 'w', '0']

# show data from plotOverLine4
plotOverLine4Display = Show(plotOverLine4, lineChartView1)

# trace defaults for the display properties.
plotOverLine4Display.CompositeDataSetIndex = [0]
plotOverLine4Display.UseIndexForXAxis = 0
plotOverLine4Display.XArrayName = 'arc_length'
plotOverLine4Display.SeriesVisibility = ['etaa0']
plotOverLine4Display.SeriesLabel = ['arc_length', 'arc_length', 'bnds', 'bnds', 'caeq', 'caeq', 'cbeq', 'cbeq', 'chi', 'chi', 'D', 'D', 'Dchi', 'Dchi', 'EFM_3', 'EFM_3', 'EFM_4', 'EFM_4', 'etaa0', 'Growth in y-direction', 'etab0', 'etab0', 'gab', 'gab', 'GJI_3', 'GJI_3', 'GJI_4', 'GJI_4', 'ha', 'ha', 'hb', 'hb', 'ka', 'ka', 'kappa_c', 'kappa_c', 'kappaa', 'kappaa', 'kappab', 'kappab', 'kb', 'kb', 'L', 'L', 'mu', 'mu', 'ObjectId', 'ObjectId', 'omegaa', 'omegaa', 'omegab', 'omegab', 'rhoa', 'rhoa', 'rhob', 'rhob', 'S', 'S', 'T', 'T', 'Tm', 'Tm', 'Vm', 'Vm', 'vtkValidPointMask', 'vtkValidPointMask', 'w', 'w', 'Points_X', 'Points_X', 'Points_Y', 'Points_Y', 'Points_Z', 'Points_Z', 'Points_Magnitude', 'Points_Magnitude']
plotOverLine4Display.SeriesColor = ['arc_length', '0', '0', '0', 'bnds', '0.889998', '0.100008', '0.110002', 'caeq', '0.220005', '0.489998', '0.719997', 'cbeq', '0.300008', '0.689998', '0.289998', 'chi', '0.6', '0.310002', '0.639994', 'D', '1', '0.500008', '0', 'Dchi', '0.650004', '0.340002', '0.160006', 'EFM_3', '0', '0', '0', 'EFM_4', '0.889998', '0.100008', '0.110002', 'etaa0', '0.666667', '0', '0', 'etab0', '0.300008', '0.689998', '0.289998', 'gab', '0.6', '0.310002', '0.639994', 'GJI_3', '1', '0.500008', '0', 'GJI_4', '0.650004', '0.340002', '0.160006', 'ha', '0', '0', '0', 'hb', '0.889998', '0.100008', '0.110002', 'ka', '0.220005', '0.489998', '0.719997', 'kappa_c', '0.300008', '0.689998', '0.289998', 'kappaa', '0.6', '0.310002', '0.639994', 'kappab', '1', '0.500008', '0', 'kb', '0.650004', '0.340002', '0.160006', 'L', '0', '0', '0', 'mu', '0.889998', '0.100008', '0.110002', 'ObjectId', '0.220005', '0.489998', '0.719997', 'omegaa', '0.300008', '0.689998', '0.289998', 'omegab', '0.6', '0.310002', '0.639994', 'rhoa', '1', '0.500008', '0', 'rhob', '0.650004', '0.340002', '0.160006', 'S', '0', '0', '0', 'T', '0.889998', '0.100008', '0.110002', 'Tm', '0.220005', '0.489998', '0.719997', 'Vm', '0.300008', '0.689998', '0.289998', 'vtkValidPointMask', '0.6', '0.310002', '0.639994', 'w', '1', '0.500008', '0', 'Points_X', '0.650004', '0.340002', '0.160006', 'Points_Y', '0', '0', '0', 'Points_Z', '0.889998', '0.100008', '0.110002', 'Points_Magnitude', '0.220005', '0.489998', '0.719997']
plotOverLine4Display.SeriesPlotCorner = ['D', '0', 'Dchi', '0', 'EFM_3', '0', 'EFM_4', '0', 'GJI_3', '0', 'GJI_4', '0', 'L', '0', 'ObjectId', '0', 'Points_Magnitude', '0', 'Points_X', '0', 'Points_Y', '0', 'Points_Z', '0', 'S', '0', 'T', '0', 'Tm', '0', 'Vm', '0', 'arc_length', '0', 'bnds', '0', 'caeq', '0', 'cbeq', '0', 'chi', '0', 'etaa0', '0', 'etab0', '0', 'gab', '0', 'ha', '0', 'hb', '0', 'ka', '0', 'kappa_c', '0', 'kappaa', '0', 'kappab', '0', 'kb', '0', 'mu', '0', 'omegaa', '0', 'omegab', '0', 'rhoa', '0', 'rhob', '0', 'vtkValidPointMask', '0', 'w', '0']
plotOverLine4Display.SeriesLabelPrefix = ''
plotOverLine4Display.SeriesLineStyle = ['D', '1', 'Dchi', '1', 'EFM_3', '1', 'EFM_4', '1', 'GJI_3', '1', 'GJI_4', '1', 'L', '1', 'ObjectId', '1', 'Points_Magnitude', '1', 'Points_X', '1', 'Points_Y', '1', 'Points_Z', '1', 'S', '1', 'T', '1', 'Tm', '1', 'Vm', '1', 'arc_length', '1', 'bnds', '1', 'caeq', '1', 'cbeq', '1', 'chi', '1', 'etaa0', '2', 'etab0', '1', 'gab', '1', 'ha', '1', 'hb', '1', 'ka', '1', 'kappa_c', '1', 'kappaa', '1', 'kappab', '1', 'kb', '1', 'mu', '1', 'omegaa', '1', 'omegab', '1', 'rhoa', '1', 'rhob', '1', 'vtkValidPointMask', '1', 'w', '1']
plotOverLine4Display.SeriesLineThickness = ['D', '2', 'Dchi', '2', 'EFM_3', '2', 'EFM_4', '2', 'GJI_3', '2', 'GJI_4', '2', 'L', '2', 'ObjectId', '2', 'Points_Magnitude', '2', 'Points_X', '2', 'Points_Y', '2', 'Points_Z', '2', 'S', '2', 'T', '2', 'Tm', '2', 'Vm', '2', 'arc_length', '2', 'bnds', '2', 'caeq', '2', 'cbeq', '2', 'chi', '2', 'etaa0', '10', 'etab0', '2', 'gab', '2', 'ha', '2', 'hb', '2', 'ka', '2', 'kappa_c', '2', 'kappaa', '2', 'kappab', '2', 'kb', '2', 'mu', '2', 'omegaa', '2', 'omegab', '2', 'rhoa', '2', 'rhob', '2', 'vtkValidPointMask', '2', 'w', '2']
plotOverLine4Display.SeriesMarkerStyle = ['D', '0', 'Dchi', '0', 'EFM_3', '0', 'EFM_4', '0', 'GJI_3', '0', 'GJI_4', '0', 'L', '0', 'ObjectId', '0', 'Points_Magnitude', '0', 'Points_X', '0', 'Points_Y', '0', 'Points_Z', '0', 'S', '0', 'T', '0', 'Tm', '0', 'Vm', '0', 'arc_length', '0', 'bnds', '0', 'caeq', '0', 'cbeq', '0', 'chi', '0', 'etaa0', '0', 'etab0', '0', 'gab', '0', 'ha', '0', 'hb', '0', 'ka', '0', 'kappa_c', '0', 'kappaa', '0', 'kappab', '0', 'kb', '0', 'mu', '0', 'omegaa', '0', 'omegab', '0', 'rhoa', '0', 'rhob', '0', 'vtkValidPointMask', '0', 'w', '0']

# show data from annotateTimeFilter1
annotateTimeFilter1Display = Show(annotateTimeFilter1, lineChartView1)

# trace defaults for the display properties.
annotateTimeFilter1Display.CompositeDataSetIndex = [0]
annotateTimeFilter1Display.AttributeType = 'Row Data'
annotateTimeFilter1Display.XArrayName = 'Text'
annotateTimeFilter1Display.SeriesLabelPrefix = ''

# ----------------------------------------------------------------
# setup the visualization in view 'renderView1'
# ----------------------------------------------------------------

# show data from dendrite_growth_orientatione
dendrite_growth_orientationeDisplay = Show(dendrite_growth_orientatione, renderView1)

# get color transfer function/color map for 'etaa0'
etaa0LUT = GetColorTransferFunction('etaa0')
etaa0LUT.AutomaticRescaleRangeMode = 'Clamp and update every timestep'
etaa0LUT.RGBPoints = [0.0, 0.23137254902, 0.298039215686, 0.752941176471, 0.5, 0.865, 0.865, 0.865, 1.0, 0.705882352941, 0.0156862745098, 0.149019607843]
etaa0LUT.ScalarRangeInitialized = 1.0

# get opacity transfer function/opacity map for 'etaa0'
etaa0PWF = GetOpacityTransferFunction('etaa0')
etaa0PWF.ScalarRangeInitialized = 1

# trace defaults for the display properties.
dendrite_growth_orientationeDisplay.Representation = 'Surface With Edges'
dendrite_growth_orientationeDisplay.ColorArrayName = ['POINTS', 'etaa0']
dendrite_growth_orientationeDisplay.LookupTable = etaa0LUT
dendrite_growth_orientationeDisplay.PointSize = 1.0
dendrite_growth_orientationeDisplay.LineWidth = 0.5
dendrite_growth_orientationeDisplay.EdgeColor = [0.0, 0.0, 0.0]
dendrite_growth_orientationeDisplay.OSPRayScaleArray = 'GlobalNodeId'
dendrite_growth_orientationeDisplay.OSPRayScaleFunction = 'PiecewiseFunction'
dendrite_growth_orientationeDisplay.SelectOrientationVectors = 'GlobalNodeId'
dendrite_growth_orientationeDisplay.ScaleFactor = 4.0
dendrite_growth_orientationeDisplay.SelectScaleArray = 'GlobalNodeId'
dendrite_growth_orientationeDisplay.GlyphType = 'Arrow'
dendrite_growth_orientationeDisplay.GlyphTableIndexArray = 'GlobalNodeId'
dendrite_growth_orientationeDisplay.GaussianRadius = 0.2
dendrite_growth_orientationeDisplay.SetScaleArray = ['POINTS', 'GlobalNodeId']
dendrite_growth_orientationeDisplay.ScaleTransferFunction = 'PiecewiseFunction'
dendrite_growth_orientationeDisplay.OpacityArray = ['POINTS', 'GlobalNodeId']
dendrite_growth_orientationeDisplay.OpacityTransferFunction = 'PiecewiseFunction'
dendrite_growth_orientationeDisplay.DataAxesGrid = 'GridAxesRepresentation'
dendrite_growth_orientationeDisplay.SelectionCellLabelFontFile = ''
dendrite_growth_orientationeDisplay.SelectionPointLabelFontFile = ''
dendrite_growth_orientationeDisplay.PolarAxes = 'PolarAxesRepresentation'
dendrite_growth_orientationeDisplay.ScalarOpacityFunction = etaa0PWF
dendrite_growth_orientationeDisplay.ScalarOpacityUnitDistance = 6.648363427260512

# init the 'PiecewiseFunction' selected for 'ScaleTransferFunction'
dendrite_growth_orientationeDisplay.ScaleTransferFunction.Points = [1.0, 0.0, 0.5, 0.0, 693.0, 1.0, 0.5, 0.0]

# init the 'PiecewiseFunction' selected for 'OpacityTransferFunction'
dendrite_growth_orientationeDisplay.OpacityTransferFunction.Points = [1.0, 0.0, 0.5, 0.0, 693.0, 1.0, 0.5, 0.0]

# init the 'GridAxesRepresentation' selected for 'DataAxesGrid'
dendrite_growth_orientationeDisplay.DataAxesGrid.XTitleColor = [0.0, 0.0, 0.0]
dendrite_growth_orientationeDisplay.DataAxesGrid.XTitleFontFile = ''
dendrite_growth_orientationeDisplay.DataAxesGrid.YTitleColor = [0.0, 0.0, 0.0]
dendrite_growth_orientationeDisplay.DataAxesGrid.YTitleFontFile = ''
dendrite_growth_orientationeDisplay.DataAxesGrid.ZTitleColor = [0.0, 0.0, 0.0]
dendrite_growth_orientationeDisplay.DataAxesGrid.ZTitleFontFile = ''
dendrite_growth_orientationeDisplay.DataAxesGrid.XLabelColor = [0.0, 0.0, 0.0]
dendrite_growth_orientationeDisplay.DataAxesGrid.XLabelFontFile = ''
dendrite_growth_orientationeDisplay.DataAxesGrid.YLabelColor = [0.0, 0.0, 0.0]
dendrite_growth_orientationeDisplay.DataAxesGrid.YLabelFontFile = ''
dendrite_growth_orientationeDisplay.DataAxesGrid.ZLabelColor = [0.0, 0.0, 0.0]
dendrite_growth_orientationeDisplay.DataAxesGrid.ZLabelFontFile = ''

# init the 'PolarAxesRepresentation' selected for 'PolarAxes'
dendrite_growth_orientationeDisplay.PolarAxes.PolarAxisTitleColor = [0.0, 0.0, 0.0]
dendrite_growth_orientationeDisplay.PolarAxes.PolarAxisTitleFontFile = ''
dendrite_growth_orientationeDisplay.PolarAxes.PolarAxisLabelColor = [0.0, 0.0, 0.0]
dendrite_growth_orientationeDisplay.PolarAxes.PolarAxisLabelFontFile = ''
dendrite_growth_orientationeDisplay.PolarAxes.LastRadialAxisTextColor = [0.0, 0.0, 0.0]
dendrite_growth_orientationeDisplay.PolarAxes.LastRadialAxisTextFontFile = ''
dendrite_growth_orientationeDisplay.PolarAxes.SecondaryRadialAxesTextColor = [0.0, 0.0, 0.0]
dendrite_growth_orientationeDisplay.PolarAxes.SecondaryRadialAxesTextFontFile = ''

# show data from plotOverLine1
plotOverLine1Display_1 = Show(plotOverLine1, renderView1)

# trace defaults for the display properties.
plotOverLine1Display_1.Representation = 'Surface'
plotOverLine1Display_1.ColorArrayName = ['POINTS', 'etaa0']
plotOverLine1Display_1.LookupTable = etaa0LUT
plotOverLine1Display_1.OSPRayScaleArray = 'D'
plotOverLine1Display_1.OSPRayScaleFunction = 'PiecewiseFunction'
plotOverLine1Display_1.SelectOrientationVectors = 'D'
plotOverLine1Display_1.ScaleFactor = 4.0
plotOverLine1Display_1.SelectScaleArray = 'D'
plotOverLine1Display_1.GlyphType = 'Arrow'
plotOverLine1Display_1.GlyphTableIndexArray = 'D'
plotOverLine1Display_1.GaussianRadius = 0.2
plotOverLine1Display_1.SetScaleArray = ['POINTS', 'D']
plotOverLine1Display_1.ScaleTransferFunction = 'PiecewiseFunction'
plotOverLine1Display_1.OpacityArray = ['POINTS', 'D']
plotOverLine1Display_1.OpacityTransferFunction = 'PiecewiseFunction'
plotOverLine1Display_1.DataAxesGrid = 'GridAxesRepresentation'
plotOverLine1Display_1.SelectionCellLabelFontFile = ''
plotOverLine1Display_1.SelectionPointLabelFontFile = ''
plotOverLine1Display_1.PolarAxes = 'PolarAxesRepresentation'

# init the 'PiecewiseFunction' selected for 'ScaleTransferFunction'
plotOverLine1Display_1.ScaleTransferFunction.Points = [1.0, 0.0, 0.5, 0.0, 1.000244140625, 1.0, 0.5, 0.0]

# init the 'PiecewiseFunction' selected for 'OpacityTransferFunction'
plotOverLine1Display_1.OpacityTransferFunction.Points = [1.0, 0.0, 0.5, 0.0, 1.000244140625, 1.0, 0.5, 0.0]

# init the 'GridAxesRepresentation' selected for 'DataAxesGrid'
plotOverLine1Display_1.DataAxesGrid.XTitleColor = [0.0, 0.0, 0.0]
plotOverLine1Display_1.DataAxesGrid.XTitleFontFile = ''
plotOverLine1Display_1.DataAxesGrid.YTitleColor = [0.0, 0.0, 0.0]
plotOverLine1Display_1.DataAxesGrid.YTitleFontFile = ''
plotOverLine1Display_1.DataAxesGrid.ZTitleColor = [0.0, 0.0, 0.0]
plotOverLine1Display_1.DataAxesGrid.ZTitleFontFile = ''
plotOverLine1Display_1.DataAxesGrid.XLabelColor = [0.0, 0.0, 0.0]
plotOverLine1Display_1.DataAxesGrid.XLabelFontFile = ''
plotOverLine1Display_1.DataAxesGrid.YLabelColor = [0.0, 0.0, 0.0]
plotOverLine1Display_1.DataAxesGrid.YLabelFontFile = ''
plotOverLine1Display_1.DataAxesGrid.ZLabelColor = [0.0, 0.0, 0.0]
plotOverLine1Display_1.DataAxesGrid.ZLabelFontFile = ''

# init the 'PolarAxesRepresentation' selected for 'PolarAxes'
plotOverLine1Display_1.PolarAxes.PolarAxisTitleColor = [0.0, 0.0, 0.0]
plotOverLine1Display_1.PolarAxes.PolarAxisTitleFontFile = ''
plotOverLine1Display_1.PolarAxes.PolarAxisLabelColor = [0.0, 0.0, 0.0]
plotOverLine1Display_1.PolarAxes.PolarAxisLabelFontFile = ''
plotOverLine1Display_1.PolarAxes.LastRadialAxisTextColor = [0.0, 0.0, 0.0]
plotOverLine1Display_1.PolarAxes.LastRadialAxisTextFontFile = ''
plotOverLine1Display_1.PolarAxes.SecondaryRadialAxesTextColor = [0.0, 0.0, 0.0]
plotOverLine1Display_1.PolarAxes.SecondaryRadialAxesTextFontFile = ''

# show data from plotOverLine3
plotOverLine3Display_1 = Show(plotOverLine3, renderView1)

# trace defaults for the display properties.
plotOverLine3Display_1.Representation = 'Surface'
plotOverLine3Display_1.ColorArrayName = ['POINTS', 'etaa0']
plotOverLine3Display_1.LookupTable = etaa0LUT
plotOverLine3Display_1.OSPRayScaleArray = 'D'
plotOverLine3Display_1.OSPRayScaleFunction = 'PiecewiseFunction'
plotOverLine3Display_1.SelectOrientationVectors = 'D'
plotOverLine3Display_1.ScaleFactor = 4.0
plotOverLine3Display_1.SelectScaleArray = 'D'
plotOverLine3Display_1.GlyphType = 'Arrow'
plotOverLine3Display_1.GlyphTableIndexArray = 'D'
plotOverLine3Display_1.GaussianRadius = 0.2
plotOverLine3Display_1.SetScaleArray = ['POINTS', 'D']
plotOverLine3Display_1.ScaleTransferFunction = 'PiecewiseFunction'
plotOverLine3Display_1.OpacityArray = ['POINTS', 'D']
plotOverLine3Display_1.OpacityTransferFunction = 'PiecewiseFunction'
plotOverLine3Display_1.DataAxesGrid = 'GridAxesRepresentation'
plotOverLine3Display_1.SelectionCellLabelFontFile = ''
plotOverLine3Display_1.SelectionPointLabelFontFile = ''
plotOverLine3Display_1.PolarAxes = 'PolarAxesRepresentation'

# init the 'PiecewiseFunction' selected for 'ScaleTransferFunction'
plotOverLine3Display_1.ScaleTransferFunction.Points = [1.0, 0.0, 0.5, 0.0, 1.000244140625, 1.0, 0.5, 0.0]

# init the 'PiecewiseFunction' selected for 'OpacityTransferFunction'
plotOverLine3Display_1.OpacityTransferFunction.Points = [1.0, 0.0, 0.5, 0.0, 1.000244140625, 1.0, 0.5, 0.0]

# init the 'GridAxesRepresentation' selected for 'DataAxesGrid'
plotOverLine3Display_1.DataAxesGrid.XTitleColor = [0.0, 0.0, 0.0]
plotOverLine3Display_1.DataAxesGrid.XTitleFontFile = ''
plotOverLine3Display_1.DataAxesGrid.YTitleColor = [0.0, 0.0, 0.0]
plotOverLine3Display_1.DataAxesGrid.YTitleFontFile = ''
plotOverLine3Display_1.DataAxesGrid.ZTitleColor = [0.0, 0.0, 0.0]
plotOverLine3Display_1.DataAxesGrid.ZTitleFontFile = ''
plotOverLine3Display_1.DataAxesGrid.XLabelColor = [0.0, 0.0, 0.0]
plotOverLine3Display_1.DataAxesGrid.XLabelFontFile = ''
plotOverLine3Display_1.DataAxesGrid.YLabelColor = [0.0, 0.0, 0.0]
plotOverLine3Display_1.DataAxesGrid.YLabelFontFile = ''
plotOverLine3Display_1.DataAxesGrid.ZLabelColor = [0.0, 0.0, 0.0]
plotOverLine3Display_1.DataAxesGrid.ZLabelFontFile = ''

# init the 'PolarAxesRepresentation' selected for 'PolarAxes'
plotOverLine3Display_1.PolarAxes.PolarAxisTitleColor = [0.0, 0.0, 0.0]
plotOverLine3Display_1.PolarAxes.PolarAxisTitleFontFile = ''
plotOverLine3Display_1.PolarAxes.PolarAxisLabelColor = [0.0, 0.0, 0.0]
plotOverLine3Display_1.PolarAxes.PolarAxisLabelFontFile = ''
plotOverLine3Display_1.PolarAxes.LastRadialAxisTextColor = [0.0, 0.0, 0.0]
plotOverLine3Display_1.PolarAxes.LastRadialAxisTextFontFile = ''
plotOverLine3Display_1.PolarAxes.SecondaryRadialAxesTextColor = [0.0, 0.0, 0.0]
plotOverLine3Display_1.PolarAxes.SecondaryRadialAxesTextFontFile = ''

# show data from plotOverLine4
plotOverLine4Display_1 = Show(plotOverLine4, renderView1)

# trace defaults for the display properties.
plotOverLine4Display_1.Representation = 'Surface'
plotOverLine4Display_1.ColorArrayName = ['POINTS', 'etaa0']
plotOverLine4Display_1.LookupTable = etaa0LUT
plotOverLine4Display_1.OSPRayScaleArray = 'D'
plotOverLine4Display_1.OSPRayScaleFunction = 'PiecewiseFunction'
plotOverLine4Display_1.SelectOrientationVectors = 'D'
plotOverLine4Display_1.ScaleFactor = 4.0
plotOverLine4Display_1.SelectScaleArray = 'D'
plotOverLine4Display_1.GlyphType = 'Arrow'
plotOverLine4Display_1.GlyphTableIndexArray = 'D'
plotOverLine4Display_1.GaussianRadius = 0.2
plotOverLine4Display_1.SetScaleArray = ['POINTS', 'D']
plotOverLine4Display_1.ScaleTransferFunction = 'PiecewiseFunction'
plotOverLine4Display_1.OpacityArray = ['POINTS', 'D']
plotOverLine4Display_1.OpacityTransferFunction = 'PiecewiseFunction'
plotOverLine4Display_1.DataAxesGrid = 'GridAxesRepresentation'
plotOverLine4Display_1.SelectionCellLabelFontFile = ''
plotOverLine4Display_1.SelectionPointLabelFontFile = ''
plotOverLine4Display_1.PolarAxes = 'PolarAxesRepresentation'

# init the 'PiecewiseFunction' selected for 'ScaleTransferFunction'
plotOverLine4Display_1.ScaleTransferFunction.Points = [1.0, 0.0, 0.5, 0.0, 1.000244140625, 1.0, 0.5, 0.0]

# init the 'PiecewiseFunction' selected for 'OpacityTransferFunction'
plotOverLine4Display_1.OpacityTransferFunction.Points = [1.0, 0.0, 0.5, 0.0, 1.000244140625, 1.0, 0.5, 0.0]

# init the 'GridAxesRepresentation' selected for 'DataAxesGrid'
plotOverLine4Display_1.DataAxesGrid.XTitleColor = [0.0, 0.0, 0.0]
plotOverLine4Display_1.DataAxesGrid.XTitleFontFile = ''
plotOverLine4Display_1.DataAxesGrid.YTitleColor = [0.0, 0.0, 0.0]
plotOverLine4Display_1.DataAxesGrid.YTitleFontFile = ''
plotOverLine4Display_1.DataAxesGrid.ZTitleColor = [0.0, 0.0, 0.0]
plotOverLine4Display_1.DataAxesGrid.ZTitleFontFile = ''
plotOverLine4Display_1.DataAxesGrid.XLabelColor = [0.0, 0.0, 0.0]
plotOverLine4Display_1.DataAxesGrid.XLabelFontFile = ''
plotOverLine4Display_1.DataAxesGrid.YLabelColor = [0.0, 0.0, 0.0]
plotOverLine4Display_1.DataAxesGrid.YLabelFontFile = ''
plotOverLine4Display_1.DataAxesGrid.ZLabelColor = [0.0, 0.0, 0.0]
plotOverLine4Display_1.DataAxesGrid.ZLabelFontFile = ''

# init the 'PolarAxesRepresentation' selected for 'PolarAxes'
plotOverLine4Display_1.PolarAxes.PolarAxisTitleColor = [0.0, 0.0, 0.0]
plotOverLine4Display_1.PolarAxes.PolarAxisTitleFontFile = ''
plotOverLine4Display_1.PolarAxes.PolarAxisLabelColor = [0.0, 0.0, 0.0]
plotOverLine4Display_1.PolarAxes.PolarAxisLabelFontFile = ''
plotOverLine4Display_1.PolarAxes.LastRadialAxisTextColor = [0.0, 0.0, 0.0]
plotOverLine4Display_1.PolarAxes.LastRadialAxisTextFontFile = ''
plotOverLine4Display_1.PolarAxes.SecondaryRadialAxesTextColor = [0.0, 0.0, 0.0]
plotOverLine4Display_1.PolarAxes.SecondaryRadialAxesTextFontFile = ''

# show data from plotOverLine2
plotOverLine2Display_1 = Show(plotOverLine2, renderView1)

# trace defaults for the display properties.
plotOverLine2Display_1.Representation = 'Surface'
plotOverLine2Display_1.ColorArrayName = ['POINTS', 'etaa0']
plotOverLine2Display_1.LookupTable = etaa0LUT
plotOverLine2Display_1.OSPRayScaleArray = 'D'
plotOverLine2Display_1.OSPRayScaleFunction = 'PiecewiseFunction'
plotOverLine2Display_1.SelectOrientationVectors = 'D'
plotOverLine2Display_1.ScaleFactor = 4.0
plotOverLine2Display_1.SelectScaleArray = 'D'
plotOverLine2Display_1.GlyphType = 'Arrow'
plotOverLine2Display_1.GlyphTableIndexArray = 'D'
plotOverLine2Display_1.GaussianRadius = 0.2
plotOverLine2Display_1.SetScaleArray = ['POINTS', 'D']
plotOverLine2Display_1.ScaleTransferFunction = 'PiecewiseFunction'
plotOverLine2Display_1.OpacityArray = ['POINTS', 'D']
plotOverLine2Display_1.OpacityTransferFunction = 'PiecewiseFunction'
plotOverLine2Display_1.DataAxesGrid = 'GridAxesRepresentation'
plotOverLine2Display_1.SelectionCellLabelFontFile = ''
plotOverLine2Display_1.SelectionPointLabelFontFile = ''
plotOverLine2Display_1.PolarAxes = 'PolarAxesRepresentation'

# init the 'PiecewiseFunction' selected for 'ScaleTransferFunction'
plotOverLine2Display_1.ScaleTransferFunction.Points = [1.0, 0.0, 0.5, 0.0, 1.000244140625, 1.0, 0.5, 0.0]

# init the 'PiecewiseFunction' selected for 'OpacityTransferFunction'
plotOverLine2Display_1.OpacityTransferFunction.Points = [1.0, 0.0, 0.5, 0.0, 1.000244140625, 1.0, 0.5, 0.0]

# init the 'GridAxesRepresentation' selected for 'DataAxesGrid'
plotOverLine2Display_1.DataAxesGrid.XTitleColor = [0.0, 0.0, 0.0]
plotOverLine2Display_1.DataAxesGrid.XTitleFontFile = ''
plotOverLine2Display_1.DataAxesGrid.YTitleColor = [0.0, 0.0, 0.0]
plotOverLine2Display_1.DataAxesGrid.YTitleFontFile = ''
plotOverLine2Display_1.DataAxesGrid.ZTitleColor = [0.0, 0.0, 0.0]
plotOverLine2Display_1.DataAxesGrid.ZTitleFontFile = ''
plotOverLine2Display_1.DataAxesGrid.XLabelColor = [0.0, 0.0, 0.0]
plotOverLine2Display_1.DataAxesGrid.XLabelFontFile = ''
plotOverLine2Display_1.DataAxesGrid.YLabelColor = [0.0, 0.0, 0.0]
plotOverLine2Display_1.DataAxesGrid.YLabelFontFile = ''
plotOverLine2Display_1.DataAxesGrid.ZLabelColor = [0.0, 0.0, 0.0]
plotOverLine2Display_1.DataAxesGrid.ZLabelFontFile = ''

# init the 'PolarAxesRepresentation' selected for 'PolarAxes'
plotOverLine2Display_1.PolarAxes.PolarAxisTitleColor = [0.0, 0.0, 0.0]
plotOverLine2Display_1.PolarAxes.PolarAxisTitleFontFile = ''
plotOverLine2Display_1.PolarAxes.PolarAxisLabelColor = [0.0, 0.0, 0.0]
plotOverLine2Display_1.PolarAxes.PolarAxisLabelFontFile = ''
plotOverLine2Display_1.PolarAxes.LastRadialAxisTextColor = [0.0, 0.0, 0.0]
plotOverLine2Display_1.PolarAxes.LastRadialAxisTextFontFile = ''
plotOverLine2Display_1.PolarAxes.SecondaryRadialAxesTextColor = [0.0, 0.0, 0.0]
plotOverLine2Display_1.PolarAxes.SecondaryRadialAxesTextFontFile = ''

# show data from annotateTimeFilter1
annotateTimeFilter1Display_1 = Show(annotateTimeFilter1, renderView1)

# trace defaults for the display properties.
annotateTimeFilter1Display_1.Color = [0.0, 0.0, 0.0]
annotateTimeFilter1Display_1.FontFamily = 'Times'
annotateTimeFilter1Display_1.FontFile = ''
annotateTimeFilter1Display_1.FontSize = 12
annotateTimeFilter1Display_1.WindowLocation = 'AnyLocation'
annotateTimeFilter1Display_1.Position = [0.3308279767141009, 0.8859014262295082]

# setup the color legend parameters for each legend in this view

# get color legend/bar for etaa0LUT in view renderView1
etaa0LUTColorBar = GetScalarBar(etaa0LUT, renderView1)
etaa0LUTColorBar.WindowLocation = 'AnyLocation'
etaa0LUTColorBar.Position = [0.8288278546712803, 0.3188524590163934]
etaa0LUTColorBar.Title = 'Order Parameter'
etaa0LUTColorBar.ComponentTitle = ''
etaa0LUTColorBar.TitleColor = [0.0, 0.0, 0.0]
etaa0LUTColorBar.TitleFontFamily = 'Times'
etaa0LUTColorBar.TitleFontFile = ''
etaa0LUTColorBar.LabelColor = [0.0, 0.0, 0.0]
etaa0LUTColorBar.LabelFontFamily = 'Times'
etaa0LUTColorBar.LabelFontFile = ''
etaa0LUTColorBar.AutomaticLabelFormat = 0
etaa0LUTColorBar.LabelFormat = '%-#6.2g'
etaa0LUTColorBar.UseCustomLabels = 1
etaa0LUTColorBar.CustomLabels = [0.0, 0.25, 0.5, 0.75, 1.0]
etaa0LUTColorBar.RangeLabelFormat = '%-#6.2g'
etaa0LUTColorBar.ScalarBarThickness = 15
etaa0LUTColorBar.ScalarBarLength = 0.33000000000000024

# set color bar visibility
etaa0LUTColorBar.Visibility = 1

# show color legend
dendrite_growth_orientationeDisplay.SetScalarBarVisibility(renderView1, True)

# show color legend
plotOverLine1Display_1.SetScalarBarVisibility(renderView1, True)

# show color legend
plotOverLine3Display_1.SetScalarBarVisibility(renderView1, True)

# show color legend
plotOverLine4Display_1.SetScalarBarVisibility(renderView1, True)

# show color legend
plotOverLine2Display_1.SetScalarBarVisibility(renderView1, True)

# ----------------------------------------------------------------
# setup color maps and opacity mapes used in the visualization
# note: the Get..() functions create a new object, if needed
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# finally, restore active source
SetActiveSource(dendrite_growth_orientatione)
# ----------------------------------------------------------------