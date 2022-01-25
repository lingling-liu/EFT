
          
          // Script to build EFTs on a global or local scale
// Import a shape for local EFTs
// Import a collection of Images
// Set for the middle year of the period 2001-2015
// You can modify the temporal resolution (Grain, Ext or year Avg)
// Calculate Mean, Seasonality and MMax
// Calculate quartiles for a defined area with global shape or
// Exports the image of EFTs
// Date: 19_apr_2018. 


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// 1) SETTING VARIABLES FOR ANALYSIS (Modify only these sections) ////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
var year_run = '_2001_2017'
var countries = ee.FeatureCollection("USDOS/LSIB_SIMPLE/2017");
var costa_rica = ee.FeatureCollection(countries.filter(ee.Filter.stringContains('country_na', 'Costa')));
//var costa_rica = test_ROI;
Map.setCenter (-84, 10); 


var GDriveOutputImgFolder = 'GEEOutputs';  
var VarForSeason = 'SD'; //'SD' or 'CV' Seasonality
//var Nseas = 12;// Number of seasons/months per year. Still 12 but needs to be programmed for 23

// 1.1 ) Definition of the studied period
  var FirstYear = 2001; // First year of the studied period
  var LastYear = 2017;  // Last year of the studied period
    var TimeFrame = ee.List.sequence(FirstYear, LastYear); // Do not modify this variable
    var NumberYears = LastYear - FirstYear + 1; // Do not modify this variable
var doy = ee.List.sequence(1,365,16);
var months = ee.List.sequence(1,12);
  
    
var coll1 =  L7_EVI.filterDate(String(FirstYear)+'-01-01', String(LastYear)+'-12-31'); // EVI y NDVIprint('coll1',coll1);
print("ori",coll1);   
    

// 1.3) Select the target variable/spectral index // 
var SelectedVariableName = 'EVI'; //'EVI' or 'NDVI'
var SelectedVariable = coll1.select([SelectedVariableName]); // EVI index, selected from the "MODIS/006/MOD13Q1" collection


// 1.4) Study area  // Be CAREFUL the whole world must be visualized before exportation of a particular region!!!!!!                  
  // See https://developers.google.com/earth-engine/importing for more information about hot to create and importe Feature Collections
var UseRegion = 1; // Set to 0 to compute the Globe
if (UseRegion == 1){

  var region = costa_rica;// Shape o Rectangle o Geometry
  Map.addLayer(region, {}, 'region', false);  
}

var scale = 30;// revise in 2020

//////////////////////////////////
///2) COMPUTATION OF VARIABLES ///
//////////////////////////////////

//LAND MASK from  GLOBCOVER
var GlobCover = ee.Image('ESA/GLOBCOVER_L4_200901_200912_V2_3');
// Select the anytime water mask.
var GlobCoverLandCover = GlobCover.select('landcover');
// Create a binary mask.
//Map.addLayer(NoWaterNoIceNoSnow, {min:0, max:222}, 'GLOBCOVERall');
var NoWaterNoIceNoSnow = GlobCoverLandCover.lt(210);
var mask = NoWaterNoIceNoSnow;
Map.addLayer(mask, {min:0, max:1}, 'GLOBCOVERmask', false);


// 2.1) Annual EFAs //
//Imports the MODIS image collection, the temporal subset is defined
// Function to calculate the average year

var Evi_mensual = months.map(function(m) {
  // Filter to 1 month.
  var Evi_men = SelectedVariable.filter(ee.Filter.calendarRange(m, m, 'month')).mean();
  // add month band for MMax
  var Evi_men2 = Evi_men.updateMask(mask);

return  Evi_men2.addBands(ee.Image.constant(m).select([0],['month']).int8());
});

var Evi_mensual = ee.ImageCollection(Evi_mensual);
    if (UseRegion == 1){
    var Evi_mensual = ee.ImageCollection(Evi_mensual
    .map(function(image){
      var xx = image.clip(region);
      return xx;
    }));
      }

