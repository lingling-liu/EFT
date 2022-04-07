pro calculate_correspondence_table_EFD_NP_2001_2017
 
  ;EFT NP from CR
  infile="/largedisk_a/Costa_Rica/EFT/EFD_Landsat7_EVI_2001_2017_4_4_window_size_7_clp_re.tif"
  ESA_data = READ_TIFF(infile,geotiff = geotiff)
  pixelsize = geotiff.MODELPIXELSCALETAG[0]
  lon1 = -85.95260302
  ns1 = n_elements(ESA_data[*,0])
  nl1 = n_elements(ESA_data[0,*]) 
  print,ns1,nl1
  
  index = where(ESA_data ge 1,count1)
  
 
  ;EFT NP
  infile="/largedisk_a/Costa_Rica/EFT/EFD_Landsat7_EVI_2001_2017_NP_4_4_window_size_7_re.tif"
  IMN_data = READ_TIFF(infile,geotiff = geotiff)
  ns2 = n_elements(IMN_data[*,0])
  nl2 = n_elements(IMN_data[0,*])
  print,ns2,nl2
  
  index = where(IMN_data ge 1, count2)
  print,count1, count2
  
  lon2 = -85.97928298
  
  start_col = -(lon2-lon1)/pixelsize
  ESA_data1 = ESA_data[0:(ns2-1)-start_col+1,0:(nl2-1)]
  IMN_data1 = IMN_data[start_col:ns2-1,*]
  
  ESA_data = ESA_data1
  IMN_data = IMN_data1
  
  index = where(IMN_data ge 1 and IMN_data le 3,count_IMN)
  
  result = lonarr(4,3)+32767
  result1 = fltarr(4,3)+32767
  for i=1,3 do begin
    print,i
    index = where(ESA_data eq i, count)
    temp = IMN_data[index]
       
    index1 = where(temp ge 1 and temp le 3,count1)
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

  ;WRITE_CSV,'C:\Costa_Rica\EFT\Landsat7\EFD_2001_2017_correspondence_table_NP_based_national_scale.csv',result
  WRITE_CSV,'/largedisk_a/Costa_Rica/EFT/EFD_b4_w7_2001_2017_correspondence_table_NP_based_national_scale_percentages.csv',result1
end
