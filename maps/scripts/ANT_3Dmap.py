'''
    Author: Sergio Pérez Montero
    Date: 2022.02.15
    Aim: Plot Antarctica 3D map from observational data
    (WORK IN PROGRESS)
'''

#####################
import math
import numpy as np
from numpy import ma

import netCDF4 as nc

import matplotlib as mpl
import matplotlib.pyplot as plt
from matplotlib import rc
import matplotlib.patheffects as PathEffects
from mpl_toolkits.mplot3d import Axes3D

import cmocean.cm as cmo
from cmaps.ocean_cmap import ocean_dark
from cmaps.ice_cmap import ant_ice_sheet
from cmaps.bat_cmap import bat_mapCentered
####################
# Parameters
locdata = '/home/sergio/entra/proyectos/d01/sources/ANT-16KM/'
locplot = '/home/sergio/entra/proyectos/d01/figures/'
file_name = 'ANT-16KM_TOPO-BedMachine.nc'  # 'ANT-16KM_TOPO-RTOPO-2.0.1.nc'
plot_name = '3Dmap_ANT-16KM_TOPO-BedMachine'  # 'map_ANT-16KM_RTOPO-2.0.1'
plot_format = 'png'  # 'eps' # pdf is recommended
resolution = 100  # 1, 10, 100 and so on, 1 generates an image of ~235 Mb!
ocean_cmap = ocean_dark  # bat_mapCentered
ice_cmap = ant_ice_sheet

# Load
data = nc.Dataset(locdata + file_name)

lat = data.variables['lat2D'][:]
lon = data.variables['lon2D'][:]

x = data.variables['x2D'][:]
y = data.variables['y2D'][:]

#H_ice = data.variables['H_ice'][:]
#z_ice_bed = data.variables['z_ice_base'][:]
z_srf = data.variables['z_srf'][:]
z_bed = data.variables['z_bed'][:]
mask = data.variables['mask'][:]

# Some calculations
ocean = z_bed
Ice = z_srf  # H_ice + z_ice_bed
Ice = ma.masked_where(mask == 0, Ice)

# Activating LaTeX font
plt.rcParams['font.family'] = 'DeJavu Serif'
plt.rcParams['font.serif'] = ['Times New Roman']
rc('text', usetex=True)

# Custom cmaps


def list2list(pylist, slice_len):
    '''
    Transform pylist with 1 dimension to pylist_converted with dimensions (len(pylist), slice_len)
    '''
    pylist_converted = []
    k = 0
    for i in range(int(len(pylist)/slice_len)):
        temp_list = []
        for j in np.arange(k, k + slice_len, 1):
            temp_list.append(pylist[j])
        pylist_converted.append(temp_list)
        k = k + slice_len
    return pylist_converted


def Ccmap(C):
    '''
    Transforms C (numpy array, dimC = (longitude of colors, 3)) into a colormap
    '''
    cm = mpl.colors.ListedColormap(C/255)
    return cm


C = np.array(list2list(ocean_cmap, 3))
cm_ocean = Ccmap(C)

C = np.array(list2list(ice_cmap, 3))
cm_ICE = Ccmap(C)

# Plotting
fig = plt.figure(figsize=(10, 10))
ax = plt.axes(projection='3d')
ax.view_init(70, 270)
ax.set_xticks([])
ax.set_yticks([])
ax.set_zticks([])
ax.axis('Off')

# Ocean
ocean = ma.masked_where(ocean > 0, ocean)
ax.plot_surface(x, y, ocean, cmap=cm_ocean, cstride=1,
                rstride=1, antialiased=False, zorder=1, alpha=1)
ax.contourf(x, y, ocean, np.arange(ma.min(ocean), 0, 100), zdir='z', offset=0, cmap=cm_ocean,
            antialiased=False, zorder=1, alpha=0.5)
# ax.contour(x, y, ocean, np.arange(ma.min(ocean), 0, 100), zdir='z', offset=0, cmap=cm_ocean,
#           antialiased=False, zorder=1, alpha=0.5)
# Ice
ax.plot_surface(x, y, Ice, cmap=cm_ICE, cstride=5,
                rstride=5, antialiased=False, zorder=10, alpha=1)
ax.contour(x, y, Ice, cmap=cm_ICE, antialiased=False, zorder=10, alpha=1)

# Some contours
ax.contour(x, y, mask, [0], colors='k', linewidths=0.8)
cz = ax.contour(x, y, z_srf, [500, 1000, 2000, 3000, 4000],
                colors='cornflowerblue', linewidths=0.8, linestyles='--', zorder=15)
manual_locations = [(323, 243,), (308, 227),
                    (305, 220), (283, 205), (250, 200)]
ax.clabel(cz, fmt='%i'+r' m', colors='blue',
          fontsize=10, manual=manual_locations)

ax.set_xticks([])
ax.set_yticks([])

# Coordinates
# lat = ma.abs(lat)
# clat = ax.contour(lat, [60, 70, 80, 85], colors='grey',
#                   linewidths=0.8, linestyles='dotted')
# manual_locations = [(190+150, 190-150), (190+98, 190-98),
#                     (190+68, 190-68), (190+35, 190-35)]
# ax.clabel(clat, fmt=r'\textbf{%i}'+r'\textbf{$\bf{^o}$S}', colors='red',
#           fontsize=14, manual=manual_locations)

