#https://www.analyticsvidhya.com/blog/2021/05/image-raster-analysis-spatial-correlation/
remove(list=ls()) 
library(tiff)
library(raster)
library(rgdal)
library(circular)
library(Rfast)
library(Hmisc)
library(sjlabelled)
#library(Directional)

#**************************Linear variable****************************
#b2_w3
str_name = "C:\\EFT\\EFD\\percentiles\\EFD_gee\\nodata\\1km\\output\\nodata\\EFD_MODIS_CR_b2_win3_nodata0_1km_reclass_nodata2_compressed.tif" 
#loading data sets
imported_raster=raster(str_name)
#print(imported_raster)
mean11 <- as.data.frame(imported_raster, xy = FALSE)
b2_w3 <- as.vector(mean11)

# #b2_w5
str_name = "C:\\EFT\\EFD\\percentiles\\EFD_gee\\nodata\\1km\\output\\nodata\\EFD_MODIS_CR_b2_win5_nodata0_1km_reclass_nodata2_compressed.tif"
imported_raster=raster(str_name)
#print(imported_raster)
SD11 <- as.data.frame(imported_raster, xy = FALSE)
b2_w5 <- as.vector(SD11)


# #b2_w7
str_name = "C:\\EFT\\EFD\\percentiles\\EFD_gee\\nodata\\1km\\output\\nodata\\EFD_MODIS_CR_b2_win7_nodata0_1km_reclass_nodata2_compressed.tif"
imported_raster=raster(str_name)
#print(imported_raster)
CV11 <- as.data.frame(imported_raster, xy = FALSE)
b2_w7 <- as.vector(CV11)


# #b4_w3
str_name = "C:\\EFT\\EFD\\percentiles\\EFD_gee\\nodata\\1km\\output\\nodata\\EFD_MODIS_CR_b4_win3_nodata0_1km_reclass_nodata2_compressed.tif"
imported_raster=raster(str_name)
#print(imported_raster)
Min_VI11 <- as.data.frame(imported_raster, xy = FALSE)
b4_w3 <- as.vector(Min_VI11)

# #b4_w5
str_name = "C:\\EFT\\EFD\\percentiles\\EFD_gee\\nodata\\1km\\output\\nodata\\EFD_MODIS_CR_b4_win5_nodata0_1km_reclass_nodata2_compressed.tif"
imported_raster=raster(str_name)
#print(imported_raster)
Max_VI11 <- as.data.frame(imported_raster, xy = FALSE)
b4_w5 <- as.vector(Max_VI11)


# #b4_w7
str_name = "C:\\EFT\\EFD\\percentiles\\EFD_gee\\nodata\\1km\\output\\nodata\\EFD_MODIS_CR_b4_win7_nodata0_1km_reclass_nodata2_compressed.tif"
imported_raster=raster(str_name)
#print(imported_raster)
Greening_VI11 <- as.data.frame(imported_raster, xy = FALSE)
b4_w7 <- as.vector(Greening_VI11)

# agreement
str_name = "C:\\EFT\\EFD\\percentiles\\EFD_gee\\efd_modis_agreement_1.tif"
imported_raster=raster(str_name)
#print(imported_raster)
Greening_VI11 <- as.data.frame(imported_raster, xy = FALSE)
agreement_mask <- as.vector(Greening_VI11)


# # #******************************************two linears***********************************************
# #count all pixels
index <- which(b2_w3 >= 0 & b2_w3 <= 1)
x <- b2_w3[index,1]

index <- which(b2_w5 >= 0 & b2_w5 <= 1)
y1 <- b2_w5[index,1]

index <- which(b2_w7 >= 0 & b2_w7 <= 1)
y2 <- b2_w7[index,1]

index <- which(b4_w3 >= 0 & b4_w3 <= 1)
y3 <- b4_w3[index,1]

index <- which(b4_w5 >= 0 & b4_w5 <= 1)
y4 <- b4_w5[index,1]

index <- which(b4_w7 >= 0 & b4_w7 <= 1)
y5 <- b4_w7[index,1]

index <- which(agreement_mask >= 0 & agreement_mask <= 1)
y6 <- agreement_mask[index,1]
# 
#count pixel values =1
index <- which(b2_w3 == 1)
x1 <- b2_w3[index,1]