var Evi_mensual_1band = months.map(function(m) {
  // Filter to 1 month.
  var Evi_men_1band = SelectedVariable.filter(ee.Filter.calendarRange(m, m, 'month')).mean();
  // add month band for MMax
  var Evi_men2_1band = Evi_men_1band.updateMask(mask);

 return  Evi_men2_1band;
});

//this clips collection to study area//
var Evi_mensual_1band = ee.ImageCollection(Evi_mensual_1band);
    if (UseRegion == 1){
    var Evi_mensual_1band = ee.ImageCollection(Evi_mensual_1band
    .map(function(image){
      var xx = image.clip(region);
      return xx;
    }));
    }
print(Evi_mensual_1band);

//convert a collection with 1-band images to 1 stacked image//
var stackCollection = function(Evi_mensual_1band) {
  // Create an initial image.
  var first = ee.Image(Evi_mensual_1band.first()).select([]);

  // Write a function that appends a band to an image.
  var appendBands = function(image, previous) {
    return ee.Image(previous).addBands(image);
  };
  return ee.Image(Evi_mensual_1band.iterate(appendBands, first));
};
var stacked = stackCollection(Evi_mensual_1band);
print('stacked image', stacked);
Map.addLayer(stacked, {}, 'stacked', false)

var stackedProjection = stacked.projection();
print('stacked projection:', stackedProjection);
//Map.addLayer(stacked, "stacked");


//*******************************************************//
//Cálculo de métricas o EFAs

var Media = Evi_mensual.select(SelectedVariableName).mean();
//print('Mean',Media)

//var histomean = ui.Chart.image.histogram(Media, region, 500, 12, 1);
//print("Mean", histomean);

Export.image.toAsset({
  image: Media,
  description: 'Landsat7_mean_A'+year_run,
  assetId: 'Landsat7_mean'+year_run,
  scale: scale,
  region: costa_rica,
  maxPixels: 1e13,
}) ;

Export.image.toDrive({
      image: Media,
      description: 'Landsat7_mean'+year_run,
      maxPixels: 1e13,
      region: costa_rica,
      folder: GDriveOutputImgFolder,
      scale: scale
    });

//Map.addLayer(MMax, { min: 1, max:Nseas, gamma:1.3}, "MMax");






if (VarForSeason == 'SD'){
  var Season = Evi_mensual.select([SelectedVariableName]).reduce(ee.Reducer.stdDev());
  //print('SD', Season)
  var season_SD = Season;
  
  Export.image.toAsset({
  image: Season,
  description: 'Landsat7_SD_A'+year_run,
  assetId: 'Landsat7_SD'+year_run,
  scale: scale,
  region: costa_rica,
  maxPixels: 1e13,
}) ;

Export.image.toDrive({
      image: Season,
      description: 'Landsat7_SD'+year_run,
      maxPixels: 1e13,
      region: costa_rica,
      folder: GDriveOutputImgFolder,
      scale: scale
    });
    
}

var VarForSeason = 'CV'; // for export CV

if (VarForSeason == 'CV'){
  var SD = Evi_mensual.select([SelectedVariableName]).reduce(ee.Reducer.stdDev());
  var SDabs = SD.abs();
  var Mediaabs = Media.abs();
  var Season = SDabs.divide(Mediaabs);
  
   Export.image.toAsset({
  image: Season,
  description: 'Landsat7_CV_A'+year_run,
  assetId: 'Landsat7_CV'+year_run,
  scale: scale,
  region: costa_rica,
  maxPixels: 1e13,
}) ;

Export.image.toDrive({
      image: Season,
      description: 'Landsat7_CV'+year_run,
      maxPixels: 1e13,
      region: costa_rica,
      folder: GDriveOutputImgFolder,
      scale: scale
    });
    
}
print('CV', Season);

VarForSeason == 'SD'; // for keeping consistency with start SD

