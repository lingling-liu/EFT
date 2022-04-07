;+
; NAME:
;    PERCENTILES
;
; PURPOSE:
;    Determines what range of a distribution lies within a percentile range.
;
; CATEGORY:
;    Math
;
; CALLING SEQUENCE:
;    Result = PERCENTILES(Values)
;
; INPUTS:
;   Values:  Array containing the distribution.
;
; KEYWORD PARAMETERS:
;   CONFLIMIT:  The fraction of the distribution encompassed. Default: 0.68
;
; OUTPUTS:
;   A 2-element vector of values that encompass a fraction CONFLIMIT
;   of the distribution. For example, if CONFLIMIT=0.68 then Result gives
;   the 16th and 85th percentiles.
;
; EXAMPLE:
;    IDL> a = 0.01*FINDGEN(101)
;    IDL> PRINT, PERCENTILES(a, CONFLIMIT=0.8)
;        0.1000000     0.900000
;
; MODIFICATION HISTORY:
;    Written by:   Jeremy Bailin
;    12 June 2008  Public release in JBIU
;-
function percentiles, values, conflimit=conflimit

  n = n_elements(values)
  if n_elements(conflimit) eq 0 then conflimit=0.68

  lowindex = long(((1.0-conflimit)/2)*n)
  highindex = n-lowindex-1
  sortvalues = values[sort(values)]

  return, [sortvalues[lowindex],sortvalues[highindex]]

end


pro create_histogram_EFAs

  dir ='/largedisk_a/Costa_Rica/EFT/EFAs/Landsat/'
  outdir = '/largedisk_a/Costa_Rica/EFT/EFAs/Histogram/'
  cd,dir
  
