
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
    #import coordinates file (explicit for silent read in)
    coord <- readr::read_csv(Sys.glob(file.path(folderpath_orgunits, "*sites*.csv")),
                             col_types = list(
                               facility = "c",
                               facility_uid = "c",
                               lat = "d",
                               long = "d")
    )
    #merge onto main df
    df <- dplyr::left_join(df, coord, by = "facility")
  } else {
    #add blank columns if the coordinates file does not exist
    df <- df %>% 
      dplyr::mutate(facility_uid = NA, 
             lat = NA, 
             long = NA)
  }
  
  #arrange
  df <- df %>% 
    dplyr::select(partner, province, district, sub_district, facility, 
                  facility_uid, lat, long, tenxten_facility, weekly_reporting, 
                  provincial_lead, site_lead,indicator, date, quarter, value)
 
  
  return(df)
  
}
