from sympy import *
from sympy import init_printing
init_printing(use_latex=True)
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
plt.rc('font',family='Times New Roman')
# plt.rc('font', family='serif', serif='Times')
# plt.rc('text', usetex=True)
plt.rc('xtick', labelsize=12)
plt.rc('ytick', labelsize=12)
plt.rc('axes', labelsize=12)
plt.rc('legend', fontsize=12)


square_hex8_coarse0_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex8_coarse0_xx_out.csv')
square_hex8_coarse1_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex8_coarse1_xx_out.csv')
square_hex8_coarse_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex8_coarse_xx_out.csv')
square_hex8_refine0_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex8_refine0_xx_out.csv')
square_hex8_refine1_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex8_refine1_xx_out.csv')
square_hex8_refine_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex8_refine_xx_out.csv')
square_hex8_unitcell_Vf47x_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/test/tests/global_strain/square_hex8_unitcell_Vf47x_xx_out.csv')
square_hex8_unitcell_Vf47_refine_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/test/tests/global_strain/square_hex8_unitcell_Vf47_refine_xx_out.csv')

square_hex20_coarse0_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex20_coarse0_xx_out.csv')
square_hex20_coarse1_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex20_coarse1_xx_out.csv')
square_hex20_coarse_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex20_coarse_xx_out.csv')
square_hex20_refine0_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex20_refine0_xx_out.csv')
square_hex20_refine1_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex20_refine1_xx_out.csv')
square_hex20_refine_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex20_refine_xx_out.csv')

square_tet4_coarse0_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet4_coarse0_xx_out.csv')
square_tet4_coarse1_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet4_coarse1_xx_out.csv')
square_tet4_coarse_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet4_coarse_xx_out.csv')
square_tet4_refine0_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet4_refine0_xx_out.csv')
square_tet4_refine1_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet4_refine1_xx_out.csv')
square_tet4_refine_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet4_refine_xx_out.csv')

square_tet10_coarse00_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet10_coarse00_xx_out.csv')
square_tet10_coarse0_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet10_coarse0_xx_out.csv')
square_tet10_coarse1_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet10_coarse1_xx_out.csv')
square_tet10_coarse_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet10_coarse_xx_out.csv')
square_tet10_refine0_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet10_refine0_xx_out.csv')
square_tet10_refine_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet10_refine_xx_out.csv')

square_hex8_coarse0_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex8_coarse0_yy_out.csv')
square_hex8_coarse1_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex8_coarse1_yy_out.csv')
square_hex8_coarse_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex8_coarse_yy_out.csv')
square_hex8_refine0_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex8_refine0_yy_out.csv')
square_hex8_refine1_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex8_refine1_yy_out.csv')
square_hex8_refine_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex8_refine_yy_out.csv')
# square_hex8_unitcell_Vf47x_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/test/tests/global_strain/square_hex8_unitcell_Vf47x_yy_out.csv')
# square_hex8_unitcell_Vf47_refine_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/test/tests/global_strain/square_hex8_unitcell_Vf47_refine_yy_out.csv')
# square_hex8_coarse1_out.iloc[1]['e11']

square_hex20_coarse0_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex20_coarse0_yy_out.csv')
square_hex20_coarse1_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex20_coarse1_yy_out.csv')
square_hex20_coarse_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex20_coarse_yy_out.csv')
square_hex20_refine0_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex20_refine0_yy_out.csv')
square_hex20_refine1_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex20_refine1_yy_out.csv')
square_hex20_refine_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex20_refine_yy_out.csv')
# unitcell_Vf47x_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/unitcell_Vf47x_yy_out.csv')
square_tet4_coarse0_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet4_coarse0_yy_out.csv')
square_tet4_coarse1_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet4_coarse1_yy_out.csv')
square_tet4_coarse_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet4_coarse_yy_out.csv')
square_tet4_refine0_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet4_refine0_yy_out.csv')
square_tet4_refine1_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet4_refine1_yy_out.csv')
square_tet4_refine_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet4_refine_yy_out.csv')


square_tet10_coarse00_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet10_coarse00_yy_out.csv')
square_tet10_coarse0_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet10_coarse0_yy_out.csv')
square_tet10_coarse1_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet10_coarse1_yy_out.csv')
square_tet10_coarse_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet10_coarse_yy_out.csv')
square_tet10_refine0_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet10_refine0_yy_out.csv')
square_tet10_refine_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet10_refine_yy_out.csv')

square_hex8_coarse0_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex8_coarse0_xy_out.csv')
square_hex8_coarse1_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex8_coarse1_xy_out.csv')
square_hex8_coarse_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex8_coarse_xy_out.csv')
square_hex8_refine0_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex8_refine0_xy_out.csv')
square_hex8_refine1_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex8_refine1_xy_out.csv')
square_hex8_refine_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex8_refine_xy_out.csv')
# square_hex8_unitcell_Vf47x_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/test/tests/global_strain/square_hex8_unitcell_Vf47x_xy_out.csv')
# square_hex8_unitcell_Vf47_refine_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/test/tests/global_strain/square_hex8_unitcell_Vf47_refine_xy_out.csv')
# square_hex8_coarse1_out.iloc[1]['e11']

square_hex20_coarse0_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex20_coarse0_xy_out.csv')
square_hex20_coarse1_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex20_coarse1_xy_out.csv')
square_hex20_coarse_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex20_coarse_xy_out.csv')
square_hex20_refine0_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex20_refine0_xy_out.csv')
square_hex20_refine1_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex20_refine1_xy_out.csv')
square_hex20_refine_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_hex20_refine_xy_out.csv')
# unitcell_Vf47x_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/unitcell_Vf47x_xy_out.csv')
square_tet4_coarse0_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet4_coarse0_xy_out.csv')
square_tet4_coarse1_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet4_coarse1_xy_out.csv')
square_tet4_coarse_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet4_coarse_xy_out.csv')
square_tet4_refine0_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet4_refine0_xy_out.csv')
square_tet4_refine1_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet4_refine1_xy_out.csv')
square_tet4_refine_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet4_refine_xy_out.csv')


square_tet10_coarse00_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet10_coarse00_xy_out.csv')
square_tet10_coarse0_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet10_coarse0_xy_out.csv')
square_tet10_coarse1_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet10_coarse1_xy_out.csv')
square_tet10_coarse_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet10_coarse_xy_out.csv')
square_tet10_refine0_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet10_refine0_xy_out.csv')
square_tet10_refine_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/square_tet10_refine_xy_out.csv')


hex_hex8_coarse0_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex8_coarse0_xy_out.csv')
hex_hex8_coarse1_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex8_coarse1_xy_out.csv')
hex_hex8_coarse_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex8_coarse_xy_out.csv')
hex_hex8_refine0_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex8_refine0_xy_out.csv')
hex_hex8_refine1_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex8_refine1_xy_out.csv')
hex_hex8_refine_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex8_refine_xy_out.csv')

hex_hex20_coarse0_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex20_coarse0_xy_out.csv')
hex_hex20_coarse1_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex20_coarse1_xy_out.csv')
hex_hex20_coarse_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex20_coarse_xy_out.csv')
hex_hex20_refine0_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex20_refine0_xy_out.csv')
hex_hex20_refine1_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex20_refine1_xy_out.csv')
hex_hex20_refine_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex20_refine_xy_out.csv')
# unitcell_Vf47x_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/unitcell_Vf47x_xy_out.csv')
hex_tet4_coarse0_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet4_coarse0_xy_out.csv')
hex_tet4_coarse1_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet4_coarse1_xy_out.csv')
hex_tet4_coarse_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet4_coarse_xy_out.csv')
hex_tet4_refine0_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet4_refine0_xy_out.csv')
hex_tet4_refine1_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet4_refine1_xy_out.csv')
hex_tet4_refine_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet4_refine_xy_out.csv')


# hex_tet10_coarse00_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_coarse00_xy_out.csv')
hex_tet10_coarse0_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_coarse0_xy_out.csv')
hex_tet10_coarse1_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_coarse1_xy_out.csv')
hex_tet10_coarse_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_coarse_xy_out.csv')
hex_tet10_refine0_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_refine0_xy_out.csv')
hex_tet10_refine1_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_refine1_xy_out.csv')
hex_tet10_refine_xy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_refine_xy_out.csv')

hex_hex8_coarse0_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex8_coarse0_xx_out.csv')
hex_hex8_coarse1_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex8_coarse1_xx_out.csv')
hex_hex8_coarse_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex8_coarse_xx_out.csv')
hex_hex8_refine0_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex8_refine0_xx_out.csv')
hex_hex8_refine1_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex8_refine1_xx_out.csv')
hex_hex8_refine_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex8_refine_xx_out.csv')

hex_hex20_coarse0_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex20_coarse0_xx_out.csv')
hex_hex20_coarse1_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex20_coarse1_xx_out.csv')
hex_hex20_coarse_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex20_coarse_xx_out.csv')
hex_hex20_refine0_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex20_refine0_xx_out.csv')
hex_hex20_refine1_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex20_refine1_xx_out.csv')
hex_hex20_refine_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex20_refine_xx_out.csv')
# unitcell_Vf47x_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/unitcell_Vf47x_xx_out.csv')
hex_tet4_coarse0_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet4_coarse0_xx_out.csv')
hex_tet4_coarse1_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet4_coarse1_xx_out.csv')
hex_tet4_coarse_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet4_coarse_xx_out.csv')
hex_tet4_refine0_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet4_refine0_xx_out.csv')
hex_tet4_refine1_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet4_refine1_xx_out.csv')
hex_tet4_refine_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet4_refine_xx_out.csv')


# hex_tet10_coarse00_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_coarse00_xx_out.csv')
hex_tet10_coarse0_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_coarse0_xx_out.csv')
hex_tet10_coarse1_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_coarse1_xx_out.csv')
hex_tet10_coarse_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_coarse_xx_out.csv')
hex_tet10_refine0_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_refine0_xx_out.csv')
hex_tet10_refine1_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_refine1_xx_out.csv')
hex_tet10_refine_xx_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_refine_xx_out.csv')


hex_hex8_coarse0_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex8_coarse0_yy_out.csv')
hex_hex8_coarse1_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex8_coarse1_yy_out.csv')
hex_hex8_coarse_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex8_coarse_yy_out.csv')
hex_hex8_refine0_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex8_refine0_yy_out.csv')
hex_hex8_refine1_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex8_refine1_yy_out.csv')
hex_hex8_refine_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex8_refine_yy_out.csv')

hex_hex20_coarse0_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex20_coarse0_yy_out.csv')
hex_hex20_coarse1_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex20_coarse1_yy_out.csv')
hex_hex20_coarse_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex20_coarse_yy_out.csv')
hex_hex20_refine0_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex20_refine0_yy_out.csv')
hex_hex20_refine1_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex20_refine1_yy_out.csv')
hex_hex20_refine_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_hex20_refine_yy_out.csv')
# unitcell_Vf47x_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/unitcell_Vf47x_yy_out.csv')
hex_tet4_coarse0_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet4_coarse0_yy_out.csv')
hex_tet4_coarse1_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet4_coarse1_yy_out.csv')
hex_tet4_coarse_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet4_coarse_yy_out.csv')
hex_tet4_refine0_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet4_refine0_yy_out.csv')
hex_tet4_refine1_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet4_refine1_yy_out.csv')
hex_tet4_refine_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet4_refine_yy_out.csv')


hex_tet10_coarse00_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_coarse00_yy_out.csv')
hex_tet10_coarse0_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_coarse0_yy_out.csv')
hex_tet10_coarse1_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_coarse1_yy_out.csv')
hex_tet10_coarse_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_coarse_yy_out.csv')
hex_tet10_refine0_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_refine0_yy_out.csv')
hex_tet10_refine1_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_refine1_yy_out.csv')
hex_tet10_refine_yy_out = pd.read_csv('/Users/bisws/programs/moose/modules/tensor_mechanics/examples/periodic_strain/hex_tet10_refine_yy_out.csv')

# square_hex8_xx_ndof = [square_hex8_unitcell_Vf47x_xx_out.iloc[1]['DOFs'], square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['DOFs'], square_hex8_coarse0_xx_out.iloc[1]['DOFs'], square_hex8_coarse1_xx_out.iloc[1]['DOFs'], square_hex8_coarse_out.iloc[1]['DOFs'], square_hex8_refine0_xx_out.iloc[1]['DOFs'], square_hex8_refine_xx_out.iloc[1]['DOFs']]
# square_hex8_xx_n_nodes = [square_hex8_unitcell_Vf47x_xx_out.iloc[1]['n_nodes'], square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['n_nodes'], square_hex8_coarse0_xx_out.iloc[1]['n_nodes'], square_hex8_coarse1_xx_out.iloc[1]['n_nodes'], square_hex8_coarse_xx_out.iloc[1]['n_nodes'], square_hex8_refine0_xx_out.iloc[1]['n_nodes'], square_hex8_refine_xx_out.iloc[1]['n_nodes']]
# square_hex8_xx_n_elements = [square_hex8_unitcell_Vf47x_xx_out.iloc[1]['n_elements'], square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['n_elements'], square_hex8_coarse0_xx_out.iloc[1]['n_elements'], square_hex8_coarse1_xx_out.iloc[1]['n_elements'], square_hex8_coarse_xx_out.iloc[1]['n_elements'], square_hex8_refine0_xx_out.iloc[1]['n_elements'], square_hex8_refine_xx_out.iloc[1]['n_elements']]
# square_hex8_xx_s00 = [square_hex8_unitcell_Vf47x_xx_out.iloc[1]['s00'], square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['s22'], square_hex8_coarse0_xx_out.iloc[1]['s00'], square_hex8_coarse1_xx_out.iloc[1]['s00'], square_hex8_coarse_xx_out.iloc[1]['s00'], square_hex8_refine0_xx_out.iloc[1]['s00'], square_hex8_refine_xx_out.iloc[1]['s00']]
# square_hex8_xx_e00 = [square_hex8_unitcell_Vf47x_xx_out.iloc[1]['e00'], square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['e22'], square_hex8_coarse0_xx_out.iloc[1]['e00'], square_hex8_coarse1_xx_out.iloc[1]['e00'], square_hex8_coarse_xx_out.iloc[1]['e00'], square_hex8_refine0_xx_out.iloc[1]['e00'], square_hex8_refine_xx_out.iloc[1]['e00']]
# square_hex8_xx_e11 = [square_hex8_unitcell_Vf47x_xx_out.iloc[1]['e11'], square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['e11'], square_hex8_coarse0_xx_out.iloc[1]['e11'], square_hex8_coarse1_xx_out.iloc[1]['e11'], square_hex8_coarse_xx_out.iloc[1]['e11'], square_hex8_refine0_xx_out.iloc[1]['e11'], square_hex8_refine_xx_out.iloc[1]['e11']]
# square_hex8_xx_e22 = [square_hex8_unitcell_Vf47x_xx_out.iloc[1]['e22'], square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['e00'], square_hex8_coarse0_xx_out.iloc[1]['e22'], square_hex8_coarse1_xx_out.iloc[1]['e22'], square_hex8_coarse_xx_out.iloc[1]['e22'], square_hex8_refine0_xx_out.iloc[1]['e22'], square_hex8_refine_xx_out.iloc[1]['e11']]
# square_hex8_xx_C11 = [square_hex8_unitcell_Vf47x_xx_out.iloc[1]['C11'], square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['C11'], square_hex8_coarse0_xx_out.iloc[1]['C11'], square_hex8_coarse1_xx_out.iloc[1]['C11'], square_hex8_coarse_xx_out.iloc[1]['C11'], square_hex8_refine0_xx_out.iloc[1]['C11'], square_hex8_refine_xx_out.iloc[1]['C11']]
# square_hex8_xx_se = [square_hex8_unitcell_Vf47x_xx_out.iloc[1]['strain_energy'], square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['strain_energy'], square_hex8_coarse0_xx_out.iloc[1]['strain_energy'], square_hex8_coarse1_xx_out.iloc[1]['strain_energy'], square_hex8_coarse_xx_out.iloc[1]['strain_energy'], square_hex8_refine0_xx_out.iloc[1]['strain_energy'], square_hex8_refine_xx_out.iloc[1]['strain_energy']]

# square_hex8_xx_ndof = [square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['DOFs'], square_hex8_coarse0_xx_out.iloc[1]['DOFs'], square_hex8_coarse1_xx_out.iloc[1]['DOFs'], square_hex8_coarse_out.iloc[1]['DOFs'], square_hex8_refine0_xx_out.iloc[1]['DOFs'], square_hex8_refine1_xx_out.iloc[1]['DOFs'], square_hex8_refine_xx_out.iloc[1]['DOFs']]
# square_hex8_xx_n_nodes = [square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['n_nodes'], square_hex8_coarse0_xx_out.iloc[1]['n_nodes'], square_hex8_coarse1_xx_out.iloc[1]['n_nodes'], square_hex8_coarse_xx_out.iloc[1]['n_nodes'], square_hex8_refine0_xx_out.iloc[1]['n_nodes'], square_hex8_refine1_xx_out.iloc[1]['n_nodes'], square_hex8_refine_xx_out.iloc[1]['n_nodes']]
# square_hex8_xx_n_elements = [square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['n_elements'], square_hex8_coarse0_xx_out.iloc[1]['n_elements'], square_hex8_coarse1_xx_out.iloc[1]['n_elements'], square_hex8_coarse_xx_out.iloc[1]['n_elements'], square_hex8_refine0_xx_out.iloc[1]['n_elements'], square_hex8_refine1_xx_out.iloc[1]['n_elements'], square_hex8_refine_xx_out.iloc[1]['n_elements']]
# square_hex8_xx_s00 = [square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['s22'], square_hex8_coarse0_xx_out.iloc[1]['s00'], square_hex8_coarse1_xx_out.iloc[1]['s00'], square_hex8_coarse_xx_out.iloc[1]['s00'], square_hex8_refine0_xx_out.iloc[1]['s00'], square_hex8_refine1_xx_out.iloc[1]['s00'], square_hex8_refine_xx_out.iloc[1]['s00']]
# square_hex8_xx_e00 = [square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['e22'], square_hex8_coarse0_xx_out.iloc[1]['e00'], square_hex8_coarse1_xx_out.iloc[1]['e00'], square_hex8_coarse_xx_out.iloc[1]['e00'], square_hex8_refine0_xx_out.iloc[1]['e00'], square_hex8_refine1_xx_out.iloc[1]['e00'], square_hex8_refine_xx_out.iloc[1]['e00']]
# square_hex8_xx_e11 = [square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['e11'], square_hex8_coarse0_xx_out.iloc[1]['e11'], square_hex8_coarse1_xx_out.iloc[1]['e11'], square_hex8_coarse_xx_out.iloc[1]['e11'], square_hex8_refine0_xx_out.iloc[1]['e11'], square_hex8_refine1_xx_out.iloc[1]['e11'], square_hex8_refine_xx_out.iloc[1]['e11']]
# square_hex8_xx_e22 = [square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['e00'], square_hex8_coarse0_xx_out.iloc[1]['e22'], square_hex8_coarse1_xx_out.iloc[1]['e22'], square_hex8_coarse_xx_out.iloc[1]['e22'], square_hex8_refine0_xx_out.iloc[1]['e22'], square_hex8_refine1_xx_out.iloc[1]['e11'], square_hex8_refine_xx_out.iloc[1]['e11']]
# square_hex8_xx_C11 = [square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['C11'], square_hex8_coarse0_xx_out.iloc[1]['C11'], square_hex8_coarse1_xx_out.iloc[1]['C11'], square_hex8_coarse_xx_out.iloc[1]['C11'], square_hex8_refine0_xx_out.iloc[1]['C11'], square_hex8_refine1_xx_out.iloc[1]['C11'], square_hex8_refine_xx_out.iloc[1]['C11']]
# square_hex8_xx_se = [square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['strain_energy'], square_hex8_coarse0_xx_out.iloc[1]['strain_energy'], square_hex8_coarse1_xx_out.iloc[1]['strain_energy'], square_hex8_coarse_xx_out.iloc[1]['strain_energy'], square_hex8_refine0_xx_out.iloc[1]['strain_energy'], square_hex8_refine1_xx_out.iloc[1]['strain_energy'], square_hex8_refine_xx_out.iloc[1]['strain_energy']]
# square_hex8_xx_cost = [square_hex8_unitcell_Vf47_refine_xx_out.iloc[1]['run_time'], square_hex8_coarse0_xx_out.iloc[1]['run_time'], square_hex8_coarse1_xx_out.iloc[1]['run_time'], square_hex8_coarse_xx_out.iloc[1]['run_time'], square_hex8_refine0_xx_out.iloc[1]['run_time'], square_hex8_refine1_xx_out.iloc[1]['run_time'], square_hex8_refine_xx_out.iloc[1]['run_time']]


