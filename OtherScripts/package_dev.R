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
  
  s <- 5
  filepath <- df_full_list$path[s]
  sheet_name <- df_full_list$sheet_name[s]
  
  df <-  wpm_import(filepath, sheet_name)
  
  
  list <- wpm_identify("RawData")
   


#check
df <- wpm_combine("RawData", "GIS", "Output")

#export
wpm_combine("RawData", "GIS", "Output", "Output")





wpm_combine()
