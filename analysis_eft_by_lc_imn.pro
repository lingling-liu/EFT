pro analysis_EFT_by_LC_IMN

  testfile = "C:\Costa_Rica\EFT\EFT_by_LC_IMN - EFT_by_LC_IMN.csv"
  data = READ_CSV(testfile, HEADER=SedHeader, $
    N_TABLE_HEADER=1, TABLE_HEADER=SedTableHeader)

  print,SedHeader
  print,data
  
  for i=0,15 do begin
    temp1 = 0L
    for j=1, 40 do begin
      if j lt 10 then begin
      str = strjoin(['FIELD0',strtrim(string(j),2)])
      endif else begin
      str = strjoin(['FIELD',strtrim(string(j),2)])
      endelse
      temp1 = temp1 +data.str
    endfor
    
  endfor




end