square_hex8_xx_ndof = [square_hex8_coarse0_xx_out.iloc[1]['DOFs'], square_hex8_coarse1_xx_out.iloc[1]['DOFs'], square_hex8_coarse_xx_out.iloc[1]['DOFs'], square_hex8_refine0_xx_out.iloc[1]['DOFs'], square_hex8_refine1_xx_out.iloc[1]['DOFs'], square_hex8_refine_xx_out.iloc[1]['DOFs']]
square_hex8_xx_n_nodes = [square_hex8_coarse0_xx_out.iloc[1]['n_nodes'], square_hex8_coarse1_xx_out.iloc[1]['n_nodes'], square_hex8_coarse_xx_out.iloc[1]['n_nodes'], square_hex8_refine0_xx_out.iloc[1]['n_nodes'], square_hex8_refine1_xx_out.iloc[1]['n_nodes'], square_hex8_refine_xx_out.iloc[1]['n_nodes']]
square_hex8_xx_n_elements = [square_hex8_coarse0_xx_out.iloc[1]['n_elements'], square_hex8_coarse1_xx_out.iloc[1]['n_elements'], square_hex8_coarse_xx_out.iloc[1]['n_elements'], square_hex8_refine0_xx_out.iloc[1]['n_elements'], square_hex8_refine1_xx_out.iloc[1]['n_elements'], square_hex8_refine_xx_out.iloc[1]['n_elements']]
square_hex8_xx_s00 = [square_hex8_coarse0_xx_out.iloc[1]['s00'], square_hex8_coarse1_xx_out.iloc[1]['s00'], square_hex8_coarse_xx_out.iloc[1]['s00'], square_hex8_refine0_xx_out.iloc[1]['s00'], square_hex8_refine1_xx_out.iloc[1]['s00'], square_hex8_refine_xx_out.iloc[1]['s00']]
square_hex8_xx_e00 = [square_hex8_coarse0_xx_out.iloc[1]['e00'], square_hex8_coarse1_xx_out.iloc[1]['e00'], square_hex8_coarse_xx_out.iloc[1]['e00'], square_hex8_refine0_xx_out.iloc[1]['e00'], square_hex8_refine1_xx_out.iloc[1]['e00'], square_hex8_refine_xx_out.iloc[1]['e00']]
square_hex8_xx_e11 = [square_hex8_coarse0_xx_out.iloc[1]['e11'], square_hex8_coarse1_xx_out.iloc[1]['e11'], square_hex8_coarse_xx_out.iloc[1]['e11'], square_hex8_refine0_xx_out.iloc[1]['e11'], square_hex8_refine1_xx_out.iloc[1]['e11'], square_hex8_refine_xx_out.iloc[1]['e11']]
square_hex8_xx_e22 = [square_hex8_coarse0_xx_out.iloc[1]['e22'], square_hex8_coarse1_xx_out.iloc[1]['e22'], square_hex8_coarse_xx_out.iloc[1]['e22'], square_hex8_refine0_xx_out.iloc[1]['e22'], square_hex8_refine1_xx_out.iloc[1]['e11'], square_hex8_refine_xx_out.iloc[1]['e11']]
square_hex8_xx_C11 = [square_hex8_coarse0_xx_out.iloc[1]['C11'], square_hex8_coarse1_xx_out.iloc[1]['C11'], square_hex8_coarse_xx_out.iloc[1]['C11'], square_hex8_refine0_xx_out.iloc[1]['C11'], square_hex8_refine1_xx_out.iloc[1]['C11'], square_hex8_refine_xx_out.iloc[1]['C11']]
square_hex8_xx_se = [square_hex8_coarse0_xx_out.iloc[1]['strain_energy'], square_hex8_coarse1_xx_out.iloc[1]['strain_energy'], square_hex8_coarse_xx_out.iloc[1]['strain_energy'], square_hex8_refine0_xx_out.iloc[1]['strain_energy'], square_hex8_refine1_xx_out.iloc[1]['strain_energy'], square_hex8_refine_xx_out.iloc[1]['strain_energy']]
square_hex8_xx_cost = [square_hex8_coarse0_xx_out.iloc[1]['run_time'], square_hex8_coarse1_xx_out.iloc[1]['run_time'], square_hex8_coarse_xx_out.iloc[1]['run_time'], square_hex8_refine0_xx_out.iloc[1]['run_time'], square_hex8_refine1_xx_out.iloc[1]['run_time'], square_hex8_refine_xx_out.iloc[1]['run_time']]

square_hex20_xx_ndof = [square_hex20_coarse0_xx_out.iloc[1]['DOFs'], square_hex20_coarse1_xx_out.iloc[1]['DOFs'], square_hex20_coarse_xx_out.iloc[1]['DOFs'], square_hex20_refine0_xx_out.iloc[1]['DOFs'], square_hex20_refine1_xx_out.iloc[1]['DOFs'], square_hex20_refine_xx_out.iloc[1]['DOFs']]
square_hex20_xx_n_nodes = [square_hex20_coarse0_xx_out.iloc[1]['n_nodes'], square_hex20_coarse1_xx_out.iloc[1]['n_nodes'], square_hex20_coarse_xx_out.iloc[1]['n_nodes'], square_hex20_refine0_xx_out.iloc[1]['n_nodes'], square_hex20_refine1_xx_out.iloc[1]['n_nodes'], square_hex20_refine_xx_out.iloc[1]['n_nodes']]
square_hex20_xx_n_elements = [square_hex20_coarse0_xx_out.iloc[1]['n_elements'], square_hex20_coarse1_xx_out.iloc[1]['n_elements'], square_hex20_coarse_xx_out.iloc[1]['n_elements'], square_hex20_refine0_xx_out.iloc[1]['n_elements'],square_hex20_refine1_xx_out.iloc[1]['n_elements'], square_hex20_refine_xx_out.iloc[1]['n_elements']]
square_hex20_xx_s00 = [square_hex20_coarse0_xx_out.iloc[1]['s00'], square_hex20_coarse1_xx_out.iloc[1]['s00'], square_hex20_coarse_xx_out.iloc[1]['s00'], square_hex20_refine0_xx_out.iloc[1]['s00'], square_hex20_refine1_xx_out.iloc[1]['s00'], square_hex20_refine_xx_out.iloc[1]['s00']]
square_hex20_xx_e00 = [square_hex20_coarse0_xx_out.iloc[1]['e00'], square_hex20_coarse1_xx_out.iloc[1]['e00'], square_hex20_coarse_xx_out.iloc[1]['e00'], square_hex20_refine0_xx_out.iloc[1]['e00'], square_hex20_refine1_xx_out.iloc[1]['e00'], square_hex20_refine_xx_out.iloc[1]['e00']]
square_hex20_xx_e11 = [square_hex20_coarse0_xx_out.iloc[1]['e11'], square_hex20_coarse1_xx_out.iloc[1]['e11'], square_hex20_coarse_xx_out.iloc[1]['e11'], square_hex20_refine0_xx_out.iloc[1]['e11'], square_hex20_refine1_xx_out.iloc[1]['e11'], square_hex20_refine_xx_out.iloc[1]['e11']]
square_hex20_xx_e22 = [square_hex20_coarse0_xx_out.iloc[1]['e22'], square_hex20_coarse1_xx_out.iloc[1]['e22'], square_hex20_coarse_xx_out.iloc[1]['e22'], square_hex20_refine0_xx_out.iloc[1]['e22'], square_hex20_refine1_xx_out.iloc[1]['e22'], square_hex20_refine_xx_out.iloc[1]['e22']]
square_hex20_xx_C11 = [square_hex20_coarse0_xx_out.iloc[1]['C11'], square_hex20_coarse1_xx_out.iloc[1]['C11'], square_hex20_coarse_xx_out.iloc[1]['C11'], square_hex20_refine0_xx_out.iloc[1]['C11'], square_hex20_refine1_xx_out.iloc[1]['C11'], square_hex20_refine_xx_out.iloc[1]['C11']]
square_hex20_xx_se = [square_hex20_coarse0_xx_out.iloc[1]['strain_energy'], square_hex20_coarse1_xx_out.iloc[1]['strain_energy'], square_hex20_coarse_xx_out.iloc[1]['strain_energy'], square_hex20_refine0_xx_out.iloc[1]['strain_energy'], square_hex20_refine1_xx_out.iloc[1]['strain_energy'], square_hex20_refine_xx_out.iloc[1]['strain_energy']]
square_hex20_xx_cost = [square_hex20_coarse0_xx_out.iloc[1]['run_time'], square_hex20_coarse1_xx_out.iloc[1]['run_time'], square_hex20_coarse_xx_out.iloc[1]['run_time'], square_hex20_refine0_xx_out.iloc[1]['run_time'], square_hex20_refine1_xx_out.iloc[1]['run_time'], square_hex20_refine_xx_out.iloc[1]['run_time']]

square_tet4_xx_ndof = [square_tet4_coarse0_xx_out.iloc[1]['DOFs'], square_tet4_coarse1_xx_out.iloc[1]['DOFs'], square_tet4_coarse_xx_out.iloc[1]['DOFs'], square_tet4_refine0_xx_out.iloc[1]['DOFs'],square_tet4_refine1_xx_out.iloc[1]['DOFs'], square_tet4_refine_xx_out.iloc[1]['DOFs']]
square_tet4_xx_n_nodes = [square_tet4_coarse0_xx_out.iloc[1]['n_nodes'], square_tet4_coarse1_xx_out.iloc[1]['n_nodes'], square_tet4_coarse_xx_out.iloc[1]['n_nodes'], square_tet4_refine0_xx_out.iloc[1]['n_nodes'], square_tet4_refine1_xx_out.iloc[1]['n_nodes'], square_tet4_refine_xx_out.iloc[1]['n_nodes']]
square_tet4_xx_n_elements =  [square_tet4_coarse0_xx_out.iloc[1]['n_elements'], square_tet4_coarse1_xx_out.iloc[1]['n_elements'], square_tet4_coarse_xx_out.iloc[1]['n_elements'], square_tet4_refine0_xx_out.iloc[1]['n_elements'], square_tet4_refine1_xx_out.iloc[1]['n_elements'], square_tet4_refine_xx_out.iloc[1]['n_elements']]
square_tet4_xx_s00 = [square_tet4_coarse0_xx_out.iloc[1]['s00'], square_tet4_coarse1_xx_out.iloc[1]['s00'], square_tet4_coarse_xx_out.iloc[1]['s00'], square_tet4_refine0_xx_out.iloc[1]['s00'], square_tet4_refine1_xx_out.iloc[1]['s00'], square_tet4_refine_xx_out.iloc[1]['s00']]
square_tet4_xx_e00 = [square_tet4_coarse0_xx_out.iloc[1]['e00'], square_tet4_coarse1_xx_out.iloc[1]['e00'], square_tet4_coarse_xx_out.iloc[1]['e00'], square_tet4_refine0_xx_out.iloc[1]['e00'], square_tet4_refine1_xx_out.iloc[1]['e00'], square_tet4_refine_xx_out.iloc[1]['e00']]
square_tet4_xx_e11 = [square_tet4_coarse0_xx_out.iloc[1]['e11'], square_tet4_coarse1_xx_out.iloc[1]['e11'], square_tet4_coarse_xx_out.iloc[1]['e11'], square_tet4_refine0_xx_out.iloc[1]['e11'], square_tet4_refine1_xx_out.iloc[1]['e11'], square_tet4_refine_xx_out.iloc[1]['e11']]
square_tet4_xx_e22 = [square_tet4_coarse0_xx_out.iloc[1]['e22'], square_tet4_coarse1_xx_out.iloc[1]['e22'], square_tet4_coarse_xx_out.iloc[1]['e22'], square_tet4_refine0_xx_out.iloc[1]['e22'], square_tet4_refine1_xx_out.iloc[1]['e11'], square_tet4_refine_xx_out.iloc[1]['e11']]
square_tet4_xx_C11 = [square_tet4_coarse0_xx_out.iloc[1]['C11'], square_tet4_coarse1_xx_out.iloc[1]['C11'], square_tet4_coarse_xx_out.iloc[1]['C11'], square_tet4_refine0_xx_out.iloc[1]['C11'], square_tet4_refine1_xx_out.iloc[1]['C11'], square_tet4_refine_xx_out.iloc[1]['C11']]
square_tet4_xx_se = [square_tet4_coarse0_xx_out.iloc[1]['strain_energy'], square_tet4_coarse1_xx_out.iloc[1]['strain_energy'], square_tet4_coarse_xx_out.iloc[1]['strain_energy'], square_tet4_refine0_xx_out.iloc[1]['strain_energy'], square_tet4_refine1_xx_out.iloc[1]['strain_energy'], square_tet4_refine_xx_out.iloc[1]['strain_energy']]
square_tet4_xx_cost = [square_tet4_coarse0_xx_out.iloc[1]['run_time'], square_tet4_coarse1_xx_out.iloc[1]['run_time'], square_tet4_coarse_xx_out.iloc[1]['run_time'], square_tet4_refine0_xx_out.iloc[1]['run_time'], square_tet4_refine1_xx_out.iloc[1]['run_time'], square_tet4_refine_xx_out.iloc[1]['run_time']]

square_tet10_xx_ndof = [square_tet10_coarse00_xx_out.iloc[1]['DOFs'], square_tet10_coarse0_xx_out.iloc[1]['DOFs'], square_tet10_coarse1_xx_out.iloc[1]['DOFs'], square_tet10_coarse_xx_out.iloc[1]['DOFs'], square_tet10_refine0_xx_out.iloc[1]['DOFs'], square_tet10_refine_xx_out.iloc[1]['DOFs']]
square_tet10_xx_n_nodes = [square_tet10_coarse00_xx_out.iloc[1]['n_nodes'], square_tet10_coarse0_xx_out.iloc[1]['n_nodes'], square_tet10_coarse1_xx_out.iloc[1]['n_nodes'], square_tet10_coarse_xx_out.iloc[1]['n_nodes'], square_tet10_refine0_xx_out.iloc[1]['n_nodes'], square_tet10_refine_xx_out.iloc[1]['n_nodes']]
square_tet10_xx_n_elements =  [square_tet10_coarse00_xx_out.iloc[1]['n_elements'], square_tet10_coarse0_xx_out.iloc[1]['n_elements'], square_tet10_coarse1_xx_out.iloc[1]['n_elements'], square_tet10_coarse_xx_out.iloc[1]['n_elements'], square_tet10_refine0_xx_out.iloc[1]['n_elements'], square_tet4_refine_xx_out.iloc[1]['n_elements']]
square_tet10_xx_s00 = [square_tet10_coarse00_xx_out.iloc[1]['s00'], square_tet10_coarse0_xx_out.iloc[1]['s00'], square_tet10_coarse1_xx_out.iloc[1]['s00'], square_tet10_coarse_xx_out.iloc[1]['s00'], square_tet10_refine0_xx_out.iloc[1]['s00'], square_tet10_refine_xx_out.iloc[1]['s00']]
square_tet10_xx_e00 = [square_tet10_coarse00_xx_out.iloc[1]['e00'], square_tet10_coarse0_xx_out.iloc[1]['e00'], square_tet10_coarse1_xx_out.iloc[1]['e00'], square_tet10_coarse_xx_out.iloc[1]['e00'], square_tet10_refine0_xx_out.iloc[1]['e00'], square_tet10_refine_xx_out.iloc[1]['e00']]
square_tet10_xx_e11 = [square_tet10_coarse00_xx_out.iloc[1]['e11'], square_tet10_coarse0_xx_out.iloc[1]['e11'], square_tet10_coarse1_xx_out.iloc[1]['e11'], square_tet10_coarse_xx_out.iloc[1]['e11'], square_tet10_refine0_xx_out.iloc[1]['e11'], square_tet10_refine_xx_out.iloc[1]['e11']]
square_tet10_xx_e22 = [square_tet10_coarse00_xx_out.iloc[1]['e22'], square_tet10_coarse0_xx_out.iloc[1]['e22'], square_tet10_coarse1_xx_out.iloc[1]['e22'], square_tet10_coarse_xx_out.iloc[1]['e22'], square_tet10_refine0_xx_out.iloc[1]['e22'], square_tet10_refine_xx_out.iloc[1]['e11']]
square_tet10_xx_C11 = [square_tet10_coarse0_xx_out.iloc[1]['C11'], square_tet10_coarse1_xx_out.iloc[1]['C11'], square_tet10_coarse_xx_out.iloc[1]['C11'], square_tet10_refine0_xx_out.iloc[1]['C11'], square_tet10_refine_xx_out.iloc[1]['C11']]
square_tet10_xx_se = [square_tet10_coarse0_xx_out.iloc[1]['strain_energy'], square_tet10_coarse1_xx_out.iloc[1]['strain_energy'], square_tet10_coarse_xx_out.iloc[1]['strain_energy'], square_tet10_refine0_xx_out.iloc[1]['strain_energy'], square_tet10_refine_xx_out.iloc[1]['strain_energy']]
square_tet10_xx_cost = [square_tet10_coarse00_xx_out.iloc[1]['run_time'], square_tet10_coarse0_xx_out.iloc[1]['run_time'], square_tet10_coarse1_xx_out.iloc[1]['run_time'], square_tet10_coarse_xx_out.iloc[1]['run_time'], square_tet10_refine0_xx_out.iloc[1]['run_time'], square_tet10_refine_xx_out.iloc[1]['run_time']]

square_E11_hex8 = np.divide(square_hex8_xx_s00,square_hex8_xx_e00)
square_E11_hex20 = np.divide(square_hex20_xx_s00,square_hex20_xx_e00)
square_E11_tet4 = np.divide(square_tet4_xx_s00,square_tet4_xx_e00)
square_E11_tet10 = np.divide(square_tet10_xx_s00,square_tet10_xx_e00)

square_E11_hex8_error = np.divide(abs(square_E11_hex8-square_E11_hex8[5]), square_E11_hex8[5])*100
square_E11_hex20_error = np.divide(abs(square_E11_hex20-square_E11_hex20[5]), square_E11_hex20[5])*100
square_E11_tet4_error = np.divide(abs(square_E11_tet4-square_E11_tet4[5]), square_E11_tet4[5])*100
square_E11_tet10_error = np.divide(abs(square_E11_tet10-square_E11_tet10[5]), square_E11_tet10[5])*100
square_tet4_xx_e00

square_n12_hex8 = -np.divide(square_hex8_xx_e11,square_hex8_xx_e00)
square_n12_hex20 = -np.divide(square_hex20_xx_e11,square_hex20_xx_e00)
square_n12_tet4 = -np.divide(square_tet4_xx_e11,square_tet4_xx_e00)
square_n12_tet10 = -np.divide(square_tet10_xx_e11,square_tet10_xx_e00)

square_n12_hex8_error = np.divide(abs(square_n12_hex8-square_n12_hex8[5]), square_n12_hex8[5])*100
square_n12_hex20_error = np.divide(abs(square_n12_hex20-square_n12_hex20[5]), square_n12_hex20[5])*100
square_n12_tet4_error = np.divide(abs(square_n12_tet4-square_n12_tet4[5]), square_n12_tet4[5])*100
square_n12_tet10_error = np.divide(abs(square_n12_tet10-square_n12_tet10[5]), square_n12_tet10[5])*100


