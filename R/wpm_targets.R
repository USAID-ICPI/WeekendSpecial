# Set up site x IM MSD for FY18 target importation

library(devtools)
load_all()


datafolder <- "C:/Users/GHFP/Documents/data/3.23 refresh"

file <- "ICPI_MER_Structured_Dataset_Site_IM_SouthAfrica_20180323_v2_1.txt"

file2 <- "ICPI_MER_Structured_Dataset_Site_IM_Burundi_20180323_v2_1.txt"

df <- readr::read_tsv(file.path(datafolder, file2),
                      guess_max = 500000) %>% 
         dplyr::rename_all(df, ~ tolower(.)) %>%
        
        

