pro EFD_overlapping_map_NP_local_national

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
  
  result = intarr(ns1,nl1)+255 ; 255 outside of boudary
  result[index] = 0 ; not ROI

  index = where(ESA_data ge 1 and ESA_data le 6,count1)
  index = where(IMN_data ge 1 and IMN_data le 6,count_IMN)
  print,count1, count_IMN

  
 

  for i=0, nl1-1 do begin
    for j=0, ns1-1 do begin
      
      ; medium (3) for national, not overlapping with medhigh-high-veryhigh(4-6) for local 
      if ESA_data[j,i] eq 3 and IMN_data[j,i] ne 4 and IMN_data[j,i] ne 5 and IMN_data[j,i] ne 6 then begin
        result[j,i] =1
      endif
      
      ;medium (3)for national overlapping with medhigh-high-veryhigh(4-6) for local
      if ESA_data[j,i] eq 3 and (IMN_data[j,i] eq 4 or IMN_data[j,i] eq 5 or IMN_data[j,i] eq 6) then begin
        result[j,i] =2
      endif
      
      ;medhigh-high-veryhigh(4-6) for national, not overlapping with medhigh-high-veryhigh (4-6)for local
      if (ESA_data[j,i] ge 4 and ESA_data[j,i] le 6) and (IMN_data[j,i] ge 1 and IMN_data[j,i] le 3) then begin
        result[j,i] =3
      endif
      
      ; medhigh-high-veryhigh(4-6) for national overlapping with medhigh-high-veryhigh (4-6) for local
      if (ESA_data[j,i] ge 4 and ESA_data[j,i] le 6) and (IMN_data[j,i] ge 4 and IMN_data[j,i] le 6) then begin
        result[j,i] =4
      endif
      
      ;medhigh-high-veryhigh (4-6)for local not overlapping with either medium(3) or medhigh-high-veryhigh (4-6)for national
      if (ESA_data[j,i] ge 1 and ESA_data[j,i] le 2) and (IMN_data[j,i] ge 4 and IMN_data[j,i] le 6) then begin
        result[j,i] =5
      endif
     
    endfor
  endfor
  
  path = "Y:\people\liu02034\Costa_Rica\EFD\EFD_overlapping_map_NP_local_national.tif"
  WRITE_TIFF,path,result,COMPRESSION=1, GEOTIFF=geotiff,/short
  
end
