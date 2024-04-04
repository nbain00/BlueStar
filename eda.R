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

# Clean zip codes
bluestar_join <- bluestar_join %>% 
  mutate(dest_zip = substr(dest_zip, 1, 5))

# This simplifies the zip codes to make showing outliers easier
simple_zip <- bluestar_join %>% 
  mutate(dest_zip = substr(dest_zip, 1, 2))

# This is a tibble that shows which dest_city, dest_state have zip codes that are likely false
multiple_zip <- simple_zip %>% 
  group_by(dest_city, dest_state, dest_zip) %>% 
  summarize(zip_count = n()) %>% 
  group_by(dest_city, dest_state) %>% 
  filter(n_distinct(dest_zip) > 1) %>% 
  ungroup() %>% 
  arrange(desc(zip_count)) %>% 
  arrange(dest_city, dest_state)

problem_zip <- multiple_zip %>% 
  group_by(dest_city, dest_state) %>% 
  slice_min(zip_count, n = 1)

# This takes the problem zip codes and replace them with the mode
zip_fix <- simple_zip %>% 
  mutate(dest_zip = if_else(dest_state == 'NM' & dest_zip == '75', '87', dest_zip)) %>% 
  mutate(dest_zip = if_else(dest_state == 'OH' & dest_zip == '12', '44', dest_zip)) %>% 
  mutate(dest_zip = if_else(dest_city == 'CARROLLTON' & dest_state == 'TX' & dest_zip == '64', '75', dest_zip)) %>% 
  mutate(dest_zip = if_else(dest_city == 'DALLAS' & dest_state == 'TX' & dest_zip == '45', '75', dest_zip)) %>% 
  mutate(dest_zip = if_else(dest_city == 'FONTANA' & dest_state == 'CA' & dest_zip == '75', '91', dest_zip)) %>% 
  mutate(dest_zip = if_else(dest_state == 'NC' & dest_zip == '57', '27', dest_zip)) %>% 
  mutate(dest_zip = if_else(dest_state == 'OH' & dest_zip == '30', '45', dest_zip)) %>% 
  mutate(dest_zip = if_else(dest_state == 'GA' & dest_zip == '60', '30', dest_zip)) %>% 
  mutate(dest_zip = if_else(dest_state == 'MO' & dest_zip == '46', '64', dest_zip))

# Prove it worked
zip_fix %>% 
  group_by(dest_city, dest_state, dest_zip) %>% 
  summarize(zip_count = n()) %>% 
  group_by(dest_city, dest_state) %>% 
  filter(n_distinct(dest_zip) > 1) %>% 
  ungroup() %>% 
  arrange(desc(zip_count)) %>% 
  arrange(dest_city, dest_state) %>% 
  group_by(dest_city, dest_state) %>% 
  slice_min(zip_count, n = 1)
