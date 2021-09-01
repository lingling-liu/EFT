remove(list=ls()) 
library(tiff)
library(raster)
library(rgdal)
library(circular)
library(Rfast)
#library(Directional)

#**************************Linear variable****************************
#mean
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\MODIS_mean_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
mean11 <- as.data.frame(imported_raster, xy = FALSE)
mean1 <- as.vector(mean11)
mean1_valid <- na.omit(mean1)
min_mean <- min(mean1_valid)
max_mean <- max(mean1_valid)

#SD
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\MODIS_SD_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
SD11 <- as.data.frame(imported_raster, xy = FALSE)
SD1 <- as.vector(SD11)
SD1_valid <- na.omit(SD1)
min_SD <- min(SD1_valid)
max_SD <- max(SD1_valid)

#CV
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\MODIS_CV_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
CV11 <- as.data.frame(imported_raster, xy = FALSE)
CV1 <- as.vector(CV11)
CV1_valid <- na.omit(CV1)
min_CV <- min(CV1_valid)
max_CV <- max(CV1_valid)

#Min_VI
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\MODIS_Min_VI_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
Min_VI11 <- as.data.frame(imported_raster, xy = FALSE)
Min_VI1 <- as.vector(Min_VI11)
Min_VI1_valid <- na.omit(Min_VI1)
min_Min_VI <- min(Min_VI1_valid)
max_Min_VI <- max(Min_VI1_valid)

#Max_VI_
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\MODIS_Max_VI_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
Max_VI11 <- as.data.frame(imported_raster, xy = FALSE)
Max_VI1 <- as.vector(Max_VI11)
Max_VI1_valid <- na.omit(Max_VI1)
min_Max_VI <- min(Max_VI1_valid)
max_Max_VI <- max(Max_VI1_valid)


#Gslope Greening_VI
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\MODIS_Greening_VI_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
Greening_VI11 <- as.data.frame(imported_raster, xy = FALSE)
Greening_VI1 <- as.vector(Greening_VI11)
Greening_VI1_valid <- na.omit(Greening_VI1)
min_Greening_VI <- min(Greening_VI1_valid)
max_Greening_VI <- max(Greening_VI1_valid)

#Bslope Browning_VI
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\MODIS_Browning_VI_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
Browning_VI11 <- as.data.frame(imported_raster, xy = FALSE)
Browning_VI1 <- as.vector(Browning_VI11)
Browning_VI1_valid <- na.omit(Browning_VI1)
min_Browning_VI <- min(Browning_VI1_valid)
max_Browning_VI <- max(Browning_VI1_valid)


#******************************Circular variables*******************

#MMax
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\MODIS_MMax_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
MMax <- as.data.frame(imported_raster, xy = FALSE)
MMax1 <- as.vector(MMax)
#index <- which(MMax1 > 0)
#y <- MMax1[index,1]
# Convert Date to circular variable
MMax1r= MMax1 * 2 *pi/365

#MMin
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\MODIS_MMin_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
Mmin <- as.data.frame(imported_raster, xy = FALSE)
Mmin1 <- as.vector(Mmin)
#index <- which(Mmin1 > 0)
#y <- Mmin1[index,1]
# Convert Date to circular variable
Mmin1r= Mmin1 * 2 *pi/365

#GreenTime
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\MODIS_GreenTime_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
GreenTime <- as.data.frame(imported_raster, xy = FALSE)
GreenTime1 <- as.vector(GreenTime)
#index <- which(GreenTime1 > 0)
#y <- GreenTime1[index,1]
# Convert Date to circular variable
GreenTime1r= GreenTime1 * 2 *pi/365

#BrownTime
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\MODIS_BrownTime_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
BrownTime <- as.data.frame(imported_raster, xy = FALSE)
BrownTime1 <- as.vector(BrownTime)
#index <- which(BrownTime1 > 0)
#y <- BrownTime1[index,1]
# Convert Date to circular variable
BrownTime1r= BrownTime1 * 2 *pi/365


#Subset valid value for both variables



#https://rdrr.io/cran/circular/man/cor.circular.html
index <- which(mean1 >= min_mean & mean1 <= max_mean &
                 Max_VI1 >= min_Max_VI & Max_VI1 <= max_Max_VI)
x_cir <- MMax1r[index,1]
y_cir1 <- Mmin1r[index,1]
y_cir2 <- GreenTime1r[index,1]
y_cir3 <- BrownTime1r[index,1]


#MMax
X_cir <-as.matrix(x_cir)
Y_cir1 <-as.matrix(y_cir1)
Y_cir2 <-as.matrix(y_cir2)
Y_cir3 <-as.matrix(y_cir3)
X <- cbind(X_cir,Y_cir1,Y_cir2,Y_cir3)
Y <- cbind(X_cir,Y_cir1,Y_cir2,Y_cir3)
result <- cor.circular(X,Y, test = TRUE)
newdf <- result$cor
newdf1 <- result$p.value



write.csv(newdf,"C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\MODIS_EFAs_correlations.csv",append = True)
write.csv(newdf1,"C:\\Costa_Rica\\EFT\\EFAs\\MODIS\\MODIS_EFAs_correlations_p_value.csv",append = True)

