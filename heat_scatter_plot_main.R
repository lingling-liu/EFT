remove(list=ls()) 

# devtools::install_github("wilkelab/cowplot")
# install.packages("colorspace")
# devtools::install_github("clauswilke/colorblindr")

# remove.packages(c("ggplot2", "data.table"))
# install.packages('Rcpp', dependencies = TRUE)
#install.packages('ggplot2', dependencies = TRUE)
# install.packages('data.table', dependencies = TRUE)

library(ggplot2)
library(grid)
library(gridExtra)
library(viridis)
library(tiff)
library(raster)
library(rgdal)
library(circular)
library(Rfast)
library(Hmisc)
library(sjlabelled)
library(Metrics)
library(cowplot)
library(colorspace)
#library(colorblindr)

#https://rpubs.com/LMunyan/363306
#read in required packages
require(readxl)
require(tidyverse)

#set the working directory from which the files will be read from
setwd("C:\\EFT\\EFD\\CR\\nodata\\1km")


#create a list of the files from your target directory
file_list <- list.files(path="C:\\EFT\\EFD\\CR\\nodata\\1km",pattern = "tif")

#initiate a blank data frame, each iteration of the loop will append the data from the given file to this variable
dataset <- data.frame()

str_name = file_list[1]
imported_raster=raster(str_name)
mean11 <- as.data.frame(imported_raster, xy = FALSE)
temp_data  <- as.vector(mean11)
dataset <- rbind(dataset, temp_data) #for each iteration, bind the new data to the building dataset


for (i in 2:length(file_list)){
  print(i)
  str_name = file_list[i]
  print(str_name)
  imported_raster=raster(str_name)
  mean11 <- as.data.frame(imported_raster, xy = FALSE)
  temp_data  <- as.vector(mean11)
  dataset <- cbind(dataset, temp_data) #for each iteration, bind the new data to the building dataset
}

# Applying colnames
colnames(dataset) <- c('Landsat_b2_w3', 'Landsat_b2_w5','Landsat_b2_w7', 'Landsat_b4_w3','Landsat_b4_w5','Landsat_b4_w7',
                       'MODIS_b2_w3', 'MODIS_b2_w5','MODIS_b2_w7', 'MODIS_b4_w3','MODIS_b4_w5','MODIS_b4_w7') 

dataset[is.na(dataset)] <- -9999

#write.csv(dataset,"C:\\EFT\\EFD\\percentiles\\EFD_gee\\test_df.csv", row.names = TRUE)

#https://slowkow.com/notes/ggplot2-color-by-density/
# Get density of points in 2 dimensions.
# @param x A numeric vector.
# @param y A numeric vector.
# @param n Create a square n by n grid to compute density.
# @return The density within each square.
get_density <- function(x, y, ...) {
  dens <- MASS::kde2d(x, y, ...)
  ix <- findInterval(x, dens$x)
  iy <- findInterval(y, dens$y)
  ii <- cbind(ix, iy)
  return(dens$z[ii])
}

rsq <- function(x, y) summary(lm(y~x))$r.squared


myplots <- list() 
i <- 1

