

# Setting libraries -------------------------------------------------------

library(dplyr)
library(ggplot2)
library(caret)
library(magrittr)

# Setting File ------------------------------------------------------------

races <- read.csv("./clean_files/sum_points_races_with_sprints.csv")


# Selecting Columns -------------------------------------------------------

races_selected <-
  select(races, driver_year, season, total_points)

races_selected


# Summing Points ----------------------------------------------------------
#
# sum_points_by_driver_year <- df %>% group_by(driver_year) %>%
#   mutate(total_points = sum(total_points))
# view(sum_points_by_driver_year)
#
#
# sum_points_by_driver_year <-
#   select(sum_points_by_driver_year, driver_year, season, total_points)
# #view(sum_points_by_driver_year)
#
# #
# # sum_laps <- sum_laps %>%
# #   distinct(driver_year, laps_year)
#
#
# sum_points_by_driver_year <- df %>%
#   group_by(driver_year, season) %>%
#   summarize(total_points = sum(pts, na.rm = TRUE))
#
# sum_points_by_driver_year <- unique(sum_points_by_driver_year)
#
#
# sum_points_by_driver_year


# Function ----------------------------------------------------------------

calculate_positions <- function(df, season_year) {
  filtered_df <- df %>%
    filter(season == season_year) %>%
    arrange(desc(total_points))
  
  filtered_df$position <- seq_along(filtered_df$total_points)
  
  return(filtered_df)
  
}

filtered_2018 <-
  calculate_positions(races_selected, 2018)

filtered_2019 <-
  calculate_positions(races_selected, 2019)

filtered_2020 <-
  calculate_positions(races_selected, 2020)

filtered_2021 <-
  calculate_positions(races_selected, 2021)

filtered_2022 <-
  calculate_positions(races_selected, 2022)

filtered_2023 <-
  calculate_positions(races_selected, 2023)



# Appending dataframes ----------------------------------------------------

dfs <-
  list(
    filtered_2018,
    filtered_2019,
    filtered_2020,
    filtered_2021,
    filtered_2022,
    filtered_2023
  )

appended_df <- data.frame()

for (df in dfs) {
  appended_df <- rbind(appended_df, df)
}

View(appended_df)


# Saving File -------------------------------------------------------------

write.csv(appended_df,
          "./clean_files/computing_position_by_year.csv",
          row.names = FALSE)
