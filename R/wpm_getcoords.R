#' Call site coordinates and hierarchy from DATIM via API
#' 
#' @description Adapted from J.Pickering's DATIM Vaidation package - datimvalidation::getOrganisationUnitMap(). Prior to running, you MUST run datimvalidation::loadSecrets()
#'
#' @param organisationUnit what is the UID for the country you would like site coordinates for?
#' @param folderpath_export what is the folderpath where you would like to save the export the file (csv)?
#'
#' @export
#' @importFrom dplyr %>%
#'
#' @examples
#' \dontrun{
#'   wpm_getcoords("cDGPF739ZZr", "GIS")}
#' 
    

  wpm_getcoords <-function(organisationUnit = NA, folderpath_export = NULL) {
    
    #url
      baseurl<-"https://datim.org/"
      url<-paste0(baseurl,"api/organisationUnits?filter=path:like:",organisationUnit, "&fields=id,name,path,coordinates&paging=false")
      
    #API pull from DATIM     
      sites <-URLencode(url) %>%
        httr::GET(httr::timeout(60)
                  #, httr::authenticate(myuser,mypwd())
                  ) %>% 
        httr::content("text") %>% 
        jsonlite::fromJSON(flatten=TRUE) %>% 
        purrr::pluck("organisationUnits") %>% 
        tibble::as_tibble()
      
    #create org unit level column names
      cols <- paste0("lvl_",seq(1,max(stringr::str_count(sites$path,"/"))))
    #split out path into each org unit  
      ou_structure <- sites %>%
        dplyr::mutate(path = stringr::str_remove(path, "^/")) %>% #remove starting / in path
        tidyr::separate(path, into=cols, sep="/", extra = "merge") %>% 
        dplyr::select(-lvl_1:-lvl_2) #remove Global/Region/Country
      
    #identify all levels for pulling in names with mapvalues (lvl_1:lvl_2 removed)
      cols <- ou_structure %>% 
        dplyr::select(dplyr::starts_with("lvl_")) %>% 
        names() 
      
    #clean up structure
      ou_structure <- ou_structure %>%
        #copy over necessary uids
        dplyr::mutate(snu1uid = lvl_4,
                      psnuuid = lvl_5) %>% 
        #map names to replace uids
        dplyr::mutate_at(dplyr::vars(cols), 
                         ~ plyr::mapvalues(.,
                                           sites$id,
                                           sites$name,
                                           warn_missing = FALSE)) %>%
        #remove any higher up levels in the org unit, just want sites
        dplyr::filter(!is.na(lvl_7)) %>% 
        dplyr::select(-lvl_7) %>% 
        #rename
        dplyr::rename(snu1 = lvl_4,
                      psnu = lvl_5,
                      community = lvl_6,
                      facility = name, 
                      facilityuid = id)
     #pull ou OU name for saving 
      ou_name <- unique(ou_structure$lvl_3) %>% 
                 stringr::str_remove_all(., "[:space:]|'")
     #separate out lat/long coordinates   
      ou_structure <- ou_structure %>% 
        dplyr::mutate(coordinates = stringr::str_remove_all(coordinates, "\\[|]")) %>% 
        tidyr::separate(coordinates, c("longitude", "latitude"), sep = ",")
     #reorder for output
      ou_structure <- ou_structure %>% 
        dplyr::select(snu1, snu1uid, psnu, psnuuid, community, facility, facilityuid, latitude, longitude)
    
     #export
      if(!is.null(folderpath_export)){
        readr::write_csv(ou_structure, file.path(folderpath_export, paste0("SBU_", ou_name, "_sites_",lubridate::today(),"_SBU.csv")), na = "")
      }
      
      return(ou_structure)
    }