square_hex8_yy_ndof = [square_hex8_coarse0_yy_out.iloc[1]['DOFs'], square_hex8_coarse1_yy_out.iloc[1]['DOFs'], square_hex8_coarse_yy_out.iloc[1]['DOFs'], square_hex8_refine0_yy_out.iloc[1]['DOFs'], square_hex8_refine1_yy_out.iloc[1]['DOFs'], square_hex8_refine_yy_out.iloc[1]['DOFs']]
square_hex8_yy_n_nodes = [square_hex8_coarse0_yy_out.iloc[1]['n_nodes'], square_hex8_coarse1_yy_out.iloc[1]['n_nodes'], square_hex8_coarse_yy_out.iloc[1]['n_nodes'], square_hex8_refine0_yy_out.iloc[1]['n_nodes'], square_hex8_refine1_yy_out.iloc[1]['n_nodes'], square_hex8_refine_yy_out.iloc[1]['n_nodes']]
square_hex8_yy_n_elements = [square_hex8_coarse0_yy_out.iloc[1]['n_elements'], square_hex8_coarse1_yy_out.iloc[1]['n_elements'], square_hex8_coarse_yy_out.iloc[1]['n_elements'], square_hex8_refine0_yy_out.iloc[1]['n_elements'], square_hex8_refine1_yy_out.iloc[1]['n_elements'], square_hex8_refine_yy_out.iloc[1]['n_elements']]
square_hex8_yy_s11 = [square_hex8_coarse0_yy_out.iloc[1]['s11'], square_hex8_coarse1_yy_out.iloc[1]['s11'], square_hex8_coarse_yy_out.iloc[1]['s11'], square_hex8_refine0_yy_out.iloc[1]['s11'], square_hex8_refine1_yy_out.iloc[1]['s11'], square_hex8_refine_yy_out.iloc[1]['s11']]
square_hex8_yy_e00 = [square_hex8_coarse0_yy_out.iloc[1]['e00'], square_hex8_coarse1_yy_out.iloc[1]['e00'], square_hex8_coarse_yy_out.iloc[1]['e00'], square_hex8_refine0_yy_out.iloc[1]['e00'], square_hex8_refine1_yy_out.iloc[1]['e00'], square_hex8_refine_yy_out.iloc[1]['e00']]
square_hex8_yy_e11 = [square_hex8_coarse0_yy_out.iloc[1]['e11'], square_hex8_coarse1_yy_out.iloc[1]['e11'], square_hex8_coarse_yy_out.iloc[1]['e11'], square_hex8_refine0_yy_out.iloc[1]['e11'], square_hex8_refine1_yy_out.iloc[1]['e11'], square_hex8_refine_yy_out.iloc[1]['e11']]
square_hex8_yy_e22 = [square_hex8_coarse0_yy_out.iloc[1]['e22'], square_hex8_coarse1_yy_out.iloc[1]['e22'], square_hex8_coarse_yy_out.iloc[1]['e22'], square_hex8_refine0_yy_out.iloc[1]['e22'], square_hex8_refine1_yy_out.iloc[1]['e11'], square_hex8_refine_yy_out.iloc[1]['e11']]
square_hex8_yy_C11 = [square_hex8_coarse0_yy_out.iloc[1]['C11'], square_hex8_coarse1_yy_out.iloc[1]['C11'], square_hex8_coarse_yy_out.iloc[1]['C11'], square_hex8_refine0_yy_out.iloc[1]['C11'], square_hex8_refine1_yy_out.iloc[1]['C11'], square_hex8_refine_yy_out.iloc[1]['C11']]
square_hex8_yy_se = [square_hex8_coarse0_yy_out.iloc[1]['strain_energy'], square_hex8_coarse1_yy_out.iloc[1]['strain_energy'], square_hex8_coarse_yy_out.iloc[1]['strain_energy'], square_hex8_refine0_yy_out.iloc[1]['strain_energy'], square_hex8_refine1_yy_out.iloc[1]['strain_energy'], square_hex8_refine_yy_out.iloc[1]['strain_energy']]
square_hex8_yy_cost = [square_hex8_coarse0_yy_out.iloc[1]['run_time'], square_hex8_coarse1_yy_out.iloc[1]['run_time'], square_hex8_coarse_yy_out.iloc[1]['run_time'], square_hex8_refine0_yy_out.iloc[1]['run_time'], square_hex8_refine1_yy_out.iloc[1]['run_time'], square_hex8_refine_yy_out.iloc[1]['run_time']]

square_hex20_yy_ndof = [square_hex20_coarse0_yy_out.iloc[1]['DOFs'], square_hex20_coarse1_yy_out.iloc[1]['DOFs'], square_hex20_coarse_yy_out.iloc[1]['DOFs'], square_hex20_refine0_yy_out.iloc[1]['DOFs'], square_hex20_refine1_yy_out.iloc[1]['DOFs'], square_hex20_refine_yy_out.iloc[1]['DOFs']]
square_hex20_yy_n_nodes = [square_hex20_coarse0_yy_out.iloc[1]['n_nodes'], square_hex20_coarse1_yy_out.iloc[1]['n_nodes'], square_hex20_coarse_yy_out.iloc[1]['n_nodes'], square_hex20_refine0_yy_out.iloc[1]['n_nodes'], square_hex20_refine1_yy_out.iloc[1]['n_nodes'], square_hex20_refine_yy_out.iloc[1]['n_nodes']]
square_hex20_yy_n_elements = [square_hex20_coarse0_yy_out.iloc[1]['n_elements'], square_hex20_coarse1_yy_out.iloc[1]['n_elements'], square_hex20_coarse_yy_out.iloc[1]['n_elements'], square_hex20_refine0_yy_out.iloc[1]['n_elements'],square_hex20_refine1_yy_out.iloc[1]['n_elements'], square_hex20_refine_yy_out.iloc[1]['n_elements']]
square_hex20_yy_s11 = [square_hex20_coarse0_yy_out.iloc[1]['s11'], square_hex20_coarse1_yy_out.iloc[1]['s11'], square_hex20_coarse_yy_out.iloc[1]['s11'], square_hex20_refine0_yy_out.iloc[1]['s11'], square_hex20_refine1_yy_out.iloc[1]['s11'], square_hex20_refine_yy_out.iloc[1]['s11']]
square_hex20_yy_e00 = [square_hex20_coarse0_yy_out.iloc[1]['e00'], square_hex20_coarse1_yy_out.iloc[1]['e00'], square_hex20_coarse_yy_out.iloc[1]['e00'], square_hex20_refine0_yy_out.iloc[1]['e00'], square_hex20_refine1_yy_out.iloc[1]['e00'], square_hex20_refine_yy_out.iloc[1]['e00']]
square_hex20_yy_e11 = [square_hex20_coarse0_yy_out.iloc[1]['e11'], square_hex20_coarse1_yy_out.iloc[1]['e11'], square_hex20_coarse_yy_out.iloc[1]['e11'], square_hex20_refine0_yy_out.iloc[1]['e11'], square_hex20_refine1_yy_out.iloc[1]['e11'], square_hex20_refine_yy_out.iloc[1]['e11']]
square_hex20_yy_e22 = [square_hex20_coarse0_yy_out.iloc[1]['e22'], square_hex20_coarse1_yy_out.iloc[1]['e22'], square_hex20_coarse_yy_out.iloc[1]['e22'], square_hex20_refine0_yy_out.iloc[1]['e22'], square_hex20_refine1_yy_out.iloc[1]['e22'], square_hex20_refine_yy_out.iloc[1]['e22']]
square_hex20_yy_C11 = [square_hex20_coarse0_yy_out.iloc[1]['C11'], square_hex20_coarse1_yy_out.iloc[1]['C11'], square_hex20_coarse_yy_out.iloc[1]['C11'], square_hex20_refine0_yy_out.iloc[1]['C11'], square_hex20_refine1_yy_out.iloc[1]['C11'], square_hex20_refine_yy_out.iloc[1]['C11']]
square_hex20_yy_se = [square_hex20_coarse0_yy_out.iloc[1]['strain_energy'], square_hex20_coarse1_yy_out.iloc[1]['strain_energy'], square_hex20_coarse_yy_out.iloc[1]['strain_energy'], square_hex20_refine0_yy_out.iloc[1]['strain_energy'], square_hex20_refine1_yy_out.iloc[1]['strain_energy'], square_hex20_refine_yy_out.iloc[1]['strain_energy']]
square_hex20_yy_cost = [square_hex20_coarse0_yy_out.iloc[1]['run_time'], square_hex20_coarse1_yy_out.iloc[1]['run_time'], square_hex20_coarse_yy_out.iloc[1]['run_time'], square_hex20_refine0_yy_out.iloc[1]['run_time'], square_hex20_refine1_yy_out.iloc[1]['run_time'], square_hex20_refine_yy_out.iloc[1]['run_time']]

square_tet4_yy_ndof = [square_tet4_coarse0_yy_out.iloc[1]['DOFs'], square_tet4_coarse1_yy_out.iloc[1]['DOFs'], square_tet4_coarse_yy_out.iloc[1]['DOFs'], square_tet4_refine0_yy_out.iloc[1]['DOFs'], square_tet4_refine1_yy_out.iloc[1]['DOFs'], square_tet4_refine_yy_out.iloc[1]['DOFs']]
square_tet4_yy_n_nodes = [square_tet4_coarse0_yy_out.iloc[1]['n_nodes'], square_tet4_coarse1_yy_out.iloc[1]['n_nodes'], square_tet4_coarse_yy_out.iloc[1]['n_nodes'], square_tet4_refine0_yy_out.iloc[1]['n_nodes'], square_tet4_refine1_yy_out.iloc[1]['n_nodes'], square_tet4_refine_yy_out.iloc[1]['n_nodes']]
square_tet4_yy_n_elements =  [square_tet4_coarse0_yy_out.iloc[1]['n_elements'], square_tet4_coarse1_yy_out.iloc[1]['n_elements'], square_tet4_coarse_yy_out.iloc[1]['n_elements'], square_tet4_refine0_yy_out.iloc[1]['n_elements'], square_tet4_refine1_yy_out.iloc[1]['n_elements'], square_tet4_refine_yy_out.iloc[1]['n_elements']]
square_tet4_yy_s11 = [square_tet4_coarse0_yy_out.iloc[1]['s11'], square_tet4_coarse1_yy_out.iloc[1]['s11'], square_tet4_coarse_yy_out.iloc[1]['s11'], square_tet4_refine0_yy_out.iloc[1]['s11'], square_tet4_refine1_yy_out.iloc[1]['s11'], square_tet4_refine_yy_out.iloc[1]['s11']]
square_tet4_yy_e00 = [square_tet4_coarse0_yy_out.iloc[1]['e00'], square_tet4_coarse1_yy_out.iloc[1]['e00'], square_tet4_coarse_yy_out.iloc[1]['e00'], square_tet4_refine0_yy_out.iloc[1]['e00'], square_tet4_refine1_yy_out.iloc[1]['e00'], square_tet4_refine_yy_out.iloc[1]['e00']]
square_tet4_yy_e11 = [square_tet4_coarse0_yy_out.iloc[1]['e11'], square_tet4_coarse1_yy_out.iloc[1]['e11'], square_tet4_coarse_yy_out.iloc[1]['e11'], square_tet4_refine0_yy_out.iloc[1]['e11'], square_tet4_refine1_yy_out.iloc[1]['e11'], square_tet4_refine_yy_out.iloc[1]['e11']]
square_tet4_yy_e22 = [square_tet4_coarse0_yy_out.iloc[1]['e22'], square_tet4_coarse1_yy_out.iloc[1]['e22'], square_tet4_coarse_yy_out.iloc[1]['e22'], square_tet4_refine0_yy_out.iloc[1]['e22'], square_tet4_refine1_yy_out.iloc[1]['e22'], square_tet4_refine_yy_out.iloc[1]['e22']]
square_tet4_yy_C11 = [square_tet4_coarse0_yy_out.iloc[1]['C11'], square_tet4_coarse1_yy_out.iloc[1]['C11'], square_tet4_coarse_yy_out.iloc[1]['C11'], square_tet4_refine0_yy_out.iloc[1]['C11'], square_tet4_refine_yy_out.iloc[1]['C11']]
square_tet4_yy_se = [square_tet4_coarse0_yy_out.iloc[1]['strain_energy'], square_tet4_coarse1_yy_out.iloc[1]['strain_energy'], square_tet4_coarse_yy_out.iloc[1]['strain_energy'], square_tet4_refine0_yy_out.iloc[1]['strain_energy'], square_tet4_refine_yy_out.iloc[1]['strain_energy']]
square_tet4_yy_cost = [square_tet4_coarse0_yy_out.iloc[1]['run_time'], square_tet4_coarse1_yy_out.iloc[1]['run_time'], square_tet4_coarse_yy_out.iloc[1]['run_time'], square_tet4_refine0_yy_out.iloc[1]['run_time'], square_tet4_refine_yy_out.iloc[1]['run_time']]

square_tet10_yy_ndof = [square_tet10_coarse00_yy_out.iloc[1]['DOFs'], square_tet10_coarse0_yy_out.iloc[1]['DOFs'], square_tet10_coarse1_yy_out.iloc[1]['DOFs'], square_tet10_coarse_yy_out.iloc[1]['DOFs'], square_tet10_refine0_yy_out.iloc[1]['DOFs'], square_tet10_refine_yy_out.iloc[1]['DOFs']]
square_tet10_yy_n_nodes = [square_tet10_coarse00_yy_out.iloc[1]['n_nodes'], square_tet10_coarse0_yy_out.iloc[1]['n_nodes'], square_tet10_coarse1_yy_out.iloc[1]['n_nodes'], square_tet10_coarse_yy_out.iloc[1]['n_nodes'], square_tet10_refine0_yy_out.iloc[1]['n_nodes'], square_tet10_refine_yy_out.iloc[1]['n_nodes']]
square_tet10_yy_n_elements =  [square_tet10_coarse00_yy_out.iloc[1]['n_elements'], square_tet10_coarse0_yy_out.iloc[1]['n_elements'], square_tet10_coarse1_yy_out.iloc[1]['n_elements'], square_tet10_coarse_yy_out.iloc[1]['n_elements'], square_tet10_refine0_yy_out.iloc[1]['n_elements'], square_tet4_refine_yy_out.iloc[1]['n_elements']]
square_tet10_yy_s11 = [square_tet10_coarse00_yy_out.iloc[1]['s11'], square_tet10_coarse0_yy_out.iloc[1]['s11'], square_tet10_coarse1_yy_out.iloc[1]['s11'], square_tet10_coarse_yy_out.iloc[1]['s11'], square_tet10_refine0_yy_out.iloc[1]['s11'], square_tet10_refine_yy_out.iloc[1]['s11']]
square_tet10_yy_e00 = [square_tet10_coarse00_yy_out.iloc[1]['e00'], square_tet10_coarse0_yy_out.iloc[1]['e00'], square_tet10_coarse1_yy_out.iloc[1]['e00'], square_tet10_coarse_yy_out.iloc[1]['e00'], square_tet10_refine0_yy_out.iloc[1]['e00'], square_tet10_refine_yy_out.iloc[1]['e00']]
square_tet10_yy_e11 = [square_tet10_coarse00_yy_out.iloc[1]['e11'], square_tet10_coarse0_yy_out.iloc[1]['e11'], square_tet10_coarse1_yy_out.iloc[1]['e11'], square_tet10_coarse_yy_out.iloc[1]['e11'], square_tet10_refine0_yy_out.iloc[1]['e11'], square_tet10_refine_yy_out.iloc[1]['e11']]
square_tet10_yy_e22 = [square_tet10_coarse00_yy_out.iloc[1]['e22'], square_tet10_coarse0_yy_out.iloc[1]['e22'], square_tet10_coarse1_yy_out.iloc[1]['e22'], square_tet10_coarse_yy_out.iloc[1]['e22'], square_tet10_refine0_yy_out.iloc[1]['e22'], square_tet10_refine_yy_out.iloc[1]['e11']]
square_tet10_yy_C11 = [square_tet10_coarse00_yy_out.iloc[1]['C11'], square_tet10_coarse0_yy_out.iloc[1]['C11'], square_tet10_coarse1_yy_out.iloc[1]['C11'], square_tet10_coarse_yy_out.iloc[1]['C11'], square_tet10_refine0_yy_out.iloc[1]['C11'], square_tet10_refine_yy_out.iloc[1]['C11']]
square_tet10_yy_se = [square_tet10_coarse00_yy_out.iloc[1]['strain_energy'], square_tet10_coarse0_yy_out.iloc[1]['strain_energy'], square_tet10_coarse1_yy_out.iloc[1]['strain_energy'], square_tet10_coarse_yy_out.iloc[1]['strain_energy'], square_tet10_refine0_yy_out.iloc[1]['strain_energy'], square_tet10_refine_yy_out.iloc[1]['strain_energy']]
square_tet10_yy_cost = [square_tet10_coarse00_yy_out.iloc[1]['run_time'], square_tet10_coarse0_yy_out.iloc[1]['run_time'], square_tet10_coarse1_yy_out.iloc[1]['run_time'], square_tet10_coarse_yy_out.iloc[1]['run_time'], square_tet10_refine0_yy_out.iloc[1]['run_time'], square_tet10_refine_yy_out.iloc[1]['run_time']]



square_E22_hex8 = np.divide(square_hex8_yy_s11,square_hex8_yy_e11)
square_E22_hex20 = np.divide(square_hex20_yy_s11,square_hex20_yy_e11)
square_E22_tet4 = np.divide(square_tet4_yy_s11,square_tet4_yy_e11)
square_E22_tet10 = np.divide(square_tet10_yy_s11,square_tet10_yy_e11)

square_E22_hex8_error = np.divide(abs(square_E22_hex8-square_E22_hex8[5]), square_E22_hex8[5])*100
square_E22_hex20_error = np.divide(abs(square_E22_hex20-square_E22_hex20[5]), square_E22_hex20[5])*100
square_E22_tet4_error = np.divide(abs(square_E22_tet4-square_E22_tet4[5]), square_E22_tet4[5])*100
square_E22_tet10_error = np.divide(abs(square_E22_tet10-square_E22_tet10[5]), square_E22_tet10[5])*100

