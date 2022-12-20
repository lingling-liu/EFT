"""
https://www.earthdatascience.org/courses/use-data-open-source-python/intro-raster-data-python/raster-data-processing/classify-plot-raster-data-in-python/
https://www.kaggle.com/gauravduttakiit/satellite-imagery-analysis-using-python
"""

from asyncore import compact_traceback
import os
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap, BoundaryNorm
import numpy as np
import xarray as xr
import rioxarray as rxr
import earthpy as et
#import earthpy.plot as ep

cdict = {'red': ((0.0, 0.0, 0.0),
                 (0.1, 0.5, 0.5),
                 (0.2, 0.0, 0.0),
                 (0.4, 0.2, 0.2),
                 (0.6, 0.0, 0.0),
                 (0.8, 1.0, 1.0),
                 (1.0, 1.0, 1.0)),
        'green':((0.0, 0.0, 0.0),
                 (0.1, 0.0, 0.0),
                 (0.2, 0.0, 0.0),
                 (0.4, 1.0, 1.0),
                 (0.6, 1.0, 1.0),
                 (0.8, 1.0, 1.0),
                 (1.0, 0.0, 0.0)),
        'blue': ((0.0, 0.0, 0.0),
                 (0.1, 0.5, 0.5),
                 (0.2, 1.0, 1.0),
                 (0.4, 1.0, 1.0),
                 (0.6, 0.0, 0.0),
                 (0.8, 0.0, 0.0),
                 (1.0, 0.0, 0.0))}

my_cmap = matplotlib.colors.LinearSegmentedColormap('my_colormap',cdict,256)

# Prettier plotting with seaborn
import seaborn as sns
sns.set(font_scale=1.5, style="whitegrid")


lidar_dem_path = r"C:\EFT\EFAs\NP\Landsat7_mean_2001_2017_NP.tif"
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
#print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
#https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm >0)
print('CHM min value:', np.nanmin(pre_lidar_chm_class_ma))
print('CHM max value:', np.nanmax(pre_lidar_chm_class_ma))
# mean_min = np.nanmin(pre_lidar_chm_class_ma)
# mean_max = np.nanmax(pre_lidar_chm_class_ma)
plt.subplots(figsize=(15,15))

plt.subplot(3, 3, 1)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
im = pre_lidar_chm_class_ma.plot.imshow(vmin=0.2, vmax=0.7,cmap=my_cmap,legend=None)
# ax = plt.get_axes()
# print(ax)
plt.text(1, 5, '(a)', size=12, ha='center', va='center')
#im = pre_lidar_chm.plot.imshow()
#plt.colorbar(im,ticks=class_bins)
plt.title('Mean_Landsat7')
plt.axis('off')
plt.legend('', frameon=False)


# lidar_dem_path = r"C:\EFT\EFAs\NP\Landsat7_SD_2001_2017_NP.tif"
# print(lidar_dem_path)
# pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
# print(type(pre_lidar_chm1))
# print(pre_lidar_chm1.shape)
# #print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
# #https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
# pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
# pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm !=0)
# print('CHM min value:', np.nanmin(pre_lidar_chm_class_ma))
# print('CHM max value:', np.nanmax(pre_lidar_chm_class_ma))
# # sd_min = np.nanmin(pre_lidar_chm_class_ma)
# # sd_max = np.nanmax(pre_lidar_chm_class_ma)

# plt.subplot(3, 3, 2)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
# pre_lidar_chm_class_ma.plot.imshow(vmin=0.00001, vmax=0.2,cmap = my_cmap)
# plt.title('SD_Landsat7')
# plt.axis('off')

# lidar_dem_path = r"C:\EFT\EFAs\NP\Landsat7_MMax_2001_2017_NP.tif"
# print(lidar_dem_path)
# pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
# print(type(pre_lidar_chm1))
# print(pre_lidar_chm1.shape)
# #print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
# #https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
# pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
# pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm > 0)
# print('CHM min value:', np.nanmin(pre_lidar_chm_class_ma))
# print('CHM max value:', np.nanmax(pre_lidar_chm_class_ma))
# DMax_min = np.nanmin(pre_lidar_chm_class_ma)
# DMax_max = np.nanmax(pre_lidar_chm_class_ma)

# plt.subplot(3, 3, 3)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
# pre_lidar_chm_class_ma.plot.imshow(vmin=DMax_min, vmax=DMax_max,cmap = my_cmap)
# plt.title('DMax_Landsat7')
# plt.axis('off')


# #Local Mean 4 classes*******************************************
# lidar_dem_path = r"C:\EFT\EFAs\NP\four_classes\Landsat7_mean_2001_2017_NP_4classes.tif"
# print(lidar_dem_path)
# pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
# print(type(pre_lidar_chm1))
# print(pre_lidar_chm1.shape)
# pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
# print(type(pre_lidar_chm))

# pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm > 0)

