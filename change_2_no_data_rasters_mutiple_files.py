from osgeo import gdal 
import os
from pathlib import Path

os.chdir("C:/EFT/EFD/percentiles/EFD_gee/nodata/1km/output")
directory = "C:/EFT/EFD/percentiles/EFD_gee/nodata/1km/output"

translateoptions = gdal.TranslateOptions(gdal.ParseCommandLine("-a_nodata 2 COMPRESS=LZW"))

for filename in os.listdir(directory):
    f = os.path.join(directory, filename)
    # checking if it is a file
    if os.path.isfile(f): 
        filename = Path(f).stem
        src = f
        dest = "C:/EFT/EFD/percentiles/EFD_gee/nodata/1km/output/nodata/"+ filename+"_nodata2_compressed.tif"
        print(dest)
        print(src)
        ds = gdal.Translate(dest,src,options=translateoptions)