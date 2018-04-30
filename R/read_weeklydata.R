##  Project weekend_special
##  J Davis, A Chafetz, USAID
##  Purpose: read in partner entered data
##  Date: 2018-04-29
##  Updated:

#NOTES
#  currently testing with 1 datafile

#dependencies
  library(magrittr)

files <- fs::dir_ls(here::here("RawData"), glob = "*.xlsx")

#get a list of sheets
  #pick one partner's workbook
    partner <- "ANOVA"
    filepath <- here::here("RawData", paste(partner, "Weekly Programme monitoring.xlsx", sep = " "))
  #full list of sheets in file
    shts <- readxl::excel_sheets(filepath)
  #remove non-standard/unnecessary sheets from list
    shts <- shts[!stringr::str_detect(shts,pattern="Instructions|Interventions|Weekly data trends|Collated sheet")]

#function to import all sheets from file
  
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
        dplyr::mutate(indicator = sheet_name, 
                      date = lubridate::as_date(as.integer(pd), origin = "1899-12-30"),
                      date2 = as.character(lubridate::quarter(date, with_year = TRUE, fiscal_start = 10)),
                      quarter = paste0("FY", stringr::str_sub(date2, start = 3, end = 4),"Q", stringr::str_sub(date2, start = -1))) %>% 
        dplyr::select(-pd, -date2) %>% #remove intermediary variables
        dplyr::select(-val, dplyr::everything()) #move value to last column
    
  }
  
  
df_sht_combo <- purrr::map_dfr(shts, ~ import_sht(filepath, .))

#need something like this
df_combo <- purrr::map2_dfr(files, shts, ~ import_sht(.x, .y))