# square_E22_tet4
hex_hex8_xx_ndof = [hex_hex8_coarse0_xx_out.iloc[1]['DOFs'], hex_hex8_coarse1_xx_out.iloc[1]['DOFs'], hex_hex8_coarse_xx_out.iloc[1]['DOFs'], hex_hex8_refine0_xx_out.iloc[1]['DOFs'], hex_hex8_refine1_xx_out.iloc[1]['DOFs'], hex_hex8_refine_xx_out.iloc[1]['DOFs']]
hex_hex8_xx_n_nodes = [hex_hex8_coarse0_xx_out.iloc[1]['n_nodes'], hex_hex8_coarse1_xx_out.iloc[1]['n_nodes'], hex_hex8_coarse_xx_out.iloc[1]['n_nodes'], hex_hex8_refine0_xx_out.iloc[1]['n_nodes'], hex_hex8_refine1_xx_out.iloc[1]['n_nodes'], hex_hex8_refine_xx_out.iloc[1]['n_nodes']]
hex_hex8_xx_n_elements = [hex_hex8_coarse0_xx_out.iloc[1]['n_elements'], hex_hex8_coarse1_xx_out.iloc[1]['n_elements'], hex_hex8_coarse_xx_out.iloc[1]['n_elements'], hex_hex8_refine0_xx_out.iloc[1]['n_elements'], hex_hex8_refine1_xx_out.iloc[1]['n_elements'], hex_hex8_refine_xx_out.iloc[1]['n_elements']]
hex_hex8_xx_s00 = [hex_hex8_coarse0_xx_out.iloc[1]['s00'], hex_hex8_coarse1_xx_out.iloc[1]['s00'], hex_hex8_coarse_xx_out.iloc[1]['s00'], hex_hex8_refine0_xx_out.iloc[1]['s00'], hex_hex8_refine1_xx_out.iloc[1]['s00'], hex_hex8_refine_xx_out.iloc[1]['s00']]
hex_hex8_xx_e00 = [hex_hex8_coarse0_xx_out.iloc[1]['e00'], hex_hex8_coarse1_xx_out.iloc[1]['e00'], hex_hex8_coarse_xx_out.iloc[1]['e00'], hex_hex8_refine0_xx_out.iloc[1]['e00'], hex_hex8_refine1_xx_out.iloc[1]['e00'], hex_hex8_refine_xx_out.iloc[1]['e00']]
hex_hex8_xx_e11 = [hex_hex8_coarse0_xx_out.iloc[1]['e11'], hex_hex8_coarse1_xx_out.iloc[1]['e11'], hex_hex8_coarse_xx_out.iloc[1]['e11'], hex_hex8_refine0_xx_out.iloc[1]['e11'], hex_hex8_refine1_xx_out.iloc[1]['e11'], hex_hex8_refine_xx_out.iloc[1]['e11']]
hex_hex8_xx_e22 = [hex_hex8_coarse0_xx_out.iloc[1]['e22'], hex_hex8_coarse1_xx_out.iloc[1]['e22'], hex_hex8_coarse_xx_out.iloc[1]['e22'], hex_hex8_refine0_xx_out.iloc[1]['e22'], hex_hex8_refine1_xx_out.iloc[1]['e11'], hex_hex8_refine_xx_out.iloc[1]['e11']]
hex_hex8_xx_C11 = [hex_hex8_coarse0_xx_out.iloc[1]['C11'], hex_hex8_coarse1_xx_out.iloc[1]['C11'], hex_hex8_coarse_xx_out.iloc[1]['C11'], hex_hex8_refine0_xx_out.iloc[1]['C11'], hex_hex8_refine1_xx_out.iloc[1]['C11'], hex_hex8_refine_xx_out.iloc[1]['C11']]
hex_hex8_xx_se = [hex_hex8_coarse0_xx_out.iloc[1]['strain_energy'], hex_hex8_coarse1_xx_out.iloc[1]['strain_energy'], hex_hex8_coarse_xx_out.iloc[1]['strain_energy'], hex_hex8_refine0_xx_out.iloc[1]['strain_energy'], hex_hex8_refine1_xx_out.iloc[1]['strain_energy'], hex_hex8_refine_xx_out.iloc[1]['strain_energy']]
hex_hex8_xx_cost = [hex_hex8_coarse0_xx_out.iloc[1]['run_time'], hex_hex8_coarse1_xx_out.iloc[1]['run_time'], hex_hex8_coarse_xx_out.iloc[1]['run_time'], hex_hex8_refine0_xx_out.iloc[1]['run_time'], hex_hex8_refine1_xx_out.iloc[1]['run_time'], hex_hex8_refine_xx_out.iloc[1]['run_time']]

hex_hex20_xx_ndof = [hex_hex20_coarse0_xx_out.iloc[1]['DOFs'], hex_hex20_coarse1_xx_out.iloc[1]['DOFs'], hex_hex20_coarse_xx_out.iloc[1]['DOFs'], hex_hex20_refine0_xx_out.iloc[1]['DOFs'], hex_hex20_refine1_xx_out.iloc[1]['DOFs'], hex_hex20_refine_xx_out.iloc[1]['DOFs']]
hex_hex20_xx_n_nodes = [hex_hex20_coarse0_xx_out.iloc[1]['n_nodes'], hex_hex20_coarse1_xx_out.iloc[1]['n_nodes'], hex_hex20_coarse_xx_out.iloc[1]['n_nodes'], hex_hex20_refine0_xx_out.iloc[1]['n_nodes'], hex_hex20_refine1_xx_out.iloc[1]['n_nodes'], hex_hex20_refine_xx_out.iloc[1]['n_nodes']]
hex_hex20_xx_n_elements = [hex_hex20_coarse0_xx_out.iloc[1]['n_elements'], hex_hex20_coarse1_xx_out.iloc[1]['n_elements'], hex_hex20_coarse_xx_out.iloc[1]['n_elements'], hex_hex20_refine0_xx_out.iloc[1]['n_elements'],hex_hex20_refine1_xx_out.iloc[1]['n_elements'], hex_hex20_refine_xx_out.iloc[1]['n_elements']]
hex_hex20_xx_s00 = [hex_hex20_coarse0_xx_out.iloc[1]['s00'], hex_hex20_coarse1_xx_out.iloc[1]['s00'], hex_hex20_coarse_xx_out.iloc[1]['s00'], hex_hex20_refine0_xx_out.iloc[1]['s00'], hex_hex20_refine1_xx_out.iloc[1]['s00'], hex_hex20_refine_xx_out.iloc[1]['s00']]
hex_hex20_xx_e00 = [hex_hex20_coarse0_xx_out.iloc[1]['e00'], hex_hex20_coarse1_xx_out.iloc[1]['e00'], hex_hex20_coarse_xx_out.iloc[1]['e00'], hex_hex20_refine0_xx_out.iloc[1]['e00'], hex_hex20_refine1_xx_out.iloc[1]['e00'], hex_hex20_refine_xx_out.iloc[1]['e00']]
hex_hex20_xx_e11 = [hex_hex20_coarse0_xx_out.iloc[1]['e11'], hex_hex20_coarse1_xx_out.iloc[1]['e11'], hex_hex20_coarse_xx_out.iloc[1]['e11'], hex_hex20_refine0_xx_out.iloc[1]['e11'], hex_hex20_refine1_xx_out.iloc[1]['e11'], hex_hex20_refine_xx_out.iloc[1]['e11']]
hex_hex20_xx_e22 = [hex_hex20_coarse0_xx_out.iloc[1]['e22'], hex_hex20_coarse1_xx_out.iloc[1]['e22'], hex_hex20_coarse_xx_out.iloc[1]['e22'], hex_hex20_refine0_xx_out.iloc[1]['e22'], hex_hex20_refine1_xx_out.iloc[1]['e22'], hex_hex20_refine_xx_out.iloc[1]['e22']]
hex_hex20_xx_C11 = [hex_hex20_coarse0_xx_out.iloc[1]['C11'], hex_hex20_coarse1_xx_out.iloc[1]['C11'], hex_hex20_coarse_xx_out.iloc[1]['C11'], hex_hex20_refine0_xx_out.iloc[1]['C11'], hex_hex20_refine1_xx_out.iloc[1]['C11'], hex_hex20_refine_xx_out.iloc[1]['C11']]
hex_hex20_xx_se = [hex_hex20_coarse0_xx_out.iloc[1]['strain_energy'], hex_hex20_coarse1_xx_out.iloc[1]['strain_energy'], hex_hex20_coarse_xx_out.iloc[1]['strain_energy'], hex_hex20_refine0_xx_out.iloc[1]['strain_energy'], hex_hex20_refine1_xx_out.iloc[1]['strain_energy'], hex_hex20_refine_xx_out.iloc[1]['strain_energy']]
hex_hex20_xx_cost = [hex_hex20_coarse0_xx_out.iloc[1]['run_time'], hex_hex20_coarse1_xx_out.iloc[1]['run_time'], hex_hex20_coarse_xx_out.iloc[1]['run_time'], hex_hex20_refine0_xx_out.iloc[1]['run_time'], hex_hex20_refine1_xx_out.iloc[1]['run_time'], hex_hex20_refine_xx_out.iloc[1]['run_time']]

hex_tet4_xx_ndof = [hex_tet4_coarse0_xx_out.iloc[1]['DOFs'], hex_tet4_coarse1_xx_out.iloc[1]['DOFs'], hex_tet4_coarse_xx_out.iloc[1]['DOFs'], hex_tet4_refine0_xx_out.iloc[1]['DOFs'],hex_tet4_refine1_xx_out.iloc[1]['DOFs'], hex_tet4_refine_xx_out.iloc[1]['DOFs']]
hex_tet4_xx_n_nodes = [hex_tet4_coarse0_xx_out.iloc[1]['n_nodes'], hex_tet4_coarse1_xx_out.iloc[1]['n_nodes'], hex_tet4_coarse_xx_out.iloc[1]['n_nodes'], hex_tet4_refine0_xx_out.iloc[1]['n_nodes'], hex_tet4_refine1_xx_out.iloc[1]['n_nodes'], hex_tet4_refine_xx_out.iloc[1]['n_nodes']]
hex_tet4_xx_n_elements =  [hex_tet4_coarse0_xx_out.iloc[1]['n_elements'], hex_tet4_coarse1_xx_out.iloc[1]['n_elements'], hex_tet4_coarse_xx_out.iloc[1]['n_elements'], hex_tet4_refine0_xx_out.iloc[1]['n_elements'], hex_tet4_refine1_xx_out.iloc[1]['n_elements'], hex_tet4_refine_xx_out.iloc[1]['n_elements']]
hex_tet4_xx_s00 = [hex_tet4_coarse0_xx_out.iloc[1]['s00'], hex_tet4_coarse1_xx_out.iloc[1]['s00'], hex_tet4_coarse_xx_out.iloc[1]['s00'], hex_tet4_refine0_xx_out.iloc[1]['s00'], hex_tet4_refine1_xx_out.iloc[1]['s00'], hex_tet4_refine_xx_out.iloc[1]['s00']]
hex_tet4_xx_e00 = [hex_tet4_coarse0_xx_out.iloc[1]['e00'], hex_tet4_coarse1_xx_out.iloc[1]['e00'], hex_tet4_coarse_xx_out.iloc[1]['e00'], hex_tet4_refine0_xx_out.iloc[1]['e00'], hex_tet4_refine1_xx_out.iloc[1]['e00'], hex_tet4_refine_xx_out.iloc[1]['e00']]
hex_tet4_xx_e11 = [hex_tet4_coarse0_xx_out.iloc[1]['e11'], hex_tet4_coarse1_xx_out.iloc[1]['e11'], hex_tet4_coarse_xx_out.iloc[1]['e11'], hex_tet4_refine0_xx_out.iloc[1]['e11'], hex_tet4_refine1_xx_out.iloc[1]['e11'], hex_tet4_refine_xx_out.iloc[1]['e11']]
hex_tet4_xx_e22 = [hex_tet4_coarse0_xx_out.iloc[1]['e22'], hex_tet4_coarse1_xx_out.iloc[1]['e22'], hex_tet4_coarse_xx_out.iloc[1]['e22'], hex_tet4_refine0_xx_out.iloc[1]['e22'], hex_tet4_refine1_xx_out.iloc[1]['e11'], hex_tet4_refine_xx_out.iloc[1]['e11']]
hex_tet4_xx_C11 = [hex_tet4_coarse0_xx_out.iloc[1]['C11'], hex_tet4_coarse1_xx_out.iloc[1]['C11'], hex_tet4_coarse_xx_out.iloc[1]['C11'], hex_tet4_refine0_xx_out.iloc[1]['C11'], hex_tet4_refine1_xx_out.iloc[1]['C11'], hex_tet4_refine_xx_out.iloc[1]['C11']]
hex_tet4_xx_se = [hex_tet4_coarse0_xx_out.iloc[1]['strain_energy'], hex_tet4_coarse1_xx_out.iloc[1]['strain_energy'], hex_tet4_coarse_xx_out.iloc[1]['strain_energy'], hex_tet4_refine0_xx_out.iloc[1]['strain_energy'], hex_tet4_refine1_xx_out.iloc[1]['strain_energy'], hex_tet4_refine_xx_out.iloc[1]['strain_energy']]
hex_tet4_xx_cost = [hex_tet4_coarse0_xx_out.iloc[1]['run_time'], hex_tet4_coarse1_xx_out.iloc[1]['run_time'], hex_tet4_coarse_xx_out.iloc[1]['run_time'], hex_tet4_refine0_xx_out.iloc[1]['run_time'], hex_tet4_refine1_xx_out.iloc[1]['run_time'], hex_tet4_refine_xx_out.iloc[1]['run_time']]

hex_tet10_xx_ndof = [hex_tet10_refine1_xx_out.iloc[1]['DOFs'], hex_tet10_coarse0_xx_out.iloc[1]['DOFs'], hex_tet10_coarse1_xx_out.iloc[1]['DOFs'], hex_tet10_coarse_xx_out.iloc[1]['DOFs'], hex_tet10_refine0_xx_out.iloc[1]['DOFs'], hex_tet10_refine_xx_out.iloc[1]['DOFs']]
hex_tet10_xx_n_nodes = [hex_tet10_refine1_xx_out.iloc[1]['n_nodes'], hex_tet10_coarse0_xx_out.iloc[1]['n_nodes'], hex_tet10_coarse1_xx_out.iloc[1]['n_nodes'], hex_tet10_coarse_xx_out.iloc[1]['n_nodes'], hex_tet10_refine0_xx_out.iloc[1]['n_nodes'], hex_tet10_refine_xx_out.iloc[1]['n_nodes']]
hex_tet10_xx_n_elements =  [hex_tet10_refine1_xx_out.iloc[1]['n_elements'], hex_tet10_coarse0_xx_out.iloc[1]['n_elements'], hex_tet10_coarse1_xx_out.iloc[1]['n_elements'], hex_tet10_coarse_xx_out.iloc[1]['n_elements'], hex_tet10_refine0_xx_out.iloc[1]['n_elements'], hex_tet4_refine_xx_out.iloc[1]['n_elements']]
hex_tet10_xx_s00 = [hex_tet10_refine1_xx_out.iloc[1]['s00'], hex_tet10_coarse0_xx_out.iloc[1]['s00'], hex_tet10_coarse1_xx_out.iloc[1]['s00'], hex_tet10_coarse_xx_out.iloc[1]['s00'], hex_tet10_refine0_xx_out.iloc[1]['s00'], hex_tet10_refine_xx_out.iloc[1]['s00']]
hex_tet10_xx_e00 = [hex_tet10_refine1_xx_out.iloc[1]['e00'], hex_tet10_coarse0_xx_out.iloc[1]['e00'], hex_tet10_coarse1_xx_out.iloc[1]['e00'], hex_tet10_coarse_xx_out.iloc[1]['e00'], hex_tet10_refine0_xx_out.iloc[1]['e00'], hex_tet10_refine_xx_out.iloc[1]['e00']]
hex_tet10_xx_e11 = [hex_tet10_refine1_xx_out.iloc[1]['e11'], hex_tet10_coarse0_xx_out.iloc[1]['e11'], hex_tet10_coarse1_xx_out.iloc[1]['e11'], hex_tet10_coarse_xx_out.iloc[1]['e11'], hex_tet10_refine0_xx_out.iloc[1]['e11'], hex_tet10_refine_xx_out.iloc[1]['e11']]
hex_tet10_xx_e22 = [hex_tet10_coarse0_xx_out.iloc[1]['e22'], hex_tet10_coarse1_xx_out.iloc[1]['e22'], hex_tet10_coarse_xx_out.iloc[1]['e22'], hex_tet10_refine0_xx_out.iloc[1]['e22'], hex_tet10_refine_xx_out.iloc[1]['e11']]
hex_tet10_xx_C11 = [hex_tet10_coarse0_xx_out.iloc[1]['C11'], hex_tet10_coarse1_xx_out.iloc[1]['C11'], hex_tet10_coarse_xx_out.iloc[1]['C11'], hex_tet10_refine0_xx_out.iloc[1]['C11'], hex_tet10_refine_xx_out.iloc[1]['C11']]
hex_tet10_xx_se = [hex_tet10_coarse0_xx_out.iloc[1]['strain_energy'], hex_tet10_coarse1_xx_out.iloc[1]['strain_energy'], hex_tet10_coarse_xx_out.iloc[1]['strain_energy'], hex_tet10_refine0_xx_out.iloc[1]['strain_energy'], hex_tet10_refine_xx_out.iloc[1]['strain_energy']]
hex_tet10_xx_cost = [hex_tet10_refine1_xx_out.iloc[1]['run_time'], hex_tet10_coarse0_xx_out.iloc[1]['run_time'], hex_tet10_coarse1_xx_out.iloc[1]['run_time'], hex_tet10_coarse_xx_out.iloc[1]['run_time'], hex_tet10_refine0_xx_out.iloc[1]['run_time'], hex_tet10_refine_xx_out.iloc[1]['run_time']]



hex_E11_hex8 = np.divide(hex_hex8_xx_s00,hex_hex8_xx_e00)
hex_E11_hex20 = np.divide(hex_hex20_xx_s00,hex_hex20_xx_e00)
hex_E11_tet4 = np.divide(hex_tet4_xx_s00,hex_tet4_xx_e00)
hex_E11_tet10 = np.divide(hex_tet10_xx_s00,hex_tet10_xx_e00)

hex_E11_hex8_error = np.divide(abs(hex_E11_hex8-hex_E11_hex8[5]), hex_E11_hex8[5])*100
hex_E11_hex20_error = np.divide(abs(hex_E11_hex20-hex_E11_hex20[5]), hex_E11_hex20[5])*100
hex_E11_tet4_error = np.divide(abs(hex_E11_tet4-hex_E11_tet4[5]), hex_E11_tet4[5])*100
hex_E11_tet10_error = np.divide(abs(hex_E11_tet10-hex_E11_tet10[5]), hex_E11_tet10[5])*100

hex_n12_hex8 = -np.divide(hex_hex8_xx_e11,hex_hex8_xx_e00)
hex_n12_hex20 = -np.divide(hex_hex20_xx_e11,hex_hex20_xx_e00)
hex_n12_tet4 = -np.divide(hex_tet4_xx_e11,hex_tet4_xx_e00)
hex_n12_tet10 = -np.divide(hex_tet10_xx_e11,hex_tet10_xx_e00)

hex_n12_hex8_error = np.divide(abs(hex_n12_hex8-hex_n12_hex8[5]), hex_n12_hex8[5])*100
hex_n12_hex20_error = np.divide(abs(hex_n12_hex20-hex_n12_hex20[5]), hex_n12_hex20[5])*100
hex_n12_tet4_error = np.divide(abs(hex_n12_tet4-hex_n12_tet4[5]), hex_n12_tet4[5])*100
hex_n12_tet10_error = np.divide(abs(hex_n12_tet10-hex_n12_tet10[5]), hex_n12_tet10[5])*100

hex_hex8_yy_ndof = [hex_hex8_coarse0_yy_out.iloc[1]['DOFs'], hex_hex8_coarse1_yy_out.iloc[1]['DOFs'], hex_hex8_coarse_yy_out.iloc[1]['DOFs'], hex_hex8_refine0_yy_out.iloc[1]['DOFs'], hex_hex8_refine1_yy_out.iloc[1]['DOFs'], hex_hex8_refine_yy_out.iloc[1]['DOFs']]
hex_hex8_yy_n_nodes = [hex_hex8_coarse0_yy_out.iloc[1]['n_nodes'], hex_hex8_coarse1_yy_out.iloc[1]['n_nodes'], hex_hex8_coarse_yy_out.iloc[1]['n_nodes'], hex_hex8_refine0_yy_out.iloc[1]['n_nodes'], hex_hex8_refine1_yy_out.iloc[1]['n_nodes'], hex_hex8_refine_yy_out.iloc[1]['n_nodes']]
hex_hex8_yy_n_elements = [hex_hex8_coarse0_yy_out.iloc[1]['n_elements'], hex_hex8_coarse1_yy_out.iloc[1]['n_elements'], hex_hex8_coarse_yy_out.iloc[1]['n_elements'], hex_hex8_refine0_yy_out.iloc[1]['n_elements'], hex_hex8_refine1_yy_out.iloc[1]['n_elements'], hex_hex8_refine_yy_out.iloc[1]['n_elements']]
hex_hex8_yy_s11 = [hex_hex8_coarse0_yy_out.iloc[1]['s11'], hex_hex8_coarse1_yy_out.iloc[1]['s11'], hex_hex8_coarse_yy_out.iloc[1]['s11'], hex_hex8_refine0_yy_out.iloc[1]['s11'], hex_hex8_refine1_yy_out.iloc[1]['s11'], hex_hex8_refine_yy_out.iloc[1]['s11']]
hex_hex8_yy_e00 = [hex_hex8_coarse0_yy_out.iloc[1]['e00'], hex_hex8_coarse1_yy_out.iloc[1]['e00'], hex_hex8_coarse_yy_out.iloc[1]['e00'], hex_hex8_refine0_yy_out.iloc[1]['e00'], hex_hex8_refine1_yy_out.iloc[1]['e00'], hex_hex8_refine_yy_out.iloc[1]['e00']]
hex_hex8_yy_e11 = [hex_hex8_coarse0_yy_out.iloc[1]['e11'], hex_hex8_coarse1_yy_out.iloc[1]['e11'], hex_hex8_coarse_yy_out.iloc[1]['e11'], hex_hex8_refine0_yy_out.iloc[1]['e11'], hex_hex8_refine1_yy_out.iloc[1]['e11'], hex_hex8_refine_yy_out.iloc[1]['e11']]
hex_hex8_yy_e22 = [hex_hex8_coarse0_yy_out.iloc[1]['e22'], hex_hex8_coarse1_yy_out.iloc[1]['e22'], hex_hex8_coarse_yy_out.iloc[1]['e22'], hex_hex8_refine0_yy_out.iloc[1]['e22'], hex_hex8_refine1_yy_out.iloc[1]['e11'], hex_hex8_refine_yy_out.iloc[1]['e11']]
hex_hex8_yy_C11 = [hex_hex8_coarse0_yy_out.iloc[1]['C11'], hex_hex8_coarse1_yy_out.iloc[1]['C11'], hex_hex8_coarse_yy_out.iloc[1]['C11'], hex_hex8_refine0_yy_out.iloc[1]['C11'], hex_hex8_refine1_yy_out.iloc[1]['C11'], hex_hex8_refine_yy_out.iloc[1]['C11']]
hex_hex8_yy_se = [hex_hex8_coarse0_yy_out.iloc[1]['strain_energy'], hex_hex8_coarse1_yy_out.iloc[1]['strain_energy'], hex_hex8_coarse_yy_out.iloc[1]['strain_energy'], hex_hex8_refine0_yy_out.iloc[1]['strain_energy'], hex_hex8_refine1_yy_out.iloc[1]['strain_energy'], hex_hex8_refine_yy_out.iloc[1]['strain_energy']]
hex_hex8_yy_cost = [hex_hex8_coarse0_yy_out.iloc[1]['run_time'], hex_hex8_coarse1_yy_out.iloc[1]['run_time'], hex_hex8_coarse_yy_out.iloc[1]['run_time'], hex_hex8_refine0_yy_out.iloc[1]['run_time'], hex_hex8_refine1_yy_out.iloc[1]['run_time'], hex_hex8_refine_yy_out.iloc[1]['run_time']]