//var histoSD = ui.Chart.image.histogram(Season, region, 500, 12, 1);
//print("SD", histoSD);

//Map.addLayer(Media, { min: 0, max:8000, gamma:1.3}, "Mean");
//Map.addLayer(Season, { min: 0, max:1000, gamma:1.3}, "Season");

var vizParamsMedia = {"opacity":1,min: 2500, max:7000,"palette":
["6000e8","8d00ff","3a00e6","4100af","2e00c3",
"4e0068","8000e2","5201ab","5700c2","000000","380032",
"44005c","005dff","0072ff","009dff","00b2ff",
"00dcff","00fff6","00ffcb","00ffbb",
"00ff90","00ff69","00ff3b","00ff26",
"04ff00","19ff00","2eff00","59ff00","6eff00",
"99ff00","a9ff00","bfff00","e9ff00","ffff00",
"ffd400","ffaa00","ff7f00","ff6a00",
"ff2a00","ff1500","ff0000","e90000","d40000","bf0000"]};

Map.addLayer(Media, vizParamsMedia, 'mean', false);



var vizParamsSD = {"opacity":1,min: 0, max:1200,"palette":
["6000e8","8d00ff","3a00e6","4100af","2e00c3",
"4e0068","8000e2","5201ab","5700c2","000000","380032",
"44005c","005dff","0072ff","009dff","00b2ff",
"00dcff","00fff6","00ffcb","00ffbb",
"00ff90","00ff69","00ff3b","00ff26",
"04ff00","19ff00","2eff00","59ff00","6eff00",
"99ff00","a9ff00","bfff00","e9ff00","ffff00",
"ffd400","ffaa00","ff7f00","ff6a00",
"ff2a00","ff1500","ff0000","e90000","d40000","bf0000"]};

Map.addLayer(Season, vizParamsSD, 'Season', false);
print(Evi_mensual, 'Evi_mensual');

//*****************************************************
//calculate 16-day NDVI composites for growing season using maximum
//*****************************************************

var Ndvi_mean2 = doy.map(function(m) {
var forcenum2 = ee.Number(m);
  var ndvi_mean2 = SelectedVariable.filter(ee.Filter.dayOfYear(forcenum2, forcenum2.add(16))).mean();
  var ndvi_mean3 = ndvi_mean2.updateMask(mask);
return  ndvi_mean3.addBands(ee.Image.constant(forcenum2).int16());
});

var Ndvi_mean2 = ee.ImageCollection(Ndvi_mean2);
    if (UseRegion == 1){
    var Ndvi_mean2 = ee.ImageCollection(Ndvi_mean2
    .map(function(image){
      var xx = image.clip(region);
      return xx;
    }));
      }
      
print('NDVI_mean2', Ndvi_mean2);
 
// 8-day to 16 day     
var Ndvi_mean_1band2 = doy.map(function(m) {
  var forcenum2 = ee.Number(m);
  // Filter to 8 day.
  var ndvi_mean_1band2 = SelectedVariable.filter(ee.Filter.dayOfYear(forcenum2, forcenum2.add(16))).mean();
  //look for calendar day of year function
  // add month band for MMax
  var ndvi_mean1_1band2 = ndvi_mean_1band2.updateMask(mask);
  var ndvi_mean2_1band2 = ndvi_mean1_1band2.addBands(ee.Image.constant(m).select([0],['day_of_year']).int16());
  return  ndvi_mean2_1band2;
});


//this clips collection to study area//
var Ndvi_mean_1band2 = ee.ImageCollection(Ndvi_mean_1band2);
    if (UseRegion == 1){
    var Ndvi_mean_1band2 = ee.ImageCollection(Ndvi_mean_1band2
    .map(function(image){
      var xx = image.clip(region);
      return xx;
    }));
    }
    
print('NDVI', Ndvi_mean_1band2.select("EVI"));
Map.addLayer(Ndvi_mean_1band2.select("EVI"), {}, '23_band', false);

