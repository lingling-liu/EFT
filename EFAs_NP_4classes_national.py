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

#*******************************MEAN*************************
# open the dataset and retrieve raster data as an array
lidar_dem_path = r"C:\EFT\EFAs\NP\Landsat7_mean_2001_2017_NP.tif"
print(lidar_dem_path)
dataset = gdal.Open(lidar_dem_path)
print(dataset)
array = dataset.ReadAsArray()
dataset_ma = array[np.where(array > 0)]
print(np.min(dataset_ma))
print(np.max(dataset_ma))
print(type(np.max(dataset_ma)))

#get break from National
# Read data from National
lidar_dem_path = r"C:\EFT\EFAs\CR\Landsat7_mean_2001_2017.tif"
print(lidar_dem_path)
dataset = gdal.Open(lidar_dem_path)
print(dataset)
array_national = dataset.ReadAsArray()
dataset_ma_national = array_national[np.where(array_national > 0)]

# use the numpy percentile function to calculate percentile thresholds
percentile_75 = np.percentile(dataset_ma_national, 75)
percentile_50 = np.percentile(dataset_ma_national, 50)
percentile_25 = np.percentile(dataset_ma_national, 25)
percentile_0 = np.percentile(dataset_ma_national, 0)

# create an array of zeros the same shape as the input array
mean_out = np.zeros_like(array).astype(np.int32)

print("Mean")
print(percentile_0,percentile_25,percentile_50,percentile_75)
print('100','200','300','400')

mean_out = np.where((array > percentile_0), 1, mean_out)
mean_out = np.where((array > percentile_25), 2, mean_out)
mean_out = np.where((array > percentile_50), 3, mean_out)
mean_out = np.where((array > percentile_75), 4, mean_out)
print(np.min(mean_out))
print(np.max(mean_out))

outname = r"C:\EFT\EFAs\NP\four_classes\Landsat7_mean_2001_2017_NP_clipped_4classes.tif"
gdal_array.SaveArray(mean_out, outname, "gtiff", prototype=dataset)

#*******************************SD*************************
# open the dataset and retrieve raster data as an array
lidar_dem_path = r"C:\EFT\EFAs\NP\Landsat7_SD_2001_2017_NP.tif"
print(lidar_dem_path)
dataset = gdal.Open(lidar_dem_path)
print(dataset)
array = dataset.ReadAsArray()
dataset_ma = array[np.where(array > 0)]
print(np.min(dataset_ma))
print(np.max(dataset_ma))
print(type(np.max(dataset_ma)))

# create an array of zeros the same shape as the input array
SD_out = np.zeros_like(array).astype(np.int32)

#get break from National
# Read data from National
lidar_dem_path = r"C:\EFT\EFAs\CR\Landsat7_SD_2001_2017.tif"
print(lidar_dem_path)
dataset = gdal.Open(lidar_dem_path)
print(dataset)
array_national = dataset.ReadAsArray()
dataset_ma_national = array_national[np.where(array_national > 0)]

# use the numpy percentile function to calculate percentile thresholds
percentile_75 = np.percentile(dataset_ma_national, 75)
percentile_50 = np.percentile(dataset_ma_national, 50)
percentile_25 = np.percentile(dataset_ma_national, 25)
percentile_0 = np.percentile(dataset_ma_national, 0)
print("SD")
print(percentile_0,percentile_25,percentile_50,percentile_75)
print('10','20','30','40')

SD_out = np.where((array > percentile_0), 1, SD_out)
SD_out = np.where((array > percentile_25), 2, SD_out)



SD_out = np.where((array > percentile_50), 3, SD_out)
SD_out = np.where((array > percentile_75), 4, SD_out)
print(np.min(SD_out))
print(np.max(SD_out))

outname = r"C:\EFT\EFAs\NP\four_classes\Landsat7_SD_2001_2017_NP_clipped_4classes.tif"
gdal_array.SaveArray(SD_out, outname, "gtiff", prototype=dataset)
