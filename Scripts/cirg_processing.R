# AUTHOR:   J. Lara | F. Ferreira | USAID
# PURPOSE:  process quarterly custom indicator submissions
# REF ID:   bd5d59eb 
# LICENSE:  MIT
# DATE:     2022-09-13
# UPDATED: 

# DEPENDENCIES ------------------------------------------------------------------
  
library(tidyverse)
library(glamr)
library(grabr)
library(Interesting)
library(googledrive)
library(googlesheets4)

# GLOBAL VARIABLES --------------------------------------------------------------
  
  #script reference number
  ref_id <- "bd5d59eb"
  
  # Processing folder, to run each quarter
  proc_folder <<- "cirg-submissions"
  
  # Processing Date (today's date or you can specify the date), to run each quarter
  proc_date <<- "2022-09-13"
  

# SET UP ------------------------------------------------------------------------
  
  #cir_setup(folder = proc_folder, dt = proc_date) - once you have the working
  # directory set up that you need, do not need to run again
  cir_setup(folder = proc_folder, dt = proc_date)
  
  #set this to save to "raw" data folder  
  dir_raw <<- cir_folder(type = "raw", dt = proc_date)

# IMPORT RAW FILES AND PROCESS --------------------------------------------------

subm <<- fs::dir_ls(dir_raw, regexp = "CIRG_.*.xlsx$")

# Initial Validation
# meta <- subm %>%
#   dplyr::first() %>%
#   validate_initial()

# Run the meta data validation for all files in the folder for initial check
metas <- subm %>%
  map_dfr(validate_initial)


# Import, Validations & Transformations
# cir_processing() will import, validation, and transform the data and save the files to the appropriate folders
df_subm <- subm %>%
  map_dfr(cir_processing)
  
# CLEAN UP AND APPEND FILES TOGETHER --------------------------------------------

#grab folder path and submissions in folder
dir_transformed <<- cir_folder(type = "transformed", dt = proc_date)
subm_processed <<- fs::dir_ls(dir_transformed)

#read transformed files in and filter out the ROW_ID bug
df_cirg_transformed <- subm_processed %>% 
  map_dfr(read_csv) %>% 
  filter(indicator != "ROW_ID")

#Now, you can read data out to a csv or xlsx file if needed


  
  
  
  
  