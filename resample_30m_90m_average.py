from osgeo import gdal 
import os
from pathlib import Path

directory = "C:/EFT/EFD/clip/nodata"
output = "C:/EFT/EFD/clip/nodata/resample/"

for filename in os.listdir(directory):
    f = os.path.join(directory, filename)
    # checking if it is a file
    if os.path.isfile(f): 
        filename = Path(f).stem
        src = f
        dest = output + filename+"_90m.tif"
        print(dest)
        print(src)
        ds =  gdal.Open(src)
        gdal.Warp(dest, ds, xRes = 0.000269494585235856*3, yRes = 0.000269494585235856*3, resampleAlg = "average")