# for(MODIS in c('MODIS_b2_w3', 'MODIS_b2_w5','MODIS_b2_w7','Landsat_b2_w3', 'Landsat_b2_w5','Landsat_b2_w7')){
#   for(Landsat in c('MODIS_b4_w3','MODIS_b4_w5','MODIS_b4_w7','Landsat_b4_w3','Landsat_b4_w5','Landsat_b4_w7')){
#a****************************************************************
    MODIS <- 'MODIS_b2_w3'
    Landsat <- 'MODIS_b4_w3'
    print(MODIS)
    print(Landsat)

    x1 <- dataset[MODIS]
    y1 <- dataset[Landsat]
    
    index <- which(x1 != -9999 & y1 != -9999)
    
    x <- x1[index,1]
    y <- y1[index,1]
    print(c(min(x),max(x)))
    print(c(min(y),max(y)))
    
    
    # xlabel <- MODIS
    # Ylabel <- Landsat
  
    rmse <- (sum((y-x)**2, na.rm =T) / length(y))**0.5
    rsquared <- rsq(x, y)
    print(c(MODIS, Landsat, rmse, rsquared))
 
    dat <- as.data.frame(cbind(x,y))
    
    reg<-lm(formula = y ~ x,
            data=dat)                      
    
    #get intercept and slope value
    coeff<-coefficients(reg)          
    intercept<-coeff[1]
    slope<- coeff[2]
    
    dat$density <- get_density(dat$x, dat$y, n = 100)
    a <- ggplot(dat) + geom_point(aes(x, y, color = density)) +
      #scale_color_viridis(option="mako") +
      #scale_color_viridis() +
      # https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html
      xlab(MODIS) +
      ylab(Landsat) +
      # a and d
      scale_x_continuous(limits = c(1,8)) +
      scale_y_continuous(limits = c(1,8)) +
      # # b and e
      # xlim(1, 15) +
      # ylim(1, 15) +
      # # c and f
      # xlim(1, 25) +
      # ylim(1, 25) +
      #https://www.geeksforgeeks.org/add-regression-line-to-ggplot2-plot-in-r/
      geom_abline(intercept = intercept , slope = slope,color="red", 
                  linetype="dashed", size=1) +
      #annotate('text', x= 1.3, y = 5.5, label = paste('RMSE of', round(rmse,3))) +
      annotate('text', x= 2.5, y = 8, label = paste('R2 of', round(rsquared,3))) +
      annotate('text', x= 8, y = 8, label = paste('(a)')) +
      theme_classic() +
      theme(legend.position = "none",axis.text=element_text(size=10), axis.title=element_text(size=10)) 
    #print(a)
    myplots[[1]] <- a

#b******************************************************************
    
    MODIS <- 'MODIS_b2_w5'
    Landsat <- 'MODIS_b4_w5'
    print(MODIS)
    print(Landsat)
    
    x1 <- dataset[MODIS]
    y1 <- dataset[Landsat]
    
    index <- which(x1 != -9999 & y1 != -9999)
    
    x <- x1[index,1]
    y <- y1[index,1]
    print(c(min(x),max(x)))
    print(c(min(y),max(y)))
    
    
    # xlabel <- MODIS
    # Ylabel <- Landsat
    
    rmse <- (sum((y-x)**2, na.rm =T) / length(y))**0.5
    rsquared <- rsq(x, y)
    print(c(MODIS, Landsat, rmse, rsquared))
    
    dat <- as.data.frame(cbind(x,y))
    
    reg<-lm(formula = y ~ x,
            data=dat)                      
    
    #get intercept and slope value
    coeff<-coefficients(reg)          
    intercept<-coeff[1]
    slope<- coeff[2]
    
    dat$density <- get_density(dat$x, dat$y, n = 100)
    a <- ggplot(dat) + geom_point(aes(x, y, color = density)) +
      #scale_color_viridis(option="mako") +
      #scale_color_viridis() +
      # https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html
      xlab(MODIS) +
      ylab(Landsat) +
      # a and d
      scale_x_continuous(limits = c(1,15)) +
      scale_y_continuous(limits = c(1,15)) +
      # # b and e
      # xlim(1, 15) +
      # ylim(1, 15) +
      # # c and f
      # xlim(1, 25) +
      # ylim(1, 25) +
      #https://www.geeksforgeeks.org/add-regression-line-to-ggplot2-plot-in-r/
      geom_abline(intercept = intercept , slope = slope,color="red", 
                  linetype="dashed", size=1) +
      #annotate('text', x= 1.3, y = 5.5, label = paste('RMSE of', round(rmse,3))) +
      annotate('text', x= 12, y = 12, label = paste('R2 of', round(rsquared,3))) +
      annotate('text', x= 15, y = 15, label = paste('(b)')) +
      theme_classic() +
      theme(legend.position = "none",axis.text=element_text(size=10), axis.title=element_text(size=10)) 
    #print(a)
    myplots[[2]] <- a
    
    
    
