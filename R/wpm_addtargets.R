#' Merge targets onto dataframe
#'
#' @param df dataframe to add targets onto
#' @param folderpath_targets folder path where targets are stored
#'
#' @importFrom dplyr %>%
#' @export
#'
#' @examples
#' #' \dontrun{
#'   df_weekly <- wpm_addtargets(df_weekly_full, "~/WPM")}

wpm_addtargets <- function(df, folderpath_targets){
  
  if(!is.null(folderpath_targets)){
    #import target file (explicit for silent read in)
    targets <- readr::read_csv(Sys.glob(file.path(folderpath_targets, "*targets*.csv")),
                             col_types = readr::cols_only(
                               snu1 = "c",
                               snu1uid = "c",
                               psnuuid = "c",
                               mechanismid = "c",
                               facility = "c",
                               indicator = "c",
                               target_wkly = "d")
                              )
    #clean up df prior to merge (remove dups)
      df <- df %>% 
        dplyr::select(-province) %>% 
        dplyr::rename(psnu = district,
                      community = sub_district)
  
    #merge onto main df
      df <- dplyr::left_join(df, coord, by = c("facility", "mechanismid", "indicator"))
      
    } else {
      #add blank columns if the coordinates file does not exist
      df <- df %>% 
        dplyr::rename(psnu = district,
                      community = sub_district) %>% 
        dplyr::mutate(snu1uid = NA,
                      psnuuid = NA,
                      target_wkly = NA)
    }
  
  return(df)
}