index <- which(b2_w5 == 1)
y11 <- b2_w5[index,1]

index <- which(b2_w7 == 1)
y21 <- b2_w7[index,1]

index <- which(b4_w3 == 1)
y31 <- b4_w3[index,1]

index <- which(b4_w5 == 1)
y41 <- b4_w5[index,1]

index <- which(b4_w7 == 1)
y51 <- b4_w7[index,1]
# 
# index <- which(agreement_mask == 1)
# y61 <- agreement_mask[index,1]

# this presents both variables on the same line, as desired
pixels <- c(NROW(x),NROW(y1),NROW(y2),NROW(y3),NROW(y4),NROW(y5))
print(pixels)
# 
# # this presents both variables on the same line, as desired
# pers <- c(NROW(x1)/NROW(x),NROW(y11)/NROW(y1),NROW(y21)/NROW(y2),NROW(y31)/NROW(y3),NROW(y41)/NROW(y4),NROW(y51)/NROW(y5))
# print(pers)
# 
# pixels1 <- c(NROW(x1),NROW(y11),NROW(y21),NROW(y31),NROW(y41),NROW(y51))
# print(pixels1)

# #******************************************
# #between each individual resampled mask 
# #first col
# #b2_w3
# #count pixel values =1
# index <- which(b2_w3 == 1 & b2_w3 == 1)
# col1_x <- b2_w3[index,1]
# 
# index <- which(b2_w3 == 1 & b2_w5 == 1)
# col1_y11 <- b2_w5[index,1]
# 
# index <- which(b2_w3 == 1 & b2_w7 == 1)
# col1_y21 <- b2_w7[index,1]
# 
# index <- which(b2_w3 == 1 & b4_w3 == 1)
# col1_y31 <- b4_w3[index,1]
# 
# index <- which(b2_w3 == 1 & b4_w5 == 1)
# col1_y41 <- b4_w5[index,1]
# 
# index <- which(b2_w3 == 1 & b4_w7 == 1)
# col1_y51 <- b4_w7[index,1]
# 
# pixels1 <- c(NROW(col1_x),NROW(col1_y11),NROW(col1_y21),NROW(col1_y31),NROW(col1_y41),NROW(col1_y51))
# print(pixels1)
# 
# #***************************
# #b2_w5
# index <- which(b2_w5 == 1 & b2_w3 == 1)
# col1_x <- b2_w3[index,1]
# 
# index <- which(b2_w5 == 1 & b2_w5 == 1)
# col1_y11 <- b2_w5[index,1]
# 
# index <- which(b2_w5 == 1 & b2_w7 == 1)
# col1_y21 <- b2_w7[index,1]
# 
# index <- which(b2_w5 == 1 & b4_w3 == 1)
# col1_y31 <- b4_w3[index,1]
# 
# index <- which(b2_w5 == 1 & b4_w5 == 1)
# col1_y41 <- b4_w5[index,1]
# 
# index <- which(b2_w5 == 1 & b4_w7 == 1)
# col1_y51 <- b4_w7[index,1]
# 
# pixels2 <- c(NROW(col1_x),NROW(col1_y11),NROW(col1_y21),NROW(col1_y31),NROW(col1_y41),NROW(col1_y51))
# print(pixels2)
# 
# 
# #*****************************
# #*b2_w7
# #*
# index <- which(b2_w7 == 1 & b2_w3 == 1)
# col1_x <- b2_w3[index,1]
# 
# index <- which(b2_w7 == 1 & b2_w5 == 1)
# col1_y11 <- b2_w5[index,1]
# 
# index <- which(b2_w7 == 1 & b2_w7 == 1)
# col1_y21 <- b2_w7[index,1]
# 
# index <- which(b2_w7 == 1 & b4_w3 == 1)
# col1_y31 <- b4_w3[index,1]
# 
# index <- which(b2_w7 == 1 & b4_w5 == 1)
# col1_y41 <- b4_w5[index,1]
# 
# index <- which(b2_w7 == 1 & b4_w7 == 1)
# col1_y51 <- b4_w7[index,1]
# 
# pixels3 <- c(NROW(col1_x),NROW(col1_y11),NROW(col1_y21),NROW(col1_y31),NROW(col1_y41),NROW(col1_y51))
# print(pixels3)
# 
# #**************************
# #*b4_w3
# 
# # #count pixel values =1
# index <- which(b4_w3 == 1 & b2_w3 == 1)
# col1_x <- b2_w3[index,1]
# 
# index <- which(b4_w3 == 1 & b2_w5 == 1)
# col1_y11 <- b2_w5[index,1]
# 
# index <- which(b4_w3 == 1 & b2_w7 == 1)
# col1_y21 <- b2_w7[index,1]
# 
# index <- which(b4_w3 == 1 & b4_w3 == 1)
# col1_y31 <- b4_w3[index,1]
# 
# index <- which(b4_w3 == 1 & b4_w5 == 1)
# col1_y41 <- b4_w5[index,1]
# 
# index <- which(b4_w3 == 1 & b4_w7 == 1)
# col1_y51 <- b4_w7[index,1]
# 
# pixels4 <- c(NROW(col1_x),NROW(col1_y11),NROW(col1_y21),NROW(col1_y31),NROW(col1_y41),NROW(col1_y51))
# print(pixels4)
# 
# #***************************
# #b4_w5
# index <- which(b4_w5 == 1 & b2_w3 == 1)
# col1_x <- b2_w3[index,1]
# 
# index <- which(b4_w5 == 1 & b2_w5 == 1)
# col1_y11 <- b2_w5[index,1]
# 
# index <- which(b4_w5 == 1 & b2_w7 == 1)
# col1_y21 <- b2_w7[index,1]
# 
# index <- which(b4_w5 == 1 & b4_w3 == 1)
# col1_y31 <- b4_w3[index,1]
# 
# index <- which(b4_w5 == 1 & b4_w5 == 1)
# col1_y41 <- b4_w5[index,1]
# 
# index <- which(b4_w5 == 1 & b4_w7 == 1)
# col1_y51 <- b4_w7[index,1]
# 
# pixels5 <- c(NROW(col1_x),NROW(col1_y11),NROW(col1_y21),NROW(col1_y31),NROW(col1_y41),NROW(col1_y51))
# print(pixels5)
# 
# 
# #*****************************
# #*b4_w7
# #*
# index <- which(b4_w7 == 1 & b2_w3 == 1)
# col1_x <- b2_w3[index,1]
# 
# index <- which(b4_w7 == 1 & b2_w5 == 1)
# col1_y11 <- b2_w5[index,1]
# 
# index <- which(b4_w7 == 1 & b2_w7 == 1)
# col1_y21 <- b2_w7[index,1]
# 
# index <- which(b4_w7 == 1 & b4_w3 == 1)
# col1_y31 <- b4_w3[index,1]
# 
# index <- which(b4_w7 == 1 & b4_w5 == 1)
# col1_y41 <- b4_w5[index,1]
# 
# index <- which(b4_w7 == 1 & b4_w7 == 1)
# col1_y51 <- b4_w7[index,1]
# 
# pixels6 <- c(NROW(col1_x),NROW(col1_y11),NROW(col1_y21),NROW(col1_y31),NROW(col1_y41),NROW(col1_y51))
# print(pixels6)
# print('output')
# pixels_all = rbind(pixels1,pixels2,pixels3,pixels4,pixels5,pixels6)
# print(pixels_all)

# #*****************************
# #*the agreement mask and the individual masks and 
# #*
index <- which(agreement_mask == 1 & b2_w3 == 1)
col1_x <- b2_w3[index,1]

index <- which(agreement_mask == 1 & b2_w5 == 1)
col1_y11 <- b2_w5[index,1]

index <- which(agreement_mask == 1 & b2_w7 == 1)
col1_y21 <- b2_w7[index,1]

index <- which(agreement_mask == 1 & b4_w3 == 1)
col1_y31 <- b4_w3[index,1]

index <- which(agreement_mask == 1 & b4_w5 == 1)
col1_y41 <- b4_w5[index,1]

index <- which(agreement_mask == 1 & b4_w7 == 1)
col1_y51 <- b4_w7[index,1]

pixels_agreement <- c(NROW(col1_x),NROW(col1_y11),NROW(col1_y21),NROW(col1_y31),NROW(col1_y41),NROW(col1_y51))
print(pixels_agreement)