hex_hex20_yy_ndof = [hex_hex20_coarse0_yy_out.iloc[1]['DOFs'], hex_hex20_coarse1_yy_out.iloc[1]['DOFs'], hex_hex20_coarse_yy_out.iloc[1]['DOFs'], hex_hex20_refine0_yy_out.iloc[1]['DOFs'], hex_hex20_refine1_yy_out.iloc[1]['DOFs'], hex_hex20_refine_yy_out.iloc[1]['DOFs']]
hex_hex20_yy_n_nodes = [hex_hex20_coarse0_yy_out.iloc[1]['n_nodes'], hex_hex20_coarse1_yy_out.iloc[1]['n_nodes'], hex_hex20_coarse_yy_out.iloc[1]['n_nodes'], hex_hex20_refine0_yy_out.iloc[1]['n_nodes'], hex_hex20_refine1_yy_out.iloc[1]['n_nodes'], hex_hex20_refine_yy_out.iloc[1]['n_nodes']]
hex_hex20_yy_n_elements = [hex_hex20_coarse0_yy_out.iloc[1]['n_elements'], hex_hex20_coarse1_yy_out.iloc[1]['n_elements'], hex_hex20_coarse_yy_out.iloc[1]['n_elements'], hex_hex20_refine0_yy_out.iloc[1]['n_elements'],hex_hex20_refine1_yy_out.iloc[1]['n_elements'], hex_hex20_refine_yy_out.iloc[1]['n_elements']]
hex_hex20_yy_s11 = [hex_hex20_coarse0_yy_out.iloc[1]['s11'], hex_hex20_coarse1_yy_out.iloc[1]['s11'], hex_hex20_coarse_yy_out.iloc[1]['s11'], hex_hex20_refine0_yy_out.iloc[1]['s11'], hex_hex20_refine1_yy_out.iloc[1]['s11'], hex_hex20_refine_yy_out.iloc[1]['s11']]
hex_hex20_yy_e00 = [hex_hex20_coarse0_yy_out.iloc[1]['e00'], hex_hex20_coarse1_yy_out.iloc[1]['e00'], hex_hex20_coarse_yy_out.iloc[1]['e00'], hex_hex20_refine0_yy_out.iloc[1]['e00'], hex_hex20_refine1_yy_out.iloc[1]['e00'], hex_hex20_refine_yy_out.iloc[1]['e00']]
hex_hex20_yy_e11 = [hex_hex20_coarse0_yy_out.iloc[1]['e11'], hex_hex20_coarse1_yy_out.iloc[1]['e11'], hex_hex20_coarse_yy_out.iloc[1]['e11'], hex_hex20_refine0_yy_out.iloc[1]['e11'], hex_hex20_refine1_yy_out.iloc[1]['e11'], hex_hex20_refine_yy_out.iloc[1]['e11']]
hex_hex20_yy_e22 = [hex_hex20_coarse0_yy_out.iloc[1]['e22'], hex_hex20_coarse1_yy_out.iloc[1]['e22'], hex_hex20_coarse_yy_out.iloc[1]['e22'], hex_hex20_refine0_yy_out.iloc[1]['e22'], hex_hex20_refine1_yy_out.iloc[1]['e22'], hex_hex20_refine_yy_out.iloc[1]['e22']]
hex_hex20_yy_C11 = [hex_hex20_coarse0_yy_out.iloc[1]['C11'], hex_hex20_coarse1_yy_out.iloc[1]['C11'], hex_hex20_coarse_yy_out.iloc[1]['C11'], hex_hex20_refine0_yy_out.iloc[1]['C11'], hex_hex20_refine1_yy_out.iloc[1]['C11'], hex_hex20_refine_yy_out.iloc[1]['C11']]
hex_hex20_yy_se = [hex_hex20_coarse0_yy_out.iloc[1]['strain_energy'], hex_hex20_coarse1_yy_out.iloc[1]['strain_energy'], hex_hex20_coarse_yy_out.iloc[1]['strain_energy'], hex_hex20_refine0_yy_out.iloc[1]['strain_energy'], hex_hex20_refine1_yy_out.iloc[1]['strain_energy'], hex_hex20_refine_yy_out.iloc[1]['strain_energy']]
hex_hex20_yy_cost = [hex_hex20_coarse0_yy_out.iloc[1]['run_time'], hex_hex20_coarse1_yy_out.iloc[1]['run_time'], hex_hex20_coarse_yy_out.iloc[1]['run_time'], hex_hex20_refine0_yy_out.iloc[1]['run_time'], hex_hex20_refine1_yy_out.iloc[1]['run_time'], hex_hex20_refine_yy_out.iloc[1]['run_time']]

hex_tet4_yy_ndof = [hex_tet4_coarse0_yy_out.iloc[1]['DOFs'], hex_tet4_coarse1_yy_out.iloc[1]['DOFs'], hex_tet4_coarse_yy_out.iloc[1]['DOFs'], hex_tet4_refine0_yy_out.iloc[1]['DOFs'],hex_tet4_refine1_yy_out.iloc[1]['DOFs'], hex_tet4_refine_yy_out.iloc[1]['DOFs']]
hex_tet4_yy_n_nodes = [hex_tet4_coarse0_yy_out.iloc[1]['n_nodes'], hex_tet4_coarse1_yy_out.iloc[1]['n_nodes'], hex_tet4_coarse_yy_out.iloc[1]['n_nodes'], hex_tet4_refine0_yy_out.iloc[1]['n_nodes'], hex_tet4_refine1_yy_out.iloc[1]['n_nodes'], hex_tet4_refine_yy_out.iloc[1]['n_nodes']]
hex_tet4_yy_n_elements =  [hex_tet4_coarse0_yy_out.iloc[1]['n_elements'], hex_tet4_coarse1_yy_out.iloc[1]['n_elements'], hex_tet4_coarse_yy_out.iloc[1]['n_elements'], hex_tet4_refine0_yy_out.iloc[1]['n_elements'], hex_tet4_refine1_yy_out.iloc[1]['n_elements'], hex_tet4_refine_yy_out.iloc[1]['n_elements']]
hex_tet4_yy_s11 = [hex_tet4_coarse0_yy_out.iloc[1]['s11'], hex_tet4_coarse1_yy_out.iloc[1]['s11'], hex_tet4_coarse_yy_out.iloc[1]['s11'], hex_tet4_refine0_yy_out.iloc[1]['s11'], hex_tet4_refine1_yy_out.iloc[1]['s11'], hex_tet4_refine_yy_out.iloc[1]['s11']]
hex_tet4_yy_e00 = [hex_tet4_coarse0_yy_out.iloc[1]['e00'], hex_tet4_coarse1_yy_out.iloc[1]['e00'], hex_tet4_coarse_yy_out.iloc[1]['e00'], hex_tet4_refine0_yy_out.iloc[1]['e00'], hex_tet4_refine1_yy_out.iloc[1]['e00'], hex_tet4_refine_yy_out.iloc[1]['e00']]
hex_tet4_yy_e11 = [hex_tet4_coarse0_yy_out.iloc[1]['e11'], hex_tet4_coarse1_yy_out.iloc[1]['e11'], hex_tet4_coarse_yy_out.iloc[1]['e11'], hex_tet4_refine0_yy_out.iloc[1]['e11'], hex_tet4_refine1_yy_out.iloc[1]['e11'], hex_tet4_refine_yy_out.iloc[1]['e11']]
hex_tet4_yy_e22 = [hex_tet4_coarse0_yy_out.iloc[1]['e22'], hex_tet4_coarse1_yy_out.iloc[1]['e22'], hex_tet4_coarse_yy_out.iloc[1]['e22'], hex_tet4_refine0_yy_out.iloc[1]['e22'], hex_tet4_refine1_yy_out.iloc[1]['e11'], hex_tet4_refine_yy_out.iloc[1]['e11']]
hex_tet4_yy_C11 = [hex_tet4_coarse0_yy_out.iloc[1]['C11'], hex_tet4_coarse1_yy_out.iloc[1]['C11'], hex_tet4_coarse_yy_out.iloc[1]['C11'], hex_tet4_refine0_yy_out.iloc[1]['C11'], hex_tet4_refine1_yy_out.iloc[1]['C11'], hex_tet4_refine_yy_out.iloc[1]['C11']]
hex_tet4_yy_se = [hex_tet4_coarse0_yy_out.iloc[1]['strain_energy'], hex_tet4_coarse1_yy_out.iloc[1]['strain_energy'], hex_tet4_coarse_yy_out.iloc[1]['strain_energy'], hex_tet4_refine0_yy_out.iloc[1]['strain_energy'], hex_tet4_refine1_yy_out.iloc[1]['strain_energy'], hex_tet4_refine_yy_out.iloc[1]['strain_energy']]
hex_tet4_yy_cost = [hex_tet4_coarse0_yy_out.iloc[1]['run_time'], hex_tet4_coarse1_yy_out.iloc[1]['run_time'], hex_tet4_coarse_yy_out.iloc[1]['run_time'], hex_tet4_refine0_yy_out.iloc[1]['run_time'], hex_tet4_refine1_yy_out.iloc[1]['run_time'], hex_tet4_refine_yy_out.iloc[1]['run_time']]

hex_tet10_yy_ndof = [hex_tet10_coarse00_yy_out.iloc[1]['DOFs'], hex_tet10_refine1_yy_out.iloc[1]['DOFs'], hex_tet10_coarse0_yy_out.iloc[1]['DOFs'], hex_tet10_coarse1_yy_out.iloc[1]['DOFs'], hex_tet10_coarse_yy_out.iloc[1]['DOFs'], hex_tet10_refine0_yy_out.iloc[1]['DOFs'], hex_tet10_refine_yy_out.iloc[1]['DOFs']]
hex_tet10_yy_n_nodes = [ hex_tet10_coarse00_yy_out.iloc[1]['n_nodes'], hex_tet10_refine1_yy_out.iloc[1]['n_nodes'], hex_tet10_coarse0_yy_out.iloc[1]['n_nodes'], hex_tet10_coarse1_yy_out.iloc[1]['n_nodes'], hex_tet10_coarse_yy_out.iloc[1]['n_nodes'], hex_tet10_refine0_yy_out.iloc[1]['n_nodes'], hex_tet10_refine_yy_out.iloc[1]['n_nodes']]
hex_tet10_yy_n_elements =  [hex_tet10_coarse00_yy_out.iloc[1]['n_elements'], hex_tet10_refine1_yy_out.iloc[1]['n_elements'], hex_tet10_coarse0_yy_out.iloc[1]['n_elements'], hex_tet10_coarse1_yy_out.iloc[1]['n_elements'], hex_tet10_coarse_yy_out.iloc[1]['n_elements'], hex_tet10_refine0_yy_out.iloc[1]['n_elements'], hex_tet4_refine_yy_out.iloc[1]['n_elements']]
hex_tet10_yy_s11 = [hex_tet10_coarse00_yy_out.iloc[1]['s11'], hex_tet10_refine1_yy_out.iloc[1]['s11'], hex_tet10_coarse0_yy_out.iloc[1]['s11'], hex_tet10_coarse1_yy_out.iloc[1]['s11'], hex_tet10_coarse_yy_out.iloc[1]['s11'], hex_tet10_refine0_yy_out.iloc[1]['s11'], hex_tet10_refine_yy_out.iloc[1]['s11']]
hex_tet10_yy_e00 = [hex_tet10_refine1_yy_out.iloc[1]['e00'], hex_tet10_coarse0_yy_out.iloc[1]['e00'], hex_tet10_coarse1_yy_out.iloc[1]['e00'], hex_tet10_coarse_yy_out.iloc[1]['e00'], hex_tet10_refine0_yy_out.iloc[1]['e00'], hex_tet10_refine_yy_out.iloc[1]['e00']]
hex_tet10_yy_e11 = [hex_tet10_coarse00_yy_out.iloc[1]['e11'], hex_tet10_refine1_yy_out.iloc[1]['e11'], hex_tet10_coarse0_yy_out.iloc[1]['e11'], hex_tet10_coarse1_yy_out.iloc[1]['e11'], hex_tet10_coarse_yy_out.iloc[1]['e11'], hex_tet10_refine0_yy_out.iloc[1]['e11'], hex_tet10_refine_yy_out.iloc[1]['e11']]
hex_tet10_yy_e22 = [hex_tet10_coarse0_yy_out.iloc[1]['e22'], hex_tet10_coarse1_yy_out.iloc[1]['e22'], hex_tet10_coarse_yy_out.iloc[1]['e22'], hex_tet10_refine0_yy_out.iloc[1]['e22'], hex_tet10_refine_yy_out.iloc[1]['e11']]
hex_tet10_yy_C11 = [hex_tet10_coarse0_yy_out.iloc[1]['C11'], hex_tet10_coarse1_yy_out.iloc[1]['C11'], hex_tet10_coarse_yy_out.iloc[1]['C11'], hex_tet10_refine0_yy_out.iloc[1]['C11'], hex_tet10_refine_yy_out.iloc[1]['C11']]
hex_tet10_yy_se = [hex_tet10_coarse0_yy_out.iloc[1]['strain_energy'], hex_tet10_coarse1_yy_out.iloc[1]['strain_energy'], hex_tet10_coarse_yy_out.iloc[1]['strain_energy'], hex_tet10_refine0_yy_out.iloc[1]['strain_energy'], hex_tet10_refine_yy_out.iloc[1]['strain_energy']]
hex_tet10_yy_cost = [hex_tet10_refine1_yy_out.iloc[1]['run_time'], hex_tet10_coarse0_yy_out.iloc[1]['run_time'], hex_tet10_coarse1_yy_out.iloc[1]['run_time'], hex_tet10_coarse_yy_out.iloc[1]['run_time'], hex_tet10_refine0_yy_out.iloc[1]['run_time'], hex_tet10_refine_yy_out.iloc[1]['run_time']]



hex_E22_hex8 = np.divide(hex_hex8_yy_s11,hex_hex8_yy_e11)
hex_E22_hex20 = np.divide(hex_hex20_yy_s11,hex_hex20_yy_e11)
hex_E22_tet4 = np.divide(hex_tet4_yy_s11,hex_tet4_yy_e11)
hex_E22_tet10 = np.divide(hex_tet10_yy_s11,hex_tet10_yy_e11)


hex_E22_hex8_error = np.divide(abs(hex_E22_hex8-hex_E22_hex8[5]), hex_E22_hex8[5])*100
hex_E22_hex20_error = np.divide(abs(hex_E22_hex20-hex_E22_hex20[5]), hex_E22_hex20[5])*100
hex_E22_tet4_error = np.divide(abs(hex_E22_tet4-hex_E22_tet4[5]), hex_E22_tet4[5])*100
hex_E22_tet10_error = np.divide(abs(hex_E22_tet10-hex_E22_tet10[6]), hex_E22_tet10[6])*100

# hex_n12_tet10

square_hex8_xy_ndof = [square_hex8_coarse0_xy_out.iloc[1]['DOFs'], square_hex8_coarse1_xy_out.iloc[1]['DOFs'], square_hex8_coarse_xy_out.iloc[1]['DOFs'], square_hex8_refine0_xy_out.iloc[1]['DOFs'], square_hex8_refine1_xy_out.iloc[1]['DOFs'], square_hex8_refine_xy_out.iloc[1]['DOFs']]
square_hex8_xy_n_nodes = [square_hex8_coarse0_xy_out.iloc[1]['n_nodes'], square_hex8_coarse1_xy_out.iloc[1]['n_nodes'], square_hex8_coarse_xy_out.iloc[1]['n_nodes'], square_hex8_refine0_xy_out.iloc[1]['n_nodes'], square_hex8_refine1_xy_out.iloc[1]['n_nodes'], square_hex8_refine_xy_out.iloc[1]['n_nodes']]
square_hex8_xy_n_elements = [square_hex8_coarse0_xy_out.iloc[1]['n_elements'], square_hex8_coarse1_xy_out.iloc[1]['n_elements'], square_hex8_coarse_xy_out.iloc[1]['n_elements'], square_hex8_refine0_xy_out.iloc[1]['n_elements'], square_hex8_refine1_xy_out.iloc[1]['n_elements'], square_hex8_refine_xy_out.iloc[1]['n_elements']]
square_hex8_xy_s01 = [square_hex8_coarse0_xy_out.iloc[1]['s01'], square_hex8_coarse1_xy_out.iloc[1]['s01'], square_hex8_coarse_xy_out.iloc[1]['s01'], square_hex8_refine0_xy_out.iloc[1]['s01'], square_hex8_refine1_xy_out.iloc[1]['s01'], square_hex8_refine_xy_out.iloc[1]['s01']]
square_hex8_xy_e00 = [square_hex8_coarse0_xy_out.iloc[1]['e00'], square_hex8_coarse1_xy_out.iloc[1]['e00'], square_hex8_coarse_xy_out.iloc[1]['e00'], square_hex8_refine0_xy_out.iloc[1]['e00'], square_hex8_refine1_xy_out.iloc[1]['e00'], square_hex8_refine_xy_out.iloc[1]['e00']]
square_hex8_xy_e11 = [square_hex8_coarse0_xy_out.iloc[1]['e11'], square_hex8_coarse1_xy_out.iloc[1]['e11'], square_hex8_coarse_xy_out.iloc[1]['e11'], square_hex8_refine0_xy_out.iloc[1]['e11'], square_hex8_refine1_xy_out.iloc[1]['e11'], square_hex8_refine_xy_out.iloc[1]['e11']]
square_hex8_xy_e01 = [square_hex8_coarse0_xy_out.iloc[1]['e01'], square_hex8_coarse1_xy_out.iloc[1]['e01'], square_hex8_coarse_xy_out.iloc[1]['e01'], square_hex8_refine0_xy_out.iloc[1]['e01'], square_hex8_refine1_xy_out.iloc[1]['e01'], square_hex8_refine_xy_out.iloc[1]['e01']]
square_hex8_xy_C11 = [square_hex8_coarse0_xy_out.iloc[1]['C11'], square_hex8_coarse1_xy_out.iloc[1]['C11'], square_hex8_coarse_xy_out.iloc[1]['C11'], square_hex8_refine0_xy_out.iloc[1]['C11'], square_hex8_refine1_xy_out.iloc[1]['C11'], square_hex8_refine_xy_out.iloc[1]['C11']]
square_hex8_xy_se = [square_hex8_coarse0_xy_out.iloc[1]['strain_energy'], square_hex8_coarse1_xy_out.iloc[1]['strain_energy'], square_hex8_coarse_xy_out.iloc[1]['strain_energy'], square_hex8_refine0_xy_out.iloc[1]['strain_energy'], square_hex8_refine1_xy_out.iloc[1]['strain_energy'], square_hex8_refine_xy_out.iloc[1]['strain_energy']]
square_hex8_xy_cost = [square_hex8_coarse0_xy_out.iloc[1]['run_time'], square_hex8_coarse1_xy_out.iloc[1]['run_time'], square_hex8_coarse_xy_out.iloc[1]['run_time'], square_hex8_refine0_xy_out.iloc[1]['run_time'], square_hex8_refine1_xy_out.iloc[1]['run_time'], square_hex8_refine_xy_out.iloc[1]['run_time']]

