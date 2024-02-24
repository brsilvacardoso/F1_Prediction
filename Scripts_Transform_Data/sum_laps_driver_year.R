
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

sum_laps <-
  tapply(races$laps, races$driver_year, FUN = sum, na.rm = TRUE)


# Converting to dataframe
sum_laps_df <-
  data.frame(driver_year = names(sum_laps),
             laps_year = sum_laps,
             row.names = NULL)

View(sum_laps_df)


# Saving File -------------------------------------------------------------

write.csv(sum_points_df,
          "./Clean_Files/sum_drivers_points.csv",
          row.names = FALSE)
