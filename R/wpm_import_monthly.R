#' Import & adjust each MONTHLY sheet from file
#'
#' @param filepath filepath for one of the montly reports 
#' @param sheet_name name of the sheet for one of the sheets within the file, eg "Oct 2017"
#'
#' @export
#' @importFrom dplyr %>%
#' @examples
#' \dontrun{
#'   df_parterdata <- wpm_import("~/ANOVA - 17020_ HTS_POS linkage to TIER.NET.xlsx", "Oct 2017")}


wpm_import_monthly <- function(filepath, sheet_name){
  
  #import sheet from file
    df <- readxl::read_excel(filepath, sheet = sheet_name, skip = 2, col_types = "text") %>% 
      dplyr::rename_all(~tolower(.)) %>%   #covert variables to lower case
      dplyr::rename_all(~stringr::str_replace_all(., "\\s|-","_")) %>% #removes spaces and covert "-" to "_"
      dplyr::rename(partner = implementing_partner,
                    mechanismid = im,
                    "unknown_<01" = `<1`,
                    "unknown_01_09" = `42744.0`)
    
  #gather long
    df_long <- df %>% 
      tidyr::gather(asg, value, `unknown_<01`:`male_50+`, na.rm = TRUE) %>% 
      dplyr::mutate(value = as.integer(value)) %>% 
      dplyr::filter(value != 0)
  
  #separate out age and sex
    df_long <- df_long %>% 
      dplyr::mutate(asg = stringr::str_replace(asg, "_", "-")) %>% 
      tidyr::separate(asg, into = c("sex", "age"), sep = "-") %>% 
      dplyr::mutate(age = stringr::str_replace(age, "_", "-"),
                    sex = stringr::str_to_title(sex))
    
  #add period in
    df_long <- df_long %>% 
      dplyr::mutate(period = sheet_name,
                    period = stringr::str_replace(period, " 20", "_"),
                    period = stringr::str_to_upper(period))
  #arrange
    df_long <- df_long %>% 
      dplyr::select(mechanismid, partner, district, sub_district, indicator, period, sex, age, value)
                    
}    