#' Create a linkage variable
#'
#' @param df dataframe to add proxy linkage to
#'
#' @importFrom dplyr %>%
#' @export
#'


wpm_genlinkage <- function(df){
  
  #capture variable order for reshape
    order <- names(df)
  
  #filter to just keep indicators needed for linkage calculation
    df_linkage <- df %>% 
      dplyr::filter(indicator %in% c("HTS_TST_POS", "TX_NEW")) %>% 
  
  #reshape so that all numbers results/targets are in one column
      tidyr::gather(type, val, value, target_wkly) %>% 
  #then cast so each variable for each site is in the same row
      tidyr::spread(indicator, val, fill = 0) %>% 
  #generate linkage variable, rounded to 3 decimal places, filtering out Inf values
      dplyr::mutate(linkage = round(TX_NEW / HTS_TST_POS, 3)) %>%
      dplyr::filter(is.finite(linkage)) %>% 
  #remove unnecessary indicators now that variable is created
      dplyr::select(-HTS_TST_POS, -TX_NEW) %>% 
  #add an indicator column for appending onto the original dataset
      dplyr::mutate(indicator = "PROXY_LINKAGE") %>% 
  #cast wide so target and result are in separate columns
      tidyr::spread(type, linkage) %>% 
  #reorder to match original df for appending
      dplyr::select(order)
  
  #append linkage values onto 
    df <- dplyr::bind_rows(df, df_linkage) 
  
  return(df)
}

