remove(list=ls()) 
library(tiff)
library(raster)
library(rgdal)
library(circular)
library(Rfast)
library(Hmisc)
library('psych')

#PC1 linear varaible
str_name = "C:\\Costa_Rica\\EFT\\PCs\\Landsat7\\Landsat7_2001_2017_PC1_NP.tif"
imported_raster=raster(str_name)
print(imported_raster)
PC11 <- as.data.frame(imported_raster, xy = FALSE)
PC1 <- as.vector(PC11)
pc1_valid <- na.omit(PC1)
min11_pc1 <- min(pc1_valid)
max11_pc1 <- max(pc1_valid)

#PC2 linear varaible
str_name = "C:\\Costa_Rica\\EFT\\PCs\\Landsat7\\Landsat7_2001_2017_PC2_NP.tif"
imported_raster=raster(str_name)
print(imported_raster)
PC22 <- as.data.frame(imported_raster, xy = FALSE)
PC2 <- as.vector(PC22)
pc2_valid <- na.omit(PC2)
min22_pc2 <- min(pc2_valid)
max22_pc2 <- max(pc2_valid)


#PC3 linear varaible
str_name = "C:\\Costa_Rica\\EFT\\PCs\\Landsat7\\Landsat7_2001_2017_PC3_NP.tif"
imported_raster=raster(str_name)
print(imported_raster)
PC33 <- as.data.frame(imported_raster, xy = FALSE)
PC3 <- as.vector(PC33)
pc3_valid <- na.omit(PC3)
min33_pc3 <- min(pc3_valid)
max33_pc3 <- max(pc3_valid)


#**********************************EFAs**********************************************
#**************************Linear variable****************************
#mean
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_mean_2001_2017_NP.tif"
imported_raster=raster(str_name)
print(imported_raster)
mean11 <- as.data.frame(imported_raster, xy = FALSE)
mean1 <- as.vector(mean11)
mean1_valid <- na.omit(mean1)
min_mean <- min(mean1_valid)
max_mean <- max(mean1_valid)

#SD
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_SD_2001_2017_NP.tif"
imported_raster=raster(str_name)
print(imported_raster)
SD11 <- as.data.frame(imported_raster, xy = FALSE)
SD1 <- as.vector(SD11)
SD1_valid <- na.omit(SD1)
min_SD <- min(SD1_valid)
max_SD <- max(SD1_valid)

#CV
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_CV_2001_2017_NP.tif"
imported_raster=raster(str_name)
print(imported_raster)
CV11 <- as.data.frame(imported_raster, xy = FALSE)
CV1 <- as.vector(CV11)
CV1_valid <- na.omit(CV1)
min_CV <- min(CV1_valid)
max_CV <- max(CV1_valid)

#Min_VI
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_Min_VI_2001_2017_NP.tif"
imported_raster=raster(str_name)
print(imported_raster)
Min_VI11 <- as.data.frame(imported_raster, xy = FALSE)
Min_VI1 <- as.vector(Min_VI11)
Min_VI1_valid <- na.omit(Min_VI1)
min_Min_VI <- min(Min_VI1_valid)
max_Min_VI <- max(Min_VI1_valid)

#Max_VI_
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_Max_VI_2001_2017_NP.tif"
imported_raster=raster(str_name)
print(imported_raster)
Max_VI11 <- as.data.frame(imported_raster, xy = FALSE)
Max_VI1 <- as.vector(Max_VI11)
Max_VI1_valid <- na.omit(Max_VI1)
min_Max_VI <- min(Max_VI1_valid)
max_Max_VI <- max(Max_VI1_valid)


#Gslope Greening_VI
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_Greening_VI_2001_2017_NP.tif"
imported_raster=raster(str_name)
print(imported_raster)
Greening_VI11 <- as.data.frame(imported_raster, xy = FALSE)
Greening_VI1 <- as.vector(Greening_VI11)
Greening_VI1_valid <- na.omit(Greening_VI1)
min_Greening_VI <- min(Greening_VI1_valid)
max_Greening_VI <- max(Greening_VI1_valid)

#Bslope Browning_VI
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_Browning_VI_2001_2017_NP.tif"
imported_raster=raster(str_name)
print(imported_raster)
Browning_VI11 <- as.data.frame(imported_raster, xy = FALSE)
Browning_VI1 <- as.vector(Browning_VI11)
Browning_VI1_valid <- na.omit(Browning_VI1)
min_Browning_VI <- min(Browning_VI1_valid)
max_Browning_VI <- max(Browning_VI1_valid)


