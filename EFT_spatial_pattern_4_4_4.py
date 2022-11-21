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
#import earthpy.plot as ep


# Prettier plotting with seaborn
import seaborn as sns
sns.set(font_scale=1.5, style="whitegrid")

def rand_cmap(nlabels, type='bright', first_color_black=True, last_color_black=False, verbose=True):
    """
    Creates a random colormap to be used together with matplotlib. Useful for segmentation tasks
    :param nlabels: Number of labels (size of colormap)
    :param type: 'bright' for strong colors, 'soft' for pastel colors
    :param first_color_black: Option to use first color as black, True or False
    :param last_color_black: Option to use last color as black, True or False
    :param verbose: Prints the number of labels and shows the colormap. True or False
    :return: colormap for matplotlib
    """
    from matplotlib.colors import LinearSegmentedColormap
    import colorsys
    import numpy as np


    if type not in ('bright', 'soft'):
        print ('Please choose "bright" or "soft" for type')
        return

    if verbose:
        print('Number of labels: ' + str(nlabels))

    # Generate color map for bright colors, based on hsv
    if type == 'bright':
        randHSVcolors = [(np.random.uniform(low=0.0, high=1),
                          np.random.uniform(low=0.2, high=1),
                          np.random.uniform(low=0.9, high=1)) for i in range(nlabels)]

        # Convert HSV list to RGB
        randRGBcolors = []
        for HSVcolor in randHSVcolors:
            randRGBcolors.append(colorsys.hsv_to_rgb(HSVcolor[0], HSVcolor[1], HSVcolor[2]))

        if first_color_black:
            randRGBcolors[0] = [0, 0, 0]

        if last_color_black:
            randRGBcolors[-1] = [0, 0, 0]

        random_colormap = LinearSegmentedColormap.from_list('new_map', randRGBcolors, N=nlabels)

    # Generate soft pastel colors, by limiting the RGB spectrum
    if type == 'soft':
        low = 0.6
        high = 0.95
        randRGBcolors = [(np.random.uniform(low=low, high=high),
                          np.random.uniform(low=low, high=high),
                          np.random.uniform(low=low, high=high)) for i in range(nlabels)]

        if first_color_black:
            randRGBcolors[0] = [0, 0, 0]

        if last_color_black:
            randRGBcolors[-1] = [0, 0, 0]
        random_colormap = LinearSegmentedColormap.from_list('new_map', randRGBcolors, N=nlabels)

    # Display colorbar
    if verbose:
        from matplotlib import colors, colorbar
        from matplotlib import pyplot as plt
        fig, ax = plt.subplots(1, 1, figsize=(15, 0.5))

        bounds = np.linspace(0, nlabels, nlabels + 1)
        norm = colors.BoundaryNorm(bounds, nlabels)

        cb = colorbar.ColorbarBase(ax, cmap=random_colormap, norm=norm, spacing='proportional', ticks=None,
                                   boundaries=bounds, format='%1i', orientation=u'horizontal')

    return random_colormap

new_cmap = rand_cmap(64, type='bright', first_color_black=False, last_color_black=False, verbose=True)


lidar_dem_path = r"C:\EFT\EFT_MODIS_EVI_2001_2017_4_4.tif"
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
#print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
#https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm !=255)
print('CHM min value:', np.nanmin(pre_lidar_chm_class_ma))
print('CHM max value:', np.nanmax(pre_lidar_chm_class_ma))
#class_bins = list(range(1, 9, 2))
#class_bins = np.linspace(1,9,3)
#print(class_bins)
plt.subplots(figsize=(20,4))

plt.subplot(1, 4, 1)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
im = pre_lidar_chm_class_ma.plot.imshow(vmin=1, vmax=64,cmap=new_cmap)
#im = pre_lidar_chm.plot.imshow()
#plt.colorbar(im,ticks=class_bins)
plt.title('EFT_MODIS_b4')
plt.axis('off')


lidar_dem_path = r"C:\EFT\EFT_Landsat7_EVI_2001_2017_4_4.tif"
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
#print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
#https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm !=255)
print('CHM min value:', np.nanmin(pre_lidar_chm_class_ma))
print('CHM max value:', np.nanmax(pre_lidar_chm_class_ma))

plt.subplot(1, 4, 2)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
pre_lidar_chm_class_ma.plot.imshow(vmin=1, vmax=64,cmap=new_cmap)
plt.title('EFT_Landsat_b4')
plt.axis('off')

lidar_dem_path = r"C:\EFT\EFT_Landsat7_EVI_2001_2017_NP_4_4.tif"
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
#print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
#https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm !=255)
print('CHM min value:', np.nanmin(pre_lidar_chm_class_ma))
print('CHM max value:', np.nanmax(pre_lidar_chm_class_ma))

plt.subplot(1, 4, 3)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
pre_lidar_chm_class_ma.plot.imshow(vmin=1, vmax=64,cmap=new_cmap)
plt.title('EFT_Landsat_b4_NP_clip')
plt.axis('off')


lidar_dem_path = r"C:\EFT\EFT_Landsat7_EVI_2001_2017_NP_4_4.tif"
print(lidar_dem_path)
pre_lidar_chm1 = rxr.open_rasterio(lidar_dem_path, masked=True)
print(type(pre_lidar_chm1))
print(pre_lidar_chm1.shape)
#print(pre_lidar_chm1.squeeze(pre_lidar_chm1, axis=0).shape)
#https://numpy.org/doc/stable/reference/generated/numpy.squeeze.html
pre_lidar_chm = np.squeeze(pre_lidar_chm1, axis=0)
pre_lidar_chm_class_ma = pre_lidar_chm.where(pre_lidar_chm !=255)
print('CHM min value:', np.nanmin(pre_lidar_chm_class_ma))
print('CHM max value:', np.nanmax(pre_lidar_chm_class_ma))

plt.subplot(1, 4, 4)  # 1 line, 2 rows, index nr 1 (first position in the subplot)
pre_lidar_chm_class_ma.plot.imshow(vmin=1, vmax=64,cmap=new_cmap)
plt.title('EFT_Landsat_b4_NP_local')
plt.axis('off')


#plt.show()
plt.savefig("C:\EFT\Fig\EFT_b4.png")
