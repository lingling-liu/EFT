remove(list=ls()) 
library(tiff)
library(raster)
library(rgdal)
library(circular)

str_name = "C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\Greening_VI_2014_2019.tif"
imported_raster=raster(str_name)
print(imported_raster)
Gslope <- as.data.frame(imported_raster, xy = FALSE)
Gslope1 <- as.vector(Gslope)

str_name = "C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\MODIS_MMin_2014_2019.tif"
imported_raster=raster(str_name)
print(imported_raster)
Mmin <- as.data.frame(imported_raster, xy = FALSE)
Mmin1 <- as.vector(Mmin)

index <- which(Gslope1 > -5000 & Mmin1 > 0)
x <- Gslope1[index,1]
y <- Mmin1[index,1]

# subset data from Gslope and Mmin //valid
# convert data_frame to vector

cor.circular(x, y, test=TRUE)