square_hex20_xy_ndof = [square_hex20_coarse0_xy_out.iloc[1]['DOFs'], square_hex20_coarse1_xy_out.iloc[1]['DOFs'], square_hex20_coarse_xy_out.iloc[1]['DOFs'], square_hex20_refine0_xy_out.iloc[1]['DOFs'], square_hex20_refine1_xy_out.iloc[1]['DOFs'], square_hex20_refine_xy_out.iloc[1]['DOFs']]
square_hex20_xy_n_nodes = [square_hex20_coarse0_xy_out.iloc[1]['n_nodes'], square_hex20_coarse1_xy_out.iloc[1]['n_nodes'], square_hex20_coarse_xy_out.iloc[1]['n_nodes'], square_hex20_refine0_xy_out.iloc[1]['n_nodes'], square_hex20_refine1_xy_out.iloc[1]['n_nodes'], square_hex20_refine_xy_out.iloc[1]['n_nodes']]
square_hex20_xy_n_elements = [square_hex20_coarse0_xy_out.iloc[1]['n_elements'], square_hex20_coarse1_xy_out.iloc[1]['n_elements'], square_hex20_coarse_xy_out.iloc[1]['n_elements'], square_hex20_refine0_xy_out.iloc[1]['n_elements'],square_hex20_refine1_xy_out.iloc[1]['n_elements'], square_hex20_refine_xy_out.iloc[1]['n_elements']]
square_hex20_xy_s01 = [square_hex20_coarse0_xy_out.iloc[1]['s01'], square_hex20_coarse1_xy_out.iloc[1]['s01'], square_hex20_coarse_xy_out.iloc[1]['s01'], square_hex20_refine0_xy_out.iloc[1]['s01'], square_hex20_refine1_xy_out.iloc[1]['s01'], square_hex20_refine_xy_out.iloc[1]['s01']]
square_hex20_xy_e00 = [square_hex20_coarse0_xy_out.iloc[1]['e00'], square_hex20_coarse1_xy_out.iloc[1]['e00'], square_hex20_coarse_xy_out.iloc[1]['e00'], square_hex20_refine0_xy_out.iloc[1]['e00'], square_hex20_refine1_xy_out.iloc[1]['e00'], square_hex20_refine_xy_out.iloc[1]['e00']]
square_hex20_xy_e11 = [square_hex20_coarse0_xy_out.iloc[1]['e11'], square_hex20_coarse1_xy_out.iloc[1]['e11'], square_hex20_coarse_xy_out.iloc[1]['e11'], square_hex20_refine0_xy_out.iloc[1]['e11'], square_hex20_refine1_xy_out.iloc[1]['e11'], square_hex20_refine_xy_out.iloc[1]['e11']]
square_hex20_xy_e01 = [square_hex20_coarse0_xy_out.iloc[1]['e01'], square_hex20_coarse1_xy_out.iloc[1]['e01'], square_hex20_coarse_xy_out.iloc[1]['e01'], square_hex20_refine0_xy_out.iloc[1]['e01'], square_hex20_refine1_xy_out.iloc[1]['e01'], square_hex20_refine_xy_out.iloc[1]['e01']]
square_hex20_xy_C11 = [square_hex20_coarse0_xy_out.iloc[1]['C11'], square_hex20_coarse1_xy_out.iloc[1]['C11'], square_hex20_coarse_xy_out.iloc[1]['C11'], square_hex20_refine0_xy_out.iloc[1]['C11'], square_hex20_refine1_xy_out.iloc[1]['C11'], square_hex20_refine_xy_out.iloc[1]['C11']]
square_hex20_xy_se = [square_hex20_coarse0_xy_out.iloc[1]['strain_energy'], square_hex20_coarse1_xy_out.iloc[1]['strain_energy'], square_hex20_coarse_xy_out.iloc[1]['strain_energy'], square_hex20_refine0_xy_out.iloc[1]['strain_energy'], square_hex20_refine1_xy_out.iloc[1]['strain_energy'], square_hex20_refine_xy_out.iloc[1]['strain_energy']]
square_hex20_xy_cost = [square_hex20_coarse0_xy_out.iloc[1]['run_time'], square_hex20_coarse1_xy_out.iloc[1]['run_time'], square_hex20_coarse_xy_out.iloc[1]['run_time'], square_hex20_refine0_xy_out.iloc[1]['run_time'], square_hex20_refine1_xy_out.iloc[1]['run_time'], square_hex20_refine_xy_out.iloc[1]['run_time']]

square_tet4_xy_ndof = [square_tet4_coarse0_xy_out.iloc[1]['DOFs'], square_tet4_coarse1_xy_out.iloc[1]['DOFs'], square_tet4_coarse_xy_out.iloc[1]['DOFs'], square_tet4_refine0_xy_out.iloc[1]['DOFs'], square_tet4_refine1_xy_out.iloc[1]['DOFs'], square_tet4_refine_xy_out.iloc[1]['DOFs']]
square_tet4_xy_n_nodes = [square_tet4_coarse0_xy_out.iloc[1]['n_nodes'], square_tet4_coarse1_xy_out.iloc[1]['n_nodes'], square_tet4_coarse_xy_out.iloc[1]['n_nodes'], square_tet4_refine0_xy_out.iloc[1]['n_nodes'], square_tet4_refine1_xy_out.iloc[1]['n_nodes'], square_tet4_refine_xy_out.iloc[1]['n_nodes']]
square_tet4_xy_n_elements =  [square_tet4_coarse0_xy_out.iloc[1]['n_elements'], square_tet4_coarse1_xy_out.iloc[1]['n_elements'], square_tet4_coarse_xy_out.iloc[1]['n_elements'], square_tet4_refine0_xy_out.iloc[1]['n_elements'], square_tet4_refine1_xy_out.iloc[1]['n_elements'], square_tet4_refine_xy_out.iloc[1]['n_elements']]
square_tet4_xy_s01 = [square_tet4_coarse0_xy_out.iloc[1]['s01'], square_tet4_coarse1_xy_out.iloc[1]['s01'], square_tet4_coarse_xy_out.iloc[1]['s01'], square_tet4_refine0_xy_out.iloc[1]['s01'], square_tet4_refine1_xy_out.iloc[1]['s01'], square_tet4_refine_xy_out.iloc[1]['s01']]
square_tet4_xy_e00 = [square_tet4_coarse0_xy_out.iloc[1]['e00'], square_tet4_coarse1_xy_out.iloc[1]['e00'], square_tet4_coarse_xy_out.iloc[1]['e00'], square_tet4_refine0_xy_out.iloc[1]['e00'], square_tet4_refine_xy_out.iloc[1]['e00']]
square_tet4_xy_e11 = [square_tet4_coarse0_xy_out.iloc[1]['e11'], square_tet4_coarse1_xy_out.iloc[1]['e11'], square_tet4_coarse_xy_out.iloc[1]['e11'], square_tet4_refine0_xy_out.iloc[1]['e11'], square_tet4_refine_xy_out.iloc[1]['e11']]
square_tet4_xy_e01 = [square_tet4_coarse0_xy_out.iloc[1]['e01'], square_tet4_coarse1_xy_out.iloc[1]['e01'], square_tet4_coarse_xy_out.iloc[1]['e01'], square_tet4_refine0_xy_out.iloc[1]['e01'], square_tet4_refine1_xy_out.iloc[1]['e01'], square_tet4_refine_xy_out.iloc[1]['e01']]
square_tet4_xy_C11 = [square_tet4_coarse0_xy_out.iloc[1]['C11'], square_tet4_coarse1_xy_out.iloc[1]['C11'], square_tet4_coarse_xy_out.iloc[1]['C11'], square_tet4_refine0_xy_out.iloc[1]['C11'], square_tet4_refine_xy_out.iloc[1]['C11']]
square_tet4_xy_se = [square_tet4_coarse0_xy_out.iloc[1]['strain_energy'], square_tet4_coarse1_xy_out.iloc[1]['strain_energy'], square_tet4_coarse_xy_out.iloc[1]['strain_energy'], square_tet4_refine0_xy_out.iloc[1]['strain_energy'], square_tet4_refine1_xy_out.iloc[1]['strain_energy'], square_tet4_refine_xy_out.iloc[1]['strain_energy']]
square_tet4_xy_cost = [square_tet4_coarse0_xy_out.iloc[1]['run_time'], square_tet4_coarse1_xy_out.iloc[1]['run_time'], square_tet4_coarse_xy_out.iloc[1]['run_time'], square_tet4_refine0_xy_out.iloc[1]['run_time'], square_tet4_refine1_xy_out.iloc[1]['run_time'], square_tet4_refine_xy_out.iloc[1]['run_time']]

square_tet10_xy_ndof = [square_tet10_coarse00_xy_out.iloc[1]['DOFs'], square_tet10_coarse0_xy_out.iloc[1]['DOFs'], square_tet10_coarse1_xy_out.iloc[1]['DOFs'], square_tet10_coarse_xy_out.iloc[1]['DOFs'], square_tet10_refine0_xy_out.iloc[1]['DOFs'], square_tet10_refine_xy_out.iloc[1]['DOFs']]
square_tet10_xy_n_nodes = [square_tet10_coarse00_xy_out.iloc[1]['n_nodes'], square_tet10_coarse0_xy_out.iloc[1]['n_nodes'], square_tet10_coarse1_xy_out.iloc[1]['n_nodes'], square_tet10_coarse_xy_out.iloc[1]['n_nodes'], square_tet10_refine0_xy_out.iloc[1]['n_nodes'], square_tet10_refine_xy_out.iloc[1]['n_nodes']]
square_tet10_xy_n_elements =  [square_tet10_coarse00_xy_out.iloc[1]['n_elements'], square_tet10_coarse0_xy_out.iloc[1]['n_elements'], square_tet10_coarse1_xy_out.iloc[1]['n_elements'], square_tet10_coarse_xy_out.iloc[1]['n_elements'], square_tet10_refine0_xy_out.iloc[1]['n_elements'], square_tet4_refine_xy_out.iloc[1]['n_elements']]
square_tet10_xy_s01 = [square_tet10_coarse00_xy_out.iloc[1]['s01'], square_tet10_coarse0_xy_out.iloc[1]['s01'], square_tet10_coarse1_xy_out.iloc[1]['s01'], square_tet10_coarse_xy_out.iloc[1]['s01'], square_tet10_refine0_xy_out.iloc[1]['s01'], square_tet10_refine_xy_out.iloc[1]['s01']]
square_tet10_xy_e00 = [square_tet10_coarse00_xy_out.iloc[1]['e00'], square_tet10_coarse0_xy_out.iloc[1]['e00'], square_tet10_coarse1_xy_out.iloc[1]['e00'], square_tet10_coarse_xy_out.iloc[1]['e00'], square_tet10_refine0_xy_out.iloc[1]['e00'], square_tet10_refine_xy_out.iloc[1]['e00']]
square_tet10_xy_e11 = [square_tet10_coarse00_xy_out.iloc[1]['e11'], square_tet10_coarse0_xy_out.iloc[1]['e11'], square_tet10_coarse1_xy_out.iloc[1]['e11'], square_tet10_coarse_xy_out.iloc[1]['e11'], square_tet10_refine0_xy_out.iloc[1]['e11'], square_tet10_refine_xy_out.iloc[1]['e11']]
square_tet10_xy_e01 = [square_tet10_coarse00_xy_out.iloc[1]['e01'], square_tet10_coarse0_xy_out.iloc[1]['e01'], square_tet10_coarse1_xy_out.iloc[1]['e01'], square_tet10_coarse_xy_out.iloc[1]['e01'], square_tet10_refine0_xy_out.iloc[1]['e01'], square_tet10_refine_xy_out.iloc[1]['e01']]
square_tet10_xy_C11 = [square_tet10_coarse00_xy_out.iloc[1]['C11'], square_tet10_coarse0_xy_out.iloc[1]['C11'], square_tet10_coarse1_xy_out.iloc[1]['C11'], square_tet10_coarse_xy_out.iloc[1]['C11'], square_tet10_refine0_xy_out.iloc[1]['C11'], square_tet10_refine_xy_out.iloc[1]['C11']]
square_tet10_xy_se = [square_tet10_coarse00_xy_out.iloc[1]['strain_energy'], square_tet10_coarse0_xy_out.iloc[1]['strain_energy'], square_tet10_coarse1_xy_out.iloc[1]['strain_energy'], square_tet10_coarse_xy_out.iloc[1]['strain_energy'], square_tet10_refine0_xy_out.iloc[1]['strain_energy'], square_tet10_refine_xy_out.iloc[1]['strain_energy']]
square_tet10_xy_cost = [square_tet10_coarse00_xy_out.iloc[1]['run_time'], square_tet10_coarse0_xy_out.iloc[1]['run_time'], square_tet10_coarse1_xy_out.iloc[1]['run_time'], square_tet10_coarse_xy_out.iloc[1]['run_time'], square_tet10_refine0_xy_out.iloc[1]['run_time'], square_tet10_refine_xy_out.iloc[1]['run_time']]


square_G12_hex8 = np.divide(square_hex8_xy_s01,square_hex8_xy_e01)/2
square_G12_hex20 = np.divide(square_hex20_xy_s01,square_hex20_xy_e01)/2
square_G12_tet4 = np.divide(square_tet4_xy_s01,square_tet4_xy_e01)/2
square_G12_tet10 = np.divide(square_tet10_xy_s01,square_tet10_xy_e01)/2

square_G12_hex8_error = np.divide(abs(square_G12_hex8-square_G12_hex8[5]), square_G12_hex8[5])*100
square_G12_hex20_error = np.divide(abs(square_G12_hex20-square_G12_hex20[5]), square_G12_hex20[5])*100
square_G12_tet4_error = np.divide(abs(square_G12_tet4-square_G12_tet4[5]), square_G12_tet4[5])*100
square_G12_tet10_error = np.divide(abs(square_G12_tet10-square_G12_tet10[5]), square_G12_tet10[5])*100


hex_hex8_xy_ndof = [hex_hex8_coarse0_xy_out.iloc[1]['DOFs'], hex_hex8_coarse1_xy_out.iloc[1]['DOFs'], hex_hex8_coarse_xy_out.iloc[1]['DOFs'], hex_hex8_refine0_xy_out.iloc[1]['DOFs'], hex_hex8_refine1_xy_out.iloc[1]['DOFs'], hex_hex8_refine_xy_out.iloc[1]['DOFs']]
hex_hex8_xy_n_nodes = [hex_hex8_coarse0_xy_out.iloc[1]['n_nodes'], hex_hex8_coarse1_xy_out.iloc[1]['n_nodes'], hex_hex8_coarse_xy_out.iloc[1]['n_nodes'], hex_hex8_refine0_xy_out.iloc[1]['n_nodes'], hex_hex8_refine1_xy_out.iloc[1]['n_nodes'], hex_hex8_refine_xy_out.iloc[1]['n_nodes']]
hex_hex8_xy_n_elements = [hex_hex8_coarse0_xy_out.iloc[1]['n_elements'], hex_hex8_coarse1_xy_out.iloc[1]['n_elements'], hex_hex8_coarse_xy_out.iloc[1]['n_elements'], hex_hex8_refine0_xy_out.iloc[1]['n_elements'], hex_hex8_refine1_xy_out.iloc[1]['n_elements'], hex_hex8_refine_xy_out.iloc[1]['n_elements']]
hex_hex8_xy_s01 = [hex_hex8_coarse0_xy_out.iloc[1]['s01'], hex_hex8_coarse1_xy_out.iloc[1]['s01'], hex_hex8_coarse_xy_out.iloc[1]['s01'], hex_hex8_refine0_xy_out.iloc[1]['s01'], hex_hex8_refine1_xy_out.iloc[1]['s01'], hex_hex8_refine_xy_out.iloc[1]['s01']]
hex_hex8_xy_e00 = [hex_hex8_coarse0_xy_out.iloc[1]['e00'], hex_hex8_coarse1_xy_out.iloc[1]['e00'], hex_hex8_coarse_xy_out.iloc[1]['e00'], hex_hex8_refine0_xy_out.iloc[1]['e00'], hex_hex8_refine1_xy_out.iloc[1]['e00'], hex_hex8_refine_xy_out.iloc[1]['e00']]
hex_hex8_xy_e11 = [hex_hex8_coarse0_xy_out.iloc[1]['e11'], hex_hex8_coarse1_xy_out.iloc[1]['e11'], hex_hex8_coarse_xy_out.iloc[1]['e11'], hex_hex8_refine0_xy_out.iloc[1]['e11'], hex_hex8_refine1_xy_out.iloc[1]['e11'], hex_hex8_refine_xy_out.iloc[1]['e11']]
hex_hex8_xy_e01 = [hex_hex8_coarse0_xy_out.iloc[1]['e01'], hex_hex8_coarse1_xy_out.iloc[1]['e01'], hex_hex8_coarse_xy_out.iloc[1]['e01'], hex_hex8_refine0_xy_out.iloc[1]['e01'], hex_hex8_refine1_xy_out.iloc[1]['e01'], hex_hex8_refine_xy_out.iloc[1]['e01']]
hex_hex8_xy_C11 = [hex_hex8_coarse0_xy_out.iloc[1]['C11'], hex_hex8_coarse1_xy_out.iloc[1]['C11'], hex_hex8_coarse_xy_out.iloc[1]['C11'], hex_hex8_refine0_xy_out.iloc[1]['C11'], hex_hex8_refine1_xy_out.iloc[1]['C11'], hex_hex8_refine_xy_out.iloc[1]['C11']]
hex_hex8_xy_se = [hex_hex8_coarse0_xy_out.iloc[1]['strain_energy'], hex_hex8_coarse1_xy_out.iloc[1]['strain_energy'], hex_hex8_coarse_xy_out.iloc[1]['strain_energy'], hex_hex8_refine0_xy_out.iloc[1]['strain_energy'], hex_hex8_refine1_xy_out.iloc[1]['strain_energy'], hex_hex8_refine_xy_out.iloc[1]['strain_energy']]
hex_hex8_xy_cost = [hex_hex8_coarse0_xy_out.iloc[1]['run_time'], hex_hex8_coarse1_xy_out.iloc[1]['run_time'], hex_hex8_coarse_xy_out.iloc[1]['run_time'], hex_hex8_refine0_xy_out.iloc[1]['run_time'], hex_hex8_refine1_xy_out.iloc[1]['run_time'], hex_hex8_refine_xy_out.iloc[1]['run_time']]

