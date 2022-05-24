from osgeo import gdal 
import os
os.chdir("C:/EFT/EFD/percentiles/EFD_gee")
#https://gis.stackexchange.com/questions/299059/osgeo-gdal-translate-how-to-set-compression-on-gdal-gtiff-driver
translateoptions = gdal.TranslateOptions(gdal.ParseCommandLine("-ot Float32 -a_nodata 0 COMPRESS=LZW"))
ds = gdal.Translate('EFD_Landsat_CR_b2_win3_mask.tif','EFD_Landsat_CR_b2_win3.tif', options=translateoptions)


from osgeo import gdal

src = "data/invest-sample-data/Carbon/lulc_current_willamette.tif"
dest = "out.tif"

gdal.Translate(
  dest,
  src,
  outputType=gdal.GDT_Float32,
  noData=0,
  creationOptions=['COMPRESS=LZW']
)