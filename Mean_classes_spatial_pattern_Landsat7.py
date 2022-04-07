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
lidar_dem_path = r'C:\EFT\Landsat7_mean_2001_2017.tif'
print(lidar_dem_path)
dataset = gdal.Open(lidar_dem_path)
print(dataset)
array = dataset.ReadAsArray()
dataset_ma = array[np.where(array > 0)]
print(np.min(dataset_ma))
print(type(np.max(dataset_ma)))


# create an array of zeros the same shape as the input array
output = np.zeros_like(array).astype(np.uint8)

#********************************* 3 classes******************************
# use the numpy percentile function to calculate percentile thresholds
percentile_67 = np.percentile(dataset_ma, 67)
percentile_33 = np.percentile(dataset_ma, 33)
percentile_0 = np.percentile(dataset_ma, 0)
print(percentile_0,percentile_33,percentile_67)

output = np.where((array > percentile_0), 1, output)
output = np.where((array > percentile_33), 2, output)
output = np.where((array > percentile_67), 3, output)

outname = r'C:\EFT\Landsat7_mean_2001_2017_3classes.tif'
gdal_array.SaveArray(output, outname, "gtiff", prototype=dataset)


lidar_dem_path = outname
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
print(type(pre_lidar_chm))

pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm > 0)

# Plot data using nicer colors
colors = ['blue', 'yellow', 'green']
class_bins = [1, 2, 3, 4]
cmap = ListedColormap(colors)
norm = BoundaryNorm(class_bins, 
                    len(colors))


plt.subplots(figsize=(20,4))

plt.subplot(1, 4, 1)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
im = pre_lidar_chm_class_ma.plot.imshow(cmap=cmap,norm=norm)
plt.title('Landsat7_mean_3classes')
plt.axis('off')


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

outname = r'C:\EFT\Landsat7_mean_2001_2017_4classes.tif'
gdal_array.SaveArray(output, outname, "gtiff", prototype=dataset)


lidar_dem_path = outname
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
print(type(pre_lidar_chm))

pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm > 0)

# Plot data using nicer colors
colors = ['blue', 'yellow', 'green', 'orange']
class_bins = [1, 2, 3, 4, 5]
cmap = ListedColormap(colors)
norm = BoundaryNorm(class_bins, 
                    len(colors))


plt.subplot(1, 4, 2)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
im = pre_lidar_chm_class_ma.plot.imshow(cmap=cmap,norm=norm)
plt.title('Landsat7_mean_4classes')
plt.axis('off')


#********************************* 5 classes******************************
# use the numpy percentile function to calculate percentile thresholds
percentile_80 = np.percentile(dataset_ma, 80)
percentile_60 = np.percentile(dataset_ma, 60)
percentile_40 = np.percentile(dataset_ma, 40)
percentile_20 = np.percentile(dataset_ma, 20)
percentile_0 = np.percentile(dataset_ma, 0)
print(percentile_0,percentile_20,percentile_40,percentile_60,percentile_80)

output = np.where((array > percentile_0), 1, output)
output = np.where((array > percentile_20), 2, output)
output = np.where((array > percentile_40), 3, output)
output = np.where((array > percentile_60), 4, output)
output = np.where((array > percentile_80), 5, output)

outname = r'C:\EFT\Landsat7_mean_2001_2017_5classes.tif'
gdal_array.SaveArray(output, outname, "gtiff", prototype=dataset)


lidar_dem_path = outname
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
print(type(pre_lidar_chm))

pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm > 0)

# Plot data using nicer colors
colors = ['blue', 'yellow', 'green', 'orange', 'red']
class_bins = [1, 2, 3, 4, 5, 6]
cmap = ListedColormap(colors)
norm = BoundaryNorm(class_bins, 
                    len(colors))

plt.subplot(1, 4, 3)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
im = pre_lidar_chm_class_ma.plot.imshow(cmap=cmap,norm=norm)
plt.title('Landsat7_mean_5classes')
plt.axis('off')

#********************************* 6 classes******************************
# use the numpy percentile function to calculate percentile thresholds
percentile_83 = np.percentile(dataset_ma, 83)
percentile_67= np.percentile(dataset_ma, 67)
percentile_50 = np.percentile(dataset_ma, 50)
percentile_33 = np.percentile(dataset_ma, 33)
percentile_17 = np.percentile(dataset_ma, 17)
percentile_0 = np.percentile(dataset_ma, 0)
print(percentile_0,percentile_20,percentile_40,percentile_60,percentile_80)

output = np.where((array > percentile_0), 1, output)
output = np.where((array > percentile_17), 2, output)
output = np.where((array > percentile_33), 3, output)
output = np.where((array > percentile_50), 4, output)
output = np.where((array > percentile_67), 5, output)
output = np.where((array > percentile_83), 6, output)

outname = r'C:\EFT\Landsat7_mean_2001_2017_6classes.tif'
gdal_array.SaveArray(output, outname, "gtiff", prototype=dataset)


lidar_dem_path = outname
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
print(type(pre_lidar_chm))

pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm > 0)

# Plot data using nicer colors
colors = ['blue', 'yellow', 'green', 'orange', 'red','purple']
class_bins = [1, 2, 3, 4, 5, 6,7]
cmap = ListedColormap(colors)
norm = BoundaryNorm(class_bins, 
                    len(colors))

plt.subplot(1, 4, 4)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
im = pre_lidar_chm_class_ma.plot.imshow(cmap=cmap,norm=norm)
plt.title('Landsat7_mean_6classes')
plt.axis('off')

plt.show()
#plt.savefig("Landsat7_mean_spatial_patterns_different_classes.png")
