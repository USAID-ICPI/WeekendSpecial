#' Merge targets onto dataframe
#'
#' @param df dataframe to add targets onto
#' @param folderpath_targets folder path where targets are stored
#'
#' @importFrom dplyr %>%
#' @export
#'


wpm_addtargets <- function(df, folderpath_targets){
  
  if(!is.null(folderpath_targets)){
    #import target file (explicit for silent read in)
      targets <- readr::read_csv(Sys.glob(file.path(folderpath_targets, "*targets*.csv")),
                             col_types = readr::cols_only(
                               snu1 = "c",
                               snu1uid = "c",
                               psnuuid = "c",
                               mechanismid = "c",
                               facilityuid = "c",
                               facility = "c",
                               indicator = "c",
                               target_wkly = "d")
                              )
      
    #clean up target file prior to merge (make sure we can merge (may be missing hierarchy if don't have site file))
      targets <- dplyr::select(targets, -c(snu1,  snu1uid, psnuuid, facility))
  
    #merge onto main df
      df <- dplyr::left_join(df, targets, by = c("facilityuid", "mechanismid", "indicator"))
    
    #make TX_CURR target cumulative
      df <- df %>% 
        dplyr::mutate(target_wkly = ifelse(indicator == "TX_CURR", fy_week * target_wkly, target_wkly))
      
    } else {
    #add blank columns if the coordinates file does not exist
      df <- df %>% 
        dplyr::mutate(target_wkly = NA)
    }
  
  return(df)
}