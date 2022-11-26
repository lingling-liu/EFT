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

# create an array of zeros the same shape as the input array
mean_out = np.zeros_like(array).astype(np.int32)
# use the numpy percentile function to calculate percentile thresholds
percentile_75 = np.percentile(dataset_ma, 75)
percentile_50 = np.percentile(dataset_ma, 50)
percentile_25 = np.percentile(dataset_ma, 25)
percentile_0 = np.percentile(dataset_ma, 0)
print("Mean")
print(percentile_0,percentile_25,percentile_50,percentile_75)

mean_out = np.where((array > percentile_0), 1, mean_out)
mean_out = np.where((array > percentile_25), 2, mean_out)
mean_out = np.where((array > percentile_50), 3, mean_out)
mean_out = np.where((array > percentile_75), 4, mean_out)
print(np.min(mean_out))
print(np.max(mean_out))

outname = r"C:\EFT\EFAs\NP\four_classes\Landsat7_mean_2001_2017_NP_4classes.tif"
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
# use the numpy percentile function to calculate percentile thresholds
percentile_75 = np.percentile(dataset_ma, 75)
percentile_50 = np.percentile(dataset_ma, 50)
percentile_25 = np.percentile(dataset_ma, 25)
percentile_0 = np.percentile(dataset_ma, 0)
print("SD")
print(percentile_0,percentile_25,percentile_50,percentile_75)

SD_out = np.where((array > percentile_0), 1, SD_out)
SD_out = np.where((array > percentile_25), 2, SD_out)
SD_out = np.where((array > percentile_50), 3, SD_out)
SD_out = np.where((array > percentile_75), 4, SD_out)
print(np.min(SD_out))
print(np.max(SD_out))

outname = r"C:\EFT\EFAs\NP\four_classes\Landsat7_SD_2001_2017_NP_4classes.tif"
gdal_array.SaveArray(SD_out, outname, "gtiff", prototype=dataset)

#*******************************DMAX*************************
# open the dataset and retrieve raster data as an array
lidar_dem_path = r"C:\EFT\EFAs\NP\Landsat7_MMax_2001_2017_NP.tif"
print(lidar_dem_path)
dataset = gdal.Open(lidar_dem_path)
print(dataset)
array = dataset.ReadAsArray()
dataset_ma = array[np.where(array > 0)]
print(np.min(dataset_ma))
print(np.max(dataset_ma))
print(type(np.max(dataset_ma)))

# create an array of zeros the same shape as the input array
DMax_out = np.zeros_like(array).astype(np.int32)

DMax_out = np.where(((array > 25) & (array <= 100)), 1, DMax_out)
DMax_out = np.where(((array > 100) & (array <= 200)), 2, DMax_out)
DMax_out = np.where(((array > 200) & (array <= 300)), 3, DMax_out)
DMax_out = np.where(((array > 300) & (array <= 365)) | ((array >=1) & (array <= 25)), 4, DMax_out)
print(np.min(DMax_out))
print(np.max(DMax_out))

outname = r"C:\EFT\EFAs\NP\four_classes\Landsat7_DMax_2001_2017_NP_4classes.tif"
gdal_array.SaveArray(DMax_out, outname, "gtiff", prototype=dataset)

