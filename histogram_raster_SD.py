
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

lidar_dem_path = r'C:\Costa_Rica\EFT\MODIS\MODIS_Mmax_2001_2017.tif'
lidar_dem_im = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(lidar_dem_im))
lidar_dem_im_test = np.array(lidar_dem_im)
print(type(lidar_dem_im_test))
max1 = np.nanmax(lidar_dem_im_test)
min1 = np.nanmin(lidar_dem_im_test)
print(max1,min1)
#lidar_dem_im_new = np.delete(lidar_dem_im, np.where(lidar_dem_im == 32767))
lidar_dem_im_new = np.where(lidar_dem_im <= 0, np.nan, lidar_dem_im)



# print(type(lidar_dem_im_new))
# max2 = np.nanmax(lidar_dem_im_new)
# min2 = np.nanmin(lidar_dem_im_new)
# print(max2,min2)

# mean = np.nanmean(lidar_dem_im_new)
# std = np.nanstd(lidar_dem_im_new)

# print(mean,std)
# print(mean-1.5*std,mean-0.5*std,mean+0.5*std,mean+1.5*std)

# Plot a histogram
#plt.hist(lidar_dem_im_new, bins =  [0,20,40,60,80,365])
#Looks like your lidar_dem_im_new must have 3 or more dimentions, but it’s only allowed to have <= 2.  This should work:
#Date
#plt.hist(lidar_dem_im_new.flatten(), bins = [0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300,320,340,365])
#mean
#plt.hist(lidar_dem_im_test.flatten(), bins = [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1])
#SD
#plt.hist(lidar_dem_im_test.flatten(), bins = [0,0.025,0.05,0.075,0.1,0.125,0.15,0.175,0.2])
# f, ax = plt.subplots(figsize=(10, 6))
# lidar_dem_im_new.plot.hist(ax=ax,
#                        facecolor="purple",
#                        bins=30)
# ax.set(title="MMax in NicoyaPeninsula",
#        xlabel='Date of annual Maximum',
#        ylabel='Frequency')
# ax.set_xlim([1,365])
# title = 'MODIS_MMax_2001_2017'
# plt.title(title)
# plt.show()
# https://www.geeksforgeeks.org/place-plots-side-by-side-in-matplotlib/

plt.figure(figsize=(15,4)) #change your figure size as per your desire here
plt.subplot(1, 3, 1)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
plt.hist(lidar_dem_im_new.flatten(), bins = [0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300,320,340,365],density = True)
plt.title('FIRST PLOT')
plt.xlim([0, 370])
plt.xticks(np.arange(0, 370, 50))
# plt.xlabel('x-axis')
# plt.ylabel('y-axis')

plt.subplot(1, 3, 2)  # 1 line, 2 rows, index nr 2 (second position in the subplot)
plt.hist(lidar_dem_im_new.flatten(), bins = [0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300,320,340,365],density = True)
plt.title('FIRST PLOT')


plt.subplot(1, 3, 3)  # 1 line, 2 rows, index nr 2 (second position in the subplot)
plt.hist(lidar_dem_im_new.flatten(), bins = [0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300,320,340,365],density = True)
plt.title('FIRST PLOT')

# space between the plots
plt.tight_layout(3)

plt.show()


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
