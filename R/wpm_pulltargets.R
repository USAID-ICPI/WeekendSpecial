#' set up site x IM MSD for FY18 target importation
#'
#' @param filepath_msd what is the full filepath to your MSD file with fy18 targets (including .txt extension)
#' @param folder_output in which folder do you want to store the output .csv file
#' @param countryname what country are you working with (enclose in "")
#'
#' @export
#' @importFrom dplyr %>% 
#' @examples 
#' \dontrun{
#'   wpm_pulltargets("~/data/Burundi_msd.txt", "~/project", "Burundi")}

wpm_pulltargets <- function(filepath_msd, folder_output, countryname) {

  #import site MER Structured Dataset, specifying cols to keep
    df <- readr::read_tsv(filepath_msd,  
                          col_type  = readr::cols_only(
                                                SNU1 = "c",
                                                SNU1Uid = "c",
                                                PSNUuid = "c",
                                                Facility = "c",
                                                FacilityUID = "c",
                                                MechanismID = "c",
                                                indicator = "c",
                                                standardizedDisaggregate = "c",
                                                FY2018_TARGETS = "d"))%>% 
          dplyr::rename_all(~ tolower(.))
  
  #munge
    df <- df %>% 
      #filter to just key variables tracked weekly & drop targets not tied to facilities
      dplyr::filter(indicator %in% c("HTS_TST", "HTS_TST_POS", "TX_NEW", "TX_CURR"),
                    standardizeddisaggregate=="Total Numerator", 
                    !is.na(fy2018_targets), 
                    !is.na(facilityuid)) %>%
      #remove disagg since just needed to pull out total num
      dplyr::select(-standardizeddisaggregate) %>%
      #summarize to catch any targets on multiple rows
      dplyr::group_by_if(is.character) %>% 
      dplyr::summarise(fy2018_targets = sum(fy2018_targets)) %>% 
      dplyr::ungroup() %>%
      #remove any zero targets
      dplyr::filter(fy2018_targets != 0)
    
  #generate a weekly target
    df <- df %>% 
      dplyr::mutate(target_wkly = fy2018_targets / 52) %>% 
      dplyr::select(-fy2018_targets)
      
  #export as csv  
    readr::write_csv(df, file.path(folderpath_output, paste0(countryname, "_fy18_site_targets.csv")), na="")
    
  }
  
  
  
  
