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
str_name = "C:\\EFT\\EFD\\percentiles\\output\\EFD_MODIS_EVI_2001_2017_2_2_window_size_3_reclass.tif" 
#loading data sets
imported_raster=raster(str_name)
print(imported_raster)
mean11 <- as.data.frame(imported_raster, xy = FALSE)
b2_w3 <- as.vector(mean11)

# #b2_w5
str_name = "C:\\EFT\\EFD\\percentiles\\output\\EFD_MODIS_EVI_2001_2017_2_2_window_size_5_reclass.tif"
imported_raster=raster(str_name)
print(imported_raster)
SD11 <- as.data.frame(imported_raster, xy = FALSE)
b2_w5 <- as.vector(SD11)


# #b2_w7
str_name = "C:\\EFT\\EFD\\percentiles\\output\\EFD_MODIS_EVI_2001_2017_2_2_window_size_7_reclass.tif"
imported_raster=raster(str_name)
print(imported_raster)
CV11 <- as.data.frame(imported_raster, xy = FALSE)
b2_w7 <- as.vector(CV11)


# #b4_w3
str_name = "C:\\EFT\\EFD\\percentiles\\output\\EFD_Landsat7_EVI_2001_2017_4_4_window_size_3_reclass.tif"
imported_raster=raster(str_name)
print(imported_raster)
Min_VI11 <- as.data.frame(imported_raster, xy = FALSE)
b4_w3 <- as.vector(Min_VI11)

# #b4_w5
str_name = "C:\\EFT\\EFD\\percentiles\\output\\EFD_Landsat7_EVI_2001_2017_4_4_window_size_5_reclass.tif"
imported_raster=raster(str_name)
print(imported_raster)
Max_VI11 <- as.data.frame(imported_raster, xy = FALSE)
b4_w5 <- as.vector(Max_VI11)


# #b4_w7
str_name = "C:\\EFT\\EFD\\percentiles\\output\\EFD_Landsat7_EVI_2001_2017_4_4_window_size_7_reclass.tif"
imported_raster=raster(str_name)
print(imported_raster)
Greening_VI11 <- as.data.frame(imported_raster, xy = FALSE)
b4_w7 <- as.vector(Greening_VI11)


# #******************************************two linears***********************************************
# #Subset valid value for both variables
index <- which(b2_w3 >= 0 & b2_w3 <= 1 &
                 b4_w3 >= 0 & b4_w3 <= 1)
x <- b2_w3[index,1]
y1 <- b2_w5[index,1]
y2 <- b2_w7[index,1]
y3 <- b4_w3[index,1]
y4<- b4_w5[index,1]
y5 <- b4_w7[index,1]

# this presents both variables on the same line, as desired
output <- c(max(x),max(y1),max(y2),max(y3),max(y4),max(y5))
print(output)


X1 <-as.matrix(x)
Y1 <-as.matrix(y1)
Y2 <-as.matrix(y2)
Y3 <-as.matrix(y3)
Y4 <-as.matrix(y4)
Y5 <-as.matrix(y5)




# my_data <- cbind(X1,Y1,Y2,Y3,Y4,Y5,Y6)
# Y <- cbind(X1,Y1,Y2,Y3,Y4,Y5,Y6)

# #https://rstudio-pubs-static.s3.amazonaws.com/240657_5157ff98e8204c358b2118fa69162e18.html
# cor_1 <- round(cor(my_data), 2)
# cor_2 <- rcorr(as.matrix(my_data))

# result1 = cor_1
# #result1_p = cor_2$
# #(cor_2,"C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_EFAs_correlations_mean.csv")

# #*****************************************linear and circular**********************************
# index <- which(mean1 >= min_mean & mean1 <= max_mean &
#                  Max_VI1 >= min_Max_VI & Max_VI1 <= max_Max_VI)

# x_cir <- MMax1r[index,1]
# x_cir1 <- Mmin1r[index,1]
# x_cir2 <- GreenTime1r[index,1]
# x_cir3 <- BrownTime1r[index,1]

# #MMax
# X_cir <-as.matrix(x_cir)
# X_cir1 <-as.matrix(x_cir1)
# X_cir2 <-as.matrix(x_cir2)
# X_cir3 <-as.matrix(x_cir3)

# y0 <- mean1[index,1]
# y1 <- SD1[index,1]
# y2 <- CV1[index,1]
# y3 <- Max_VI1[index,1]
# y4<- Min_VI1[index,1]
# y5 <- Greening_VI1[index,1]
# y6 <- Browning_VI1[index,1]

# #MMax
# Y0 <-as.matrix(y0)
# Y1 <-as.matrix(y1)
# Y2 <-as.matrix(y2)
# Y3 <-as.matrix(y3)
# Y4 <-as.matrix(y4)
# Y5 <-as.matrix(y5)
# Y6 <-as.matrix(y6)

# Y <- cbind(Y0,Y1,Y2,Y3,Y4,Y5,Y6)

# #MMax vs
# #https://rdrr.io/cran/Rfast/man/circlin.cor.html
# #https://stackoverflow.com/questions/14596420/how-to-get-value-by-column-name-in-r
# result <- circlin.cor(X_cir, Y)
# cor0 = sqrt(result[,1])
# p0 = result[,2]

# result <- circlin.cor(X_cir1, Y)
# cor1 = sqrt(result[,1])
# p1 = result[,2]

# result <- circlin.cor(X_cir2, Y)
# cor2 = sqrt(result[,1])
# p2 = result[,2]

# result <- circlin.cor(X_cir3, Y)
# cor3 = sqrt(result[,1])
# p3 = result[,2]

# corr_res <- cbind(cor0,cor1,cor2,cor3)
# p_res <- cbind(p0,p1,p2,p3)

# #https://stat.ethz.ch/R-manual/R-devel/library/base/html/t.html
# print(t(corr_res))
# result2 <- t(corr_res)

# #write.csv(t(corr_res),"C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_EFAs_correlations_linear_circular.csv")
# #write.csv(t(p_res),"C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_EFAs_correlations_p_value_linear_circular.csv")

# #*********************************************two circular variables***********************************
# #Subset valid value for both variables
# #https://rdrr.io/cran/circular/man/cor.circular.html
# index <- which(mean1 >= min_mean & mean1 <= max_mean &
#                  Max_VI1 >= min_Max_VI & Max_VI1 <= max_Max_VI)
# x_cir <- MMax1r[index,1]
# y_cir1 <- Mmin1r[index,1]
# y_cir2 <- GreenTime1r[index,1]
# y_cir3 <- BrownTime1r[index,1]


# #MMax
# X_cir <-as.matrix(x_cir)
# Y_cir1 <-as.matrix(y_cir1)
# Y_cir2 <-as.matrix(y_cir2)
# Y_cir3 <-as.matrix(y_cir3)
# X <- cbind(X_cir,Y_cir1,Y_cir2,Y_cir3)
# Y <- cbind(X_cir,Y_cir1,Y_cir2,Y_cir3)
# result <- cor.circular(X,Y, test = TRUE)
# newdf <- result$cor
# newdf1 <- result$p.value

# result3 = newdf

# #preprocessing result3
# vec <- rep(-9999, 4)
# vec1 <-t(as.matrix(vec))
# test <- rbind(vec1,vec1,vec1,result3)

# result12 = rbind(as.data.frame(result1),as.data.frame(result2))
# result_all = cbind(result12,test)

# write.csv(result_all,"C:\\Costa_Rica\\EFT\\EFAs\\Landsat7\\Landsat7_EFAs_correlations_all_NP.csv",append = True)
