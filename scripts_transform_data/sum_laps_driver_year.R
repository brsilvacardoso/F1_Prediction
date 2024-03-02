
# Setting libraries -------------------------------------------------------

library(dplyr)

# Setting File ------------------------------------------------------------

races <- read.csv("./clean_files/races_2018_2023_appended.csv")
races

# Selecting Columns -------------------------------------------------------


races <-
  select(races, driver_year,  circuit, laps)

View(races)


# Summing Points ----------------------------------------------------------

sum_laps <- races %>% group_by(driver_year) %>%
  mutate(points_by_year = sum(laps))

sum_laps <- sum_laps %>%
  distinct(driver_year, points_by_year)


# Saving File -------------------------------------------------------------

write.csv(sum_laps_df,
          "./clean_files/sum_drivers_laps_year.csv",
          row.names = FALSE)
