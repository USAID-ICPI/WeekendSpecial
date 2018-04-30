#' Combine all Partner Weekly Data into one tidy dataset
#'
#' @param folderpath_reports what folder are all the partner reports stored in?
#' @param folderpath_output what folder would you like to save the combines output dataset in? If no folder is noted, no file will be saved
#'
#' @return
#' @export
#' @importFrom dplyr %>%
#'
#' @examples
#'  \dontrun{
#'  df_weekly <- sheet_combine("~/Week_23")}

sheet_combine <- function(folderpath_reports, folderpath_output = NULL){ 

  #genreate full list of sheets within each file
    df_full_list <- sheet_identify(folder)
  
  #combine all data into one df
    df_full_weekly <- purrr::map2_dfr(df_full_list$path, df_full_list$sheet_name,
                                   ~ sheet_import(.x, .y))
  #export
    if(!is.null(folderpath_output)){
    readr::write_csv(df_full_weekly, 
                     file.path(folderpath_output, 
                               paste("Output/ZAF-USAID_Weekly-Programmme-Monitoring_", 
                               lubridate::today(), ".csv")), 
                     na = "")
    } else {
      return(df_full_weekly)
    }
}