// var spatialFiltered = Ndvi_mean_1band2.filterBounds(point);
// print('spatialFiltered', spatialFiltered);

// var ft2 = Ndvi_mean_1band2.reduceRegions(point, ee.Reducer.first(),30);
// print('ft2', ft2);

// var Mean = Ndvi_mean2.select(SelectedVariableName).mean();
// print('Mean',Mean);

// Max
 var Max = Ndvi_mean_1band2.qualityMosaic(SelectedVariableName);
 print('Max',Max);
 Map.addLayer(Max, {}, 'Max', false);
 var MMax = Max.select(['day_of_year']);
 print ('MMax', MMax);
 Map.addLayer(MMax, {}, 'MMax', false);
 
 
   Export.image.toAsset({
  image: Max.select(['EVI']),
      description: 'Landsat7_Max_VI_A'+year_run,
  assetId: 'Landsat7_MAX_VI'+year_run,
  scale: scale,
  region: costa_rica,
  maxPixels: 1e13,
}) ;
 
 Export.image.toDrive({
      image: Max.select(['EVI']),
      description: 'Landsat7_Max_VI'+year_run,
      maxPixels: 1e13,
      region: costa_rica,
      folder: GDriveOutputImgFolder,
      scale: scale
    });
    
      Export.image.toAsset({
      image: MMax,
      description: 'Landsat7_MMax_A'+year_run,
      assetId: 'Landsat7_MMax'+year_run,
      scale: scale,
      region: costa_rica,
      maxPixels: 1e13,
     }) ;
  Export.image.toDrive({
      image: MMax,
      description: 'Landsat7_MMax'+year_run,
      maxPixels: 1e13,
      region: costa_rica,
      folder: GDriveOutputImgFolder,
      scale: scale
    });


// Min 020 revise by LL
//convert to array images
 var test = Ndvi_mean_1band2.select(['EVI', 'day_of_year']).toArray();// find maximum value (row)
 var sort = test.arraySlice(1, 0, 1);
 // sort array
 var testSorted = test.arraySort(sort);
 print('testSorted',testSorted);
 Map.addLayer(testSorted, {}, 'array, test with times (sorted)', false);
 // convert to images
 var Min = testSorted.arraySlice(0, 0, 1)
  .arrayProject([1])
  .arrayFlatten([['NDVI_min', 't1']]);
 print('Min',Min);
 Map.addLayer(Min, {}, 'Min', false);
 
  Export.image.toAsset({
      image: Min.select(['NDVI_min']),
      description: 'Landsat7_Min_VI_A'+year_run,
      assetId: 'Landsat7_Min_VI'+year_run,
      scale: scale,
      region: costa_rica,
      maxPixels: 1e13,
     }) ;
    Export.image.toDrive({
      image: Min.select(['NDVI_min']),
      description: 'Landsat7_Min_VI'+year_run,
      maxPixels: 1e13,
      region: costa_rica,
      folder: GDriveOutputImgFolder,
      scale: scale
    });
    
     Export.image.toAsset({
      image: Min.select(['t1']),
      description: 'Landsat7_MMin_A'+year_run,
      assetId: 'Landsat7_MMin'+year_run,
      scale: scale,
      region: costa_rica,
      maxPixels: 1e13,
     }) ;
  Export.image.toDrive({
      image: Min.select(['t1']),
      description: 'Landsat7_MMin'+year_run,
      maxPixels: 1e13,
      region: costa_rica,
      folder: GDriveOutputImgFolder,
      scale: scale
    });
 

// convert to array images and compute diff between two adjacent image (in time)
var a = Ndvi_mean_1band2.select(['EVI', 'day_of_year']).toArray();
var a1 = a.arraySlice(0, 0, -1);
var a2 = a.arraySlice(0, 1);

var diff = a1.subtract(a2);

Map.addLayer(diff, {}, 'array, diff', false);

