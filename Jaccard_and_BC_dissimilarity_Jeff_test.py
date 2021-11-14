# estimate Jaccard and BC dissimilarity
import numpy as np
import pandas as pd
import pymc3 as pm
import rasterio
import rasterio.plot
import geopandas as gpd
import rasterio.features
import matplotlib.pyplot as plt
import scipy
import seaborn as sns
​
#Define EFT map
eftMap = rasterio.open(r'C:\Costa_Rica\EFT\TFE1-45_CR.tif')
​
​
#Define main function
def mainFunction(filePath, code):
​
    #Read in shapefile
    ecoregions = gpd.read_file(filePath)

    #Reproject shapefile to EFT crs
    ecoregions = ecoregions.to_crs(eftMap.crs)
​
    #Do same data minipulating
    if code == 'codigoC':
        ecoregions['codigoC'] = ecoregions['codigo'].str.replace('C','')


    #Read in EFT map
    out_arr = eftMap.read(1)
    meta = eftMap.meta.copy()
​
    #Rasterize the ecoregion shapefile onto the rasters extent and resolution
    for i in pd.unique(ecoregions[code]):
        toBurn = ecoregions[ecoregions[code] == i]
        shapes = toBurn['geometry']
        burned = rasterio.features.rasterize(shapes=shapes, fill = 0, out=out_arr, transform=eftMap.transform, default_value=i)
​

    #Make array to define communities
    communities = burned * 0
​
    #Define the size of the community (coummity will be x**2 'individuals')
    commSize = 10
​
    #Counters
    x = 0
    y = 0
    z = 0


    #Assign communities
    while x < communities.shape[0] and y < communities.shape[1]:

        if x+commSize+1 < communities.shape[0] and y+commSize+1 < communities.shape[1]:
            communities[x:x+commSize+1 , y:y+commSize+1] = z
        elif x+commSize+1 > communities.shape[0] and y+commSize+1 < communities.shape[1]:
            communities[x:, y:y+commSize+1] = z
        elif x+commSize+1 < communities.shape[0] and y+commSize+1 > communities.shape[1]:
            communities[x:x+commSize+1 , y:] = z
        else:
            communities[x:,y:] = z
        x += commSize
        z += 1

        if x >= communities.shape[0]:
            x = 0
            y += commSize

    #Mask out no data
    communities = (burned*0) + communities

​
    #Set up DF to make your community table
    commTable = pd.DataFrame(index=np.arange(0,46,1))
​
    #Read in efts
    eftDF = eftMap.read(1)

    #Loop through and subset each community
    toLoop = np.unique(communities)
    x = 0
    for i in toLoop:
        if i >= 0:

            #Subset community
            locs = np.where(communities == i)

            #Make sure the community only has 1 ecoregion
            if len(np.unique(burned[locs])) == 1:

                #Get community from bigger DF
                data = eftDF[locs]

                #REformat community to standard community table format
                toAppend = np.zeros(45)
                for j in np.arange(0,45,1):
                    toAppend[j] = len(data[data == j + 1])

                toAppend = np.append(np.unique(burned[locs]), toAppend)

                #Add the resultant community to my DF of communities
                commTable[str('comm' + str(i))] = toAppend

                x += 1

        #Set upper limit of how many communities we should be sampling
        if x >= 10000:
            break

    #Make DF for results to graph
    finalDF = pd.DataFrame()
    x = 0

    #Loop through a number of pair-wise comparisons
    while x < 1000:

        #Draw a pairwise sample
        s1 = commTable.sample(2, axis = 1)

        #See if the 2 communities are in the same ecoregion
        if s1.iloc[0,0] == s1.iloc[0,1]:
            sameEco = True
        else:
            sameEco = False

        #Calculated bray-curtis
        s1 = s1.iloc[1:,:]
        bc = float(scipy.spatial.distance.pdist(s1.T.values, metric = 'braycurtis'))

        #Calculate jaccard
        s1[s1 > 1] = 1
        jaccard = float(scipy.spatial.distance.pdist(s1.T.values, metric = 'jaccard'))

        chao = 0

        #Calculate distance
        c1, c2 = list(s1)
        c1, c2 = float(c1[4:]), float(c2[4:])

        x1, y1 = np.mean(np.where(communities == c1), axis = 1)
        x2, y2 = np.mean(np.where(communities == c2), axis = 1)
        geoDist = ((x2 - x1) ** 2 + (y2 - y1) ** 2) ** 0.5

        #fill final DF
        toAppend = [sameEco, bc, jaccard, chao, geoDist]
        finalDF = finalDF.append(pd.DataFrame(toAppend).T)
        x += 1




    #Make som graphs
    finalDF = finalDF.rename(columns = {0:'sameEco', 1:'BC', 2:'jaccard', 3:'chao', 4:'geographic'})
    finalDF[['BC', 'jaccard', 'chao', 'geographic']] =  finalDF[['BC', 'jaccard', 'chao', 'geographic']].astype('float')
​
    #BC graph
    finalDF2 = finalDF[finalDF.geographic < 500]
    sns.lmplot(x = 'geographic', y = 'BC', hue = 'sameEco', data = finalDF2, x_bins = 10, logx = True)
    plt.show()
​
    #Jaccard graph
    finalDF2 = finalDF[finalDF.geographic < 500]
    sns.lmplot(x = 'geographic', y = 'jaccard', hue = 'sameEco', data = finalDF2, x_bins = 10, logx = True)
    plt.show()
​
​
#Function that takes a path to any shapefile and makes the above graphs comparing EFT communities to geographic distance and if they're in the same zone
#mainFunction(r"C:\Users\jeffr\Documents\Academic\Stanford\EFTs\Data\ecoregions\ecorregiones_2011.shp", 'codigo')
#mainFunction(r"C:\Users\jeffr\Documents\Academic\Stanford\EFTs\Data\floristic\unidades_fitogeograficas_2014.shp", 'codigoC')
#mainFunction(r"C:\Users\jeffr\Documents\Academic\Stanford\EFTs\Data\lifeZones\zonasdevida.shp", 'zonas_id')
#mainFunction(r"C:\Users\jeffr\Documents\Academic\Data\GIS_layers\Ecoregions_2017\Ecoregions2017\Ecoregions2017.shp", 'ECO_ID')

mainFunction(r"C:\Costa_Rica\EFT\Life_zones\zonas_de_vida\zonasdevida.shp", 'zonas_id')
