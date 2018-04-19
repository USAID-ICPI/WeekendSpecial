##  Project weekend_special
##  J Davis, A Chafetz, G Sarfaty, USAID
##  Purpose: munge weekly data from SA partners into one file format
##  Date: 4.19.2018
##  Update:


# Dependancies ------------------------------------------------------------

library(tidyverse)
library(readxl)
# install.packages("googlesheets")
library(googlesheets)
library(lubridate)



# Read in data ------------------------------------------------------------
##  nb: as of 4.19.2018 HQ only had access to xlsx file, consider updating
##  using googlesheets:: when google drive access is granted

  datafolder <- "C:/Users/GHFP/Documents/data/3.23 refresh"
  temp_import <- read_xlsx(file.path(datafolder, "Collated weekly reports - DCM - Merged (2).xlsx")) %>% 
    rename_all(tolower)
  

# Reshape -----------------------------------------------------------------

  sa_week <- temp_import %>%
      rename(sub_district = `sub-district`) %>% 
      gather(week, value, (-c(partner, district, sub_district, facility, indicator))) %>% 
      mutate(week = mdy(week),
             pd = as.character( quarter(week, with_year = TRUE, fiscal_start = 10)),
             quarter = paste0("FY", str_sub(pd, start = 3, end = 4),"Q",str_sub(pd, start = -1)))
  
  rm(temp_import)

# Create orglevel objects -------------------------------------------------

  sa_week_district <- sa_week %>%
      distinct(district) %>% 
      arrange(district)
  
  sa_week_sub_dist <- sa_week %>%
      distinct(sub_district) %>% 
      arrange(sub_district)
      
  sa_week_fac <- sa_week %>%
    distinct(facility) %>% 
    arrange(facility)
  
  sa_week_part <- sa_week %>%
    distinct(partner) %>% 
    arrange(partner)
    
    
    
    
    
    
  
  
  
  
  