// add times
var t1 = a1.arraySlice(1, 1);
var t2 = a2.arraySlice(1, 1);

diff = diff
  .arrayCat(t1, 1)
  .arrayCat(t2, 1);

Map.addLayer(diff, {}, 'array, diff with times', false);  

// sort array
var sort = diff.arraySlice(1, 0, 1);

// find maximum value (row)
var diffSorted = diff.arraySort(sort);
  
Map.addLayer(diffSorted, {}, 'array, diff with times (sorted)', false);  
  
// select min/max and convert to images
var diffMin = diffSorted.arraySlice(0, 0, 1)
  .arrayProject([1])
  .arrayFlatten([['NDVI_diff_min', 't_diff', 't1', 't2']]);
  
// var histo1 = ui.Chart.image.histogram(diffMin, cavm, scale, 12, {}, {})
// print(histo1)

var diffMax = diffSorted.arraySlice(0, -1, diff.arrayLength(0))
  .arrayProject([1])
  .arrayFlatten([['NDVI_diff_max', 't_diff', 't1', 't2']]);
  
print(diffMax, "diffMax");

// Map.addLayer(diffMax, { bands: ['NDVI_diff_max'], min: 0, max: 5000 }, 'max(diff)')
// Map.addLayer(diffMax, { bands: ['t1'], min: 0, max: 365 }, 'max(diff) time')

// Map.addLayer(diffMin, { bands: ['NDVI_diff_min'], min: 0, max: 5000 }, 'min(diff)')
// Map.addLayer(diffMin, { bands: ['t1'], min: 0, max: 365 }, 'min(diff) time')

var vizParamsGreening = {"opacity":1, min: 90, max: 268, palette: 
['#ffffff','#effcd1','#d9f0a3','#addd8e','#41ab5d',
'#006837','#0c4e38','#000000','#fefba2','#fed98e',
'#cc4c02','#662506']};

var vizParamsBrowning = {"opacity":1, min: 1, max: 365, palette: 
['#ffffff','#effcd1','#d9f0a3','#addd8e','#41ab5d',
'#006837','#0c4e38','#000000','#fefba2','#fed98e',
'#cc4c02','#662506']};

var vizParamsBrowning = {"opacity":1,min: 1, max:365,"palette":
["6000e8","8d00ff","3a00e6","4100af","2e00c3",
"4e0068","8000e2","5201ab","5700c2","000000","380032",
"44005c","005dff","0072ff","009dff","00b2ff",
"00dcff","00fff6","00ffcb","00ffbb",
"00ff90","00ff69","00ff3b","00ff26",
"04ff00","19ff00","2eff00","59ff00","6eff00",
"99ff00","a9ff00","bfff00","e9ff00","ffff00",
"ffd400","ffaa00","ff7f00","ff6a00",
"ff2a00","ff1500","ff0000","e90000","d40000","bf0000"]};

var browning = diffMax.select(['NDVI_diff_max'])
Map.addLayer(browning, {}, 'browning', false);

Export.image.toAsset({
      image: browning,
      description: 'Landsat7_Browning_VI_A'+year_run,
      assetId: 'Landsat7_Browning_VI'+year_run,
      scale: scale,
      region: costa_rica,
      maxPixels: 1e13,
     }) ;
     
    Export.image.toDrive({
      image: browning,
      description: 'Landsat7_Browning_VI'+year_run,
      region: costa_rica,
      maxPixels: 1e13,
      folder: GDriveOutputImgFolder,
      scale: scale
    });

var browning_time = diffMax.select(['t1'])
Map.addLayer(browning_time, vizParamsBrowning, 'browning_time', false)

 Export.image.toAsset({
      image: browning_time,
      description: 'Landsat7_BrownTime_A'+year_run,
      assetId: 'Landsat7_BrownTime'+year_run,
      scale: scale,
      region: costa_rica,
      maxPixels: 1e13,
     }) ;
     
    Export.image.toDrive({
      image: browning_time,
      description: 'Landsat7_BrownTime'+year_run,
      region: costa_rica,
      maxPixels: 1e13,
      folder: GDriveOutputImgFolder,
      scale: scale
    });
    

