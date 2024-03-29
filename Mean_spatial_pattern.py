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


lidar_dem_path = r'C:\EFT\MODIS_mean_2001_2017.tif'
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
#print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
#https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)/10000
#class_bins = list(range(1, 10000, 1000))
# print(class_bins)

# pre_lidar_chm_class = xr.apply_ufunc(np.digitize,
#                                      pre_lidar_chm,
#                                      class_bins)
# print(np.unique(pre_lidar_chm_class))

# print('CHM min value:', np.nanmin(pre_lidar_chm_class))
# print('CHM max value:', np.nanmax(pre_lidar_chm_class))

# # Mask out values not equalt to 5
# pre_lidar_chm_class_ma = pre_lidar_chm_class.where(pre_lidar_chm_class != 10)

pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm > 0)
print("test")
print(type(pre_lidar_chm_class_ma))

plt.subplots(figsize=(15,4))

plt.subplot(1, 3, 1)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
im = pre_lidar_chm_class_ma.plot.imshow(vmin=0, vmax=0.8)
#im = pre_lidar_chm.plot.imshow()
#plt.colorbar(im,ticks=class_bins)
plt.title('MODIS_mean_2001_2017')
plt.axis('off')


lidar_dem_path = r'C:\EFT\Landsat7_mean_2001_2017.tif'
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
#print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
#https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm > 0)


plt.subplot(1, 3, 2)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
pre_lidar_chm_class_ma.plot.imshow(vmin=0, vmax=0.8)
plt.title('Landsat7_mean_2001_2017')
plt.axis('off')

lidar_dem_path = r'C:\EFT\Landsat7_mean_2001_2017_NP.tif'
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
#print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
#https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm > 0)


plt.subplot(1, 3, 3)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
pre_lidar_chm_class_ma.plot.imshow(vmin=0, vmax=0.8)
plt.title('Landsat7_mean_2001_2017_NP')
plt.axis('off')


#plt.show()
plt.savefig("Mean_spatial_patterns.png")
