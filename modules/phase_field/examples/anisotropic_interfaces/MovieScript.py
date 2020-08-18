#!/usr/bin/env python
#pylint: disable=missing-docstring
#* This file is part of the MOOSE framework
#* https://www.mooseframework.org
#*
#* All rights reserved, see COPYRIGHT for full restrictions
#* https://github.com/idaholab/moose/blob/master/COPYRIGHT
#*
#* Licensed under LGPL 2.1, please see LICENSE for details
#* https://www.gnu.org/licenses/lgpl-2.1.html

# Importing necessary modules
import chigger
from chigger.annotations import ImageAnnotation
from chigger.utils import img2mov

import mooseutils
import vtk
import itertools

# Setup view position (can be expoted from Peacock)
# camera = vtk.vtkCamera()
# camera.SetViewUp(0.0000, 1.0000, 0.0000)
# camera.SetPosition(0.0000, 0.0000, 200.0)
# camera.SetFocalPoint(0.0000, 0.0000, 0.0000)

# Read the exodus output files
reader0 = chigger.exodus.ExodusReader('file_name_out.e', timestep=1)

# Setup the configuration for visualization
exodus0 = chigger.exodus.ExodusResult(reader0, edges=False, edge_color=[0.2, 0.2, 0.2], variable='bnds', cmap='viridis',
                                      local_range=True, viewport=[0,0,1,1])

# Alternative opions, can be used to set up multiple views in a single window
# result = chigger.exodus.ExodusResult(reader0, variable='etaa0', viewport=[0,0,1,1], opacity=1,
#                                      edges=True, edge_color=[1,1,1], range=[0, 1], camera=camera)

exodus0.update()
# Specify the position and format of the colorbar
cbar = chigger.exodus.ExodusColorBar(exodus0, colorbar_origin=[0.8, 0.25],
                                     viewport=[0, 0, 1, 1], width=0.03, location='right',
                                     lim = [0.0, 1.0], notation='fixed', precision=2)
cbar.setOptions('primary', num_ticks=6, font_size=18, title='Order Parameter')
# cbar.setOptions('secondary', num_ticks=6, font_size=18, title='Grain Radius ($\mu$m)', notation='fixed', precision=2, axis_scale=1e6)

# Annotate time
time = chigger.annotations.TimeAnnotation(layer=2, font_size=18, color=[1,0,1], prefix='Time:',
                                          justification='center', position=[0.9,0.9],
                                          vertical_justification='middle', notation='fixed', precision=4)

# Add logos and texts
moose = ImageAnnotation(filename='moose.png', scale=0.9, opacity=0.12)
inl = ImageAnnotation(filename='inl.png', position=[0.05, 0.98], scale=0.07,
                      horizontal_alignment='left', vertical_alignment='top')
text1 = chigger.annotations.TextAnnotation(text='Name of the Plot/Movie', font_size=20, text_color=[1,1,1],
                                          position=[0.5, 0.07], justification='center', vertical_justification='middle')
text2 = chigger.annotations.TextAnnotation(text='Created by ', font_size=18, text_color=[1,1,1],
                                          position=[0.5, 0.03], justification='center', vertical_justification='middle')

# Create the visualization window
window = chigger.RenderWindow(exodus0, time, moose, inl, text1, text2, size=[600, 600], test=False)

# Creating images for each of the timestep
reader0.update()
times = reader0.getTimes()
for i in range(0,100):
    time.update(time=times[i])
    reader0.setOptions(timestep=i)
    exodus0.update()
    window.write('solidification_4P_%04d.png' % i)

# Opens the window
window.start()

# Creating the movie for visualization
img2mov('solidification_4P*.png', 'solidification_multi_4P.mp4', duration=10)
