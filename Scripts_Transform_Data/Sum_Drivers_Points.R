# Setting File ------------------------------------------------------------

races <- read.csv("./clean_files/races_2018_2023_appended.csv")


# Selecting Columns -------------------------------------------------------


races <-
  select(races, Driver_Name_Abbreviation,  PTS)

View(races)


# Summing Points ----------------------------------------------------------

sum_points <-
  tapply(races$PTS, races$Driver, FUN = sum, na.rm = TRUE)


# Converting to dataframe
sum_points_df <-
  data.frame(Driver = names(sum_points),
             Points = sum_points,
             row.names = NULL)

View(sum_points_df)


# Saving File -------------------------------------------------------------

write.csv(sum_points_df,
          "./Clean_Files/sum_drivers_points.csv", row.names = FALSE)
