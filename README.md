# Project Weekend Special

Project Purpose: Working with the South Africa team to organize, structure, analyze, and visualize the weekly data coming in from partners.

![image](https://user-images.githubusercontent.com/8933069/39522542-8d551194-4de0-11e8-8921-e09acd44907f.png)

### WeekendSpecial R Package

This package is used to import, transform, and combine weekly partner data collected in Google Sheets and output a tidy csv file for analysis. 

### Process and how to run the R function

#### First time setup

- The first step is to setup a folder structure for this project on yor local machine. You'll need a folder to store the weekly reports from partners and the combined output. We would recommend the following structure. Focus on setting up the folders and we'll get the files in there that you need later.

  ```
  `-- Weekly Program Data
      |-- WeeklyReports
      |   |-- ANOVA Weekly Programme monitoring.xlsx
      |   |-- BRHC Weekly Programme monitoring.xlsx
      |   |-- FPD Weekly Programme monitoring.xlsx 
      |   `-- etc
      |-- CombinedDataset
      |   `-- Weekly-Programmme-Monitoring_ZAF-USAID_2018-04-30.csv
      |-- SupportingMaterial
      |   `-- ZAF_site-metadata.csv
      `-- Tableau
          `-- Programme Monitoring Report.twbx
  ```

- You will also need to download a file (ZAF_site-metadata.csv) from Google Drive that contains the meta data related to the partners and their sites (eg lat/lon info). This should be stored locally. In the tree diagram above, this file is stored in the SupportingMaterial folder.

- One additional file you'll need is the Tableau file for doing the exploratory analysis. [This file is curretnly a work in progress and we don't yet have this produced]. Download this file from Google Drive and store it locally on your machine. In the tree diagram above, this is located in the Tableau folder.

- If you don't currently have R/RStudio on your machine, you'll need to install that as well. 
   - If you are working on a USAID machine and on AIDNET you can follow these setps to install R.
      - In the window explorer, search for Software Cetenter
      - In Software Center, select RforWindows and then Install
   - Alternatively, you can download R online from CRAN. If you are on a USAID machine, you will need CIO to install the software.
      - In your internet browser navigate to https://cran.r-project.org/
      - At the top, select Download R for Windows
      - When this page loads, select the base link and finally Download R for Windows at the top.
    
- We have created a package to allow you to quickly and easily extract the partner data from each of their weekly reports and combine it all together into one file. You will need to install the following R "packages" the first time you run this. 
   - Open up R.
   - Under File, select New Scipt.
   - In the window that pops up, paste the following script into the R Editor
   - Select all the text, right click and select Run Line or Selection.

  ```
  ## INITIAL SETUP
  
  #install supporting R packages 
    install.packages("tidyverse")
    install.packages("readxl")
    install.packages("devtools")
    install.packages("fs")
    install.packages("getPass")
    devtools::install_github("jason-p-pickering/datim-validation")
  
  #install WeekendSpecial package for ZAF program monitoring data extraction/combination
    devtools::install_github("USAID-ICPI/WeekendSpecial")
  
  ```

#### Weekly Updating

- Each week when you finish collecting your data, you will need to download all the updated Google Sheets and stored them in a folder. In the tree diagram above, this would be in the WeeklyReports folder. There should be nothing else stored in the folder expect the _current_ partners' Google Sheets saved as .xlsx files. (Delete the previous week's data if there are also stored in this folder).

- Once the files are all stored locally on your machine, you can then run the R package/function that will pull in each indicator sheet from each partner's worksheet and output one unifed file. You will need to open R and then run the following lines of code, changing the file paths to the exact folders where your reports and site coordinates are stored and where you want to save the combined dataset.

  ```
  ## WEEKLY UPDATE
  
  #check for updates
    devtools::install_github("USAID-ICPI/WeekendSpecial")
    
  #create combined, tidy dataset (output to csv)
    WeekendSpecial::wpm_combine(folderpath_reports = "C:/Users/.../Weekly Program Data/WeeklyReports", 
                  folderpath_sitecoords = "C:/Users/.../Weekly Program Data/GIS",
                  folderpath_output  = "C:/Users/.../Weekly Program Data/CombinedDataset")
    
  ```

- The above code will output a csv file with a combined dataset that will serve as the basis for the Tableau exploratory analysis.

- [More instructions to come around Tableau when that file is developed.]