#******************************Circular variables*******************

#MMax
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_MMax_2001_2017_NP.tif"
imported_raster=raster(str_name)
print(imported_raster)
MMax <- as.data.frame(imported_raster, xy = FALSE)
MMax1 <- as.vector(MMax)
#index <- which(MMax1 > 0)
#y <- MMax1[index,1]
# Convert Date to circular variable
MMax1r= MMax1 * 2 *pi/365

#MMin
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_MMin_2001_2017_NP.tif"
imported_raster=raster(str_name)
print(imported_raster)
Mmin <- as.data.frame(imported_raster, xy = FALSE)
Mmin1 <- as.vector(Mmin)
#index <- which(Mmin1 > 0)
#y <- Mmin1[index,1]
# Convert Date to circular variable
Mmin1r= Mmin1 * 2 *pi/365

#GreenTime
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_GreenTime_2001_2017_NP.tif"
imported_raster=raster(str_name)
print(imported_raster)
GreenTime <- as.data.frame(imported_raster, xy = FALSE)
GreenTime1 <- as.vector(GreenTime)
#index <- which(GreenTime1 > 0)
#y <- GreenTime1[index,1]
# Convert Date to circular variable
GreenTime1r= GreenTime1 * 2 *pi/365

#BrownTime
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_BrownTime_2001_2017_NP.tif"
imported_raster=raster(str_name)
print(imported_raster)
BrownTime <- as.data.frame(imported_raster, xy = FALSE)
BrownTime1 <- as.vector(BrownTime)
#index <- which(BrownTime1 > 0)
#y <- BrownTime1[index,1]
# Convert Date to circular variable
BrownTime1r= BrownTime1 * 2 *pi/365

#Subset valid value for both variables
index <- which(PC1 >= min11_pc1 & PC1 <= max11_pc1 & mean1 >= min_mean & mean1 <= max_mean)
x1 <- PC1[index,1]
x2 <- PC2[index,1]
x3 <- PC3[index,1]

X1 <-as.matrix(x1)
X2 <-as.matrix(x2)
X3 <-as.matrix(x3)


# linear variables
y0 <- mean1[index,1]
y1 <- SD1[index,1]
y2 <- CV1[index,1]
y3 <- Max_VI1[index,1]
y4<- Min_VI1[index,1]
y5 <- Greening_VI1[index,1]
y6 <- Browning_VI1[index,1]

Y0 <-as.matrix(y0)
Y1 <-as.matrix(y1)
Y2 <-as.matrix(y2)
Y3 <-as.matrix(y3)
Y4 <-as.matrix(y4)
Y5 <-as.matrix(y5)
Y6 <-as.matrix(y6)

my_data <- cbind(X1,X2,X3)
Y <- cbind(Y0,Y1,Y2,Y3,Y4,Y5,Y6)
#https://stackoverflow.com/questions/60379644/correlation-matrix-between-two-dataframes-in-r
cor_2 <- cor(my_data,Y)

#circular variables
y_cir0 <- MMax1r[index,1]
y_cir1 <- Mmin1r[index,1]
y_cir2 <- GreenTime1r[index,1]
y_cir3 <- BrownTime1r[index,1]


#MMax
Y_cir0 <-as.matrix(y_cir0)
Y_cir1 <-as.matrix(y_cir1)
Y_cir2 <-as.matrix(y_cir2)
Y_cir3 <-as.matrix(y_cir3)

my_data1 <- cbind(X1,X2,X3)
result <- circlin.cor(Y_cir0, my_data1)
cor0 = sqrt(result[,1])
p0 = result[,2]

result <- circlin.cor(Y_cir1, my_data1)
cor1 = sqrt(result[,1])
p1 = result[,2]

result <- circlin.cor(Y_cir2, my_data1)
cor2 = sqrt(result[,1])
p2 = result[,2]

result <- circlin.cor(Y_cir3, my_data1)
cor3 = sqrt(result[,1])
p3 = result[,2]

corr_res <- cbind(cor0,cor1,cor2,cor3)
p_res <- cbind(p0,p1,p2,p3)

#https://stat.ethz.ch/R-manual/R-devel/library/base/html/t.html
#print(corr_res)

result <-cbind(cor_2,corr_res)
write.csv(result,"C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_NP_PCs_EFAs_correlations.csv")


