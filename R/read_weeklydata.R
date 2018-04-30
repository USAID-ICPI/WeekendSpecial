##  Project weekend_special
##  J Davis, A Chafetz, USAID
##  Purpose: read in partner entered data
##  Date: 2018-04-29
##  Updated: 2018-04-30



# Dependencies ------------------------------------------------------------


  library(magrittr)


# Function: identify all files and their sheets within --------------------

  identify_sheets <- function(folderpath){
    
    #identify list of all files in 
    files <- fs::dir_ls(folderpath, glob = "*.xlsx")
    
    #cull files & all sheets into a df
    df <- 
      #create a df with all files in   
      tibble::data_frame(path = files) %>% 
      #add each sheet onto each file
      dplyr::mutate(sheet_name = purrr::map(path, readxl::excel_sheets)) %>% 
      #unpack list so all one df
      tidyr::unnest() %>% 
      #filter to keep only only  
      dplyr::filter(stringr::str_detect(sheet_name, "HTS|Early|IPT|Waiting|nconfirmed|TX_CURR"))
    
    return(df)
    
  }
  

# Function: import & adjust each sheet from file --------------------------
  
  import_sht <- function(filepath, sheet_name){

    #import sheet from file
      df <- readxl::read_excel(filepath, sheet = sheet_name) %>% 
        dplyr::rename_all(~tolower(.)) %>%   #covert variables to lower case
        dplyr::rename_all(~stringr::str_replace_all(., "\\s|-","_")) #removes spaces and covert "-" to "_"
      
    #reshape long to make tidy
      df_long <- df %>% 
        tidyr::gather(pd, val, -partner:-site_lead, na.rm = TRUE)  
    
    #covert Excel date (origin - 1899-12-30) to readable date & add variable name (from sheetname)
      df_long <- df_long %>% 
        dplyr::mutate(val = as.double(val),
                      indicator = sheet_name, 
                      date = lubridate::as_date(as.integer(pd), origin = "1899-12-30"),
                      date2 = as.character(lubridate::quarter(date, with_year = TRUE, fiscal_start = 10)),
                      quarter = paste0("FY", stringr::str_sub(date2, start = 3, end = 4),"Q", stringr::str_sub(date2, start = -1))) %>% 
        dplyr::select(-pd, -date2) %>% #remove intermediary variables
        dplyr::select(-val, dplyr::everything()) #move value to last column
    
  }
  
  

# Run: Import all data ----------------------------------------------------

  #identify folder where raw data sits
    folder <- here::here("RawData")
    
  #genreate full list of sheets within each file
    df_full_list <- identify_sheets(folder)
    
  #combine all data into one df
    df_zaf_weekly <- purrr::map2_dfr(df_full_list$path, df_full_list$sheet_name,
                                ~ import_sht(.x, .y))
  


# Run: Export data --------------------------------------------------------
  
  #create export folder (if it doesn't exist)
    fs::dir_create("Output")
    
  #export
    readr::write_csv(df_zaf_weekly, paste("Output/ZAF-USAID_Weekly-Programmme-Monitoring_", lubridate::today(), ".csv"), na = "")
