#' Combine all Partner MONTLY Data into one tidy dataset
#'
#' @param folderpath_reports what folder are all the partner reports stored in?
#' @param folderpath_output what folder would you like to save the combines output dataset in? If no folder is noted, no file will be saved
#'
#' @export
#' @importFrom dplyr %>%
#'
#' @examples
#'  \dontrun{
#'  df_weekly <- wpm_combine("~/Week_23")}


wpm_combine_monthly <- function(folderpath_reports, folderpath_output = NULL){ 
  
  #genreate full list of sheets within each file
    df_full_list <- wpm_identify(folderpath_reports)
  
  #combine all data into one df
    df_full_monthly <- purrr::map2_dfr(df_full_list$path, df_full_list$sheet_name,
                                      ~ wpm_import_monthly(.x, .y))
  #export
    if(!is.null(folderpath_output)){
      readr::write_csv(df_full_monthly, 
                       file.path(folderpath_output, 
                                 "ZAF-Monthly-Programmme-Monitoring.csv"), 
                       na = "")
    } else {
      return(df_full_monthly)
    }
}
