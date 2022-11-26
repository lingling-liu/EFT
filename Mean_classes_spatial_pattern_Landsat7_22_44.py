"""
https://www.earthdatascience.org/courses/use-data-open-source-python/intro-raster-data-python/raster-data-processing/classify-plot-raster-data-in-python/
https://www.kaggle.com/gauravduttakiit/satellite-imagery-analysis-using-python
"""

import numpy as np
from osgeo import gdal, gdal_array
import os
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap, BoundaryNorm
import numpy as np
import xarray as xr
import rioxarray as rxr
import earthpy as et
#import earthpy.plot as ep

# open the dataset and retrieve raster data as an array
lidar_dem_path = r"C:\EFT\EFAs\CR\Landsat7_mean_2001_2017.tif"
print(lidar_dem_path)
dataset = gdal.Open(lidar_dem_path)
print(dataset)
array = dataset.ReadAsArray()
dataset_ma = array[np.where(array > 0)]
print(np.min(dataset_ma))
print(type(np.max(dataset_ma)))


# create an array of zeros the same shape as the input array
output = np.zeros_like(array).astype(np.uint8)

#********************************* 2 classes******************************
# use the numpy percentile function to calculate percentile thresholds
percentile_50 = np.percentile(dataset_ma, 50)
percentile_0 = np.percentile(dataset_ma, 0)
print(percentile_0,percentile_50)

output = np.where((array > percentile_0), 1, output)
output = np.where((array > percentile_50), 2, output)

outname = r'C:\EFT\EFAs\CR\reclasses\Landsat7_mean_2001_2017_2classes.tif'
gdal_array.SaveArray(output, outname, "gtiff", prototype=dataset)


# lidar_dem_path = outname
# print(lidar_dem_path)
# pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
# print(type(pre_lidar_chm1))
# print(pre_lidar_chm1.shape)
# pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
# print(type(pre_lidar_chm))

# pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm > 0)

# # Plot data using nicer colors
# colors = ['blue', 'yellow']
# class_bins = [1, 2, 3]
# cmap = ListedColormap(colors)
# norm = BoundaryNorm(class_bins, 
#                     len(colors))


# plt.subplots(figsize=(10,4))

# plt.subplot(1, 2, 1)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
# im = pre_lidar_chm_class_ma.plot.imshow(cmap=cmap,norm=norm)
# plt.title('Landsat7_SD_2classes')
# plt.axis('off')


#********************************* 4 classes******************************
# use the numpy percentile function to calculate percentile thresholds
percentile_75 = np.percentile(dataset_ma, 75)
percentile_50 = np.percentile(dataset_ma, 50)
percentile_25 = np.percentile(dataset_ma, 25)
percentile_0 = np.percentile(dataset_ma, 0)
print(percentile_0,percentile_25,percentile_50,percentile_75)

output = np.where((array > percentile_0), 1, output)
output = np.where((array > percentile_25), 2, output)
output = np.where((array > percentile_50), 3, output)
output = np.where((array > percentile_75), 4, output)

outname = r'C:\EFT\EFAs\CR\reclasses\Landsat7_mean_2001_2017_4classes.tif'
gdal_array.SaveArray(output, outname, "gtiff", prototype=dataset)


# lidar_dem_path = outname
# print(lidar_dem_path)
# pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
# print(type(pre_lidar_chm1))
# print(pre_lidar_chm1.shape)
# pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
# print(type(pre_lidar_chm))

# pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm > 0)

# # Plot data using nicer colors
# colors = ['blue', 'yellow', 'green', 'orange']
# class_bins = [1, 2, 3, 4, 5]
# cmap = ListedColormap(colors)
# norm = BoundaryNorm(class_bins, 
#                     len(colors))


# plt.subplot(1, 2, 2)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
# im = pre_lidar_chm_class_ma.plot.imshow(cmap=cmap,norm=norm)
# plt.title('Landsat7_SD_4classes')
# plt.axis('off')

# #plt.show()
# plt.savefig(r"C:\EFT\Landsat7_SD_spatial_patterns_22_44.png")