# lon[lon < 0] = lon[lon < 0] + 360  # only positive values
# lon[int(len(lon)/2):, int(len(lon)/2)-1] = np.NaN  # dealing with discontinuity
# clon = ax.contour(lon, [0, 90, 180, 270], colors='grey',
#                   linewidths=0.8, linestyles='dotted')
# manual_locations = [(190, 355), (355, 190), (190, 25), (25, 190)]
# ax.clabel(clon, fmt=r'\textbf{%i}'+r'\textbf{$\bf{^o}$E}', colors='red',
#           fontsize=14, manual=manual_locations)

# # South Pole
# circle = plt.Circle((190, 190), 1, color='r', zorder=10)
# ax.add_patch(circle)
# ax.text(190, 190, 'South Pole', horizontalalignment='left',
#         verticalalignment='bottom', color='k', fontsize=12)

# # Important sites
# txt = ax.text(130, 227, r'\textbf{\textit{Filchner-Ronne}}'+'\n'+r'\textbf{\textit{Ice Shelf}}', horizontalalignment='center',
#               verticalalignment='center', color='navy', fontsize=12)
# txt = ax.text(180, 133, r'\textbf{\textit{Ross}}'+'\n'+r'\textbf{\textit{Ice Shelf}}', horizontalalignment='center',
#               verticalalignment='center', color='navy', fontsize=12)
# txt = ax.text(88, 185, r'\textbf{\textit{Pine}}'+'\n'+r'\textbf{\textit{Island}}', horizontalalignment='center',
#               verticalalignment='center', color='navy', fontsize=12)

# # Main regions
# txt = ax.text(245, 245, r'\textbf{EAIS}', horizontalalignment='center',
#               verticalalignment='center', color='k', fontsize=24)
# txt.set_path_effects([PathEffects.withStroke(linewidth=3, foreground='w')])
# txt = ax.text(120, 170, r'\textbf{WAIS}', horizontalalignment='center',
#               verticalalignment='center', color='k', fontsize=24)
# txt.set_path_effects([PathEffects.withStroke(linewidth=3, foreground='w')])
# txt = ax.text(65, 250, r'\textbf{APIS}', horizontalalignment='center',
#               verticalalignment='center', color='k', fontsize=24, rotation=-30)
# txt.set_path_effects([PathEffects.withStroke(linewidth=3, foreground='w')])

# # Some important basins
# txt = ax.text(252, 88, r'\textbf{Wilkes}'+'\n'+r'\textbf{Subglacial Basin}', horizontalalignment='center',
#               verticalalignment='center', color='k', fontsize=16, fontweight='bold')
# txt.set_path_effects([PathEffects.withStroke(linewidth=2, foreground='w')])
# txt = ax.text(300, 138, r'\textbf{Aurora}'+'\n'+r'\textbf{Subglacial Basin}', horizontalalignment='center',
#               verticalalignment='center', color='k', fontsize=16)
# txt.set_path_effects([PathEffects.withStroke(linewidth=2, foreground='w')])
# txt = ax.text(173, 270, r'\textbf{Recovery}'+'\n'+r'\textbf{Subglacial Basin}', horizontalalignment='center',
#               verticalalignment='center', color='k', fontsize=16)
# txt.set_path_effects([PathEffects.withStroke(linewidth=2, foreground='w')])

# # Main seas
# txt = ax.text(315, 335, r'\textbf{\textit{Southern Ocean}}', horizontalalignment='center',
#               verticalalignment='center', color='lightgrey', fontsize=24, rotation=-40)
# txt.set_path_effects([PathEffects.withStroke(linewidth=3, foreground='k')])
# txt = ax.text(100, 295, r'\textbf{\textit{Weddell Sea}}', horizontalalignment='center',
#               verticalalignment='center', color='lightgrey', fontsize=12)
# txt.set_path_effects([PathEffects.withStroke(linewidth=3, foreground='k')])
# txt = ax.text(180, 85, r'\textbf{\textit{Ross Sea}}', horizontalalignment='center',
#               verticalalignment='center', color='lightgrey', fontsize=12)
# txt.set_path_effects([PathEffects.withStroke(linewidth=3, foreground='k')])
# txt = ax.text(55, 137, r'\textbf{\textit{Amundsen Sea}}', horizontalalignment='center',
#               verticalalignment='center', color='lightgrey', fontsize=12)
# txt.set_path_effects([PathEffects.withStroke(linewidth=3, foreground='k')])
# txt = ax.text(38, 200, r'\textbf{\textit{Bellinghausen Sea}}', horizontalalignment='center',
#               verticalalignment='center', color='lightgrey', fontsize=12)
# txt.set_path_effects([PathEffects.withStroke(linewidth=3, foreground='k')])

# # Legend
# custom_lines = [mpl.lines.Line2D([0], [0], color='k', ls='None', marker='^', markersize=2),
#                 mpl.lines.Line2D([0], [0], color='k',
#                                  ls='None', marker='^', markersize=2),
#                 mpl.lines.Line2D([0], [0], color='k', ls='None', marker='^', markersize=2)]
# leg = ax.legend(custom_lines, [r'EAIS, \textit{East Antarctic Ice Sheet}', r'WAIS, \textit{West Antarctic Ice Sheet}',
#                                r'APIS, \textit{Antarctic Peninsula Ice Sheet}'], loc='lower left', markerscale=0.1, title=r'\textbf{Map legend:}', fontsize=12)
# leg._legend_box.align = 'left'
# leg.get_title().set_fontsize('14')

# plt.show()
plt.savefig(locplot + plot_name + '.' + plot_format, format=plot_format)
