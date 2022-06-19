pro calculate_correspondence_table_EFD_NP_2001_2017
 
  ;EFT NP from CR
  infile="Y:\people\liu02034\Costa_Rica\EFD\EFD_Landsat_NP_clipped_b4_win7_reclassify.tif"
  ESA_data = READ_TIFF(infile,geotiff = geotiff)
  pixelsize = geotiff.MODELPIXELSCALETAG[0]
  ns1 = n_elements(ESA_data[*,0])
  nl1 = n_elements(ESA_data[0,*]) 
  print,ns1,nl1
  
  index = where(ESA_data ge 1 and ESA_data le 6,count1)
 
  ;EFT NP
  infile="Y:\people\liu02034\Costa_Rica\EFD\EFD_Landsat_NP_b4_win7_reclassify.tif"
  IMN_data = READ_TIFF(infile,geotiff = geotiff)
  ns2 = n_elements(IMN_data[*,0])
  nl2 = n_elements(IMN_data[0,*])
  print,ns2,nl2
  
  index = where(IMN_data ge 1 and IMN_data le 6, count2)
  print,count1, count2
  
  ;exclude the data outside of boudary
  ESA_data1 = bytarr(ns1,nl1)+127
  ESA_data1[index] = ESA_data[index]
  ESA_data = ESA_data1
  
  index = where(ESA_data ge 1 and ESA_data le 6,count1)
   
  index = where(IMN_data ge 1 and IMN_data le 6,count_IMN)
  print,count1, count_IMN
  
  result = lonarr(7,6)+32767
  result1 = fltarr(7,6)+32767
  for i=1,6 do begin
    print,i
    index = where(ESA_data eq i, count)
    temp = IMN_data[index]
       
    index1 = where(temp ge 1 and temp le 6,count1)
    if count1 gt 0 then begin
      temp1 = temp[index1]
      classes = temp1[UNIQ(temp1, SORT(temp1))]
      ;print,classes
      nums = n_elements(classes)
      for j=0,nums-1 do begin
        index = where(temp eq classes[j], count11)
        print,count11
        result[classes[j],i-1] = count11
        result1[classes[j],i-1] = count11/(count_IMN-0.0)
      endfor
      ;print,result[*,i-1]
    endif
  endfor
  
  print,result1

  WRITE_CSV,'Y:\people\liu02034\Costa_Rica\EFD\EFD_b4_w7_correspondence_table_NP_based_national_scale_percentages.csv',result1
end
