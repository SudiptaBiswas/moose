"""
python /Users/bisws/Programs/moose/modules/phase_field/examples/anisotropic_interfaces/disp.py
"""

import vtk
import chigger

camera = vtk.vtkCamera()
camera.SetViewUp(0.0000, 1.0000, 0.0000)
camera.SetPosition(0.0000, 0.0000, 273.2051)
camera.SetFocalPoint(0.0000, 0.0000, 0.0000)

reader = chigger.exodus.ExodusReader(u'GrandPotentialSolidification_updatedmodel_out.e')
reader.setOptions(block=['0'])

result = chigger.exodus.ExodusResult(reader)
result.setOptions(edge_color=[0, 0, 0], variable='etab0', block=['0'], cmap='plasma', local_range=True, camera=camera)

cbar = chigger.exodus.ExodusColorBar(result)
cbar.setOptions(colorbar_origin=(0.8, 0.25, 0.0), cmap='plasma')
cbar.setOptions('primary', lim=[-0.0014898376221385487, 1.000042419148649])

window = chigger.RenderWindow(result, cbar)
window.setOptions(size=None, style=None, background=[0.7058823529411765, 0.7058823529411765, 0.7058823529411765], background2=[0.43529411764705883, 0.43529411764705883, 0.43529411764705883], gradient_background=True)
window.start()