var histoBRWN = ui.Chart.image.histogram(browning_time, region, 500, 12, 1)
print("End of growing season", histoBRWN)

var greening = diffMin.select(['NDVI_diff_min'])
Map.addLayer(greening, {}, 'greening', false)

Export.image.toAsset({
       image: greening,
      description: 'Landsat7_Greening_VI_A'+year_run,
      assetId: 'Landsat7_Greening_VI'+year_run,
      scale: scale,
      region: costa_rica,
      maxPixels: 1e13,
     }) ;
 Export.image.toDrive({
      image: greening,
      description: 'Landsat7_Greening_VI'+year_run,
      maxPixels: 1e13,
      region: costa_rica,
      folder: GDriveOutputImgFolder,
      scale: scale
    });
    

var greening_time = diffMin.select(['t1'])
Map.addLayer(greening_time, vizParamsGreening, 'greening_time', false)

Export.image.toAsset({
       image: greening_time,
      description: 'Landsat7_GreenTime_A'+year_run,
      assetId: 'Landsat7_GreenTime'+year_run,
      scale: scale,
      region: costa_rica,
      maxPixels: 1e13,
     }) ;
 Export.image.toDrive({
      image: greening_time,
      description: 'Landsat7_GreenTime'+year_run,
      maxPixels: 1e13,
      region: costa_rica,
      folder: GDriveOutputImgFolder,
      scale: scale
    });
    

var histoGRN = ui.Chart.image.histogram(greening_time, region, 500, 12, 1)
print("histoGRN", histoGRN)

print(greening_time, "greening_time")

//Calculate the quartiles

var quartM = Media.reduceRegion({
              reducer: ee.Reducer.percentile([50]),
              geometry: costa_rica,
              //crs:'EPSG:4326',
              scale: scale,
              bestEffort: true,
              maxPixels: 100000
              });

print (quartM);

var Mp50 = ee.Image.constant(quartM.get(String(SelectedVariableName)));
print('Mp50',Mp50)

var Season = season_SD;
var quartSeason = Season.reduceRegion({
              reducer: ee.Reducer.percentile([50]),
              geometry: costa_rica,
              //crs:'EPSG:4326',
              scale: scale,
              bestEffort: true,
              maxPixels: 100000
              });
print (quartSeason);

var Season50 = ee.Image.constant(quartSeason.get(String(SelectedVariableName)+'_stdDev'));
print('Season50',Season50)

//Classification of the EFTss based on quartiles and seasons of the year for the MMax

var PPN = Media.where(Media.lte(Mp50), 100);
PPN = PPN.where(Media.gt(Mp50), 200);

var Seasonality = Season.where(Season.lte(Season50), 10);
Seasonality = Seasonality.where(Season.gt(Season50), 20); 


var Feno = MMax.where(MMax.gt(125).and(MMax.lte(300)), 1); 
Feno = Feno.where((MMax.gt(300).and(MMax.lte(365))).or(MMax.gt(1).and(MMax.lte(125))), 2); //


var TFEcat = PPN.int().addBands([Seasonality,Feno]).int();  
var TFEunib = TFEcat.reduce(ee.Reducer.sum());


//EFTs from 1 to 8
var clasInpt = ([111, 112, 121, 122,
211, 212,  221, 222
]);

var clasesF = ee.List.sequence(1, 8);

var TFEclas = TFEunib.remap(clasInpt, clasesF);

var TFEunib = TFEunib.toUint16(); 

print('TFE111-222',TFEunib);
print('TFE1-8',TFEclas);

//EFTs from 111 to 533. Show the EFTs on the map, you can clip to the study area

// clip to the study area shape
var clipped = TFEclas.clip(region);

