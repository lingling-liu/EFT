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

# open national dataset and retrieve raster data as an array
lidar_dem_path = r"C:\EFT\EFD\EFD_Landsat_NP_clipped_b4_win7_6classes.tif"
print(lidar_dem_path)
dataset = gdal.Open(lidar_dem_path)
print(dataset)
EFD_National = dataset.ReadAsArray()

# open local dataset and retrieve raster data as an array 
lidar_dem_path = r"C:\EFT\EFD\EFD_Landsat_NP_b4_win7_6classes.tif"
print(lidar_dem_path)
dataset = gdal.Open(lidar_dem_path)
print(dataset)
EFD_Local = dataset.ReadAsArray()

index = np.where((EFD_National > 0) & (EFD_Local> 0))
EFD_National_01 = EFD_National[index]
EFD_Local_01 = EFD_Local[index]
count_all = np.count_nonzero(EFD_Local_01)

result = np.zeros((6, 6))

import csv
output = "C:\EFT\EFD\EFD_b4_w7_correspondence_table_NP_based_national_scale_percentages.csv"

for x in range(6):
    index = np.where(EFD_National_01 == x+1)
    EFD_Local_x = EFD_Local_01[index]
    for y in range(6):
        print(x,y)
        index_xy = np.where(EFD_Local_x == y+1)
        EFD_Local_xy = EFD_Local_x[index_xy]
        temp = (np.count_nonzero(EFD_Local_xy))/count_all
        result[x,y] = temp

np.savetxt(output,result, delimiter=",")
 








