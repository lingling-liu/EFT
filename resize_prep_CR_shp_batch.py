import glob
import os

import arcpy
from arcpy import env
from arcpy.sa import *

arcpy.CheckOutExtension('Spatial')

"""folder containing only your input rasters and nothing else"""
indir = 'C:/Users/Yy_PC/Downloads/wc2.1_30s_prec/'
outdir = 'C:/EFT/prep/'

"""absolute path to your mask layer"""
mask = "C:/EFT/boudary/CR_WGS1984.shp"
#mask = "C:/EFT/EFD/CR/EFD_Landsat_CR_b2_win5.tif"

"""create emply list to hold paths to input rasters"""
inrasters = []

"""populate the list inrasters with all paths to .tif in directory"""
os.chdir(indir)
for r in glob.glob('*.tif'):
    inrasters.append(r)

"""iterate over all input .tif from list inrasters"""
for inraster in inrasters:

    """create a unique name for each output raster"""
    outraster = outdir+inraster.replace('.tif','_clip.tif')
    print(inraster)
    print(outraster)
    """Clip each raster with it's unique name as output"""
    r = arcpy.sa.ExtractByMask(inraster,mask,"INSIDE")
    r.save(outraster)