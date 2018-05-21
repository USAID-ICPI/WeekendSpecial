#Package development

library(devtools)

document()
load_all()
build()


#import site coordinates
  datimvalidation::loadSecrets(secrets = NA)
  wpm_getcoords2("cDGPF739ZZr", 7, "ZAF")


#test
  folderpath_reports <- "RawData"
  folderpath_sitecoords <- "GIS"
  folderpath_targets <-  "Output"
  folderpath_output <- "Output"
  
  library(magrittr)
  
  wpm_filerefresh("C:/Users/achafetz/Downloads/drive-download-20180510T140330Z-001.zip",
                  "C:/Users/achafetz/Documents/GitHub/WeekendSpecial/RawData")
  
  filepath <- df_full_list$path[1]
  sheet_name <- df_full_list$sheet_name[1]
  
  list <- wpm_identify("RawData")
   



df <- wpm_combine("RawData", "GIS", "Output")





wpm_combine()
