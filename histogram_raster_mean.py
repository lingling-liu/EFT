#https://stackoverflow.com/questions/61881175/normed-histogram-y-axis-larger-than-1
# Import necessary packages
import os
import matplotlib.pyplot as plt
#import seaborn as sns
import numpy as np
import rioxarray as rxr
from rasterio.plot import show_hist
#import earthpy as et


lidar_dem_path = r'C:\EFT\MODIS_mean_2001_2017.tif'
lidar_dem_im = rxr.open_rasterio(lidar_dem_path, masked=True)
lidar_dem_im1 = np.where(lidar_dem_im <= 0, np.nan, lidar_dem_im)
lidar_dem_MODIS = np.rint(lidar_dem_im1)#/10000.0
max1 = np.nanmax(lidar_dem_MODIS)
min1 = np.nanmin(lidar_dem_MODIS)
print(type(lidar_dem_MODIS))
print(max1,min1)

lidar_dem_path = r'C:\EFT\Landsat7_mean_2001_2017.tif'
lidar_dem_im = rxr.open_rasterio(lidar_dem_path, masked=True)*10000
lidar_dem_im1 = np.where(lidar_dem_im <= 0, np.nan, lidar_dem_im)
lidar_dem_Landsat7 = np.rint(lidar_dem_im1)#/10000.0
max1 = np.nanmax(lidar_dem_Landsat7)
min1 = np.nanmin(lidar_dem_Landsat7)
print(type(lidar_dem_Landsat7))
print(max1,min1)


lidar_dem_path = r'C:\EFT\Landsat7_mean_2001_2017_NP.tif'
lidar_dem_im = rxr.open_rasterio(lidar_dem_path, masked=True)*10000
lidar_dem_im1 = np.where(lidar_dem_im <= 0, np.nan, lidar_dem_im)
lidar_dem_Landsat7_NP = np.rint(lidar_dem_im1)#/10000.0
max1 = np.nanmax(lidar_dem_Landsat7_NP)
min1 = np.nanmin(lidar_dem_Landsat7_NP)
print(type(lidar_dem_Landsat7_NP))
print(max1,min1)


# # # https://www.geeksforgeeks.org/place-plots-side-by-side-in-matplotlib/

#Date
#plt.hist(lidar_dem_im_new.flatten(), bins = [0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300,320,340,365])
#mean
#plt.hist(lidar_dem_im_test.flatten(), bins = [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1])
#SD
#plt.hist(lidar_dem_im_test.flatten(), bins = [0,0.025,0.05,0.075,0.1,0.125,0.15,0.175,0.2])


#bins = np.arange(0,0.9,0.05)
bins = range(0,10000,500)
print(type(bins))
print(bins)

plt.figure(figsize=(15,4)) #change your figure size as per your desire here
plt.subplot(1, 3, 1)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
plt.hist(lidar_dem_MODIS.flatten(), bins = bins,density = True)
plt.title('MODIS_mean_2001_2017',size=16)
plt.xticks(fontsize=14)
plt.yticks(fontsize=14)
# plt.xlim([0, 1])
# plt.xticks(np.arange(0,1,0.2))
# plt.xlabel('x-axis')
# plt.ylabel('y-axis')

plt.subplot(1, 3, 2)  # 1 line, 2 rows, index nr 2 (second position in the subplot)
plt.hist(lidar_dem_Landsat7.flatten(), bins = bins,density = True)
plt.title('Landsat7_mean_2001_2017',size=16)
plt.xticks(fontsize=14)
plt.yticks(fontsize=14)

#get the y-axis range of a plot in Matplotlib in Python
axes = plt.gca()
y_min, y_max = axes.get_ylim()
print(y_min, y_max)


plt.subplot(1, 3, 3)  # 1 line, 2 rows, index nr 2 (second position in the subplot)
plt.hist(lidar_dem_Landsat7_NP.flatten(), bins = bins,density = True)
plt.title('Landsat7_mean_2001_2017_NP',size=16)
plt.xticks(fontsize=14)
plt.yticks(fontsize=14)

# space between the plots
plt.tight_layout(3)

plt.show()
