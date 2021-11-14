
# Import necessary packages
import os
import matplotlib.pyplot as plt
#import seaborn as sns
import numpy as np
import rioxarray as rxr
from rasterio.plot import show_hist
#import earthpy as et


lidar_dem_path = r'C:\Costa_Rica\EFT\MODIS\MODIS_mean_2001_2017.tif'
lidar_dem_im = rxr.open_rasterio(lidar_dem_path, masked=True)
lidar_dem_im1 = np.where(lidar_dem_im <= 0, np.nan, lidar_dem_im)
lidar_dem_im2 = np.rint(lidar_dem_im1)

# max1 = np.nanmax(lidar_dem_im2)
# min1 = np.nanmin(lidar_dem_im2)
# print(type(lidar_dem_im2))
# print(max1,min1)
# lidar_dem_im = lidar_dem_im1.astype(int)
# print(type(lidar_dem_im))
# lidar_dem_im_test = np.array(lidar_dem_im)
# print(type(lidar_dem_im_test))
# max1 = np.nanmax(lidar_dem_im_test)
# min1 = np.nanmin(lidar_dem_im_test)
# print(max1,min1)
# #lidar_dem_im_new = np.delete(lidar_dem_im, np.where(lidar_dem_im == 32767))

# lidar_dem_im_MODIS1 = lidar_dem_im_MODIS.flatten()
# print(lidar_dem_im_MODIS1.shape)
# lidar_dem_im_MODIS2 = int(lidar_dem_im_MODIS1*10000)



lidar_dem_path = r'C:\Costa_Rica\EFT\Landsat7\EFAs_2001-2017\Landsat7_mean_2001_2017.tif'
lidar_dem_im = rxr.open_rasterio(lidar_dem_path, masked=True)
lidar_dem_im1 = np.where(lidar_dem_im <= 0, np.nan, lidar_dem_im)
lidar_dem_im3 = np.rint(lidar_dem_im1)

# print(type(lidar_dem_im))
# lidar_dem_im_test = np.array(lidar_dem_im)
# print(type(lidar_dem_im_test))
# max1 = np.nanmax(lidar_dem_im_test)
# min1 = np.nanmin(lidar_dem_im_test)
# print(max1,min1)
# #lidar_dem_im_new = np.delete(lidar_dem_im, np.where(lidar_dem_im == 32767))
# lidar_dem_im_Landsat7 = np.where(lidar_dem_im <= 0, np.nan, lidar_dem_im)


# lidar_dem_path = r'C:\Costa_Rica\EFT\Landsat7\EFAs_2001-2017\Landsat7_mean_2001_2017_NP.tif'
# lidar_dem_im = int(rxr.open_rasterio(lidar_dem_path, masked=True))
# print(type(lidar_dem_im))
# lidar_dem_im_test = np.array(lidar_dem_im)
# print(type(lidar_dem_im_test))
# max1 = np.nanmax(lidar_dem_im_test)
# min1 = np.nanmin(lidar_dem_im_test)
# print(max1,min1)
# #lidar_dem_im_new = np.delete(lidar_dem_im, np.where(lidar_dem_im == 32767))
# lidar_dem_im_Landsat7_NP = np.where(lidar_dem_im <= 0, np.nan, lidar_dem_im)
# # # https://www.geeksforgeeks.org/place-plots-side-by-side-in-matplotlib/

# bins = range(0,10000,1000)

# plt.figure(figsize=(15,4)) #change your figure size as per your desire here
# plt.subplot(1, 3, 1)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
# plt.hist(lidar_dem_im_MODIS.flatten(), bins = bins,density = True)
# plt.title('FIRST PLOT')
# plt.xlim([0, 1])
# plt.xticks(np.arange(0,1, 0.2))
# # plt.xlabel('x-axis')
# # plt.ylabel('y-axis')

# plt.subplot(1, 3, 2)  # 1 line, 2 rows, index nr 2 (second position in the subplot)
# plt.hist(lidar_dem_im_Landsat7.flatten(), bins = bins,density = True)
# plt.title('FIRST PLOT')


# plt.subplot(1, 3, 3)  # 1 line, 2 rows, index nr 2 (second position in the subplot)
# plt.hist(lidar_dem_im_Landsat7_NP.flatten(), bins = bins,density = True)
# plt.title('FIRST PLOT')

# # space between the plots
# plt.tight_layout(3)

# plt.show()