#c******************************************************************
    
    MODIS <- 'MODIS_b2_w7'
    Landsat <- 'MODIS_b4_w7'
    print(MODIS)
    print(Landsat)
    
    x1 <- dataset[MODIS]
    y1 <- dataset[Landsat]
    
    index <- which(x1 != -9999 & y1 != -9999)
    
    x <- x1[index,1]
    y <- y1[index,1]
    print(c(min(x),max(x)))
    print(c(min(y),max(y)))
    
    
    # xlabel <- MODIS
    # Ylabel <- Landsat
    
    rmse <- (sum((y-x)**2, na.rm =T) / length(y))**0.5
    rsquared <- rsq(x, y)
    print(c(MODIS, Landsat, rmse, rsquared))
    
    dat <- as.data.frame(cbind(x,y))
    
    reg<-lm(formula = y ~ x,
            data=dat)                      
    
    #get intercept and slope value
    coeff<-coefficients(reg)          
    intercept<-coeff[1]
    slope<- coeff[2]
    
    dat$density <- get_density(dat$x, dat$y, n = 100)
    a <- ggplot(dat) + geom_point(aes(x, y, color = density)) +
      #scale_color_viridis(option="mako") +
      #scale_color_viridis() +
      # https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html
      xlab(MODIS) +
      ylab(Landsat) +
      # a and d
      scale_x_continuous(limits = c(1,25)) +
      scale_y_continuous(limits = c(1,25)) +
      # # b and e
      # xlim(1, 15) +
      # ylim(1, 15) +
      # # c and f
      # xlim(1, 25) +
      # ylim(1, 25) +
      #https://www.geeksforgeeks.org/add-regression-line-to-ggplot2-plot-in-r/
      geom_abline(intercept = intercept , slope = slope,color="red", 
                  linetype="dashed", size=1) +
      #annotate('text', x= 1.3, y = 5.5, label = paste('RMSE of', round(rmse,3))) +
      annotate('text', x= 6, y = 25, label = paste('R2 of', round(rsquared,3))) +
      annotate('text', x= 25, y = 25, label = paste('(c)')) +
      theme_classic() +
      theme(legend.position = "none",axis.text=element_text(size=10), axis.title=element_text(size=10)) 
    #print(a)
    myplots[[3]] <- a
    
    
    
#d******************************************************
    MODIS <- 'Landsat_b2_w3'
    Landsat <- 'Landsat_b4_w3'
    print(MODIS)
    print(Landsat)
    
    x1 <- dataset[MODIS]
    y1 <- dataset[Landsat]
    
    index <- which(x1 != -9999 & y1 != -9999)
    
    x <- x1[index,1]
    y <- y1[index,1]
    print(c(min(x),max(x)))
    print(c(min(y),max(y)))
    
    
    # xlabel <- MODIS
    # Ylabel <- Landsat
    
    rmse <- (sum((y-x)**2, na.rm =T) / length(y))**0.5
    rsquared <- rsq(x, y)
    print(c(MODIS, Landsat, rmse, rsquared))
    
    dat <- as.data.frame(cbind(x,y))
    
    reg<-lm(formula = y ~ x,
            data=dat)                      
    
    #get intercept and slope value
    coeff<-coefficients(reg)          
    intercept<-coeff[1]
    slope<- coeff[2]
    
    dat$density <- get_density(dat$x, dat$y, n = 100)
    a <- ggplot(dat) + geom_point(aes(x, y, color = density)) +
      #scale_color_viridis(option="mako") +
      #scale_color_viridis() +
      # https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html
      xlab(MODIS) +
      ylab(Landsat) +
      # a and d
      scale_x_continuous(limits = c(1,8)) +
      scale_y_continuous(limits = c(1,8)) +
      # # b and e
      # xlim(1, 15) +
      # ylim(1, 15) +
      # # c and f
      # xlim(1, 25) +
      # ylim(1, 25) +
      #https://www.geeksforgeeks.org/add-regression-line-to-ggplot2-plot-in-r/
      geom_abline(intercept = intercept , slope = slope,color="red", 
                  linetype="dashed", size=1) +
      #annotate('text', x= 1.3, y = 5.5, label = paste('RMSE of', round(rmse,3))) +
      annotate('text', x= 2.5, y = 8, label = paste('R2 of', round(rsquared,3))) +
      annotate('text', x= 8, y = 8, label = paste('(d)')) +
      theme_classic() +
      theme(legend.position = "none",axis.text=element_text(size=10), axis.title=element_text(size=10)) 
    #print(a)
    myplots[[4]] <- a
    
