
# Import necessary packages
import os
import matplotlib.pyplot as plt
#import seaborn as sns
import numpy as np
import rioxarray as rxr
from rasterio.plot import show_hist
#import earthpy as et

# # Open data mean
# lidar_dem_path = r'C:\Costa_Rica\NicoyaPeninsula\Landsat8_mean_NP.tif'
# lidar_dem_im = rxr.open_rasterio(lidar_dem_path, masked=True)

# # Plot a histogram
# f, ax = plt.subplots(figsize=(10, 6))
# lidar_dem_im.plot.hist(ax=ax,
#                        facecolor="purple",
#                        bins=30)
# ax.set(title="EVI mean in NicoyaPeninsula",
#        xlabel='EVI',
#        ylabel='Frequency')
# ax.set_xlim([0,1])
# plt.show()


# # Open data MMax
#lidar_dem_path = r'C:\Costa_Rica\NicoyaPeninsula\Landsat8_MMax_NP.tif'
#lidar_dem_path = r'C:\Costa_Rica\NicoyaPeninsula\Landsat8_MMin_8times.tif'
#lidar_dem_path = r'C:\Costa_Rica\EFT\Landsat7\Landsat7_MMax.tif'
#lidar_dem_path = r'C:\Costa_Rica\EFT\Landsat7\NP\Landsat7_MMax_NP.tif'\
#lidar_dem_path = r'C:\Costa_Rica\EFT\MODIS\MODIS_MMin_2000_2020.tif'
#lidar_dem_path = r'C:\Costa_Rica\EFT\MODIS\MODIS_GreenTime_2000_2020.tif'

#lidar_dem_path = r'C:\Costa_Rica\EFT\MODIS\MODIS_mean_2000_2020.tif'
#lidar_dem_path = r'C:\Costa_Rica\EFT\Landsat7\EFAs_2001-2017\Landsat7_mean_2001_2017_NP.tif'
#lidar_dem_path = r'C:\Costa_Rica\EFT\Landsat7\EFAs_2001-2017\Landsat7_SD_2001_2017_NP.tif'
lidar_dem_path = r'C:\Costa_Rica\EFT\Landsat7\EFAs_2001-2017\Landsat7_Min_VI_2001_2017_NP.tif'
#lidar_dem_path = r'C:\Costa_Rica\EFT\MODIS\MODIS_mean_2001_2017.tif'
print(lidar_dem_path)
lidar_dem_im = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(lidar_dem_im))
lidar_dem_im_test = np.array(lidar_dem_im)
print(type(lidar_dem_im_test))
max1 = np.nanmax(lidar_dem_im_test)
min1 = np.nanmin(lidar_dem_im_test)
print(max1,min1)
#lidar_dem_im_new = np.delete(lidar_dem_im, np.where(lidar_dem_im == 32767))
lidar_dem_im_new = np.where(lidar_dem_im <= 0, np.nan, lidar_dem_im)
print(type(lidar_dem_im_new))
max2 = np.nanmax(lidar_dem_im_new)
min2 = np.nanmin(lidar_dem_im_new)
print(max2,min2)

mean = np.nanmean(lidar_dem_im_new)
std = np.nanstd(lidar_dem_im_new)
print("mean11","std")
print(mean,std)
#print("{:.2f}".format(mean-1.5*std),"{:.2f}".format(mean-0.5*std),"{:.2f}".format(mean+0.5*std),"{:.2f}".format(mean+1.5*std))
#print("{:.3f}".format(mean-1.5*std),"{:.3f}".format(mean-0.5*std),"{:.3f}".format(mean+0.5*std),"{:.3f}".format(mean+1.5*std))
print("{:.2f}".format(mean-std),"{:.2f}".format(mean+std))

# Plot a histogram
#plt.hist(lidar_dem_im_new, bins =  [0,20,40,60,80,365])
#Looks like your lidar_dem_im_new must have 3 or more dimentions, but it’s only allowed to have <= 2.  This should work:
#plt.hist(lidar_dem_im_test.flatten(), bins = [0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300,320,340,365])
# f, ax = plt.subplots(figsize=(10, 6))
# lidar_dem_im_new.plot.hist(ax=ax,
#                        facecolor="purple",
#                        bins=30)
# ax.set(title="MMax in NicoyaPeninsula",
#        xlabel='Date of annual Maximum',
#        ylabel='Frequency')
# ax.set_xlim([1,365])
#plt.show()

# Open data mean
# lidar_dem_path = r'C:\Costa_Rica\NicoyaPeninsula\Landsat8_SD_NP.tif'
# lidar_dem_im = rxr.open_rasterio(lidar_dem_path, masked=True)

# # Plot a histogram
# f, ax = plt.subplots(figsize=(10, 6))
# lidar_dem_im.plot.hist(ax=ax,
#                        facecolor="purple",
#                        bins=30)
# ax.set(title="EVI SD in NicoyaPeninsula",
#        xlabel='EVI',
#        ylabel='Frequency')
# ax.set_xlim([0,0.3])
# plt.show()

# Send to slack to ask
# import os
# import matplotlib.pyplot as plt
# import numpy as np
# import rioxarray as rxr
# from rasterio.plot import show_hist
# # # Open data MMax
# lidar_dem_path = r'C:\Costa_Rica\NicoyaPeninsula\Landsat8_MMax_NP.tif'
# lidar_dem_im = rxr.open_rasterio(lidar_dem_path, masked=True)
# lidar_dem_im_new = np.where(lidar_dem_im == 0, np.nan, lidar_dem_im)

# # Plot a histogram
# plt.hist(lidar_dem_im_new.flatten(), bins = [0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300,320,340,365])
# plt.show()