;  ;**************************************
;  ; Read a flat binary file with an image.
;  ;Gslope
;  filename = 'MODIS_Greening_VI_2014_2019.tif'
;  file = dir+ filename
;  data = READ_tiff(file)
;  index = where(data ge -10000 and data le 10000)
;  data1 = data[index]/10000.0
;  outliers = PERCENTILES(data1,conflimit=0.9)
;  scan = data1[where(data1 ge outliers[0] and data1 le outliers[1])]
;  min1 = min(scan)
;  max1 = max(scan)
;
;
;  ; Compute the image histogram, using the default bin size of 1.
;  binsize = (max1-min1)/10.0
;  pdf = HISTOGRAM(scan, binsize = binsize,LOCATIONS=xbin,min= min1,max=max1)
;  pdf1 = (pdf-0.0)/N_ELEMENTS(scan)
;  cdf = TOTAL(pdf, /CUMULATIVE) / N_ELEMENTS(scan)
;
;  ; Display the image and its histogram, setting MAX_VALUE to exclude the spike
;  ; at 0 caused by the black pixels.
;  ;pimage = IMAGE(data, /ORDER, LAYOUT=[2,1,1], DIMENSIONS=[3*256,256], $
;  ;  TITLE=strmid(filename,0,strlen(filename)-4))
;  ;p = PLOT(xbin, pdf1, LAYOUT=[2,1,2], /CURRENT, XRANGE=[min1,max1], $
;  p = PLOT(xbin, pdf1,/CURRENT, XRANGE=[min1,max1],DIMENSIONS=[400,400], $
;    TITLE=strmid(filename,0,strlen(filename)-4), XTITLE='Pixel value', YTITLE='Percentage', $
;    MAX_VALUE=5e3, AXIS_STYLE=1, /STAIRSTEP,COLOR='red',font_size =12)
;
;  p.Save,outdir+strmid(filename,0,strlen(filename)-4)+'.png', BORDER=10, $
;    RESOLUTION=300, /TRANSPARENT
;  p.close
; ;*****************************************************


; ;*********************************************************
; ; Mean 
; ; Read a flat binary file with an image.
; filename = 'MODIS_mean_2014_2019.tif'
; file = dir+ filename
; data = READ_tiff(file)
; index = where(data ge -10000 and data le 10000)
; data1 = data[index]/10000.0
; outliers = PERCENTILES(data1,conflimit=0.9)
; scan = data1[where(data1 ge outliers[0] and data1 le outliers[1])]
; min1 = min(scan)
; max1 = max(scan)
;
;
; ; Compute the image histogram, using the default bin size of 1.
; binsize = (max1-min1)/10.0
; pdf = HISTOGRAM(scan, binsize = binsize,LOCATIONS=xbin,min= min1,max=max1)
; pdf1 = (pdf-0.0)/N_ELEMENTS(scan)
; cdf = TOTAL(pdf, /CUMULATIVE) / N_ELEMENTS(scan)
;
; ; Display the image and its histogram, setting MAX_VALUE to exclude the spike
; ; at 0 caused by the black pixels.
; ;pimage = IMAGE(data, /ORDER, LAYOUT=[2,1,1], DIMENSIONS=[3*256,256], $
; ;  TITLE=strmid(filename,0,strlen(filename)-4))
; ;p = PLOT(xbin, pdf1, LAYOUT=[2,1,2], /CURRENT, XRANGE=[min1,max1], $
; p = PLOT(xbin, pdf1,/CURRENT, XRANGE=[min1,max1],DIMENSIONS=[400,400], $
;   TITLE=strmid(filename,0,strlen(filename)-4), XTITLE='Pixel value', YTITLE='Percentage', $
;   MAX_VALUE=5e3, AXIS_STYLE=1, /STAIRSTEP,COLOR='red',font_size =12)
;
; p.Save,outdir+strmid(filename,0,strlen(filename)-4)+'.png', BORDER=10, $
;   RESOLUTION=300, /TRANSPARENT
; p.close
; ;*******************************************************************
 
; ;*********************************************************
;; ; SD
;; ; Read a flat binary file with an image.
; filename = 'Landsat8_Greening_VI.tif'
;filename = 'Landsat8_mean.tif'
;filename = 'Landsat8_SD.tif'
;filename = 'Landsat8_CV.tif'
;filename = 'Landsat8_Max_VI.tif'
;filename = 'Landsat8_Min_VI.tif'
;filename = 'Landsat8_Browning_VI.tif'
; file = dir+ filename
; data = READ_tiff(file)
; index = where(data ge -1 and data le 1)
; data1 = data[index]
; outliers = PERCENTILES(data1,conflimit=0.9)
; scan = data1[where(data1 ge outliers[0] and data1 le outliers[1])]
; min1 = min(scan)
; max1 = max(scan)
;
;
; ; Compute the image histogram, using the default bin size of 1.
; binsize = (max1-min1)/20.0
; pdf = HISTOGRAM(scan, binsize = binsize,LOCATIONS=xbin,min= min1,max=max1)
; pdf1 = (pdf-0.0)/N_ELEMENTS(scan)
; cdf = TOTAL(pdf, /CUMULATIVE) / N_ELEMENTS(scan)
;
; ; Display the image and its histogram, setting MAX_VALUE to exclude the spike
; ; at 0 caused by the black pixels.
; ;pimage = IMAGE(data, /ORDER, LAYOUT=[2,1,1], DIMENSIONS=[3*256,256], $
; ;  TITLE=strmid(filename,0,strlen(filename)-4))
; ;p = PLOT(xbin, pdf1, LAYOUT=[2,1,2], /CURRENT, XRANGE=[min1,max1], $
; p = PLOT(xbin, pdf1,/CURRENT, XRANGE=[min1,max1],DIMENSIONS=[400,400], $
;   TITLE=strmid(filename,0,strlen(filename)-4), XTITLE='Pixel value', YTITLE='Percentage', $
;   MAX_VALUE=5e3, AXIS_STYLE=1, /STAIRSTEP,COLOR='red',font_size =12)
;
; p.Save,outdir+strmid(filename,0,strlen(filename)-4)+'.png', BORDER=10, $
;   RESOLUTION=300, /TRANSPARENT
; p.close
 ;*******************************************************************
 
 ; Dates
 ; Read a flat binary file with an image.
 filename = 'Landsat8_MMax.tif'
 filename = 'Landsat8_MMin.tif'
filename = 'Landsat8_GreenTime.tif'
filename = 'Landsat8_BrownTime.tif'
 file = dir+ filename
 data = READ_tiff(file)
 index = where(data ge 1 and data le 365)
 data1 = data[index]
 outliers = PERCENTILES(data1,conflimit=0.9)
 scan = data1[where(data1 ge outliers[0] and data1 le outliers[1])]
 min1 = min(scan)
 max1 = max(scan)


 ; Compute the image histogram, using the default bin size of 1.
 binsize = (max1-min1)/36.0
 pdf = HISTOGRAM(scan, binsize = binsize,LOCATIONS=xbin,min= min1,max=max1)
 pdf1 = (pdf-0.0)/N_ELEMENTS(scan)
 cdf = TOTAL(pdf, /CUMULATIVE) / N_ELEMENTS(scan)

 ; Display the image and its histogram, setting MAX_VALUE to exclude the spike
 ; at 0 caused by the black pixels.
; pimage = IMAGE(data, /ORDER, LAYOUT=[2,1,1], DIMENSIONS=[3*256,256], $
;   TITLE=strmid(filename,0,strlen(filename)-4))
 ;p = PLOT(xbin, pdf1, LAYOUT=[2,1,2], /CURRENT, XRANGE=[min1,max1], $
 p = PLOT(xbin, pdf1,/CURRENT, XRANGE=[min1,max1],DIMENSIONS=[400,400], $
   TITLE=strmid(filename,0,strlen(filename)-4), XTITLE='Pixel value', YTITLE='Percentage', $
   MAX_VALUE=5e3, AXIS_STYLE=1, /STAIRSTEP,COLOR='red',font_size =12)

 p.Save,outdir+strmid(filename,0,strlen(filename)-4)+'.png', BORDER=10, $
   RESOLUTION=300, /TRANSPARENT
 p.close
; ;*******************************************************************
end