#e******************************************************************
    
    MODIS <- 'Landsat_b2_w5'
    Landsat <- 'Landsat_b4_w5'
    print(MODIS)
    print(Landsat)
    
    x1 <- dataset[MODIS]
    y1 <- dataset[Landsat]
    
    index <- which(x1 != -9999 & y1 != -9999)
    
    x <- x1[index,1]
    y <- y1[index,1]
    print(c(min(x),max(x)))
    print(c(min(y),max(y)))
    
    
    # xlabel <- MODIS
    # Ylabel <- Landsat
    
    rmse <- (sum((y-x)**2, na.rm =T) / length(y))**0.5
    rsquared <- rsq(x, y)
    print(c(MODIS, Landsat, rmse, rsquared))
    
    dat <- as.data.frame(cbind(x,y))
    
    reg<-lm(formula = y ~ x,
            data=dat)                      
    
    #get intercept and slope value
    coeff<-coefficients(reg)          
    intercept<-coeff[1]
    slope<- coeff[2]
    
    dat$density <- get_density(dat$x, dat$y, n = 100)
    a <- ggplot(dat) + geom_point(aes(x, y, color = density)) +
      #scale_color_viridis(option="mako") +
      #scale_color_viridis() +
      # https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html
      xlab(MODIS) +
      ylab(Landsat) +
      # a and d
      scale_x_continuous(limits = c(1,15)) +
      scale_y_continuous(limits = c(1,15)) +
      # # b and e
      # xlim(1, 15) +
      # ylim(1, 15) +
      # # c and f
      # xlim(1, 25) +
      # ylim(1, 25) +
      #https://www.geeksforgeeks.org/add-regression-line-to-ggplot2-plot-in-r/
      geom_abline(intercept = intercept , slope = slope,color="red", 
                  linetype="dashed", size=1) +
      #annotate('text', x= 1.3, y = 5.5, label = paste('RMSE of', round(rmse,3))) +
      annotate('text', x= 4, y = 15, label = paste('R2 of', round(rsquared,3))) +
      annotate('text', x= 15, y = 15, label = paste('(e)')) +
      theme_classic() +
      theme(legend.position = "none",axis.text=element_text(size=10), axis.title=element_text(size=10)) 
    #print(a)
    myplots[[5]] <- a
    
    
    
