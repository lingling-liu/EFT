remove(list=ls())
library(tiff)
library(raster)
library(rgdal)
library(circular)
#library(Directional)

str_name = "C:\\Costa_Rica\\NicoyaPeninsula\\Landsat8_MMax_NP.tif"
imported_raster=raster(str_name)
print(imported_raster)
MMax <- as.data.frame(imported_raster, xy = FALSE)
MMax1 <- as.vector(MMax)
index <- which(MMax1 > 0)
rvs <- MMax1[index,1]

hist(rvs)
rvs <- rvs * 360  / 365
rvs <- circular::rad(rvs)
rvs <- circular::circular(rvs)
quantiles <- circular::quantile.circular(rvs,probs = seq(0, 1, 0.3333))
quantiles <- circular::deg(quantiles)
quantiles <- quantiles /360 * 365

# test
print(rvs)
