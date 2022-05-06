# from os import listdir
# from os.path import isfile, join

# mypath = "C:\EFT\EFD\percentiles"
# onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]
# print(onlyfiles)

# import glob

# EFDfiles =  glob.glob("C:/EFT/EFD/*window_size*.tif")
# print(EFDfiles)

# import required module
import os
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap, BoundaryNorm
import numpy as np
import xarray as xr
import rioxarray as rxr
import earthpy as et
import numpy
from pathlib import Path
# assign directory
#directory = "D:\My Drive\EFT\EFD\percentiles\EFD_test"
#directory = "D:\My Drive\EFT\EFD\percentiles"
directory = "C:\EFT\EFD\percentiles\EFD_gee"

path1 = "C:/EFT/EFD/EFD_gee_percentages_pixels_above_75_quantiles.txt"
f_txt = open(path1,'w')
 
# iterate over files in
# that directory
for filename in os.listdir(directory):
    f = os.path.join(directory, filename)
    # checking if it is a file
    if os.path.isfile(f):
        print(f)
        lidar_dem_path = f
        pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
        print(type(pre_lidar_chm1))
        print(pre_lidar_chm1.shape)
        #print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
        #https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
        pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
        print(type(pre_lidar_chm))
        pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm !=255)
        print('CHM min value:', np.nanmin(pre_lidar_chm_class_ma))
        print('CHM max value:', np.nanmax(pre_lidar_chm_class_ma))
        #https://carpentries-incubator.github.io/geospatial-python/05-raster-structure/
        da = pre_lidar_chm_class_ma
        da_per= da.quantile([0.75])
        print(type(da_per.values))
        print(da_per.values[0])
 
        #https://carpentries-incubator.github.io/geospatial-python/07-raster-calculations/index.html
        # Defines the bins for pixel values
        class_bins = [da_per.values[0]+0.00001,pre_lidar_chm_class_ma.max().values+0.000001]# does not include da_per.values[0]+0.00001, uppper 
        EFD_classified = xr.apply_ufunc(
                np.digitize,  # func to run across the input array
                pre_lidar_chm_class_ma,  # func arg 1 (the array that needs to be classified)
                class_bins    # func arg 2 (the classification bins)
        )
        print(type(EFD_classified))
        print(EFD_classified.shape)
        print(pre_lidar_chm1.shape)

        count0 = (EFD_classified ==0).sum()
        count1 = (EFD_classified ==1).sum()
        print(count0, count1)
        percentages = count0/(count0+count1)
        print(percentages.values)

        
        EFD_classified.rio.write_crs(pre_lidar_chm1.rio.crs, inplace=True)
        EFD_classified.rio.set_nodata(255, inplace=True)
        print('CHM min value:', np.nanmin(EFD_classified))
        print('CHM max value:', np.nanmax(EFD_classified))
        #https://stackoverflow.com/questions/678236/how-do-i-get-the-filename-without-the-extension-from-a-path-in-python
        filename = Path(f).stem
        print(filename)
        #concatenate strings
        #f_txt.write("C:/EFT/EFD/percentiles/output/"+ filename+"_reclass.tif")
        f_txt.write("C:/EFT/EFD/percentiles/EFD_gee/output/"+ filename+"_reclass.tif")   
        f_txt.write('\n')
        f_txt.write(str(percentages.values))
        f_txt.write('\n')
        #print("C:/EFT/EFD/percentiles/output/"+ filename+"_reclass.tif")
        #EFD_classified.rio.to_raster("C:/EFT/EFD/percentiles/output/"+ filename+"_reclass.tif",dtype=np.int32)
f_txt.close()
        



