
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
                             col_types = readr::cols(.default = "c")) %>% 
      dplyr::mutate_at(dplyr::vars(latitude, longitude), ~ as.numeric(.))
    #drop hiearchy contained in orginal files
    df <- dplyr::select(df, -c(province, district, sub_district))
    #merge onto main df
    df <- dplyr::left_join(df, coord, by = "facility")
  } else {
    #add blank columns if the coordinates file does not exist
    df <- df %>% 
      dplyr::mutate(operatingunit = NA,
                    snu1          = NA, 
                    snu1uid       = NA,
                    psnu          = NA,
                    psnuuid       = NA,
                    facilityuid   = NA,
                    community     = NA,
                    facilityuid   = NA,
                    latitude      = NA, 
                    longitude     = NA)
  }

  return(df)
  
}
