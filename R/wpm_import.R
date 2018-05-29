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
    if(stringr::str_detect(filepath,"AURUM|HST")){
      skip_n <- 6
    } else if(stringr::str_detect(filepath,"THC")) {
      skip_n <- 1
    } else{
      skip_n <- 0
    }
    
  #import sheet from file
    df <- readxl::read_excel(filepath, sheet = sheet_name, skip = skip_n) %>% 
      dplyr::rename_all(~tolower(.)) %>%   #covert variables to lower case
      dplyr::rename_all(~stringr::str_replace_all(., "\\s|-","_")) #removes spaces and covert "-" to "_"
  
  #covert weekly/monlty reporting into same variable (CDC)
    if("mthly_reporting" %in% colnames(df)){
      df <- df %>% 
        dplyr::rename(reporting_freq = mthly_reporting) %>% 
        dplyr::mutate(reporting_freq = ifelse(reporting_freq == "YES", "monthly", reporting_freq))
    } else if("weekly_reporting" %in% colnames(df)){
      df <- df %>% 
        dplyr::rename(reporting_freq = weekly_reporting) %>% 
        dplyr::mutate(reporting_freq = ifelse(reporting_freq == "YES", "weekly", reporting_freq))
    }
  #add missing columns if they don't already exist (differences between USAID and CDC)
    cols <- c("province", "provincial_lead", "site_lead", "10x10_facility", "reporting_freq", "indicator")
    for (c in cols) {
      if(!c %in% colnames(df)){
        df <- df %>% 
          dplyr::mutate(!!c := as.character(NA))
      }
    }
  #for USAID partners, add weekly to reporting_freq for all
    df <- df %>% 
      dplyr::mutate(reporting_freq = ifelse(stringr::str_detect(filepath,"AURUM|HST|THC"),
                                              reporting_freq, "weekly"))
  #rename 10x10 facility column (CDC)
    df <- dplyr::rename(df, tenxten_facility = `10x10_facility`)
  
  #reshape long to make tidy
    cols_full <- c("partner", "province", "district", "sub_district", "facility", "tenxten_facility", 
                   "reporting_freq", "provincial_lead", "site_lead","indicator")
    df <- dplyr::select(df, cols_full, dplyr::everything()) #arrange
    df_long <- df %>% 
      tidyr::gather(pd, value, -cols_full, na.rm = TRUE)
    
  #ensure values are double and create indicator from sheet name
    df_long <- df_long %>% 
      dplyr::mutate(value = as.double(value),
                    indicator = sheet_name)
  #covert Excel date (origin - 1899-12-30) to readable date; different for CDC and USAID
    if(stringr::str_detect(filepath,"AURUM|HST|THC")){
      df_long <- df_long %>% 
        dplyr::mutate(date = lubridate::dmy(pd))
    } else {
      df_long <- df_long %>% 
        dplyr::mutate(date = lubridate::as_date(as.integer(pd), origin = "1899-12-30"))
    }
  #additional date vars
    df_long <- df_long %>% 
      dplyr::mutate(date2 = as.character(lubridate::quarter(date, with_year = TRUE, fiscal_start = 10))) %>% 
      dplyr::select(-pd, -date2) %>% #remove intermediary variables
      dplyr::select(-value, dplyr::everything()) %>%  #move value to last column
      dplyr::filter(value != 0)
  
  #standardize indicator names
    df_long <- df_long %>% 
      dplyr::mutate(indicator = dplyr::case_when(
        indicator == "Direct HTS_POS"                                                       ~ "HTS_TST_POS",
        indicator == "Proxy TX_NEW"                                                         ~ "TX_NEW",
        indicator %in% c("IPT Initiation", "IPT initiations")                               ~ "IPT",
        indicator %in% c("Early Missed Appointment", "EarlyMissed", "APPT_EARLY_MISSED")    ~ "APPT_EARLY_MISSED",
        indicator == "Proxy HTS_POS"                                                        ~ "HTS_TST_POS_PROXY",
        indicator == "Direct HTS_TST_ART"                                                   ~ "HTS_TST_ART",
        indicator %in% c("Unconfirmed Loss to Follow Up", "Unconfirmed loss to follow up")  ~ "LTFU_UNCONFIRMED",
        indicator == "Waiting for ART"                                                      ~ "ART_WAITING",
        TRUE                                                                                ~ indicator)
      )
}
