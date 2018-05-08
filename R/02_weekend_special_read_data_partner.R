##  Project weekend_special
##  J Davis, A Chafetz, G Sarfaty, USAID
##  Purpose: munge weekly data from SA partners into one file format
##  Date: 4.29.2018
##  Update: read in partner level files from g-sheets downloads


# Dependancies ------------------------------------------------------------

library(tidyverse)
library(readxl)
# install.packages("googlesheets")
library(googlesheets)
library(lubridate)


# read in partner/tab match table -----------------------------------------

datafolder <- "C:/Users/GHFP/Documents/data/SA_weekend_special/files"


match_table <- read_excel("C:/Users/GHFP/Documents/GitHub/weekend_special/Documents/weekend_special_mapping.xlsx", 
  sheet = "monitoring_tool_structure") %>% 
  rename_all(tolower)


# ANOVA -------------------------------------------------------------------

anova_cats <- filter(match_table, partner == "Anova") %>% 
  select(tabs) %>% 
  filter(tabs %in% c("HTS_TST", "Proxy_HTS_POS", "Proxy_TX_NEW", "TX_CURR"))

## read in data now
setwd(file.path(datafolder)) ## sorry aaron, I couldn't get it to work otherwise

var_type <- rep("date")

df <- read_excel("ANOVA Weekly Programme monitoring.xlsx",
      sheet = "HTS_TST", col_types = "list") %>% 
      rename_all(tolower) 
      
      %>% 
      mutate(indicator = "HTS_TST")
 %>% 
      #rename(sub_district = `sub-district`) %>% 
      gather(week, value, (-c(partner, district, sub_district, facility, indicator))) %>% 
      mutate(week = mdy(week),
         pd = as.character( quarter(week, with_year = TRUE, fiscal_start = 10)),
         quarter = paste0("FY", str_sub(pd, start = 3, end = 4),"Q",str_sub(pd, start = -1)))





















                