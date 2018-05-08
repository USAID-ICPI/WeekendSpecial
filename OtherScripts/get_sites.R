##  Project weekend_special
##  A.Chafetz, USAID
##  Purpose: pull coordinates and hiearchy via API 
##  Date: 2018-05-08
##  Updated: 


# Setup/DATIM login -------------------------------------------------------

  #initialize loadSecrets & login to API; enter DATIM username & password; then URL (datim.org/) when prompted
  datimvalidation::loadSecrets(secrets = NA)


# Function ----------------------------------------------------------------

  #function to pull site location & hierachy (from datimvalidation::getOrganisationUnitMap())
    getSites <-function(organisationUnit=NA,level=NA, folderpath_export = NULL) {
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
        tidyr::separate(path, into = paste0("orgunitlevel_", 0:7), sep = "/") %>% 
        dplyr::rename(facility = name, facility_uid = id, district_uid = orgunitlevel_5) %>%
        dplyr::mutate(snu1 = NA, psnu = NA) %>% 
        dplyr::select(facility, facility_uid, district_uid, lat, long)
      
      if(!is.null(folderpath_export)){
        readr::write_csv(df, file.path(folderpath_export, paste0("SBU_ZAF_sites_",lubridate::today(),"_SBU.csv")), na = "")
      }
      
      return( sites )
    }



# Pull and export ---------------------------------------------------------

  #Call new GetSites function to get site locations as df; must reference OU of interest by UID and site level by #
    df <- getSites("cDGPF739ZZr",7, "GIS") 
  