# # Plot data using nicer colors
# colors = ['blue', 'yellow', 'green', 'orange']
# class_bins = [1, 2, 3, 4, 5]
# cmap = ListedColormap(colors)
# norm = BoundaryNorm(class_bins, 
#                     len(colors))


# plt.subplot(3, 3, 4)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
# im = pre_lidar_chm_class_ma.plot.imshow(cmap=cmap,norm=norm)
# plt.title('Mean_Landsat7_4classes_Local')
# plt.axis('off')

# #Local SD 4 classses
# lidar_dem_path = r"C:\EFT\EFAs\NP\four_classes\Landsat7_SD_2001_2017_NP_4classes.tif"
# print(lidar_dem_path)
# pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
# print(type(pre_lidar_chm1))
# print(pre_lidar_chm1.shape)
# pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
# print(type(pre_lidar_chm))

# pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm > 0)

# # Plot data using nicer colors
# colors = ['blue', 'yellow', 'green', 'orange']
# class_bins = [1, 2, 3, 4, 5]
# cmap = ListedColormap(colors)
# norm = BoundaryNorm(class_bins, 
#                     len(colors))


# plt.subplot(3, 3, 5)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
# im = pre_lidar_chm_class_ma.plot.imshow(cmap=cmap,norm=norm)
# plt.title('SD_Landsat7_4classes_Local')
# plt.axis('off')

# #Local Dmax 4 classes
# lidar_dem_path = r"C:\EFT\EFAs\NP\four_classes\Landsat7_DMax_2001_2017_NP_4classes.tif"
# print(lidar_dem_path)
# pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
# print(type(pre_lidar_chm1))
# print(pre_lidar_chm1.shape)
# pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
# print(type(pre_lidar_chm))

# pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm > 0)

# # Plot data using nicer colors
# colors = ['blue', 'yellow', 'green', 'orange']
# class_bins = [1, 2, 3, 4, 5]
# cmap = ListedColormap(colors)
# norm = BoundaryNorm(class_bins, 
#                     len(colors))


# plt.subplot(3, 3, 6)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
# im = pre_lidar_chm_class_ma.plot.imshow(cmap=cmap,norm=norm)
# plt.title('DMax_4classes_Landsat7_Local')
# plt.axis('off')


# # #National mean 4 classes

# lidar_dem_path = r"C:\EFT\EFAs\NP\four_classes\Landsat7_mean_2001_2017_NP_clipped_4classes.tif"
# print(lidar_dem_path)
# pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
# print(type(pre_lidar_chm1))
# print(pre_lidar_chm1.shape)
# pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
# print(type(pre_lidar_chm))

# pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm > 0)

# # Plot data using nicer colors
# colors = ['blue', 'yellow', 'green', 'orange']
# class_bins = [1, 2, 3, 4, 5]
# cmap = ListedColormap(colors)
# norm = BoundaryNorm(class_bins, 
#                     len(colors))


# plt.subplot(3, 3, 7)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
# im = pre_lidar_chm_class_ma.plot.imshow(cmap=cmap,norm=norm)
# plt.title('Mean_Landsat7_4classes_National')
# plt.axis('off')

# # #National SD 4 classes
# lidar_dem_path = r"C:\EFT\EFAs\NP\four_classes\Landsat7_SD_2001_2017_NP_clipped_4classes.tif"
# print(lidar_dem_path)
# pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
# print(type(pre_lidar_chm1))
# print(pre_lidar_chm1.shape)
# pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
# print(type(pre_lidar_chm))

# pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm > 0)

# # Plot data using nicer colors
# colors = ['blue', 'yellow', 'green', 'orange']
# class_bins = [1, 2, 3, 4, 5]
# cmap = ListedColormap(colors)
# norm = BoundaryNorm(class_bins, 
#                     len(colors))


# plt.subplot(3, 3, 8)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
# im = pre_lidar_chm_class_ma.plot.imshow(cmap=cmap,norm=norm)
# plt.title('SD_Landsat7_4classes_National')
# plt.axis('off')

# # #National Dmax 4 classes
# lidar_dem_path = r"C:\EFT\EFAs\NP\four_classes\Landsat7_DMax_2001_2017_NP_4classes.tif"
# print(lidar_dem_path)
# pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
# print(type(pre_lidar_chm1))
# print(pre_lidar_chm1.shape)
# pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
# print(type(pre_lidar_chm))

# pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm > 0)

# # Plot data using nicer colors
# colors = ['blue', 'yellow', 'green', 'orange']
# class_bins = [1, 2, 3, 4, 5]
# cmap = ListedColormap(colors)
# norm = BoundaryNorm(class_bins, 
#                     len(colors))


# plt.subplot(3, 3, 9)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
# im = pre_lidar_chm_class_ma.plot.imshow(cmap=cmap,norm=norm)
# plt.title('DMax_4classes_Landsat7_Local')
# plt.axis('off')

# # #plt.show()
plt.savefig("C:\EFT\Fig\EFAs_Landsat_NP.png")