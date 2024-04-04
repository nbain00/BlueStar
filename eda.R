library(tidyverse)
library(readxl)

# Set working directory
setwd('C:/Users/zink4/OneDrive/Documents/GitHub/BlueStar')

# Read data
bluestar_raw <- read_excel("Blue_Star.xlsx") %>%
  as_tibble() %>%
  janitor::clean_names()

carriers_raw <- read_excel("Carriers.xlsx") %>%
  as_tibble() %>%
  janitor::clean_names()

# Join datasets
bluestar_join <- bluestar_raw %>%
  left_join(carriers_raw, by = 'scac')