#f******************************************************************
    
    MODIS <- 'Landsat_b2_w7'
    Landsat <- 'Landsat_b4_w7'
    print(MODIS)
    print(Landsat)
    
    x1 <- dataset[MODIS]
    y1 <- dataset[Landsat]
    
    index <- which(x1 != -9999 & y1 != -9999)
    
    x <- x1[index,1]
    y <- y1[index,1]
    print(c(min(x),max(x)))
    print(c(min(y),max(y)))
    
    
    # xlabel <- MODIS
    # Ylabel <- Landsat
    
    rmse <- (sum((y-x)**2, na.rm =T) / length(y))**0.5
    rsquared <- rsq(x, y)
    print(c(MODIS, Landsat, rmse, rsquared))
    
    dat <- as.data.frame(cbind(x,y))
    
    reg<-lm(formula = y ~ x,
            data=dat)                      
    
    #get intercept and slope value
    coeff<-coefficients(reg)          
    intercept<-coeff[1]
    slope<- coeff[2]
    
    dat$density <- get_density(dat$x, dat$y, n = 100)
    a <- ggplot(dat) + geom_point(aes(x, y, color = density)) +
      #scale_color_viridis(option="mako") +
      #scale_color_viridis() +
      # https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html
      xlab(MODIS) +
      ylab(Landsat) +
      # a and d
      scale_x_continuous(limits = c(1,25)) +
      scale_y_continuous(limits = c(1,25)) +
      # # b and e
      # xlim(1, 15) +
      # ylim(1, 15) +
      # # c and f
      # xlim(1, 25) +
      # ylim(1, 25) +
      #https://www.geeksforgeeks.org/add-regression-line-to-ggplot2-plot-in-r/
      geom_abline(intercept = intercept , slope = slope,color="red", 
                  linetype="dashed", size=1) +
      #annotate('text', x= 1.3, y = 5.5, label = paste('RMSE of', round(rmse,3))) +
      annotate('text', x= 6, y = 25, label = paste('R2 of', round(rsquared,3))) +
      annotate('text', x= 25, y = 25, label = paste('(f)')) +
      theme_classic() +
      theme(legend.position = "none",axis.text=element_text(size=10), axis.title=element_text(size=10)) 
    #print(a)
    myplots[[6]] <- a
    
    
    
#g************************************************************
    
    MODIS <- 'MODIS_b4_w7'
    Landsat <- 'Landsat_b4_w7'
    print(MODIS)
    print(Landsat)
    
    x1 <- dataset[MODIS]
    y1 <- dataset[Landsat]
    
    index <- which(x1 != -9999 & y1 != -9999)
    
    x <- x1[index,1]
    y <- y1[index,1]
    print(c(min(x),max(x)))
    print(c(min(y),max(y)))
    
    
    # xlabel <- MODIS
    # Ylabel <- Landsat
    
    rmse <- (sum((y-x)**2, na.rm =T) / length(y))**0.5
    rsquared <- rsq(x, y)
    print(c(MODIS, Landsat, rmse, rsquared))
    
    dat <- as.data.frame(cbind(x,y))
    
    reg<-lm(formula = y ~ x,
            data=dat)                      
    
    #get intercept and slope value
    coeff<-coefficients(reg)          
    intercept<-coeff[1]
    slope<- coeff[2]
    
    dat$density <- get_density(dat$x, dat$y, n = 100)
    a <- ggplot(dat) + geom_point(aes(x, y, color = density)) +
      #scale_color_viridis(option="mako") +
      #scale_color_viridis() +
      # https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html
      xlab(MODIS) +
      ylab(Landsat) +
      # a and d
      scale_x_continuous(limits = c(1,25)) +
      scale_y_continuous(limits = c(1,25)) +
      # # b and e
      # xlim(1, 15) +
      # ylim(1, 15) +
      # # c and f
      # xlim(1, 25) +
      # ylim(1, 25) +
      #https://www.geeksforgeeks.org/add-regression-line-to-ggplot2-plot-in-r/
      geom_abline(intercept = intercept , slope = slope,color="red", 
                  linetype="dashed", size=1) +
      #annotate('text', x= 1.3, y = 5.5, label = paste('RMSE of', round(rmse,3))) +
      annotate('text', x= 6, y = 25, label = paste('R2 of', round(rsquared,3))) +
      annotate('text', x= 25, y = 25, label = paste('(g)')) +
      theme_classic() +
      theme(legend.position = "none",axis.text=element_text(size=10), axis.title=element_text(size=10)) 
    #print(a)
    myplots[[7]] <- a
    
