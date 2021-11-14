remove(list=ls())
library(tiff)
library(raster)
library(rgdal)
library(circular)
library(Directional)

#PC1 linear varaible
str_name = "C:\\Costa_Rica\\EFT\\PCs\\MODIS\\PC1_MODIS_2014_2019.tif"
imported_raster=raster(str_name)
print(imported_raster)
PC11 <- as.data.frame(imported_raster, xy = FALSE)
PC1 <- as.vector(PC11)
pc1_valid <- na.omit(PC1)
min11_pc1 <- min(pc1_valid)
max11_pc1 <- max(pc1_valid)

#Mmin
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\MODIS_MMin_2014_2019.tif"
imported_raster=raster(str_name)
print(imported_raster)
Mmin <- as.data.frame(imported_raster, xy = FALSE)
Mmin1 <- as.vector(Mmin)
#index <- which(Mmin1 > 0)
#y <- Mmin1[index,1]
# Convert Date to circular variable
Mmin1r= Mmin1 * 2 *pi/365

#Subset valid value for both variables
index <- which(PC1 >= min11_pc1 & PC1 <= max11_pc1 & Mmin1r > 0)
x <- PC1[index,1]
y_cir <- Mmin1r[index,1]

result <- circlin.cor(y_cir, x, rads = TRUE)
print("pc1*MMin")
print(result)





