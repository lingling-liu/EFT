"""
https://www.earthdatascience.org/courses/use-data-open-source-python/intro-raster-data-python/raster-data-processing/classify-plot-raster-data-in-python/
https://www.kaggle.com/gauravduttakiit/satellite-imagery-analysis-using-python
"""

import os
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap, BoundaryNorm
import numpy as np
import xarray as xr
import rioxarray as rxr
import earthpy as et
#mport earthpy.plot as ep


# Prettier plotting with seaborn
import seaborn as sns
sns.set(font_scale=1.5, style="whitegrid")

# get data
#lidar_dem_path = r'C:\Costa_Rica\EFT\Landsat7\EFAs_2001-2017\EFT_Landsat7_EVI_2001_2017.tif'
#title1="EFT_Landsat7_EVI_2001_2017_CR_1st"

#lidar_dem_path = r'C:\Costa_Rica\EFT\MODIS\EFT_MODIS_EVI_2001_2017.tif'
#title1="EFT_MODIS_EVI_2001_2017_CR_1st"

#lidar_dem_path = r'C:\Costa_Rica\EFT\Landsat7\EFAs_2001-2017\EFT_Landsat7_EVI_2001_2017_NP1.tif'
#title1="EFT_Landsat7_EVI_2001_2017_NP_1st"

lidar_dem_path = r'C:\Costa_Rica\EFT\Landsat7\EFAs_2001-2017\EFT_Landsat7_EVI_2001_2017_NP_CR.tif'
title1="EFT_Landsat7_EVI_2001_2017_clipped_CR_1st"

#lidar_dem_path = r'C:\Costa_Rica\EFT\Landsat7\EFAs_2001-2017\EFT_Landsat7_EVI_2001_2017_NP_CR.tif'
#title1="EFT_Landsat7_EVI_2001_2017_NP_clipped_CR"



print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))

print(pre_lidar_chm1.shape)
#print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
#https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
print('CHM min value:', np.nanmin(pre_lidar_chm))
print('CHM max value:', np.nanmax(pre_lidar_chm))

class_bins = list(range(1,47,9))
print(class_bins)


pre_lidar_chm_class = xr.apply_ufunc(np.digitize,
                                     pre_lidar_chm,
                                     class_bins)

print('CHM min value:', np.nanmin(pre_lidar_chm_class))
print('CHM max value:', np.nanmax(pre_lidar_chm_class))

# Mask out values not equalt to 5
pre_lidar_chm_class_ma = pre_lidar_chm_class.where(pre_lidar_chm_class != 6)


# Create a colormap from a list of colors
colors = ['blue', 'purple', 'darkgreen', 'orange', 'red']
class_bins = [1, 2, 3, 4, 5,6]

cmap = ListedColormap(colors)
norm = BoundaryNorm(class_bins,
                    len(colors))

# Plot newly classified and masked raster
f, ax = plt.subplots(figsize=(5, 5))

im = pre_lidar_chm_class_ma.plot.imshow(cmap=cmap,
                                        norm=norm,
                                        )
# Add legend using earthpy
#ep.draw_legend(im,
#               titles=height_class_labels)

ax.set(title=title1)
ax.set_axis_off()
#plt.show()
plt.savefig(title1+".png")


