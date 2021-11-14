
memory.limit(size=6000)
remove(list=ls()) 
library(tiff)
library(raster)
library(rgdal)
library(circular)
library(Rfast)
library(Hmisc)
#library(Directional)

#**************************Linear variable****************************
#mean
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_mean_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
mean11 <- as.data.frame(imported_raster, xy = FALSE)
mean1 <- as.vector(mean11)
mean1_valid <- na.omit(mean1)
min_mean <- min(mean1_valid)
max_mean <- max(mean1_valid)

#SD
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_SD_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
SD11 <- as.data.frame(imported_raster, xy = FALSE)
SD1 <- as.vector(SD11)
SD1_valid <- na.omit(SD1)
min_SD <- min(SD1_valid)
max_SD <- max(SD1_valid)

#CV
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_CV_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
CV11 <- as.data.frame(imported_raster, xy = FALSE)
CV1 <- as.vector(CV11)
CV1_valid <- na.omit(CV1)
min_CV <- min(CV1_valid)
max_CV <- max(CV1_valid)

#Min_VI
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_Min_VI_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
Min_VI11 <- as.data.frame(imported_raster, xy = FALSE)
Min_VI1 <- as.vector(Min_VI11)
Min_VI1_valid <- na.omit(Min_VI1)
min_Min_VI <- min(Min_VI1_valid)
max_Min_VI <- max(Min_VI1_valid)

#Max_VI_
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_Max_VI_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
Max_VI11 <- as.data.frame(imported_raster, xy = FALSE)
Max_VI1 <- as.vector(Max_VI11)
Max_VI1_valid <- na.omit(Max_VI1)
min_Max_VI <- min(Max_VI1_valid)
max_Max_VI <- max(Max_VI1_valid)


#Gslope Greening_VI
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_Greening_VI_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
Greening_VI11 <- as.data.frame(imported_raster, xy = FALSE)
Greening_VI1 <- as.vector(Greening_VI11)
Greening_VI1_valid <- na.omit(Greening_VI1)
min_Greening_VI <- min(Greening_VI1_valid)
max_Greening_VI <- max(Greening_VI1_valid)

#Bslope Browning_VI
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_Browning_VI_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
Browning_VI11 <- as.data.frame(imported_raster, xy = FALSE)
Browning_VI1 <- as.vector(Browning_VI11)
Browning_VI1_valid <- na.omit(Browning_VI1)
min_Browning_VI <- min(Browning_VI1_valid)
max_Browning_VI <- max(Browning_VI1_valid)


#******************************Circular variables*******************

#MMax
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_MMax_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
MMax <- as.data.frame(imported_raster, xy = FALSE)
MMax1 <- as.vector(MMax)
#index <- which(MMax1 > 0)
#y <- MMax1[index,1]
# Convert Date to circular variable
MMax1r= MMax1 * 2 *pi/365

#MMin
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_MMin_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
Mmin <- as.data.frame(imported_raster, xy = FALSE)
Mmin1 <- as.vector(Mmin)
#index <- which(Mmin1 > 0)
#y <- Mmin1[index,1]
# Convert Date to circular variable
Mmin1r= Mmin1 * 2 *pi/365

#GreenTime
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_GreenTime_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
GreenTime <- as.data.frame(imported_raster, xy = FALSE)
GreenTime1 <- as.vector(GreenTime)
#index <- which(GreenTime1 > 0)
#y <- GreenTime1[index,1]
# Convert Date to circular variable
GreenTime1r= GreenTime1 * 2 *pi/365

#BrownTime
str_name = "C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_BrownTime_2001_2017.tif"
imported_raster=raster(str_name)
print(imported_raster)
BrownTime <- as.data.frame(imported_raster, xy = FALSE)
BrownTime1 <- as.vector(BrownTime)
#index <- which(BrownTime1 > 0)
#y <- BrownTime1[index,1]
# Convert Date to circular variable
BrownTime1r= BrownTime1 * 2 *pi/365

