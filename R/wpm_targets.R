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
#'   wpm_targets("~/data/Burundi_msd.txt", "~/project", "Burundi")}
wpm_targets <- function(filepath_msd, folder_output, countryname) {

  #import site MER Structured Dataset, specifying cols to keep
    df <- readr::read_tsv(filepath_msd,  
                          col_type  = readr::cols_only(Facility = "c",
                                                FY2018_TARGETS = "d",
                                                FacilityUID = "c",
                                                indicator = "c",
                                                standardizedDisaggregate = "c",
                                                SNU1 = "c",
                                                PSNU = "c",
                                                Community = "c",
                                                CommunityUID = "c"))%>% 
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
      dplyr::ungroup()
  
  readr::write_csv(df, file.path(folderpath_output, paste0(countryname, "_fy18_site_targets.csv")), na="")
    
  }
  
  
  
  
