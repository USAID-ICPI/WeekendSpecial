#' Add month and fiscal quarter
#'
#' @param df data frame to add week number to
#' @param date_var unquoted variable that contains the date
#'
#' @export
#' @importFrom dplyr %>%
#'
#' @examples
#' \dontrun{
#'   df_weekly <- wpm_addpds(df_weekly, date)}


wpm_addpds <- function(df, date_var){
  
  #quote user input date variable
    date_var <- dplyr::enquo(date_var)
  
  #figure out location for ordering
    loc <- match("date", names(df)) #TODO - need to change "date" to date_var
  
  #add blank column for ordered placeholder
    df <- df %>% 
      tibble::add_column(month = NA, quarter = NA, .after = loc)
  
  #add date
    df <- df %>% 
      dplyr::mutate(month = lubridate::month(date, label = TRUE),
                    date2 = as.character(lubridate::quarter(date, with_year = TRUE, fiscal_start = 10)),
                    quarter = paste0("FY", stringr::str_sub(date2, start = 3, end = 4),"Q", stringr::str_sub(date2, start = -1))) %>% 
      dplyr::select(-date2) #remove intermediary variables
  
  return(df)
  
}
