pro eft_efd


  dir = '/largedisk_a/Costa_Rica/EFT/EFT_new/'
  cd,dir
  raster_files = file_search('*.tif',count=num_raster)

  dir_output = '/largedisk_a/Costa_Rica/EFT/EFT_new/EFD/'
  ; window size 3, 5,7
  for k=0,2 do begin
    window_size = 2*(k+1)+1
    print,window_size

    for m=0, num_raster-1 do begin

      infile = dir + raster_files[m]
      print,infile

      data = READ_TIFF(infile,geotiff = geotiff)
      pixelsize = geotiff.MODELPIXELSCALETAG[0]


      ns = n_elements(data[*,0])
      nl = n_elements(data[0,*])
      print,ns,nl

      result = intarr(ns/window_size,nl/window_size)+255

      for i=0,nl/window_size-1 do begin
        for j=0,ns/window_size-1 do begin
          ;print,j*5l,(j+1)*5l-1,i*5l,(i+1)*5l-1
          temp = data[j*window_size: (j+1)*window_size-1,i*window_size: (i+1)*window_size-1]
          index = where(temp ge 1 and temp le 64, count)

          if count gt 0 then begin
            array = temp[index]
            result[j,i]= n_elements(UNIQ(array, SORT(array)))
          endif
        endfor
      endfor
      newpixelsize = window_size*pixelsize
      geotiff.MODELPIXELSCALETAG = [newpixelsize,newpixelsize,0.0000000000000000]
      tiff_file= dir_output + 'EFD'+strmid(raster_files[m],3,strlen(raster_files[m])-4)+'window_size_'+strtrim(string(window_size),2)+'.tif'
      WRITE_TIFF, tiff_file, result, GEOTIFF=geotiff,/short
    endfor
  endfor
end