#Package development

library(devtools)

document()
load_all()
build()


#import site coordinates
  datimvalidation::loadSecrets(secrets = NA)
  wpm_getcoords("cDGPF739ZZr", 7, "GIS")


#test
  library(magrittr)
  
  wpm_filerefresh("C:/Users/achafetz/Downloads/drive-download-20180510T140330Z-001.zip",
                  "C:/Users/achafetz/Documents/GitHub/WeekendSpecial/RawData")
  
  list <- wpm_identify("RawData")
   



df <- wpm_combine("RawData", "GIS", "Output")


