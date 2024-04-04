library(tidyverse)
library(readxl)

setwd('C:/Users/zink4/OneDrive/Documents/GitHub/BlueStar')

bluestar_excel <- read_excel("Blue_Star.xlsx")
bluestar_raw <- as_tibble(bluestar_excel)
#bluestar_raw %>% glimpse

carriers_excel <- read_excel("Carriers.xlsx")
carriers_raw <- as_tibble(carriers_excel)
#carriers_raw %>% glimpse

bluestar_join <- bluestar_raw %>% 
  left_join(carriers_raw, by = 'SCAC') %>% 
  janitor::clean_names()

# There are some cities that exist in multiple states. Thus dest_city is not a unique identifier.
bluestar_join %>% 
  count(dest_city, dest_state) %>% 
  group_by(dest_city) %>% 
  summarize(n = n()) %>% 
  arrange(desc(n))




