#Package development

library(devtools)
load_all()

document()

build()


#import site coordinates
  datimvalidation::loadSecrets(secrets = NA)
  wpm_getcoords("cDGPF739ZZr", "ZAF")


#test
  folderpath_reports <- "RawData"
  folderpath_sitecoords <- "GIS"
  folderpath_targets <-  "Output"
  folderpath_output <- "Output"
  
  library(magrittr)
  
  if(length(dir("C:/Users/achafetz/Downloads/", pattern = "drive-download*"))==1){
    dwnld_file <- dir("C:/Users/achafetz/Downloads/", pattern = "drive-download*", full.names = TRUE)
  } else {
    paste("There were ", length(dir("C:/Users/achafetz/Downloads/", pattern = "drive-download*")), "found. dwnld_file not created ")
  }
  
  wpm_filerefresh(dwnld_file,
                  "C:/Users/achafetz/Documents/GitHub/WeekendSpecial/RawData")
  rm(dwnld_file)
  
  
  s <- 1
  filepath <- df_full_list$path[s]
  sheet_name <- df_full_list$sheet_name[s]
  
  df <-  wpm_import(filepath, sheet_name)
  
  
  list <- wpm_identify("RawData")
   


#check
df <- wpm_combine("RawData", "GIS", "Output")

#export
df <- wpm_combine("RawData", "GIS", "Output", "Output")




wpm_combine()
