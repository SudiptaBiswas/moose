#!/usr/bin/env python2
#pylint: disable=missing-docstring
#* This file is part of the MOOSE framework
#* https://www.mooseframework.org
#*
#* All rights reserved, see COPYRIGHT for full restrictions
#* https://github.com/idaholab/moose/blob/master/COPYRIGHT
#*
#* Licensed under LGPL 2.1, please see LICENSE for details
#* https://www.gnu.org/licenses/lgpl-2.1.html

import chigger
from chigger.annotations import ImageAnnotation
from chigger.utils import img2mov

import mooseutils
import vtk
import itertools
#
# camera = vtk.vtkCamera()
# camera.SetViewUp(0.0000, 1.0000, 0.0000)
# camera.SetPosition(0.0000, 0.0000, 200.0)
# camera.SetFocalPoint(0.0000, 0.0000, 0.0000)

reader0 = chigger.exodus.ExodusReader('GrandPotentialSolidification_updatedmodel_out.e', timestep=1000)
exodus0 = chigger.exodus.ExodusResult(reader0, edges=False, edge_color=[0.2, 0.2, 0.2], variable='etab0', cmap='viridis',
                                      local_range=True, viewport=[0,0,0.5,1])
# result = chigger.exodus.ExodusResult(reader, variable='etaa0', viewport=[0,0,1,1], opacity=1,
#                                      edges=True, edge_color=[1,1,1], range=[0, 1], camera=camera)
exodus0.update()

cbar = chigger.exodus.ExodusColorBar(exodus0, colorbar_origin=[0.8, 0.25],
                                     viewport=[0, 0, 0.5, 1], width=0.03, location='right',
                                     lim = [0.0, 1.0], notation='fixed', precision=2)
cbar.setOptions('primary', num_ticks=6, font_size=18, title='Order Parameter')
# cbar.setOptions('secondary', num_ticks=6, font_size=18, title='Grain Radius ($\mu$m)', notation='fixed', precision=2, axis_scale=1e6)

time = chigger.annotations.TimeAnnotation(layer=2, font_size=18, color=[1,0,1], prefix='Time:',
                                          justification='center', position=[0.9,0.9],
                                          vertical_justification='middle', notation='fixed', precision=4)

moose = ImageAnnotation(filename='moose.png', scale=1.8, opacity=0.12)
inl = ImageAnnotation(filename='inl.png', position=[0.05, 0.98], scale=0.07,
                      horizontal_alignment='left', vertical_alignment='top')
text1 = chigger.annotations.TextAnnotation(text='Dendrite Growth during Alloy Solidification', font_size=20, text_color=[1,1,1],
                                          position=[0.5, 0.07], justification='center', vertical_justification='middle')
text2 = chigger.annotations.TextAnnotation(text='Created by Sudipta Biswas', font_size=14, text_color=[1,1,1],
                                          position=[0.5, 0.03], justification='center', vertical_justification='middle')

p0 = (0., 0., 0.)
p1= (-50.0, -50.0, 0)
p2 = (50.0, 50.0, 0)
p3 = (-50.0, 50.0, 0)
p4 = (50.0, -50.0, 0)
p5 = (-50.0, 0., 0)
p6 = (0.0, -50.0, 0)
p7 = (50.0, 0.0, 0)
p8 = (0.0, 50.0, 0)

# sample1 = chigger.exodus.ExodusResultLineSampler(exodus0, point1=p1, point2=p2, resolution=50)
# sample2 = chigger.exodus.ExodusResultLineSampler(exodus0, point1=p3, point2=p4, resolution=50)
sample1 = chigger.exodus.ExodusResultLineSampler(exodus0, point1=p0, point2=p5, resolution=50)
sample2 = chigger.exodus.ExodusResultLineSampler(exodus0, point1=p0, point2=p6, resolution=50)
sample3 = chigger.exodus.ExodusResultLineSampler(exodus0, point1=p0, point2=p7, resolution=50)
sample4 = chigger.exodus.ExodusResultLineSampler(exodus0, point1=p0, point2=p8, resolution=50)
sample1.update()
sample2.update()
sample3.update()
sample4.update()

x1 = sample1[0].getDistance()
x2 = sample2[0].getDistance()
x3 = sample3[0].getDistance()
x4 = sample4[0].getDistance()

etaa1 = sample1[0].getSample('etab0')
etaa2 = sample2[0].getSample('etab0')
etaa3 = sample3[0].getSample('etab0')
etaa4 = sample4[0].getSample('etab0')


# line_temp = chigger.graphs.Line(x, y1, width=2, label='Temp')
line1 = chigger.graphs.Line(x1, etaa1, width=2, append=False, color=[0,0,1], marker='cross', style='none', label='Left')
line2 = chigger.graphs.Line(x2, etaa2, width=2, append=False, color=[1,0,0], label='Bottom', marker='plus', style='none')
line3 = chigger.graphs.Line(x3, etaa3, width=2, append=False, color=[0,1,0], label='Right')
line4 = chigger.graphs.Line(x4, etaa4, width=2, append=False, color=[0.7,0.2,0.8], label='Top', marker='circle', style='none')

# graph1 = chigger.graphs.Graph(line1, line2, viewport=[0.4,0,0.7,0.95])
# graph1.setOptions('xaxis', title='Distance', font_size=18, precision=0)
# graph1.setOptions('yaxis', lim = [0.25, 1.0], title='Order Parameter', font_size=18)
# graph1.setOptions('legend', point=[0.75, 0.2], label_font_size=18)

graph2 = chigger.graphs.Graph(line1, line2, line4, line3, viewport=[0.5,0.1,0.95,0.9])
graph2.setOptions('xaxis', title='Distance', font_size=16, precision=0)
graph2.setOptions('yaxis', lim = [0.0, 1.0], title='Order Parameter', font_size=16)
graph2.setOptions('legend', point=[0.8, 0.12], label_font_size=14)

window = chigger.RenderWindow(exodus0, time, moose, inl, text1, text2, graph2, size=[1200, 600], test=False)

reader0.update()
times = reader0.getTimes()
for i in range(0,4000,50):
    time.update(time=times[i])
    reader0.setOptions(timestep=i)
    exodus0.update()
    etaa1 = sample1[0].getSample('etab0')
    etaa2 = sample2[0].getSample('etab0')
    etaa3 = sample3[0].getSample('etab0')
    etaa4 = sample4[0].getSample('etab0')
    line1.setOptions(y=etaa1)
    line2.setOptions(y=etaa2)
    line3.setOptions(y=etaa3)
    line4.setOptions(y=etaa4)
    window.write('dendrite_growth2_%04d.png' % i)

window.start()

img2mov('dendrite_growth2_*.png', 'dendrite_growth.mp4', duration=15)
