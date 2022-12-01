from osgeo import gdal 
import os
from pathlib import Path

# os.chdir("C:/EFT/EFD/percentiles/EFD_gee/ori")
# directory = "C:\EFT\EFD\percentiles\EFD_gee\ori"

#os.chdir("C:/EFT/EFD/percentiles/EFD_gee/NP/ori")
#directory = "C:/EFT/EFD/percentiles/EFD_gee/NP/ori"

#directory = "C:/EFT/EFD/CR"
#output = "C:/EFT/EFD/CR/nodata/" 

# directory = "C:/EFT/EFD/NP"
# output = "C:/EFT/EFD/NP/nodata/"

directory = "C:/EFT/EFD/NP/MODIS"
output = "C:/EFT/EFD/NP/MODIS/nodata/"

translateoptions = gdal.TranslateOptions(gdal.ParseCommandLine("-ot Float32 -a_nodata 0 COMPRESS=LZW"))

for filename in os.listdir(directory):
    f = os.path.join(directory, filename)
    # checking if it is a file
    if os.path.isfile(f): 
        filename = Path(f).stem
        src = f
        dest = output + filename+"_nodata0_compressed.tif"
        print(dest)
        print(src)
        ds = gdal.Translate(dest,src,options=translateoptions)