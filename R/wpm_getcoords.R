#' Call site coordinates and hierarchy from DATIM via API
#' 
#' @description Adapted from J.Pickering's DATIM Vaidation package - datimvalidation::getOrganisationUnitMap(). Prior to running, you MUST run datimvalidation::loadSecrets()
#'
#' @param organisationUnit what is the UID for the country you would like site coordinates for?
#' @param level what is the site level in DATIM, eg 7?
#' @param ou_name what is the name of the country? (used for saving)
#' @param folderpath_export what is the folderpath where you would like to save the export the file (csv)?
#'
#' @export
#' @importFrom dplyr %>%
#'
#' @examples
#' \dontrun{
#'   wpm_getcoords("cDGPF739ZZr", 7, "ZAF", "GIS")}
#' 
    

  wpm_getcoords <-function(organisationUnit = NA,level= NA, ou_name = NA, folderpath_export = NULL) {
      if ( is.na(organisationUnit) ) { organisationUnit<-getOption("organisationUnit") }
      url<-URLencode(paste0(getOption("baseurl"),"api/organisationUnits.json?&filter=path:like:",organisationUnit,"&fields=id,name,path,coordinates&paging=false&filter=level:eq:",level))
      sig<-digest::digest(url,algo='md5', serialize = FALSE)
      sites<-datimvalidation::getCachedObject(sig)
      if (is.null(sites)){
        r<-httr::GET(url,httr::timeout(600))
        if (r$status == 200L ){
          r<- httr::content(r, "text")
          sites<-jsonlite::fromJSON(r,flatten=TRUE)[[1]]
          datimvalidation::saveCachedObject(sites,sig)
        } else {
          print(paste("Could not retreive site listing",httr::content(r,"text")))
          stop()
        }
      }
      sites <- sites %>% 
        dplyr::mutate(coordinates = stringr::str_remove_all(coordinates, "\\[|]")) %>% 
        tidyr::separate(coordinates, c("lat", "long"), sep = ",") %>% 
        #tidyr::separate(path, into = paste0("orgunitlevel_", 0:7), sep = "/") %>% 
        dplyr::rename(facility = name, facilityuid = id) %>%
        #dplyr::mutate(snu1 = NA, psnu = NA) %>% 
        dplyr::select(facility, facilityuid, lat, long)
      
      if(!is.null(folderpath_export)){
        readr::write_csv(sites, file.path(folderpath_export, paste0("SBU_", ou_name, "_sites_",lubridate::today(),"_SBU.csv")), na = "")
      }
      
      return( sites )
    }



