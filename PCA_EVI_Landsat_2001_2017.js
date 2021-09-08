var L8_EVI = ee.ImageCollection("LANDSAT/LC8_L1T_8DAY_EVI"),
    L7_EVI = ee.ImageCollection("LANDSAT/LE7_L1T_8DAY_EVI"),
    L5_EVI = ee.ImageCollection("LANDSAT/LT5_L1T_8DAY_EVI"),

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
var year_range = '_2001_2017'
var countries = ee.FeatureCollection("USDOS/LSIB_SIMPLE/2017");
var costa_rica = ee.FeatureCollection(countries.filter(ee.Filter.stringContains('country_na', 'Costa')));
//var costa_rica = test_ROI;
Map.setCenter (-4, 37.5);

var GDriveOutputImgFolder = 'GEEOutputs/Landsat7_EFT';
var VarForSeason = 'SD'; //'SD' or 'CV' Seasonality


// 1.1 ) Definition of the studied period
  var FirstYear = 2001; // First year of the studied period
  var LastYear = 2017;  // Last year of the studied period
  var TimeFrame = ee.List.sequence(FirstYear, LastYear); 
  var NumberYears = LastYear - FirstYear + 1; 
  var months = ee.List.sequence(1, 12);//this is the growing season

// 1.2) Select Image Collection  Landsat only 2018 same sensor

  var coll1 = L7_EVI.filterDate(String(FirstYear)+'-01-01', String(LastYear)+'-12-31'); // EVI y NDVI
                   
    print('coll1',coll1);
    


// 1.3) Select the target variable/spectral index // 
  var SelectedVariableName = 'EVI' //choose EVI or NDVI
  var SelectedVariable = coll1.select([SelectedVariableName]); // EVI index, selected from the "MODIS/006/MOD13Q1" collection


// 1.4) Study area  // Be CAREFUL the whole world must be visualized before exportation of a particular region!!!!!!                  
   var UseRegion = 1; // Set to 0 to compute the Globe
   if (UseRegion == 1){
      var region = costa_rica ;// Shape o Rectangle o Geometry
      Map.addLayer(region);  
  }


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
Map.addLayer(mask, {min:0, max:1}, 'GLOBCOVERmask');


// Mean Stack
//Imports the MODIS image collection, the temporal subset is defined
// Function to calculate the average

var Evi_mensual = months.map(function(m) {
  // Filter to 1 month.
  var Evi_men = SelectedVariable.filter(ee.Filter.calendarRange(m, m, 'month')).mean();
  // add month band
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
  // add month band
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


//do PCA on inter-annual mean NDVI or EVI by month, where each month is a band in the stack//
var centered = stacked;

// This helper function returns a list of new band names.
var getNewBandNames = function(prefix) {
var seq = ee.List.sequence(1, bandNames.length());
return seq.map(function(b) {
 return ee.String(prefix).cat(ee.Number(b).int());
});
};

print('getNewBandNames',getNewBandNames);

//var scale = 500; //this can be adjusted depending on the size of your study area
var scale = 30; //this can be adjusted depending on the size of your study area

var bandNames = stacked.bandNames();

print('bandNames',bandNames);


var getPrincipalComponents = function(centered, scale, region) {
  // Collapse the bands of the image into a 1D array per pixel.
  var arrays = centered.toArray();

  // Compute the covariance of the bands within the region.
  var covar = arrays.reduceRegion({
   reducer: ee.Reducer.centeredCovariance(),
   geometry: region,
   scale: scale,
   maxPixels: 1e9
 });

  // Get the 'array' covariance result and cast to an array.
  // This represents the band-to-band covariance within the region.
  var covarArray = ee.Array(covar.get('array'));

  // Perform an eigen analysis and slice apart the values and vectors.
  var eigens = covarArray.eigen();

  // This is a P-length vector of Eigenvalues.
  var eigenValues = eigens.slice(1, 0, 1);
   print('eigenValues',eigenValues); //07/2020
  // This is a PxP matrix with eigenvectors in rows.
  var eigenVectors = eigens.slice(1, 1);
   print('eigenVectors',eigenVectors);

  /// Convert the array image to 2D arrays for matrix computations.
  var arrayImage = arrays.toArray(1);

  // Left multiply the image array by the matrix of eigenvectors.
  var principalComponents = ee.Image(eigenVectors).matrixMultiply(arrayImage);

  // Turn the square roots of the Eigenvalues into a P-band image.
  var sdImage = ee.Image(eigenValues.sqrt())
      .arrayProject([0]).arrayFlatten([getNewBandNames('sd')]);

  // Turn the PCs into a P-band image, normalized by SD.
  return principalComponents
      // Throw out an an unneeded dimension, [[]] -> [].
     .arrayProject([0])
      // Make the one band array image a multi-band image, [] -> image.
     .arrayFlatten([getNewBandNames('pc')])
      // Normalize the PCs by their SDs.
     .divide(sdImage);
  
};

// Get the PCs at the specified scale and in the specified region

var pcImage = getPrincipalComponents(centered, scale, region);

print('pcImage',pcImage);

//Plot each PC as a new layer
for (var i = 0; i < bandNames.length().getInfo(); i++) {
var band = pcImage.bandNames().get(i).getInfo();
Map.addLayer(pcImage.select([band]), {min: -2, max: 2}, band);
}

// //export PCs//
// Export.image.toDrive({
//       image: pcImage.clip(region),
//       description: 'pcImage_Landsat7_EVI'+year_range,
//       region: region,
//       maxPixels: 1e13,
//       folder: GDriveOutputImgFolder,
//       scale: scale
// });


Export.image.toAsset({
      image: pcImage.select('pc1').clip(region),
      description: 'Landsat7_PC1'+year_range,
      assetId: 'Landsat7_PC1'+year_range,
      scale: scale,
      region: costa_rica,
      maxPixels: 1e13,
    }) ;
    
Export.image.toDrive({
      image: pcImage.select('pc1').clip(region),
      description: 'Landsat7_2001_2017_PC1',
      region: costa_rica,
      maxPixels: 1e13,
      folder: GDriveOutputImgFolder,
      scale: scale
      //crs: 'EPSG:3571'
    });
    
Export.image.toAsset({
      image: pcImage.select('pc2').clip(region),
      description: 'Landsat7_PC2'+year_range,
      assetId: 'Landsat7_PC2'+year_range,
      scale: scale,
      region: costa_rica,
      maxPixels: 1e13,
    }) ;

Export.image.toDrive({
      image: pcImage.select('pc2').clip(region),
      description: 'Landsat7_2001_2017_PC2',
      region: costa_rica,
      maxPixels: 1e13,
      folder: GDriveOutputImgFolder,
      scale: scale
      //crs: 'EPSG:3571'
    });
    
Export.image.toAsset({
      image: pcImage.select('pc3').clip(region),
      description: 'Landsat7_PC3'+year_range,
      assetId: 'Landsat7_PC3'+year_range,
      scale: scale,
      region: costa_rica,
      maxPixels: 1e13,
    }) ;

Export.image.toDrive({
      image: pcImage.select('pc3').clip(region),
      description: 'Landsat7_2001_2017_PC3',
      region: costa_rica,
      maxPixels: 1e13,
      folder: GDriveOutputImgFolder,
      scale: scale
      //crs: 'EPSG:3571'
    });
    
