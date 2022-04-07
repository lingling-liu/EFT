"""
https://www.earthdatascience.org/courses/use-data-open-source-python/intro-raster-data-python/raster-data-processing/classify-plot-raster-data-in-python/
https://www.kaggle.com/gauravduttakiit/satellite-imagery-analysis-using-python
"""

import os
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap, BoundaryNorm
import numpy as np
import xarray as xr
import rioxarray as rxr
import earthpy as et
#import earthpy.plot as ep


# Prettier plotting with seaborn
import seaborn as sns
sns.set(font_scale=1.5, style="whitegrid")


lidar_dem_path = r"C:\EFT\EFD\EFD_MODIS_EVI_2001_2017_2_2_window_size_5.tif"
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
#print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
#https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm !=255)
print('CHM min value:', np.nanmin(pre_lidar_chm_class_ma))
print('CHM max value:', np.nanmax(pre_lidar_chm_class_ma))
#class_bins = list(range(1, 9, 2))
#class_bins = np.linspace(1,9,3)
#print(class_bins)
plt.subplots(figsize=(20,4))

plt.subplot(1, 4, 1)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
im = pre_lidar_chm_class_ma.plot.imshow(vmin=1, vmax=6)
#im = pre_lidar_chm.plot.imshow()
#plt.colorbar(im,ticks=class_bins)
plt.title('EFD_MODIS_b2_w5')
plt.axis('off')


lidar_dem_path = r"C:\EFT\EFD\EFD_Landsat7_EVI_2001_2017_2_2_window_size_5.tif"
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
#print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
#https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm !=255)
print('CHM min value:', np.nanmin(pre_lidar_chm_class_ma))
print('CHM max value:', np.nanmax(pre_lidar_chm_class_ma))

plt.subplot(1, 4, 2)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
pre_lidar_chm_class_ma.plot.imshow(vmin=1, vmax=6)
plt.title('EFD_Landsat_b2_w5')
plt.axis('off')

lidar_dem_path = r"C:\EFT\EFD\clip\EFD_Landsat7_EVI_2001_2017_2_2_window_size_5_clp.tif"
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
#print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
#https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm !=255)
print('CHM min value:', np.nanmin(pre_lidar_chm_class_ma))
print('CHM max value:', np.nanmax(pre_lidar_chm_class_ma))

plt.subplot(1, 4, 3)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
pre_lidar_chm_class_ma.plot.imshow(vmin=1, vmax=6)
plt.title('EFD_Landsat_b2_w5_NP_clip')
plt.axis('off')


lidar_dem_path = r"C:\EFT\EFD\EFD_Landsat7_EVI_2001_2017_NP_2_2_window_size_5.tif"
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
#print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
#https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm !=255)
print('CHM min value:', np.nanmin(pre_lidar_chm_class_ma))
print('CHM max value:', np.nanmax(pre_lidar_chm_class_ma))

plt.subplot(1, 4, 4)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
pre_lidar_chm_class_ma.plot.imshow(vmin=1, vmax=6)
plt.title('EFD_Landsat_b2_w5_NP_local')
plt.axis('off')


#plt.show()
plt.savefig("C:\EFT\Fig\EFD_b2_w5.png")
