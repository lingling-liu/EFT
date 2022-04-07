pro generate_PCA_rmse_map_ecoregion

  ; read ecoregion data
  infile = '/largedisk_a/Costa_Rica/EFT/zones/ecoregiones12.tif'
  eco= read_tiff(infile)

  ; read EFT diversity 5*5
  infile = '/largedisk_a/Costa_Rica/EFT/PCA_EVI/pcImage_MODIS_EVI.tif'
  data= read_tiff(infile)
  ns = n_elements(data[0,*,0])
  nl = n_elements(data[0,0,*])
  data = data[*,1: ns-2,1:nl-2]
  min1= min(data)
  max1 = max(data)

  output = '/largedisk_a/Costa_Rica/EFT/PCA_MODIS_RMSE_Ecoregion.img'
  openw,unit,output,/get_lun

  array = eco
  eco_id = array[UNIQ(array, SORT(array))]
  eco_id = eco_id[1:13]
  num_eco = n_elements(eco_id)
  mean_eco = fltarr(3,num_eco)

  ns = 1633
  nl = 1528

  for i=0,num_eco-1d do begin
    index = where(eco eq eco_id[i],count)
    if count gt 0 then begin
      ;pc1
      temp = reform(data[0,*,*],ns,nl); pc1
      temp1 = temp[index]
      index1 = where(temp1 ge min1 and temp1 le max1,count1)
      mean_eco[0,i] = float(mean(temp1[index1]))

      ;pc2
      temp = reform(data[1,*,*],ns,nl); pc2
      temp1 = temp[index]
      index1 = where(temp1 ge min1 and temp1 le max1,count1)
      mean_eco[1,i] = float(mean(temp1[index1]))

      ;pc3
      temp = reform(data[2,*,*],ns,nl); pc3
      temp1 = temp[index]
      index1 = where(temp1 ge min1 and temp1 le max1,count1)
      mean_eco[2,i] = float(mean(temp1[index1]))

    endif
  endfor


  result = fltarr(3,ns,nl)+32767

  for q = 0, 2 do begin
    for i=0,nl-1 do begin
      for j=0,ns-1 do begin

        temp_eco = eco[j,i]
        if temp_eco ge 1 and temp_eco le 13 and data[q,j,i] ge min1 and data[q,j,i] le max1 then begin
          index = where(eco_id eq temp_eco)
          result[q,j,i] = (data[q,j,i]-mean_eco[q,index])*(data[q,j,i]-mean_eco[q,index])
        endif

      endfor
    endfor
  endfor


  result1 = fltarr(ns,nl)+32767

  for i=0,nl-1 do begin
    for j=0,ns-1 do begin
      temp = result[*,j,i]
      index = where(temp eq 32767,count)
      if count eq 0 then begin
        result1[j,i] = total(result[*,j,i])
      endif
    endfor
  endfor


  index  = where(result1 ne 32767,count)
  print,'Ecoregion',mean(result1[index])
  



end