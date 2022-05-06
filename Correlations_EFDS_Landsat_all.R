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
str_name = "C:\\EFT\\EFD\\percentiles\\EFD_gee\\output\\EFD_Landsat_CR_b2_win3_reclass.tif" 
#loading data sets
imported_raster=raster(str_name)
print(imported_raster)
mean11 <- as.data.frame(imported_raster, xy = FALSE)
b2_w3 <- as.vector(mean11)

# #b2_w5
str_name = "C:\\EFT\\EFD\\percentiles\\EFD_gee\\output\\EFD_Landsat_CR_b2_win5_reclass.tif"
imported_raster=raster(str_name)
print(imported_raster)
SD11 <- as.data.frame(imported_raster, xy = FALSE)
b2_w5 <- as.vector(SD11)


# #b2_w7
str_name = "C:\\EFT\\EFD\\percentiles\\EFD_gee\\output\\EFD_Landsat_CR_b2_win7_reclass.tif"
imported_raster=raster(str_name)
print(imported_raster)
CV11 <- as.data.frame(imported_raster, xy = FALSE)
b2_w7 <- as.vector(CV11)


# #b4_w3
str_name = "C:\\EFT\\EFD\\percentiles\\EFD_gee\\output\\EFD_Landsat_CR_b4_win3_reclass.tif"
imported_raster=raster(str_name)
print(imported_raster)
Min_VI11 <- as.data.frame(imported_raster, xy = FALSE)
b4_w3 <- as.vector(Min_VI11)

# #b4_w5
str_name = "C:\\EFT\\EFD\\percentiles\\EFD_gee\\output\\EFD_Landsat_CR_b4_win5_reclass.tif"
imported_raster=raster(str_name)
print(imported_raster)
Max_VI11 <- as.data.frame(imported_raster, xy = FALSE)
b4_w5 <- as.vector(Max_VI11)


# #b4_w7
str_name = "C:\\EFT\\EFD\\percentiles\\EFD_gee\\output\\EFD_Landsat_CR_b4_win7_reclass.tif"
imported_raster=raster(str_name)
print(imported_raster)
Greening_VI11 <- as.data.frame(imported_raster, xy = FALSE)
b4_w7 <- as.vector(Greening_VI11)


# #******************************************two linears***********************************************
# #Subset valid value for both variables
index <- which(b2_w3 >= 0 & b2_w3 <= 1 &
                 b4_w3 >= 0 & b4_w3 <= 1 &
                 b4_w5 >= 0 & b4_w5 <= 1 &
                 b4_w7 >= 0 & b4_w7 <= 1)
x <- b2_w3[index,1]
y1 <- b2_w5[index,1]
y2 <- b2_w7[index,1]
y3 <- b4_w3[index,1]
y4 <- b4_w5[index,1]
y5 <- b4_w7[index,1]

# this presents both variables on the same line, as desired
maxs <- c(max(x),max(y1),max(y2),max(y3),max(y4),max(y5))
print(maxs)

# this presents both variables on the same line, as desired
mins <- c(min(x),min(y1),min(y2),min(y3),min(y4),min(y5))
print(mins)

X1 <-as.matrix(x)
Y1 <-as.matrix(y1)
Y2 <-as.matrix(y2)
Y3 <-as.matrix(y3)
Y4 <-as.matrix(y4)
Y5 <-as.matrix(y5)

my_data <- cbind(X1,Y1,Y2,Y3,Y4,Y5)
Y <- cbind(X1,Y1,Y2,Y3,Y4,Y5)

# #https://rstudio-pubs-static.s3.amazonaws.com/240657_5157ff98e8204c358b2118fa69162e18.html
cor_1 <- round(cor(my_data), 2)
cor_2 <- rcorr(as.matrix(my_data))

result1_r = cor_1
result1_p = cor_2$P
res <- rbind(result1_r,result1_p)
write.csv(res,"C:\\EFT\\EFD\\Landsat_EFDs_correlations.csv")
