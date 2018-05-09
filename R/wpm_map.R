
#' Add coordinates and uids to 
#'
#' @param df dataframe to add coorindates/uids to
#' @param folderpath_orgunits what folder are the org units stored in?
#'
#' @export
#'
#' @examples
#' \dontrun{
#'  df <- wpm_combine(df,"~/WPM/GIS")}

wpm_map <- function(df, folderpath_orgunits){
  if(!is.null(folderpath_orgunits)){
  #import coordinates file
    coord <- readr::read_csv(Sys.glob(file.path(folderpath_orgunits, "*sites*.csv")))
  #merge onto main df
    df <- dplyr::left_join(df, coord, by = c("facility" = "name"))
  } else {
    #add blank columsn if the coordinates file does not exist
    df <- df %>% 
      mutate(facility_uid = NA, 
             district_uid = NA, 
             lat = NA, 
             long = NA)
  }
  
  return(df)
  
}
