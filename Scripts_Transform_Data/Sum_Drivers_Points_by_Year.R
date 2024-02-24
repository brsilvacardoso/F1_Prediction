# Setting File ------------------------------------------------------------

races <- read.csv("./clean_files/races_2018_2023_appended.csv")


# Selecting Columns -------------------------------------------------------

df <-
  select(races, driver, driver_year, season, pts)

#View(df)


# Summing Points ----------------------------------------------------------

sum_points_by_driver_year <- df %>%
  group_by(driver_year, driver, season) %>%
  summarize(total_points = sum(pts, na.rm = TRUE))


view(sum_points_by_driver_year)



# Saving File -------------------------------------------------------------

write.csv(sum_points_by_driver_year,
          "./clean_files/sum_points_driver_year.csv", row.names = FALSE)
