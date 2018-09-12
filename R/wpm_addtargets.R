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
    
    #limit target file to what is in the df
      lst_facilities <- unique(df$facilityuid)
      lst_mechs <- unique(df$mechanismid)
      targets <- targets %>% 
        dplyr::filter(facilityuid %in% lst_facilities, mechanismid %in% lst_mechs)
    
    #duplicate each target for each week
      n_weeks <- max(df$fy_week)
      targets_wk <-  
        purrr::map_df(seq_len(n_weeks), ~ targets) %>% 
        dplyr::group_by(mechanismid, facilityuid, indicator, target_wkly) %>% 
        dplyr::mutate(fy_week = row_number())  %>% 
        dplyr::ungroup()
      
    #make TX_CURR target cumulative
      targets_wk <- targets_wk %>% 
        dplyr::mutate(target_wkly = ifelse(indicator == "TX_CURR", fy_week * target_wkly, target_wkly))
    
    #capture start date of fiscal year (for adding date back in)
      start_ymd <- min(df$date)
      
    #expand so each mech/site/ind has a line for merging weekly targets on (even where no results were reported)
      df <- df %>% 
        dplyr::select(-c(date)) %>% #drop date for complete to work correctly
        tidyr::complete(tidyr::nesting(partner, sub_district, facility, tenxten_facility, reporting_freq, provincial_lead, site_lead, indicator, mechanismid, fundingagency, operatingunit, snu1, snu1uid, psnu, psnuuid, community, facilityuid, latitude, longitude), fy_week)
    
    #add date back in  
      df <- df %>% 
        dplyr::mutate(date = lubridate::days((fy_week - 1) * 7) + lubridate::ymd(start_ymd))
      
    #merge targets onto main df (left join -> drop where missing facilities are not captured in weekly reporting but had targets)
      df <- dplyr::left_join(df, targets_wk, by = c("facilityuid", "mechanismid", "indicator", "fy_week"))
      
    } else {
    #add blank columns if the coordinates file does not exist
      df <- df %>% 
        dplyr::mutate(target_wkly = NA)
    }
  
  return(df)
}