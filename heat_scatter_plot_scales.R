remove(list=ls()) 

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

#https://rpubs.com/LMunyan/363306
#read in required packages
require(readxl)
require(tidyverse)

#set the working directory from which the files will be read from
setwd("C:\\EFT\\EFD\\percentiles\\EFD_gee\\NP\\nodata\\90m\\")

#create a list of the files from your target directory
#file_list <- list.files(path="C:\\EFT\\EFD\\percentiles\\EFD_gee\\nodata\\1km",pattern = "tif")
file_list <- list.files(path="C:\\EFT\\EFD\\percentiles\\EFD_gee\\NP\\nodata\\90m\\",pattern = "tif")


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
colnames(dataset) <- c('NP_local_b2_w3', 'NP_local_b2_w5','NP_local_b2_w7', 'NP_local_b4_w3','NP_local_b4_w5','NP_local_b4_w7',
                       'NP_clipped_b2_w3', 'NP_clipped_b2_w5','NP_clipped_b2_w7', 'NP_clipped_b4_w3','NP_clipped_b4_w5','NP_clipped_b4_w7') 

dataset[is.na(dataset)] <- -9999

#write.csv(dataset,"C:\\EFT\\EFD\\percentiles\\EFD_gee\\test_df_scale.csv", row.names = TRUE)

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

for(MODIS in c('NP_local_b2_w3', 'NP_local_b2_w5','NP_local_b2_w7', 'NP_local_b4_w3','NP_local_b4_w5','NP_local_b4_w7')){
  for(Landsat in c('NP_clipped_b2_w3', 'NP_clipped_b2_w5','NP_clipped_b2_w7', 'NP_clipped_b4_w3','NP_clipped_b4_w5','NP_clipped_b4_w7')){
    print(MODIS)
    print(Landsat)

    # MODIS <- 'NP_local_b2_w3'
    # Landsat <- 'NP_clipped_b2_w3'

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
 
    dat_all <- as.data.frame(cbind(x,y))
    dat <- dat_all[sample(nrow(dat_all), 200000),]
    dat$density <- get_density(dat$x, dat$y, n = 100)
    a <- ggplot(dat) + geom_point(aes(x, y, color = density)) +
      scale_color_viridis() +
      xlab(MODIS) +
      ylab(Landsat) +
      scale_x_continuous(limits = c(0.8,max(x)+0.5)) + 
      scale_y_continuous(limits = c(0.8,max(y)+0.5)) + 
      geom_abline(intercept = 0, slope = 1) +
      #annotate('text', x= 1.3, y = 5.5, label = paste('RMSE of', round(rmse,3))) +
      annotate('text', x= 2, y = max(y)+0.3, label = paste('R2 of', round(rsquared,3))) +
      theme_classic() +
      theme(legend.position = "none") 
    myplots[[i]] <- a
    i <- i + 1
  }
}

#https://stackoverflow.com/questions/17059099/saving-grid-arrange-plot-to-file

#pdf/jpeg/png("C:\\EFT\\EFD\\percentiles\\EFD_gee\\filename.pdf", width = 10, height = 10) # Open a new pdf file
# p3 <- grid.arrange(myplots[[1]],myplots[[2]],myplots[[3]],myplots[[4]],myplots[[5]],myplots[[6]],
#              myplots[[7]],myplots[[8]],myplots[[9]],myplots[[10]],myplots[[11]],myplots[[12]],
#              myplots[[13]],myplots[[14]],myplots[[15]],myplots[[16]],myplots[[17]],myplots[[18]],
#              myplots[[19]],myplots[[20]],myplots[[21]],myplots[[22]],myplots[[23]],myplots[[24]],
#              myplots[[25]],myplots[[26]],myplots[[27]],myplots[[28]],myplots[[29]],myplots[[30]],
#              myplots[[31]],myplots[[32]],myplots[[33]],myplots[[34]],myplots[[35]],myplots[[36]],
#              nrow = 6)
#dev.off() # Close the file
p3 <- grid.arrange(myplots[[1]],myplots[[2]],myplots[[3]],myplots[[4]],myplots[[5]],myplots[[6]],
             myplots[[7]],myplots[[8]],myplots[[9]],myplots[[10]],myplots[[11]],myplots[[12]],
             myplots[[13]],myplots[[14]],myplots[[15]],myplots[[16]],myplots[[17]],myplots[[18]],
             myplots[[19]],myplots[[20]],myplots[[21]],myplots[[22]],myplots[[23]],myplots[[24]],
             myplots[[25]],myplots[[26]],myplots[[27]],myplots[[28]],myplots[[29]],myplots[[30]],
             myplots[[31]],myplots[[32]],myplots[[33]],myplots[[34]],myplots[[35]],myplots[[36]],
             nrow = 6)
# 
ggsave("C:\\EFT\\EFD\\percentiles\\EFD_gee\\EFD_scales_comparsion_90m.jpg", p3,width = 40, height = 40, units = "cm")
