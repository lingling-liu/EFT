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
lidar_dem_path = r"C:\EFT\EFD\NP\EFD_Landsat_NP_b4_win7.tif"
print(lidar_dem_path)
dataset = gdal.Open(lidar_dem_path)
print(dataset)
array = dataset.ReadAsArray()
dataset_ma = array[np.where(array > 0)]
print(np.min(dataset_ma))
print(type(np.max(dataset_ma)))


# create an array of zeros the same shape as the input array
DMax_out = np.zeros_like(array).astype(np.uint8)

#********************************* 6 classes******************************
# create an array of zeros the same shape as the input array
DMax_out = np.zeros_like(array).astype(np.int32)

DMax_out = np.where(((array >=1) & (array <= 3)), 1, DMax_out)
DMax_out = np.where(((array >=4) & (array <= 6)), 2, DMax_out)
DMax_out = np.where(((array >= 7) & (array <= 9)), 3, DMax_out)
DMax_out = np.where(((array >= 10) & (array <= 12)), 4, DMax_out)
DMax_out = np.where(((array >= 13) & (array <= 15)), 5, DMax_out)
DMax_out = np.where((array >15), 6, DMax_out)
print(np.min(DMax_out))
print(np.max(DMax_out))

outname = r"C:\EFT\EFD\EFD_Landsat_NP_b4_win7_6classes.tif"
gdal_array.SaveArray(DMax_out, outname, "gtiff", prototype=dataset)



# open the dataset and retrieve raster data as an array
lidar_dem_path = r"C:\EFT\EFD\clip\EFD_Landsat_NP_clipped_b4_win7.tif"
print(lidar_dem_path)
dataset = gdal.Open(lidar_dem_path)
print(dataset)
array = dataset.ReadAsArray()
dataset_ma = array[np.where(array > 0)]
print(np.min(dataset_ma))
print(type(np.max(dataset_ma)))


# create an array of zeros the same shape as the input array
DMax_out = np.zeros_like(array).astype(np.uint8)

#********************************* 6 classes******************************
# create an array of zeros the same shape as the input array
DMax_out = np.zeros_like(array).astype(np.int32)

DMax_out = np.where(((array >=1) & (array <= 3)), 1, DMax_out)
DMax_out = np.where(((array >=4) & (array <= 6)), 2, DMax_out)
DMax_out = np.where(((array >= 7) & (array <= 9)), 3, DMax_out)
DMax_out = np.where(((array >= 10) & (array <= 12)), 4, DMax_out)
DMax_out = np.where(((array >= 13) & (array <= 15)), 5, DMax_out)
DMax_out = np.where((array >15), 6, DMax_out)
print(np.min(DMax_out))
print(np.max(DMax_out))

outname = r"C:\EFT\EFD\EFD_Landsat_NP_clipped_b4_win7_6classes.tif"
gdal_array.SaveArray(DMax_out, outname, "gtiff", prototype=dataset)