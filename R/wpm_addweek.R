
#' Add week number
#'
#' @param df data frame to add week number to
#' @param date_var unquoted variable that contains the date
#' @param fy_start first Monday of FY, default = "2017-10-02"
#'
#' @export
#' @importFrom dplyr %>%
#'
#' @examples
#' \dontrun{
#'   df_weekly <- wpm_addweek(df_weekly, date)}


wpm_addweek <- function(df, date_var, fy_start = "2017-10-02"){
  
  #quote user input date variable
    date_var <- dplyr::enquo(date_var)
    
  #convert user input date (first Monday of fiscal year) to date
    fy_start <- lubridate::ymd(fy_start)
  
  #figure out location for ordering
    loc <- match("date", names(df)) + 1 #TODO - need to change "date" to date_var
    
  #add blank column for ordered placeholder
    df <- df %>% 
      tibble::add_column(fy_week = NA, .after = loc)
    
  #add date
    df <- df %>% 
      dplyr::mutate(fy_week = (!!date_var - fy_start)/7 + 1)
    
  return(df)
  
}
