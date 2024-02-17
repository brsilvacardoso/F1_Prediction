# Setting Libraries -------------------------------------------------------

library(tidyr)

# Setting File ------------------------------------------------------------

races <- read.csv("./clean_files/races_2018_2023_appended.csv")


# Selecting Columns -------------------------------------------------------

# Races
df_races <-
  select(races, Driver, Driver_Name_Abbreviation, Pos)

View(df_races)



# Pivoting ----------------------------------------------------------------

df_races <- pivot_wider(df_races, names_from = Pos, values_from = Pos, values_fn = length)

df_races[is.na(df_races)] <- 0

View(df_races)

# Saving the dataframe ----------------------------------------------------

write.csv(
  df_races,
  "./clean_files/count_positions.csv"
)