hex_hex20_xy_ndof = [hex_hex20_coarse0_xy_out.iloc[1]['DOFs'], hex_hex20_coarse1_xy_out.iloc[1]['DOFs'], hex_hex20_coarse_xy_out.iloc[1]['DOFs'], hex_hex20_refine0_xy_out.iloc[1]['DOFs'], hex_hex20_refine1_xy_out.iloc[1]['DOFs'], hex_hex20_refine_xy_out.iloc[1]['DOFs']]
hex_hex20_xy_n_nodes = [hex_hex20_coarse0_xy_out.iloc[1]['n_nodes'], hex_hex20_coarse1_xy_out.iloc[1]['n_nodes'], hex_hex20_coarse_xy_out.iloc[1]['n_nodes'], hex_hex20_refine0_xy_out.iloc[1]['n_nodes'], hex_hex20_refine1_xy_out.iloc[1]['n_nodes'], hex_hex20_refine_xy_out.iloc[1]['n_nodes']]
hex_hex20_xy_n_elements = [hex_hex20_coarse0_xy_out.iloc[1]['n_elements'], hex_hex20_coarse1_xy_out.iloc[1]['n_elements'], hex_hex20_coarse_xy_out.iloc[1]['n_elements'], hex_hex20_refine0_xy_out.iloc[1]['n_elements'],hex_hex20_refine1_xy_out.iloc[1]['n_elements'], hex_hex20_refine_xy_out.iloc[1]['n_elements']]
hex_hex20_xy_s01 = [hex_hex20_coarse0_xy_out.iloc[1]['s01'], hex_hex20_coarse1_xy_out.iloc[1]['s01'], hex_hex20_coarse_xy_out.iloc[1]['s01'], hex_hex20_refine0_xy_out.iloc[1]['s01'], hex_hex20_refine1_xy_out.iloc[1]['s01'], hex_hex20_refine_xy_out.iloc[1]['s01']]
hex_hex20_xy_e00 = [hex_hex20_coarse0_xy_out.iloc[1]['e00'], hex_hex20_coarse1_xy_out.iloc[1]['e00'], hex_hex20_coarse_xy_out.iloc[1]['e00'], hex_hex20_refine0_xy_out.iloc[1]['e00'], hex_hex20_refine1_xy_out.iloc[1]['e00'], hex_hex20_refine_xy_out.iloc[1]['e00']]
hex_hex20_xy_e11 = [hex_hex20_coarse0_xy_out.iloc[1]['e11'], hex_hex20_coarse1_xy_out.iloc[1]['e11'], hex_hex20_coarse_xy_out.iloc[1]['e11'], hex_hex20_refine0_xy_out.iloc[1]['e11'], hex_hex20_refine1_xy_out.iloc[1]['e11'], hex_hex20_refine_xy_out.iloc[1]['e11']]
hex_hex20_xy_e01 = [hex_hex20_coarse0_xy_out.iloc[1]['e01'], hex_hex20_coarse1_xy_out.iloc[1]['e01'], hex_hex20_coarse_xy_out.iloc[1]['e01'], hex_hex20_refine0_xy_out.iloc[1]['e01'], hex_hex20_refine1_xy_out.iloc[1]['e01'], hex_hex20_refine_xy_out.iloc[1]['e01']]
hex_hex20_xy_C11 = [hex_hex20_coarse0_xy_out.iloc[1]['C11'], hex_hex20_coarse1_xy_out.iloc[1]['C11'], hex_hex20_coarse_xy_out.iloc[1]['C11'], hex_hex20_refine0_xy_out.iloc[1]['C11'], hex_hex20_refine1_xy_out.iloc[1]['C11'], hex_hex20_refine_xy_out.iloc[1]['C11']]
hex_hex20_xy_se = [hex_hex20_coarse0_xy_out.iloc[1]['strain_energy'], hex_hex20_coarse1_xy_out.iloc[1]['strain_energy'], hex_hex20_coarse_xy_out.iloc[1]['strain_energy'], hex_hex20_refine0_xy_out.iloc[1]['strain_energy'], hex_hex20_refine1_xy_out.iloc[1]['strain_energy'], hex_hex20_refine_xy_out.iloc[1]['strain_energy']]
hex_hex20_xy_cost = [hex_hex20_coarse0_xy_out.iloc[1]['run_time'], hex_hex20_coarse1_xy_out.iloc[1]['run_time'], hex_hex20_coarse_xy_out.iloc[1]['run_time'], hex_hex20_refine0_xy_out.iloc[1]['run_time'], hex_hex20_refine1_xy_out.iloc[1]['run_time'], hex_hex20_refine_xy_out.iloc[1]['run_time']]

hex_tet4_xy_ndof = [hex_tet4_coarse0_xy_out.iloc[1]['DOFs'], hex_tet4_coarse1_xy_out.iloc[1]['DOFs'], hex_tet4_coarse_xy_out.iloc[1]['DOFs'], hex_tet4_refine0_xy_out.iloc[1]['DOFs'],hex_tet4_refine1_xy_out.iloc[1]['DOFs'], hex_tet4_refine_xy_out.iloc[1]['DOFs']]
hex_tet4_xy_n_nodes = [hex_tet4_coarse0_xy_out.iloc[1]['n_nodes'], hex_tet4_coarse1_xy_out.iloc[1]['n_nodes'], hex_tet4_coarse_xy_out.iloc[1]['n_nodes'], hex_tet4_refine0_xy_out.iloc[1]['n_nodes'], hex_tet4_refine1_xy_out.iloc[1]['n_nodes'], hex_tet4_refine_xy_out.iloc[1]['n_nodes']]
hex_tet4_xy_n_elements =  [hex_tet4_coarse0_xy_out.iloc[1]['n_elements'], hex_tet4_coarse1_xy_out.iloc[1]['n_elements'], hex_tet4_coarse_xy_out.iloc[1]['n_elements'], hex_tet4_refine0_xy_out.iloc[1]['n_elements'], hex_tet4_refine1_xy_out.iloc[1]['n_elements'], hex_tet4_refine_xy_out.iloc[1]['n_elements']]
hex_tet4_xy_s01 = [hex_tet4_coarse0_xy_out.iloc[1]['s01'], hex_tet4_coarse1_xy_out.iloc[1]['s01'], hex_tet4_coarse_xy_out.iloc[1]['s01'], hex_tet4_refine0_xy_out.iloc[1]['s01'], hex_tet4_refine1_xy_out.iloc[1]['s01'], hex_tet4_refine_xy_out.iloc[1]['s01']]
hex_tet4_xy_e00 = [hex_tet4_coarse0_xy_out.iloc[1]['e00'], hex_tet4_coarse1_xy_out.iloc[1]['e00'], hex_tet4_coarse_xy_out.iloc[1]['e00'], hex_tet4_refine0_xy_out.iloc[1]['e00'], hex_tet4_refine1_xy_out.iloc[1]['e00'], hex_tet4_refine_xy_out.iloc[1]['e00']]
hex_tet4_xy_e11 = [hex_tet4_coarse0_xy_out.iloc[1]['e11'], hex_tet4_coarse1_xy_out.iloc[1]['e11'], hex_tet4_coarse_xy_out.iloc[1]['e11'], hex_tet4_refine0_xy_out.iloc[1]['e11'], hex_tet4_refine1_xy_out.iloc[1]['e11'], hex_tet4_refine_xy_out.iloc[1]['e11']]
hex_tet4_xy_e01 = [hex_tet4_coarse0_xy_out.iloc[1]['e01'], hex_tet4_coarse1_xy_out.iloc[1]['e01'], hex_tet4_coarse_xy_out.iloc[1]['e01'], hex_tet4_refine0_xy_out.iloc[1]['e01'], hex_tet4_refine1_xy_out.iloc[1]['e01'], hex_tet4_refine_xy_out.iloc[1]['e01']]
hex_tet4_xy_C11 = [hex_tet4_coarse0_xy_out.iloc[1]['C11'], hex_tet4_coarse1_xy_out.iloc[1]['C11'], hex_tet4_coarse_xy_out.iloc[1]['C11'], hex_tet4_refine0_xy_out.iloc[1]['C11'], hex_tet4_refine1_xy_out.iloc[1]['C11'], hex_tet4_refine_xy_out.iloc[1]['C11']]
hex_tet4_xy_se = [hex_tet4_coarse0_xy_out.iloc[1]['strain_energy'], hex_tet4_coarse1_xy_out.iloc[1]['strain_energy'], hex_tet4_coarse_xy_out.iloc[1]['strain_energy'], hex_tet4_refine0_xy_out.iloc[1]['strain_energy'], hex_tet4_refine1_xy_out.iloc[1]['strain_energy'], hex_tet4_refine_xy_out.iloc[1]['strain_energy']]
hex_tet4_xy_cost = [hex_tet4_coarse0_xy_out.iloc[1]['run_time'], hex_tet4_coarse1_xy_out.iloc[1]['run_time'], hex_tet4_coarse_xy_out.iloc[1]['run_time'], hex_tet4_refine0_xy_out.iloc[1]['run_time'], hex_tet4_refine1_xy_out.iloc[1]['run_time'], hex_tet4_refine_xy_out.iloc[1]['run_time']]

hex_tet10_xy_ndof = [hex_tet10_refine1_xy_out.iloc[1]['DOFs'], hex_tet10_coarse0_xy_out.iloc[1]['DOFs'], hex_tet10_coarse1_xy_out.iloc[1]['DOFs'], hex_tet10_coarse_xy_out.iloc[1]['DOFs'], hex_tet10_refine0_xy_out.iloc[1]['DOFs'], hex_tet10_refine_xy_out.iloc[1]['DOFs']]
hex_tet10_xy_n_nodes = [hex_tet10_refine1_xy_out.iloc[1]['n_nodes'], hex_tet10_coarse0_xy_out.iloc[1]['n_nodes'], hex_tet10_coarse1_xy_out.iloc[1]['n_nodes'], hex_tet10_coarse_xy_out.iloc[1]['n_nodes'], hex_tet10_refine0_xy_out.iloc[1]['n_nodes'], hex_tet10_refine_xy_out.iloc[1]['n_nodes']]
hex_tet10_xy_n_elements =  [hex_tet10_refine1_xy_out.iloc[1]['n_elements'], hex_tet10_coarse0_xy_out.iloc[1]['n_elements'], hex_tet10_coarse1_xy_out.iloc[1]['n_elements'], hex_tet10_coarse_xy_out.iloc[1]['n_elements'], hex_tet10_refine0_xy_out.iloc[1]['n_elements'], hex_tet4_refine_xy_out.iloc[1]['n_elements']]
hex_tet10_xy_s01 = [hex_tet10_refine1_xy_out.iloc[1]['s01'], hex_tet10_coarse0_xy_out.iloc[1]['s01'], hex_tet10_coarse1_xy_out.iloc[1]['s01'], hex_tet10_coarse_xy_out.iloc[1]['s01'], hex_tet10_refine0_xy_out.iloc[1]['s01'], hex_tet10_refine_xy_out.iloc[1]['s01']]
hex_tet10_xy_e00 = [hex_tet10_refine1_xy_out.iloc[1]['e00'], hex_tet10_coarse0_xy_out.iloc[1]['e00'], hex_tet10_coarse1_xy_out.iloc[1]['e00'], hex_tet10_coarse_xy_out.iloc[1]['e00'], hex_tet10_refine0_xy_out.iloc[1]['e00'], hex_tet10_refine_xy_out.iloc[1]['e00']]
hex_tet10_xy_e11 = [hex_tet10_coarse0_xy_out.iloc[1]['e11'], hex_tet10_coarse1_xy_out.iloc[1]['e11'], hex_tet10_coarse_xy_out.iloc[1]['e11'], hex_tet10_refine0_xy_out.iloc[1]['e11'], hex_tet10_refine_xy_out.iloc[1]['e11']]
hex_tet10_xy_e01 = [hex_tet10_refine1_xy_out.iloc[1]['e01'], hex_tet10_coarse0_xy_out.iloc[1]['e01'], hex_tet10_coarse1_xy_out.iloc[1]['e01'], hex_tet10_coarse_xy_out.iloc[1]['e01'], hex_tet10_refine0_xy_out.iloc[1]['e01'], hex_tet10_refine_xy_out.iloc[1]['e01']]
hex_tet10_xy_C11 = [hex_tet10_coarse0_xy_out.iloc[1]['C11'], hex_tet10_coarse1_xy_out.iloc[1]['C11'], hex_tet10_coarse_xy_out.iloc[1]['C11'], hex_tet10_refine0_xy_out.iloc[1]['C11'], hex_tet10_refine_xy_out.iloc[1]['C11']]
hex_tet10_xy_se = [hex_tet10_coarse0_xy_out.iloc[1]['strain_energy'], hex_tet10_coarse1_xy_out.iloc[1]['strain_energy'], hex_tet10_coarse_xy_out.iloc[1]['strain_energy'], hex_tet10_refine0_xy_out.iloc[1]['strain_energy'], hex_tet10_refine_xy_out.iloc[1]['strain_energy']]
hex_tet10_xy_cost = [hex_tet10_refine1_xy_out.iloc[1]['run_time'], hex_tet10_coarse0_xy_out.iloc[1]['run_time'], hex_tet10_coarse1_xy_out.iloc[1]['run_time'], hex_tet10_coarse_xy_out.iloc[1]['run_time'], hex_tet10_refine0_xy_out.iloc[1]['run_time'], hex_tet10_refine_xy_out.iloc[1]['run_time']]


hex_G12_hex8 = np.divide(hex_hex8_xy_s01,hex_hex8_xy_e01)/2
hex_G12_hex20 = np.divide(hex_hex20_xy_s01,hex_hex20_xy_e01)/2
hex_G12_tet4 = np.divide(hex_tet4_xy_s01,hex_tet4_xy_e01)/2
hex_G12_tet10 = np.divide(hex_tet10_xy_s01,hex_tet10_xy_e01)/2


hex_G12_hex8_error = np.divide(abs(hex_G12_hex8-hex_G12_hex8[5]), hex_G12_hex8[5])*100
hex_G12_hex20_error = np.divide(abs(hex_G12_hex20-hex_G12_hex20[5]), hex_G12_hex20[5])*100
hex_G12_tet4_error = np.divide(abs(hex_G12_tet4-hex_G12_tet4[5]), hex_G12_tet4[5])*100
hex_G12_tet10_error = np.divide(abs(hex_G12_tet10-hex_G12_tet10[5]), hex_G12_tet10[5])*100

ax = plt.figure(1)
# plt.plot(square_hex8_yy_n_elements, square_E22_hex8, 'bo', label='Square RVE, Hex $1^{st}$', markersize = 6)
# plt.plot(square_hex20_yy_n_elements, square_E22_hex20, 'ro', label='Square RVE, Hex $2^{nd}', markersize = 6)
# plt.plot(square_tet4_yy_n_elements, square_E22_tet4, 'b*', label='Square RVE, Tetra $1^{st}', markersize = 7)
# plt.plot(square_tet10_yy_n_elements, square_E22_tet10, 'r*', label='Square RVE, Tetra $2^{nd}', markersize = 7)

# plt.plot(square_hex8_xx_n_elements, square_E11_hex8, 'bo', label='Square RVE, Hex $1^{st}$', markersize = 6)
# plt.plot(square_hex20_xx_n_elements, square_E11_hex20, 'ro', label='Square RVE, Hex $2^{nd}', markersize = 6)
# plt.plot(square_tet4_xx_n_elements, square_E11_tet4, 'b*', label='Square RVE, Tetra $1^{st}', markersize = 7)
# plt.plot(square_tet10_xx_n_elements, square_E11_tet10, 'r*', label='Square RVE, Tetra $2^{nd}', markersize = 7)

# plt.plot(square_hex8_xy_n_elements, square_G12_hex8, 'bo', label='Square RVE, Hex $1^{st}$', markersize = 6)
# plt.plot(square_hex20_xy_n_elements, square_G12_hex20, 'ro', label='Square RVE, Hex $2^{nd}', markersize = 6)
# plt.plot(square_tet4_xy_n_elements, square_G12_tet4, 'b*', label='Square RVE, Tetra $1^{st}', markersize = 7)
# plt.plot(square_tet10_xy_n_elements, square_G12_tet10, 'r*', label='Square RVE, Tetra $2^{nd}', markersize = 7)


# plt.plot(hex_hex8_xx_n_elements, hex_E11_hex8, 'bo', label='Hex RVE, Hex $1^{st}$', markersize = 6)
# plt.plot(hex_hex20_xx_n_elements, hex_E11_hex20, 'ro', label='Hex RVE, Hex $2^{nd}', markersize = 6)
# plt.plot(hex_tet4_xx_n_elements, hex_E11_tet4, 'b*', label='Hex RVE, Tetra $1^{st}', markersize = 7)
# plt.plot(hex_tet10_xx_n_elements, hex_E11_tet10, 'r*', label='hex RVE, Tetra $2^{nd}', markersize = 7)

plt.plot(hex_hex8_xy_n_elements, hex_G12_hex8, 'bo', label='Hex RVE, Hex $1^{st}$', markersize = 6)
plt.plot(hex_hex20_xy_n_elements, hex_G12_hex20, 'ro', label='Hex RVE, Hex $2^{nd}', markersize = 6)
plt.plot(hex_tet4_xy_n_elements, hex_G12_tet4, 'b*', label='Hex RVE, Tetra $1^{st}', markersize = 7)
plt.plot(hex_tet10_xy_n_elements, hex_G12_tet10, 'r*', label='hex RVE, Tetra $2^{nd}', markersize = 7)


plt.xscale('symlog')

# plt.xlim([0, 80000])
# plt.ylim([1200, 1250])
plt.xlabel('No. of Elements')
plt.ylabel('E11')
# plt.legend(frameon=False)
plt.show()
# plt.savefig("/Users/bisws/Writings/papers/grizzly/LWRS_Grizzly/figures/damage_tens_comp.png")

ax = plt.figure(2)
# plt.plot(square_hex8_yy_ndof, square_E22_hex8, 'bo', label='Square RVE, Hex $1^{st}$', markersize = 6)
# plt.plot(square_hex20_yy_ndof, square_E22_hex20, 'ro', label='Square RVE, Hex $2^{nd}', markersize = 6)
# plt.plot(square_tet4_yy_ndof, square_E22_tet4, 'b*', label='Square RVE, Tetra $1^{st}', markersize = 7)
# plt.plot(square_tet10_yy_ndof, square_E22_tet10, 'r*', label='Square RVE, Tetra $2^{nd}', markersize = 7)

# plt.plot(square_hex8_xx_ndof, square_E11_hex8, 'bo', label='Square RVE, Hex $1^{st}$', markersize = 6)
# plt.plot(square_hex20_xx_ndof, square_E11_hex20, 'ro', label='Square RVE, Hex $2^{nd}', markersize = 6)
# plt.plot(square_tet4_xx_ndof, square_E11_tet4, 'b*', label='Square RVE, Tetra $1^{st}', markersize = 7)
# plt.plot(square_tet10_xx_ndof, square_E11_tet10, 'r*', label='Square RVE, Tetra $2^{nd}', markersize = 7)

plt.plot(hex_hex8_xx_ndof, hex_E11_hex8, 'bo', label='Hex RVE, Hex $1^{st}$', markersize = 6)
plt.plot(hex_hex20_xx_ndof, hex_E11_hex20, 'ro', label='Hex RVE, Hex $2^{nd}', markersize = 6)
plt.plot(hex_tet4_xx_ndof, hex_E11_tet4, 'b*', label='Hex RVE, Tetra $1^{st}', markersize = 7)
plt.plot(hex_tet10_xx_ndof, hex_E11_tet10, 'r*', label='hex RVE, Tetra $2^{nd}', markersize = 7)


# plt.xlim([0.01, 10])
# plt.ylim([1200, 1250])
plt.xscale('symlog')
plt.xlabel('No. of DOFs')
plt.ylabel('E11')
# plt.legend(frameon=False)
plt.show()
# plt.savefig("/Users/bisws/Writings/papers/grizzly/LWRS_Grizzly/figures/damage_tens_comp.png")

ax = plt.figure(3)
# plt.plot(square_hex8_yy_n_elements, square_E22_hex8_error, 'bs-', label='Square RVE, Hex $1^{st}$', markersize = 5.5)
# plt.plot(square_hex20_yy_n_elements, square_E22_hex20_error, 'rs-', label='Square RVE, Hex $2^{nd}$', markersize = 5.5)
# plt.plot(square_tet4_yy_n_elements, square_E22_tet4_error, 'gs-', label='Square RVE, Tetra $1^{st}$', markersize = 5.5)
# plt.plot(square_tet10_yy_n_elements, square_E22_tet10_error, 'ms-', label='Square RVE, Tetra $2^{nd}$', markersize = 5.5)

