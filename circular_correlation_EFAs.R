remove(list=ls()) 
library(tiff)
library(raster)
library(rgdal)

str_name = "C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\Greening_VI_2014_2019.tif"
#temp <- tempfile(fileext = ".tif")
imported_raster=raster(str_name)
#download.file("https://drive.google.com/uc?export=download&id=1ngTVXBp52i_2LaWE8H-jQ6DhuQPBxrBw",
#              temp)
print(imported_raster)
DSM_HARV_df <- as.data.frame(imported_raster, xy = TRUE)
Gslope <- as.data.frame(imported_raster, xy = FALSE)

str_name = "C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\MODIS_MMin_2014_2019.tif"
#temp <- tempfile(fileext = ".tif")
imported_raster=raster(str_name)
#download.file("https://drive.google.com/uc?export=download&id=1ngTVXBp52i_2LaWE8H-jQ6DhuQPBxrBw",
#              temp)
print(imported_raster)

Mmin <- as.data.frame(imported_raster, xy = FALSE)

# subset data from Gslope and Mmin //valid
# convert data_frame to vector

cor.circular(x, y, test=TRUE)

