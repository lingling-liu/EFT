remove(list=ls())
library(tiff)
library(raster)
library(rgdal)
library(circular)
#library(Directional)

#str_name = "C:\\Costa_Rica\\NicoyaPeninsula\\Landsat8_MMin_8times.tif"
#str_name = "C:\\Costa_Rica\\EFT\\Landsat7\\Landsat7_MMax_8times.tif"
#str_name = "C:\\Costa_Rica\\EFT\\Landsat7\\NP\\Landsat7_MMax_NP_4times.tif"
#str_name = "C:\\Costa_Rica\\EFT\\MODIS\\MODIS_MMin_2001_2017.tif"
str_name = "C:\\Costa_Rica\\EFT\\MODIS\\MODIS_GreenTime_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
MMax <- as.data.frame(imported_raster, xy = FALSE)
MMax1 <- as.vector(MMax)
MMax1 <- na.omit(MMax1)
index <- which(MMax1 > 0)
rvs <- MMax1[index,1]

hist(rvs)
rvs <- rvs * 360  / 365
rvs <- circular::rad(rvs)
rvs <- circular::circular(rvs)
set.seed(123)
quantiles <- circular::quantile.circular(rvs,probs = seq(0, 1, 0.3333))
quantiles <- circular::deg(quantiles)
quantiles <- quantiles /360 * 365


