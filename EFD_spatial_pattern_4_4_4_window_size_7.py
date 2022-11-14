"""
https://www.earthdatascience.org/courses/use-data-open-source-python/intro-raster-data-python/raster-data-processing/classify-plot-raster-data-in-python/
https://www.kaggle.com/gauravduttakiit/satellite-imagery-analysis-using-python
"""

from asyncore import compact_traceback
import os
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap, BoundaryNorm
import numpy as np
import xarray as xr
import rioxarray as rxr
import earthpy as et
#import earthpy.plot as ep

cdict = {'red': ((0.0, 0.0, 0.0),
                 (0.1, 0.5, 0.5),
                 (0.2, 0.0, 0.0),
                 (0.4, 0.2, 0.2),
                 (0.6, 0.0, 0.0),
                 (0.8, 1.0, 1.0),
                 (1.0, 1.0, 1.0)),
        'green':((0.0, 0.0, 0.0),
                 (0.1, 0.0, 0.0),
                 (0.2, 0.0, 0.0),
                 (0.4, 1.0, 1.0),
                 (0.6, 1.0, 1.0),
                 (0.8, 1.0, 1.0),
                 (1.0, 0.0, 0.0)),
        'blue': ((0.0, 0.0, 0.0),
                 (0.1, 0.5, 0.5),
                 (0.2, 1.0, 1.0),
                 (0.4, 1.0, 1.0),
                 (0.6, 0.0, 0.0),
                 (0.8, 0.0, 0.0),
                 (1.0, 0.0, 0.0))}

my_cmap = matplotlib.colors.LinearSegmentedColormap('my_colormap',cdict,256)

# Prettier plotting with seaborn
import seaborn as sns
sns.set(font_scale=1.5, style="whitegrid")


lidar_dem_path = r"C:\EFT\EFD\EFD_MODIS_CR_b4_win7.tif"
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
#print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
#https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm !=0)
print('CHM min value:', np.nanmin(pre_lidar_chm_class_ma))
print('CHM max value:', np.nanmax(pre_lidar_chm_class_ma))
#class_bins = list(range(1, 9, 2))
#class_bins = np.linspace(1,9,3)
#print(class_bins)
plt.subplots(figsize=(20,4))

plt.subplot(1, 4, 1)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
im = pre_lidar_chm_class_ma.plot.imshow(vmin=1, vmax=20,cmap=my_cmap)
#im = pre_lidar_chm.plot.imshow()
#plt.colorbar(im,ticks=class_bins)
plt.title('EFD_MODIS_b4_w7')
plt.axis('off')


lidar_dem_path = r"C:\EFT\EFD\EFD_Landsat_CR_b4_win7.tif"
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
#print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
#https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm !=0)
print('CHM min value:', np.nanmin(pre_lidar_chm_class_ma))
print('CHM max value:', np.nanmax(pre_lidar_chm_class_ma))

plt.subplot(1, 4, 2)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
pre_lidar_chm_class_ma.plot.imshow(vmin=1, vmax=20,cmap = 'magma')
plt.title('EFD_Landsat_b4_w7')
plt.axis('off')

lidar_dem_path = r"C:\EFT\EFD\clip\EFD_Landsat_NP_clipped_b4_win7.tif"
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
#print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
#https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm !=0)
print('CHM min value:', np.nanmin(pre_lidar_chm_class_ma))
print('CHM max value:', np.nanmax(pre_lidar_chm_class_ma))

plt.subplot(1, 4, 3)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
pre_lidar_chm_class_ma.plot.imshow(vmin=1, vmax=20,cmap = 'magma')
plt.title('EFD_Landsat_b4_w7_NP_clip')
plt.axis('off')


lidar_dem_path = r"C:\EFT\EFD\EFD_Landsat_NP_b4_win7.tif"
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
#print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
#https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm !=0)
print('CHM min value:', np.nanmin(pre_lidar_chm_class_ma))
print('CHM max value:', np.nanmax(pre_lidar_chm_class_ma))

plt.subplot(1, 4, 4)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
pre_lidar_chm_class_ma.plot.imshow(vmin=1, vmax=20,cmap = 'magma')
plt.title('EFD_Landsat_b4_w7_NP_local')
plt.axis('off')


#plt.show()
plt.savefig("C:\EFT\Fig\EFD_b4_w7.png")
