#' Import & adjust each sheet from file
#'
#' @param filepath filepath for one of the weekly reports 
#' @param sheet_name name of the sheet for one of the sheets within the file, eg "HTS_TST"
#'
#' @export
#' @importFrom dplyr %>%
#' @examples
#' \dontrun{
#'   df_parterdata <- wpm_import("~/X Weekly Programme monitoring.xlsx", "HTS_TST")}

wpm_import <- function(filepath, sheet_name){
  
  #if CDC partner workbook, need to skip first 6 rows
    if(stringr::str_detect(filepath,"AURUM|HST|THC")){
      skip_n <- 6
    } else{
      skip_n <- 0
    }
    
  #import sheet from file
    df <- readxl::read_excel(filepath, sheet = sheet_name, skip = skip_n) %>% 
      dplyr::rename_all(~tolower(.)) %>%   #covert variables to lower case
      dplyr::rename_all(~stringr::str_replace_all(., "\\s|-","_")) #removes spaces and covert "-" to "_"
  
  
  #add missing columns if they don't already exist (differences between USAID and CDC)
    cols <- c("province", "provincial_lead", "site_lead", "10x10_facility", "weekly_reporting", "indicator")
    for (c in cols) {
      if(!c %in% colnames(df)){
        df <- df %>% 
          dplyr::mutate(!!c := as.character(NA))
      }
    }
  
  #rename 10x10 facility column (CDC)
    df <- dplyr::rename(df, tenxten_facility = `10x10_facility`)
  
  #reshape long to make tidy
    cols_full <- c("partner", "province", "district", "sub_district", "facility", "tenxten_facility", 
                   "weekly_reporting", "provincial_lead", "site_lead","indicator")
    df <- dplyr::select(df, cols_full, dplyr::everything()) #arrange
    df_long <- df %>% 
      tidyr::gather(pd, value, -cols_full, na.rm = TRUE)
    
  #covert Excel date (origin - 1899-12-30) to readable date & add variable name (from sheetname)
    df_long <- df_long %>% 
      dplyr::mutate(value = as.double(value),
                    indicator = sheet_name, 
                    date = lubridate::as_date(as.integer(pd), origin = "1899-12-30"),
                    date2 = as.character(lubridate::quarter(date, with_year = TRUE, fiscal_start = 10)),
                    quarter = paste0("FY", stringr::str_sub(date2, start = 3, end = 4),"Q", stringr::str_sub(date2, start = -1))) %>% 
      dplyr::select(-pd, -date2) %>% #remove intermediary variables
      dplyr::select(-value, dplyr::everything()) %>%  #move value to last column
      dplyr::filter(value != 0)
  
}
