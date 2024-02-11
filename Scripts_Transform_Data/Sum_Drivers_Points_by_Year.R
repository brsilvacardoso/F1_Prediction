# Setting File ------------------------------------------------------------

races <- read.csv("./Clean_Files/races_2018_2023_appended.csv")


# Selecting Columns -------------------------------------------------------

# Races
df_races <-
  select(races, Driver_Year, PTS)

#View(df_races)


# Summing Points ----------------------------------------------------------

sum_points <-
  tapply(df_races$PTS,
         df_races$Driver_Year,
         FUN = sum,
         na.rm = TRUE)


# Converting to dataframe
sum_points_df <-
  data.frame(
    Driver_Year = names(sum_points),
    Points = sum_points,
    row.names = NULL
  )

View(sum_points_df)


# Saving File -------------------------------------------------------------

write.csv(sum_points_df,
          "./Clean_Files/sum_points_driver_year.csv", row.names = FALSE)

