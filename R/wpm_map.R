
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
  #import coordinates file
    coord <- readr::read_csv(Sys.glob(file.path(folderpath_orgunits, "*orgunits*.csv")))
  #merge onto main df
    df2 <- dplyr::left_join(df, coord, by = c("facility" = "name"))
  
}