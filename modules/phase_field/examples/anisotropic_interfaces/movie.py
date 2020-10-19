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

# reader0 = chigger.exodus.ExodusReader('GrandPotentialSolidification_updatedmodel_out.e', timestep=0)
# exodus0 = chigger.exodus.ExodusResult(reader0, edges=False, edge_color=[0.2, 0.2, 0.2], variable='bnds', cmap='viridis',
                                      # local_range=True, viewport=[0,0,0.8,1])
# result = chigger.exodus.ExodusResult(reader, variable='etaa0', viewport=[0,0,1,1], opacity=1,
#                                      edges=True, edge_color=[1,1,1], range=[0, 1], camera=camera)
# exodus0.update()
#
# cbar = chigger.exodus.ExodusColorBar(exodus0, colorbar_origin=[0.8, 0.25],
#                                      viewport=[0, 0, 1, 1], width=0.03, location='right',
#                                      lim = [0.0, 1.0], notation='fixed', precision=2)
# cbar.setOptions('primary', num_ticks=6, font_size=18, title='Order Parameter')
# # cbar.setOptions('secondary', num_ticks=6, font_size=18, title='Grain Radius ($\mu$m)', notation='fixed', precision=2, axis_scale=1e6)
#
# time = chigger.annotations.TimeAnnotation(layer=2, font_size=18, color=[1,0,1], prefix='Time:',
#                                           justification='center', position=[0.4,0.9],
#                                           vertical_justification='middle', notation='fixed', precision=4)
#
# moose = ImageAnnotation(filename='moose.png', scale=0.9, opacity=0.15)
# inl = ImageAnnotation(filename='inl.png', position=[0.95, 0.08], scale=0.08,
#                       horizontal_alignment='right', vertical_alignment='bottom')
# text = chigger.annotations.TextAnnotation(text='Created by Sudipta Biswas', font_size=14, text_color=[1,1,1], position=[0.25, 0.1])

# p0 = (0., 0., 0.)
# p1= (-20.0, -20.0, 0)
# p2 = (20.0, 20.0, 0)
# p3 = (-20.0, 20.0, 0)
# p4 = (20.0, -20.0, 0)
# p5 = (-20.0, 0., 0)
# p6 = (0.0, -20.0, 0)
# p7 = (20.0, 0.0, 0)
# p8 = (0.0, 20.0, 0)
#
# sample1 = chigger.exodus.ExodusResultLineSampler(exodus0, point1=p1, point2=p2, resolution=50)
# sample2 = chigger.exodus.ExodusResultLineSampler(exodus0, point1=p3, point2=p4, resolution=50)
# sample3 = chigger.exodus.ExodusResultLineSampler(exodus0, point1=p5, point2=p7, resolution=40)
# sample4 = chigger.exodus.ExodusResultLineSampler(exodus0, point1=p6, point2=p8, resolution=40)
# sample1.update()
# sample2.update()
# sample3.update()
# sample4.update()
#
# x1 = sample1[0].getDistance()
# x2 = sample2[0].getDistance()
# x3 = sample3[0].getDistance()
# x4 = sample4[0].getDistance()
#
# etaa1 = sample1[0].getSample('bnds')
# etaa2 = sample2[0].getSample('bnds')
# etaa3 = sample3[0].getSample('bnds')
# etaa4 = sample4[0].getSample('bnds')
#
#
# # line_temp = chigger.graphs.Line(x, y1, width=2, label='Temp')
# line1 = chigger.graphs.Line(x1, etaa1, width=2, append=False, color=[0,1,0], label='Diagonal1')
# line2 = chigger.graphs.Line(x2, etaa2, width=2, append=False, color=[0.7,0.2,0.8], label='Diagonal2', marker='circle', style='none')
#
# line3 = chigger.graphs.Line(x3, etaa3, width=2, append=False, color=[0,1,0], label='x-direction')
# line4 = chigger.graphs.Line(x4, etaa4, width=2, append=False, color=[0.7,0.2,0.8], label='y-direction', marker='circle', style='none')
#
# graph1 = chigger.graphs.Graph(line1, line2, viewport=[0.4,0,0.7,0.95])
# graph1.setOptions('xaxis', title='Distance', font_size=18, precision=0)
# graph1.setOptions('yaxis', lim = [0.25, 1.0], title='Order Parameter', font_size=18)
# graph1.setOptions('legend', point=[0.75, 0.2], label_font_size=18)
#
# graph2 = chigger.graphs.Graph(line3, line4, viewport=[0.7,0,1,0.95])
# graph2.setOptions('xaxis', title='Distance', font_size=18, precision=0)
# graph2.setOptions('yaxis', lim = [0.25, 1.0], title='Order Parameter', font_size=18)
# graph2.setOptions('legend', point=[0.75, 0.2], label_font_size=18)
#
# window = chigger.RenderWindow(exodus0, cbar, time, moose, inl, text, size=[600, 600], test=False)
#
# reader0.update()
# times = reader0.getTimes()
# for i in range(0,4000,100):
#     # if i <= 200:
#     time.update(time=times[i])
#     reader0.setOptions(timestep=i)
#     window.write('solidification_%4d.png' % i)

    # exodus0.update()
    # etaa1 = sample1[0].getSample('bnds')
    # etaa2 = sample2[0].getSample('bnds')
    # etaa3 = sample3[0].getSample('bnds')
    # etaa4 = sample4[0].getSample('bnds')
    # line1.setOptions(y=etaa1)
    # line2.setOptions(y=etaa2)
    # line3.setOptions(y=etaa3)
    # line4.setOptions(y=etaa4)
    # window.write('solidification_%04d.png' % i)

# window.start()
# img2mov('solidification_multi2*.png', 'solidification_multi2.mp4', duration=10)
# img2mov('solidification_4P*.png', 'solidification_4P_test.mp4', duration=10)
img2mov('dendrite_4P*.png', 'dendrtite_multi_4P.mp4', duration=10)


# img2mov('solidification_directional4_*.png', 'solidification_directional4.mp4', duration=10)
