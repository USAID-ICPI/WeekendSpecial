#' Identify all files and their sheets within
#'
#' @param folderpath what folder are the weekly files stored in? 
#'
#' @export
#' @importFrom dplyr %>%
#' 
#' @examples
#' \dontrun{
#' wpm_identify("~/project_x") }

wpm_identify <- function(folderpath){
  
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
    dplyr::filter(stringr::str_detect(sheet_name, "HTS|Early|IPT|Waiting|nconfirmed|TX_CURR|TX_NEW|20"))
  
  return(df)
  
}