# plt.plot(square_hex8_xx_n_elements, square_E11_hex8_error, 'bs-', label='Square RVE, Hex $1^{st}$', markersize = 5.5)
# plt.plot(square_hex20_xx_n_elements, square_E11_hex20_error, 'rs-', label='Square RVE, Hex $2^{nd}$', markersize = 5.5)
# plt.plot(square_tet4_xx_n_elements, square_E11_tet4_error, 'gs-', label='Square RVE, Tetra $1^{st}$', markersize = 5.5)
# plt.plot(square_tet10_xx_n_elements, square_E11_tet10_error, 'ms-', label='Square RVE, Tetra $2^{nd}$', markersize = 5.5)

# plt.plot(square_hex8_xy_n_elements, square_G12_hex8_error, 'bs-.', label='Square RVE, Hex $1^{st}$', markersize = 5.5)
# plt.plot(square_hex20_xy_n_elements, square_G12_hex20_error, 'rs-.', label='Square RVE, Hex $2^{nd}', markersize = 5.5)
# plt.plot(square_tet4_xy_n_elements, square_G12_tet4_error, 'gs-.', label='Square RVE, Tetra $1^{st}', markersize = 5.5)
# plt.plot(square_tet10_xy_n_elements, square_G12_tet10_error, 'ms-.', label='Square RVE, Tetra $2^{nd}', markersize = 5.5)


# plt.plot(hex_hex8_yy_n_elements, hex_E22_hex8_error, 'b*', label='Hex RVE, Hex $1^{st}$', markersize = 8)
# plt.plot(hex_hex20_yy_n_elements, hex_E22_hex20_error, 'r*', label='Hex RVE, Hex $2^{nd}$', markersize = 8)
# plt.plot(hex_tet4_yy_n_elements, hex_E22_tet4_error, 'g*', label='Hex RVE, Tetra $1^{st}$', markersize = 8)
# plt.plot(hex_tet10_yy_n_elements, hex_E22_tet10_error, 'm*', label='Hex RVE, Tetra $2^{nd}$', markersize = 8)

# plt.plot(hex_hex8_xx_n_elements, hex_E11_hex8_error, 'b*-', label='Hex RVE, Hex $1^{st}$', markersize = 8)
# plt.plot(hex_hex20_xx_n_elements, hex_E11_hex20_error, 'r*-', label='Hex RVE, Hex $2^{nd}$', markersize = 8)
# plt.plot(hex_tet4_xx_n_elements, hex_E11_tet4_error, 'g*-', label='Hex RVE, Tetra $1^{st}$', markersize = 8)
# plt.plot(hex_tet10_xx_n_elements, hex_E11_tet10_error, 'm*-', label='Hex RVE, Tetra $2^{nd}$', markersize = 8)

# plt.plot(hex_hex8_xy_n_elements, hex_G12_hex8_error, 'b*-.', label='Hex RVE, Hex $1^{st}$', markersize = 8)
# plt.plot(hex_hex20_xy_n_elements, hex_G12_hex20_error, 'r*-.', label='Hex RVE, Hex $2^{nd}', markersize = 8)
# plt.plot(hex_tet4_xy_n_elements, hex_G12_tet4_error, 'g*-.', label='Hex RVE, Tetra $1^{st}', markersize = 8)
plt.plot(hex_tet10_xy_n_elements, hex_G12_tet10_error, 'm*-', label='Hex RVE, Tetra $2^{nd}', markersize = 8)

plt.xscale('symlog')

# plt.ylim([-0.5, 2.5])
# plt.ylim([1200, 1250])
plt.xlabel('No. of Elements')
plt.ylabel('Error (%)')
# plt.legend(frameon=False)
plt.show()
# plt.savefig("/Users/bisws/Writings/papers/grizzly/LWRS_Grizzly/figures/damage_tens_comp.png")

ax = plt.figure(4)
plt.plot(square_hex8_yy_ndof, square_E22_hex8_error, 'bs', label='Square RVE, Hex $1^{st}$', markersize = 5.5)
plt.plot(square_hex20_yy_ndof, square_E22_hex20_error, 'rs', label='Square RVE, Hex $2^{nd}$', markersize = 5.5)
plt.plot(square_tet4_yy_ndof, square_E22_tet4_error, 'gs', label='Square RVE, Tetra $1^{st}$', markersize = 5.5)
plt.plot(square_tet10_yy_ndof, square_E22_tet10_error, 'ms', label='Square RVE, Tetra $2^{nd}$', markersize = 5.5)

# plt.plot(square_hex8_xx_ndof, square_E11_hex8_error, 'gs', label='Square RVE, Hex $1^{st}$', markersize = 6)
# plt.plot(square_hex20_xx_ndof, square_E11_hex20_error, 'ms', label='Square RVE, Hex $2^{nd}$', markersize = 6)
# plt.plot(square_tet4_xx_ndof, square_E11_tet4_error, 'gs', label='Square RVE, Tetra $1^{st}$', markersize = 6)
# plt.plot(square_tet10_xx_ndof, square_E11_tet10_error, 'ms', label='Square RVE, Tetra $2^{nd}$', markersize = 6)

plt.plot(hex_hex8_xx_ndof, hex_E11_hex8_error, 'b*', label='Hex RVE, Hex $1^{st}$', markersize = 8)
plt.plot(hex_hex20_xx_ndof, hex_E11_hex20_error, 'r*', label='Hex RVE, Hex $2^{nd}', markersize = 8)
plt.plot(hex_tet4_xx_ndof, hex_E11_tet4_error, 'g*', label='Hex RVE, Tetra $1^{st}', markersize = 8)
plt.plot(hex_tet10_xx_ndof, hex_E11_tet10_error, 'm*', label='hex RVE, Tetra $2^{nd}', markersize = 8)


# plt.xlim([0.01, 10])
# plt.ylim([1200, 1250])
plt.xscale('symlog')
plt.xlabel('No. of DOFs')
plt.ylabel('Error (%)')
# plt.legend(frameon=False)
plt.show()
# plt.savefig("/Users/bisws/Writings/papers/grizzly/LWRS_Grizzly/figures/damage_tens_comp.png")


square_hex8 = np.array([square_E11_hex8, square_E22_hex8, square_G12_hex8, square_n12_hex8])
square_hex20 = np.array([square_E11_hex20, square_E22_hex20, square_G12_hex20, square_n12_hex20])
square_tet4 = np.array([square_E11_tet4, square_E22_tet4, square_G12_tet4, square_n12_tet4])
square_tet10 = np.array([square_E11_tet10, square_E22_tet10, square_G12_tet10, square_n12_tet10])


hex_hex8 = np.array([hex_E11_hex8, hex_E22_hex8, hex_G12_hex8, hex_n12_hex8])
hex_hex20 = np.array([hex_E11_hex20, hex_E22_hex20, hex_G12_hex20, hex_n12_hex20])
hex_tet4 = np.array([hex_E11_tet4, hex_E22_tet4, hex_G12_tet4, hex_n12_tet4])
hex_tet10 = np.array([hex_E11_tet10, hex_E22_tet10, hex_G12_tet10, hex_n12_tet10])


square_hex8_error = np.array([square_E11_hex8_error, square_E22_hex8_error, square_G12_hex8_error, square_n12_hex8_error])
square_hex8_error_mean = np.mean(square_hex8_error, axis=0)
square_hex8_error_err = np.std(square_hex8_error, axis=0)

square_hex20_error = np.array([square_E11_hex20_error, square_E22_hex20_error, square_G12_hex20_error, square_n12_hex20_error])
square_hex20_error_mean = np.mean(square_hex20_error, axis=0)
square_hex20_error_err = np.std(square_hex20_error, axis=0)

square_tet4_error = np.array([square_E11_tet4_error, square_E22_tet4_error, square_G12_tet4_error, square_n12_tet4_error])
square_tet4_error_mean = np.mean(square_tet4_error, axis=0)
square_tet4_error_err = np.std(square_tet4_error, axis=0)

square_tet10_error = np.array([square_E11_tet10_error, square_E22_tet10_error, square_G12_tet10_error, square_n12_tet10_error])
square_tet10_error_mean = np.mean(square_tet10_error, axis=0)
square_tet10_error_err = np.std(square_tet10_error, axis=0)

hex_hex8_error = np.array([hex_E11_hex8_error, hex_E22_hex8_error, hex_G12_hex8_error, hex_n12_hex8_error])
hex_hex8_error_mean = np.mean(hex_hex8_error, axis=0)
hex_hex8_error_err = np.std(hex_hex8_error, axis=0)

hex_hex20_error = np.array([hex_E11_hex20_error, hex_E22_hex20_error, hex_G12_hex20_error, hex_n12_hex20_error])
hex_hex20_error_mean = np.mean(hex_hex20_error, axis=0)
hex_hex20_error_err = np.std(hex_hex20_error, axis=0)

hex_tet4_error = np.array([hex_E11_tet4_error, hex_E22_tet4_error, hex_G12_tet4_error, hex_n12_tet4_error])
hex_tet4_error_mean = np.mean(hex_tet4_error, axis=0)
hex_tet4_error_err = np.std(hex_tet4_error, axis=0)

hex_tet10_error = np.array([hex_E11_tet10_error, hex_E22_tet10_error[1:7], hex_G12_tet10_error, hex_n12_tet10_error])
hex_tet10_error_mean = np.mean(hex_tet10_error, axis=0)
hex_tet10_error_err = np.std(hex_tet10_error, axis=0)

# plt.rc('font', family='serif', serif='Times')
# plt.rc('text', usetex=True)
import matplotlib as mpl
plt.rc('font',family='Times New Roman')
plt.rc('xtick', labelsize=14)
plt.rc('ytick', labelsize=14)
plt.rc('axes', labelsize=14)
plt.rc('legend', fontsize=14)

# width as measured in inkscape
# width = 100
# height = 100

# ax = plt.figure(10)
# mpl.style.use(sty)

fig, (ax1, ax2) = plt.subplots(1,2,figsize=(15,8))

ax1.errorbar(square_hex8_xx_n_elements, square_hex8_error_mean, yerr=square_hex8_error_err, fmt='bs', label='Square RVE, Hex $1^{st}$', markersize = 7)
ax1.errorbar(square_hex20_yy_n_elements, square_hex20_error_mean, yerr=square_hex20_error_err, fmt='ks', label='Square RVE, Hex $2^{nd}$', markersize = 7)
ax1.errorbar(square_tet4_xx_n_elements, square_tet4_error_mean, yerr=square_tet4_error_err, fmt='gs', label='Square RVE, Tetra $1^{st}$', markersize = 7)
ax1.errorbar(square_tet10_yy_n_elements, square_tet10_error_mean, yerr=square_tet10_error_err,fmt='ms', label='Square RVE, Tetra $2^{nd}$', markersize = 7)

ax1.errorbar(hex_hex8_xx_n_elements, hex_hex8_error_mean, yerr=hex_hex8_error_err, fmt='bo', label='Hex RVE, Hex $1^{st}$', markersize = 8)
ax1.errorbar(hex_hex20_yy_n_elements, hex_hex20_error_mean, yerr=hex_hex20_error_err, fmt='ko', label='Hex RVE, Hex $2^{nd}$', markersize = 8)
ax1.errorbar(hex_tet4_xx_n_elements, hex_tet4_error_mean, yerr=hex_tet4_error_err, fmt='go', label='Hex RVE, Tetra $1^{st}$', markersize = 8)
ax1.errorbar(hex_tet10_yy_n_elements[1:7], hex_tet10_error_mean, yerr=hex_tet10_error_err, fmt='mo', label='Hex RVE, Tetra $2^{nd}$', markersize = 8)

ax1.set_xscale('symlog')


# plt.ylim([-0.5, 2.5])
# plt.ylim([1200, 1250])
ax1.set_xlabel('No. of Elements')
ax1.set_ylabel('Error ($\%$)')
ax1.set_title('(a)', y=-0.25)

# plt.legend(frameon=False)
# plt.legend(bbox_to_anchor=(1.0, 0.85), loc='upper left', borderaxespad=0., frameon=False)

# plt.show()
# plt.savefig("/Users/bisws/Writings/papers/grizzly/LWRS_Grizzly/figures/damage_tens_comp.png")

# ax = plt.figure(11)
ax2.errorbar(square_hex8_xx_ndof, square_hex8_error_mean, yerr=square_hex8_error_err, fmt='bs', markersize = 7)
ax2.errorbar(square_hex20_yy_ndof, square_hex20_error_mean, yerr=square_hex20_error_err, fmt='ks', markersize = 7)
ax2.errorbar(square_tet4_xx_ndof, square_tet4_error_mean, yerr=square_tet4_error_err, fmt='gs', markersize = 7)
ax2.errorbar(square_tet10_yy_ndof, square_tet10_error_mean, yerr=square_tet10_error_err,fmt='ms', markersize = 7)

ax2.errorbar(hex_hex8_xx_ndof, hex_hex8_error_mean, yerr=hex_hex8_error_err, fmt='co', markersize = 8)
ax2.errorbar(hex_hex20_yy_ndof, hex_hex20_error_mean, yerr=hex_hex20_error_err, fmt='ko', markersize = 8)
ax2.errorbar(hex_tet4_xx_ndof, hex_tet4_error_mean, yerr=hex_tet4_error_err, fmt='yo', markersize = 8)
ax2.errorbar(hex_tet10_yy_ndof[1:7], hex_tet10_error_mean, yerr=hex_tet10_error_err, fmt='o', color='orrange', markersize = 8)
# plt.xscale('symlog')


# # # plt.xlim([0.01, 10])
# # # plt.ylim([1200, 1250])
ax2.set_xscale('symlog')
ax2.set_xlabel('No. of DOFs')
ax2.set_ylabel('Error ($\%$)')
ax2.set_title('(b)', y=-0.25)
# p.legend(frameon=False)
# plt.legend(bbox_to_anchor=(0., 1.02, 1., .102), loc='lower left',
#            ncol=4, mode="expand", frameon=False)
# plt.show()
# fig.tight_layout()

fig.legend(bbox_to_anchor=(0.5, 0.2), loc='lower center', ncol=4, frameon=False )
plt.subplots_adjust(bottom=0.4)

# ax1.text(0.5,-0.1, "(a)")
# ax2.text(0.5,-0.1, "(b)", ha="center")
plt.show()

# fig.legend([bs,rs,gs,ms,bst,rst,gst,mst],["Square RVE, Hex $1^{st}$","Square RVE, Hex $2^{nd}$", "Square RVE, Tetra $1^{st}", "Square RVE, Tetra $2^{nd}$","Hex RVE, Hex $1^{st}", "Hex RVE, Hex $2^{nd}", "Hex RVE, Tetra $1^{st}", "Hex RVE, Tetra $2^{nd}"],loc = (0.5, 0), ncol=4 )
# fig.savefig("/Users/bisws/writings/papers/biswas/strain-periodicity/figures/RVE_convergence2.png")

# plt.rc('font', family='serif', serif='Times')
# plt.rc('text', usetex=True)
plt.rc('font',family='Times New Roman')
plt.rc('xtick', labelsize=14)
plt.rc('ytick', labelsize=14)
plt.rc('axes', labelsize=14)
plt.rc('legend', fontsize=14)

# width as measured in inkscape
# width = 100
# height = 100

# ax = plt.figure(10)


fig, (ax1, ax2) = plt.subplots(1,2,figsize=(15,8))

ax1.errorbar(square_hex8_xx_n_elements, square_hex8_error_mean, yerr=square_hex8_error_err, fmt='bs', label='Square RVE, Hex $1^{st}$', markersize = 7)
ax1.errorbar(square_hex20_yy_n_elements, square_hex20_error_mean, yerr=square_hex20_error_err, fmt='ks', label='Square RVE, Hex $2^{nd}$', markersize = 7)
ax1.errorbar(square_tet4_xx_n_elements, square_tet4_error_mean, yerr=square_tet4_error_err, fmt='gs', label='Square RVE, Tet $1^{st}$', markersize = 7)
ax1.errorbar(square_tet10_yy_n_elements, square_tet10_error_mean, yerr=square_tet10_error_err,fmt='ms', label='Square RVE, Tet $2^{nd}$', markersize = 7)

ax1.errorbar(hex_hex8_xx_n_elements, hex_hex8_error_mean, yerr=hex_hex8_error_err, fmt='bo', label='Hex RVE, Hex $1^{st}$', markersize = 8)
ax1.errorbar(hex_hex20_yy_n_elements, hex_hex20_error_mean, yerr=hex_hex20_error_err, fmt='ko', label='Hex RVE, Hex $2^{nd}$', markersize = 8)
ax1.errorbar(hex_tet4_xx_n_elements, hex_tet4_error_mean, yerr=hex_tet4_error_err, fmt='go', label='Hex RVE, Tet $1^{st}$', markersize = 8)
ax1.errorbar(hex_tet10_yy_n_elements[1:7], hex_tet10_error_mean, yerr=hex_tet10_error_err, fmt='mo', label='Hex RVE, Tet $2^{nd}$', markersize = 8)

ax1.set_xscale('symlog')


# plt.ylim([-0.5, 2.5])
# plt.ylim([1200, 1250])
ax1.set_xlabel('No. of Elements')
ax1.set_ylabel('Error ($\%$)')
ax1.set_title('(a)', y=-0.25)

# plt.legend(frameon=False)
# plt.legend(bbox_to_anchor=(1.0, 0.85), loc='upper left', borderaxespad=0., frameon=False)

# plt.show()
# plt.savefig("/Users/bisws/Writings/papers/grizzly/LWRS_Grizzly/figures/damage_tens_comp.png")

# ax = plt.figure(11)
ax2.errorbar(square_hex8_xx_ndof, square_hex8_error_mean, yerr=square_hex8_error_err, fmt='bs', markersize = 7)
ax2.errorbar(square_hex20_yy_ndof, square_hex20_error_mean, yerr=square_hex20_error_err, fmt='ks', markersize = 7)
ax2.errorbar(square_tet4_xx_ndof, square_tet4_error_mean, yerr=square_tet4_error_err, fmt='gs', markersize = 7)
ax2.errorbar(square_tet10_yy_ndof, square_tet10_error_mean, yerr=square_tet10_error_err,fmt='ms', markersize = 7)

ax2.errorbar(hex_hex8_xx_ndof, hex_hex8_error_mean, yerr=hex_hex8_error_err, fmt='bo', markersize = 8)
ax2.errorbar(hex_hex20_yy_ndof, hex_hex20_error_mean, yerr=hex_hex20_error_err, fmt='ko', markersize = 8)
ax2.errorbar(hex_tet4_xx_ndof, hex_tet4_error_mean, yerr=hex_tet4_error_err, fmt='go', markersize = 8)
ax2.errorbar(hex_tet10_yy_ndof[1:7], hex_tet10_error_mean, yerr=hex_tet10_error_err, fmt='mo', markersize = 8)
# plt.xscale('symlog')


# # # plt.xlim([0.01, 10])
# # # plt.ylim([1200, 1250])
ax2.set_xscale('symlog')
ax2.set_xlabel('No. of DoFs')
ax2.set_ylabel('Error ($\%$)')
ax2.set_title('(b)', y=-0.25)
# p.legend(frameon=False)
# plt.legend(bbox_to_anchor=(0., 1.02, 1., .102), loc='lower left',
#            ncol=4, mode="expand", frameon=False)
# plt.show()
# fig.tight_layout()

fig.legend(bbox_to_anchor=(0.5, 0.2), loc='lower center', ncol=4, frameon=False )
plt.subplots_adjust(bottom=0.4)

# ax1.text(0.5,-0.1, "(a)")
# ax2.text(0.5,-0.1, "(b)", ha="center")
plt.show()

# fig.legend([bs,rs,gs,ms,bst,rst,gst,mst],["Square RVE, Hex $1^{st}$","Square RVE, Hex $2^{nd}$", "Square RVE, Tetra $1^{st}", "Square RVE, Tetra $2^{nd}$","Hex RVE, Hex $1^{st}", "Hex RVE, Hex $2^{nd}", "Hex RVE, Tetra $1^{st}", "Hex RVE, Tetra $2^{nd}"],loc = (0.5, 0), ncol=4 )
fig.savefig("/Users/bisws/writings/papers/biswas/strain-periodicity/figures/RVE_convergence.png")
