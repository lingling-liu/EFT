# ArcGIS insert new notebook

import arcpy, glob, os

arcpy.CheckOutExtension('Spatial')

# folder containing only input rasters and nothing else
inws = r'C:\EFT\EFD'
outws = r'C:\EFT\EFD\clip' # Note the new output workspace folder

# absolute path to mask layer
mask = r'C:\EFT\drive-download-20220322T011341Z-001\Guanacaste_NicoyaPeninsula_boundaries.shp'

# Generate a list of all .tif files (Note this lists full paths)
rasters = glob.glob(os.path.join(inws, "*.tif"))
print(rasters)

#iterate over all input .tif from raster list
for ras in rasters:

    # Define the output path and name
    outname = os.path.join(outws, os.path.basename(ras).split(".")[0] + "_clp.tif")
    print(outname)

    # Perform the EBM
    out_extract = arcpy.sa.ExtractByMask(ras, mask)

    # Save the output
    out_extract.save(outname)