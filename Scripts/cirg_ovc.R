
# PURPOSE:  Munge and Analysis of OVC CIRG DATA
# AUTHOR:  Joe Lara | USAID
# DATE: 2021-06-02
# NOTES: 

## LOCALS & SETUP ------------------------
#

library(tidyverse)
library(glamr)
library(glitr)
library(readxl)
library(janitor)
library(glue)

## LOAD DATA ----------------------------
#


ovc_offer_cirg <- read_excel("Data/CIRG_FY21_Q2_MOZAMBIQUE_20210514.xlsx", skip = 1, sheet = "OVC_OFFER_CIRG")
ovc_enroll_cirg <- read_excel("Data/CIRG_FY21_Q2_MOZAMBIQUE_20210514.xlsx", skip = 1, sheet = "OVC_ENROLL_CIRG")
ovc_vl_eligible_cirg <- read_excel("Data/CIRG_FY21_Q2_MOZAMBIQUE_20210514.xlsx", skip = 1, sheet = "OVC_VL_ELIGIBLE_CIRG")
ovc_vlr_cirg <- read_excel("Data/CIRG_FY21_Q2_MOZAMBIQUE_20210514.xlsx", skip = 1, sheet = "OVC_VLR_CIRG")
ovc_vls_cirg <- read_excel("Data/CIRG_FY21_Q2_MOZAMBIQUE_20210514.xlsx", skip = 1, sheet = "OVC_VLS_CIRG")

## MUNGE ---------------------------------
#

ovc_offer_cirg_2 <- ovc_offer_cirg %>% 
  pivot_longer(cols = starts_with("ovc_"),
               names_to = "indicator",
               values_to = "value") %>% 
  separate(indicator, c("indicator", "age", "sex"), sep = "\\.", extra = "drop") %>% 
  mutate(age = recode(age,
                      "u1" = "<1",
                      "1_4" = "1-4",
                      "5_9" = "5-9",
                      "10_14" = "10-14",
                      "15_17" = "15-17",
                      "o18" = "18+"))


ovc_enroll_cirg_2 <- ovc_enroll_cirg %>% 
  pivot_longer(cols = starts_with("ovc_"),
               names_to = "indicator",
               values_to = "value") %>% 
  separate(indicator, c("indicator", "age", "sex"), sep = "\\.", extra = "drop") %>% 
  mutate(age = recode(age,
                      "u1" = "<1",
                      "1_4" = "1-4",
                      "5_9" = "5-9",
                      "10_14" = "10-14",
                      "15_17" = "15-17",
                      "o18" = "18+"))

ovc_vl_eligible_cirg_2 <- ovc_vl_eligible_cirg %>% 
  pivot_longer(cols = starts_with("ovc_"),
               names_to = "indicator",
               values_to = "value") %>% 
  separate(indicator, c("indicator", "age", "sex"), sep = "\\.", extra = "drop") %>% 
  mutate(age = recode(age,
                      "u1" = "<1",
                      "1_4" = "1-4",
                      "5_9" = "5-9",
                      "10_14" = "10-14",
                      "15_17" = "15-17",
                      "o18" = "18+"))

ovc_vlr_cirg_2 <- ovc_vlr_cirg %>% 
  pivot_longer(cols = starts_with("ovc_"),
               names_to = "indicator",
               values_to = "value") %>% 
  separate(indicator, c("indicator", "age", "sex", "temp", "disaggregate"), sep = "\\.", extra = "drop") %>% 
  mutate(age = recode(age,
                      "u1" = "<1",
                      "1_4" = "1-4",
                      "5_9" = "5-9",
                      "10_14" = "10-14",
                      "15_17" = "15-17",
                      "o18" = "18+")) %>% 
  select(-c(temp))


ovc_vls_cirg_2 <- ovc_vls_cirg %>% 
  pivot_longer(cols = starts_with("ovc_"),
               names_to = "indicator",
               values_to = "value") %>% 
  separate(indicator, c("indicator", "age", "sex", "temp", "disaggregate"), sep = "\\.", extra = "drop") %>% 
  mutate(age = recode(age,
                      "u1" = "<1",
                      "1_4" = "1-4",
                      "5_9" = "5-9",
                      "10_14" = "10-14",
                      "15_17" = "15-17",
                      "o18" = "18+")) %>% 
  select(-c(temp))

ovc_cirg <- bind_rows(ovc_offer_cirg_2, ovc_enroll_cirg_2, ovc_vl_eligible_cirg_2, ovc_vlr_cirg_2, ovc_vls_cirg_2)
rm(ovc_offer_cirg_2, ovc_enroll_cirg_2, ovc_vl_eligible_cirg_2, ovc_vlr_cirg_2, ovc_vls_cirg_2, ovc_offer_cirg, ovc_enroll_cirg, ovc_vl_eligible_cirg, ovc_vlr_cirg, ovc_vls_cirg)

## BIND DATAFRAMES & PIVOT WIDE ---------------------------------
#

ovc_cirg_2 <- ovc_cirg %>% 
  mutate(partner = recode(partner,
                      "ANDA - Manica" = "ANDA",
                      "NWETI HEALTH COMMUNICATION" = "Nweti",
                      "ComuSanas_OVC Response Sofala" = "Comusanas",
                      "NWETIHEALTHCOMMUNICATION" = "Nweti",
                      "Service Delivery and Support for Orphans and Vulnerable Children" = "COVIDA")) %>% 
  drop_na(value) %>% 
  pivot_wider(names_from = indicator, values_from = value, values_fill = NULL)


## SAVE TO DISK ---------------------
#

readr::write_tsv(
  ovc_cirg_2,
  "Dataout/ovc_cirg.txt",
  na ="")