#**h*******************************************************
      
    
    #initiate a blank data frame, each iteration of the loop will append the data from the given file to this variable
    dataset1 <- data.frame()
    
    str_name = "C:\\EFT\\EFD\\clip\\nodata\\resample\\EFD_Landsat_NP_clipped_b4_win7_nodata0_compressed_90m.tif"
    imported_raster=raster(str_name)
    mean11 <- as.data.frame(imported_raster, xy = FALSE)
    temp_data  <- as.vector(mean11)
    dataset1 <- rbind(dataset1, temp_data) #for each iteration, bind the new data to the building dataset
    

    str_name = "C:\\EFT\\EFD\\NP\\nodata\\resample\\EFD_Landsat_NP_b4_win7_nodata0_compressed_90m.tif"
    print(str_name)
    imported_raster=raster(str_name)
    mean11 <- as.data.frame(imported_raster, xy = FALSE)
    temp_data  <- as.vector(mean11)
    dataset1 <- cbind(dataset1, temp_data) #for each iteration, bind the new data to the building dataset

    
    # Applying colnames
    colnames(dataset1) <- c('Nationally Derived', 'Locally Derived') 
    
    dataset1[is.na(dataset1)] <- -9999
    
    MODIS <- 'Nationally Derived'
    Landsat <- 'Locally Derived'
    
    x1 <- dataset1[MODIS]
    y1 <- dataset1[Landsat]
    
    index <- which(x1 != -9999 & y1 != -9999)
    x <- x1[index,1]
    y <- y1[index,1]
    
    
    print(c(min(x),max(x)))
    print(c(min(y),max(y)))
    
    
    # xlabel <- MODIS
    # Ylabel <- Landsat
    
    rmse <- (sum((y-x)**2, na.rm =T) / length(y))**0.5
    rsquared <- rsq(x, y)
    print(c(MODIS, Landsat, rmse, rsquared))
    
    dat <- as.data.frame(cbind(x,y))
    
    reg<-lm(formula = y ~ x,
            data=dat)                      
    
    #get intercept and slope value
    coeff<-coefficients(reg)          
    intercept<-coeff[1]
    slope<- coeff[2]
    
    
    dat_all <- as.data.frame(cbind(x,y))
    dat <- dat_all[sample(nrow(dat_all), 200000),]
    dat$density <- get_density(dat$x, dat$y, n = 100)
    a <- ggplot(dat) + geom_point(aes(x, y, color = density)) +
      #scale_color_viridis() +
      xlab(expression(atop("Landsat, Nationally Derived", paste("b4_w7_Nicoya Peninsula")))) +
      ylab(expression(atop("Landsat, Locally Derived", paste("b4_w7_Nicoya Peninsula")))) +
      scale_x_continuous(limits = c(1,25)) +
      scale_y_continuous(limits = c(1,25)) +
      #geom_abline(intercept = 0, slope = 1) +
      #annotate('text', x= 1.3, y = 5.5, label = paste('RMSE of', round(rmse,3))) +
      geom_abline(intercept = intercept , slope = slope,color="red", 
                  linetype="dashed", size=1) +
      #annotate('text', x= 1.3, y = 5.5, label = paste('RMSE of', round(rmse,3))) +
      annotate('text', x= 7, y = 25, label = paste('R2 of', round(rsquared,3))) +
      annotate('text', x= 24, y = 25, label = paste('(h)')) +
      theme_classic() +
      theme(legend.position = "none",axis.text=element_text(size=10), axis.title=element_text(size=10)) 
    myplots[[8]] <- a
    
    
