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

#PC2 linear varaible
str_name = "C:\\Costa_Rica\\EFT\\PCs\\MODIS\\PC2_MODIS_2014_2019.tif"
imported_raster=raster(str_name)
print(imported_raster)
PC22 <- as.data.frame(imported_raster, xy = FALSE)
PC2 <- as.vector(PC22)
pc2_valid <- na.omit(PC2)
min22_pc2 <- min(pc2_valid)
max22_pc2 <- max(pc2_valid)


#PC3 linear varaible
str_name = "C:\\Costa_Rica\\EFT\\PCs\\MODIS\\PC3_MODIS_2014_2019.tif"
imported_raster=raster(str_name)
print(imported_raster)
PC33 <- as.data.frame(imported_raster, xy = FALSE)
PC3 <- as.vector(PC33)
pc3_valid <- na.omit(PC3)
min33_pc3 <- min(pc3_valid)
max33_pc3 <- max(pc3_valid)

#Mmin
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\MODIS_MMax_2014_2019.tif"
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

# PC1 PC2 PC3
#Subset valid value for both variables
index <- which(PC1 >= min11_pc1 & PC1 <= max11_pc1 & 
                 PC2 >= min22_pc2 & PC2 <= max22_pc2 & 
                 PC3 >= min33_pc3 & PC3 <= max33_pc3 & 
                 Mmin1r > 0)
x1 <- PC1[index,1]
x2 <- PC2[index,1]
x3 <- PC3[index,1]
y_cir <- Mmin1r[index,1]
print("PCs*MMax")
result1 <- circlin.cor(y_cir, x1, rads = TRUE)
result2 <- circlin.cor(y_cir, x2, rads = TRUE)
result3 <- circlin.cor(y_cir, x3, rads = TRUE)
print(result1)
print(result2)
print(result3)

