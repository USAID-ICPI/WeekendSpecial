#' Import & adjust each sheet from file
#'
#' @param filepath filepath for one of the weekly reports 
#' @param sheet_name name of the sheet for one of the sheets within the file, eg "HTS_TST"
#'
#' @export
#' @importFrom dplyr %>%
#' @examples
#' \dontrun{
#'   df_parterdata <- sheet_import("~/X Weekly Programme monitoring.xlsx", "HTS_TST")}

sheet_import <- function(filepath, sheet_name){
  
  #import sheet from file
  df <- readxl::read_excel(filepath, sheet = sheet_name) %>% 
    dplyr::rename_all(~tolower(.)) %>%   #covert variables to lower case
    dplyr::rename_all(~stringr::str_replace_all(., "\\s|-","_")) #removes spaces and covert "-" to "_"
  
  #reshape long to make tidy
  df_long <- df %>% 
    tidyr::gather(pd, value, -partner:-site_lead, na.rm = TRUE)  
  
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
