# Setting libraries -------------------------------------------------------

library(dplyr)


# Setting File ------------------------------------------------------------

races <- read.csv("./clean_files/sum_points_driver_year.csv")
sprint_races <-
  read.csv("./clean_files/sprint_races_sum_points_driver_year.csv")

View(races)
View(sprint_races)



# Renaming columns --------------------------------------------------------

races <- races %>%
  rename(total_points =  Total_Points)

races

sprint_races <- sprint_races %>%
  rename(total_points_sprint =  total_points)

sprint_races


# Selecting columns -------------------------------------------------------

sprint_races_selected <-
  select(sprint_races, driver_year, total_points_sprint)
sprint_races_selected


# Merging dataframes ------------------------------------------------------


races_with_sprints <-
  merge(races, sprint_races_selected, by = "driver_year", all.x = TRUE)

View(races_with_sprints)



# Summing races and sprint races points -----------------------------------

races_with_sprints$total_points <-
  races_with_sprints$total_points + races_with_sprints$total_points_sprint

View(races_with_sprints)


# Saving the dataframe ----------------------------------------------------

write.csv(
  races_with_sprints,
  "./clean_files/sum_points_races_with_sprints.csv"
)