//var vizParams = { min: 1, max:64,'palette':"6000E8, 8D00FF, A400D3, 3A00E6, 4100AF, 3900B9, 2E00C3, 5500DC, 4E0068, 55007C, 51008E, 4B00A6, 000000, 380032, 450052, 44005C, 005DFF, 0072FF, 0087FF, 009DFF, 00B2FF, 00C7FF, 00DCFF, 00F2FF, 00FFF6, 00FFE1, 00FFCB, 00FFBB, 00FFA5,	00FF90, 00FF7B, 00FF69, 00FF4E, 00FF3B, 00FF26, 00FF10, 04FF00, 19FF00, 2EFF00, 43FF00, 59FF00, 6EFF00, 83FF00, 99FF00, A9FF00, BFFF00, D4FF00, E9FF00, FFFF00, FFE900, FFD400, FFBF00, FFAA00, FF9400, FF7F00, FF6A00, FF5500, FF3F00, FF2A00, FF1500, FF0000, E90000, D40000, BF0000"};
//var vizParamsTFEunib = { min: 111, max:444,'palette':"6000E8, 8D00FF, A400D3, 3A00E6, 4100AF, 3900B9, 2E00C3, 5500DC, 4E0068, 55007C, 51008E, 4B00A6, 000000, 380032, 450052, 44005C, 005DFF, 0072FF, 0087FF, 009DFF, 00B2FF, 00C7FF, 00DCFF, 00F2FF, 00FFF6, 00FFE1, 00FFCB, 00FFBB, 00FFA5,	00FF90, 00FF7B, 00FF69, 00FF4E, 00FF3B, 00FF26, 00FF10, 04FF00, 19FF00, 2EFF00, 43FF00, 59FF00, 6EFF00, 83FF00, 99FF00, A9FF00, BFFF00, D4FF00, E9FF00, FFFF00, FFE900, FFD400, FFBF00, FFAA00, FF9400, FF7F00, FF6A00, FF5500, FF3F00, FF2A00, FF1500, FF0000, E90000, D40000, BF0000"};
var vizParamsTFEunib45 = {"opacity":1,min: 111, max:533,"palette":
["6000e8","8d00ff","3a00e6","4100af","2e00c3",
"4e0068","8000e2","5201ab","5700c2","000000","380032",
"44005c","005dff","0072ff","009dff","00b2ff",
"00dcff","00fff6","00ffcb","00ffbb",
"00ff90","00ff69","00ff3b","00ff26",
"04ff00","19ff00","2eff00","59ff00","6eff00",
"99ff00","a9ff00","bfff00","e9ff00","ffff00",
"ffd400","ffaa00","ff7f00","ff6a00",
"ff2a00","ff1500","ff0000","e90000","d40000","bf0000"]};

var vizParamsTFEclasArctic = {"opacity":1,min: 1, max:45,"palette":
["6000e8","8d00ff","4100af","3900b9","2e00c3",
"5500dc","4e0068","8000e2","5201ab","5700c2","380032",
"005dff","0072ff","0087ff","009dff","00b2ff",
"00f2ff","00fff6","00ffe1","00ffcb","00ffbb",
"00ff7b","00ff69","00ff4e","00ff3b","00ff26",
"00ff10","04ff00","43ff00","59ff00","6eff00",
"bfff00","d4ff00","e9ff00","ffff00",
"ffe900","ffd400","ffbf00","ff6a00",
"ff5500","ff3f00","ff2a00","ff1500","ff0000","e90000","d40000",]};

Map.addLayer(TFEunib, vizParamsTFEunib45, 'TFE111-444');
Map.addLayer(TFEclas, vizParamsTFEclasArctic, 'TFE1-64');

    Export.image.toDrive({
      image: TFEclas,
      description: 'EFT_Landsat7_EVI_2001_2017_2_2',
      region: costa_rica,
      maxPixels: 1e13,
      folder: GDriveOutputImgFolder,
      scale: scale
      //crs: 'EPSG:3571'
    });
    
     
