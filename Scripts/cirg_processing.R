library(tidyverse)
library(glamr)
library(grabr)
library(Interesting)
library(googledrive)
library(googlesheets4)


# Processing folder, to run each quarter
proc_folder <<- "cirg-submissions"

# Processing Date (today's date or you can specify the date), to run each quarter
proc_date <<- "2022-09-13"

#cir_setup(folder = proc_folder, dt = proc_date) do not need to run again
cir_setup(folder = proc_folder, dt = proc_date)

#set this to save to "raw" data folder  
dir_raw <<- cir_folder(type = "raw", dt = proc_date)


subm <<- fs::dir_ls(dir_raw, regexp = "CIRG_.*.xlsx$")


# Initial Validation
# meta <- subm %>%
#   dplyr::first() %>%
#   validate_initial()

metas <- subm %>%
  map_dfr(validate_initial)


# Import, Validations & Transformations
df_subm <- subm %>%
  map_dfr(cir_processing)
  # dplyr::first() %>%
  cir_processing()
  
  ## TEST!
