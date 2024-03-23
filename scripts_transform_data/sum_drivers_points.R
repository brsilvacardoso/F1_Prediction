# Setting File ------------------------------------------------------------

races <- read.csv("./clean_files/races_2018_2023_appended.csv")


# Selecting Columns -------------------------------------------------------


races <-
  select(races, driver_name_abbreviation,  pts)

View(races)


# Summing Points ----------------------------------------------------------

sum_points <-
  tapply(races$pts, races$driver, FUN = sum, na.rm = TRUE)


# Converting to dataframe
sum_points_df <-
  data.frame(driver = names(sum_points),
             doints = sum_points,
             row.names = NULL)

View(sum_points_df)


# Saving File -------------------------------------------------------------

write.csv(sum_points_df,
          "./Clean_Files/sum_drivers_points.csv", row.names = FALSE)
