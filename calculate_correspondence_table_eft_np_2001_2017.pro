pro calculate_correspondence_table_EFT_NP_2001_2017
 
  ;EFT NP from CR
  filename="C:\Costa_Rica\EFT\Landsat7\EFAs_2001-2017\EFT_Landsat7_EVI_2001_2017_NP_CR.tif"
  openr,unit,filename,/get_lun
  ns = 4402
  nl = 6244
  ESA_data =dblarr(ns,nl)
  readu,unit,ESA_data
  close,unit
  
  ;EFT NP
  filename="C:\Costa_Rica\EFT\Landsat7\EFAs_2001-2017\EFT_Landsat7_EVI_2001_2017_NP1.tif"
  openr,unit,filename,/get_lun
  ns = 4402
  nl = 6244
  IMN_data =dblarr(ns,nl)
  readu,unit,IMN_data
  close,unit
  

  result = lonarr(46,45)+32767
  result1 = fltarr(46,45)+32767
  for i=1,45 do begin
    print,i
    index = where(ESA_data eq i, count)
    temp = IMN_data[index]
       
    index1 = where(temp ge 1 and temp le 45,count1)
    if count1 gt 0 then begin
      temp1 = temp[index1]
      classes = temp1[UNIQ(temp1, SORT(temp1))]
      nums = n_elements(classes)
      for j=0,nums-1 do begin
        index = where(temp eq classes[j], count11)
        print,count11
        result[classes[j],i-1] = count11
        result1[classes[j],i-1] = count11/(count1-0.0)
      endfor
      ;print,result[*,i-1]
    endif
  endfor

  WRITE_CSV,'C:\Costa_Rica\EFT\Landsat7\EFT_2001_2017_correspondence_table_NP_based_national_scale.csv',result
  WRITE_CSV,'C:\Costa_Rica\EFT\Landsat7\EFT_2001_2017_correspondence_table_NP_based_national_scale_percentages.csv',result1
end