#**i*******************************************************
    
    
    #initiate a blank data frame, each iteration of the loop will append the data from the given file to this variable
    dataset1 <- data.frame()
    
    str_name = "C:\\EFT\\EFD\\NP\\MODIS\\nodata\\EFD_MODIS_NP_b4_clipped_win7_nodata0_1km.tif"
    
    imported_raster=raster(str_name)
    mean11 <- as.data.frame(imported_raster, xy = FALSE)
    temp_data  <- as.vector(mean11)
    dataset1 <- rbind(dataset1, temp_data) #for each iteration, bind the new data to the building dataset
    
    
    str_name = "C:\\EFT\\EFD\\NP\\MODIS\\nodata\\EFD_MODIS_NP_b4_win7_nodata0_1km.tif"
    print(str_name)
    imported_raster=raster(str_name)
    mean11 <- as.data.frame(imported_raster, xy = FALSE)
    temp_data  <- as.vector(mean11)
    dataset1 <- cbind(dataset1, temp_data) #for each iteration, bind the new data to the building dataset
    
    
    # Applying colnames
    colnames(dataset1) <- c('Nationally Derived', 'Locally Derived') 
    
    dataset1[is.na(dataset1)] <- -9999
    
    MODIS <- 'Nationally Derived'
    Landsat <- 'Locally Derived'
    
    x1 <- dataset1[MODIS]
    y1 <- dataset1[Landsat]
    
    index <- which(x1 != -9999 & y1 != -9999)
    x <- x1[index,1]
    y <- y1[index,1]
    
    
    print(c(min(x),max(x)))
    print(c(min(y),max(y)))
    
    
    # xlabel <- MODIS
    # Ylabel <- Landsat
    
    rmse <- (sum((y-x)**2, na.rm =T) / length(y))**0.5
    rsquared <- rsq(x, y)
    print(c(MODIS, Landsat, rmse, rsquared))
    
    dat <- as.data.frame(cbind(x,y))
    
    reg<-lm(formula = y ~ x,
            data=dat)                      
    
    #get intercept and slope value
    coeff<-coefficients(reg)          
    intercept<-coeff[1]
    slope<- coeff[2]
    
    
    # dat_all <- as.data.frame(cbind(x,y))
    # dat <- dat_all[sample(nrow(dat_all), 200000),]
    dat$density <- get_density(dat$x, dat$y, n = 100)
    a <- ggplot(dat) + geom_point(aes(x, y, color = density)) +
      #scale_color_viridis() +
      xlab(expression(atop("MODIS, Nationally Derived", paste("b4_w7_Nicoya Peninsula")))) +
      ylab(expression(atop("MODIS, Locally Derived", paste("b4_w7_Nicoya Peninsula")))) +
      scale_x_continuous(limits = c(1,25)) +
      scale_y_continuous(limits = c(1,25)) +
      #geom_abline(intercept = 0, slope = 1) +
      #annotate('text', x= 1.3, y = 5.5, label = paste('RMSE of', round(rmse,3))) +
      geom_abline(intercept = intercept , slope = slope,color="red", 
                  linetype="dashed", size=1) +
      #annotate('text', x= 1.3, y = 5.5, label = paste('RMSE of', round(rmse,3))) +
      annotate('text', x= 7, y = 25, label = paste('R2 of', round(rsquared,3))) +
      annotate('text', x= 24, y = 25, label = paste('(i)')) +
      theme_classic() +
      theme(legend.position = "none",axis.text=element_text(size=10), axis.title=element_text(size=10)) 
    myplots[[9]] <- a   
    
   
    
    
#https://stackoverflow.com/questions/17059099/saving-grid-arrange-plot-to-file

p4 <- arrangeGrob(myplots[[1]],myplots[[2]],myplots[[3]],
                  myplots[[4]],myplots[[5]],myplots[[6]],
                  myplots[[7]],myplots[[8]],myplots[[9]],
                  nrow = 3)
ggsave("C:\\EFT\\Fig\\Figure3.jpg", p4,width = 18, height = 18, units = "cm")