#******************************************two linears***********************************************
#Subset valid value for both variables
index <- which(mean1 >= min_mean & mean1 <= max_mean &
                 SD1 >= min_SD & SD1 <= max_SD & Min_VI1 >= min_Min_VI & Min_VI1 <= max_Min_VI)
x <- mean1[index,1]
y1 <- SD1[index,1]
y2 <- CV1[index,1]
y3 <- Max_VI1[index,1]
y4<- Min_VI1[index,1]
y5 <- Greening_VI1[index,1]
y6 <- Browning_VI1[index,1]

#MMax
X1 <-as.matrix(x)
Y1 <-as.matrix(y1)
Y2 <-as.matrix(y2)
Y3 <-as.matrix(y3)
Y4 <-as.matrix(y4)
Y5 <-as.matrix(y5)
Y6 <-as.matrix(y6)

my_data <- cbind(X1,Y1,Y2,Y3,Y4,Y5,Y6)
Y <- cbind(X1,Y1,Y2,Y3,Y4,Y5,Y6)

#https://rstudio-pubs-static.s3.amazonaws.com/240657_5157ff98e8204c358b2118fa69162e18.html
cor_1 <- round(cor(my_data), 2)
cor_2 <- rcorr(as.matrix(my_data))

result1 = cor_1
#result1_p = cor_2$
#(cor_2,"C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_EFAs_correlations_mean.csv")

#*****************************************linear and circular**********************************
index <- which(mean1 >= min_mean & mean1 <= max_mean &
                 Max_VI1 >= min_Max_VI & Max_VI1 <= max_Max_VI)

x_cir <- MMax1r[index,1]
x_cir1 <- Mmin1r[index,1]
x_cir2 <- GreenTime1r[index,1]
x_cir3 <- BrownTime1r[index,1]

#MMax
X_cir <-as.matrix(x_cir)
X_cir1 <-as.matrix(x_cir1)
X_cir2 <-as.matrix(x_cir2)
X_cir3 <-as.matrix(x_cir3)

y0 <- mean1[index,1]
y1 <- SD1[index,1]
y2 <- CV1[index,1]
y3 <- Max_VI1[index,1]
y4<- Min_VI1[index,1]
y5 <- Greening_VI1[index,1]
y6 <- Browning_VI1[index,1]

#MMax
Y0 <-as.matrix(y0)
Y1 <-as.matrix(y1)
Y2 <-as.matrix(y2)
Y3 <-as.matrix(y3)
Y4 <-as.matrix(y4)
Y5 <-as.matrix(y5)
Y6 <-as.matrix(y6)

Y <- cbind(Y0,Y1,Y2,Y3,Y4,Y5,Y6)

#MMax vs
#https://rdrr.io/cran/Rfast/man/circlin.cor.html
#https://stackoverflow.com/questions/14596420/how-to-get-value-by-column-name-in-r
result <- circlin.cor(X_cir, Y)
cor0 = sqrt(result[,1])
p0 = result[,2]

result <- circlin.cor(X_cir1, Y)
cor1 = sqrt(result[,1])
p1 = result[,2]

result <- circlin.cor(X_cir2, Y)
cor2 = sqrt(result[,1])
p2 = result[,2]

result <- circlin.cor(X_cir3, Y)
cor3 = sqrt(result[,1])
p3 = result[,2]

corr_res <- cbind(cor0,cor1,cor2,cor3)
p_res <- cbind(p0,p1,p2,p3)

#https://stat.ethz.ch/R-manual/R-devel/library/base/html/t.html
print(t(corr_res))
result2 <- t(corr_res)

#write.csv(t(corr_res),"C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_EFAs_correlations_linear_circular.csv")
#write.csv(t(p_res),"C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_EFAs_correlations_p_value_linear_circular.csv")

#*********************************************two circular variables***********************************
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

result3 = newdf

#preprocessing result3
vec <- rep(-9999, 4)
vec1 <-t(as.matrix(vec))
test <- rbind(vec1,vec1,vec1,result3)

result12 = rbind(as.data.frame(result1),as.data.frame(result2))
result_all = cbind(result12,test)

write.csv(result_all,"C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_EFAs_correlations_all_CR.csv",append = True)
