# Setting File ------------------------------------------------------------

races <- read.csv("./Clean_Files/races_2018_2023_appended.csv")

# Races
df_races <-
  select(races, Driver_Year, Is_Winner)

View(df_races)


#Year
df_year <-
  select(races, Driver, Driver_Name_Abbreviation, Year, Driver_Year)

#Getting unique values
df_year <- unique(df_year)

#View(df_year)

# Counting Wins -----------------------------------------------------------
df_winner <- select(races, Driver_Year, Is_Winner)

#View(df_winner)

count_df <-
  as.data.frame(table(df_winner$Driver_Year, df_winner$Is_Winner))

#View(count_df)

names(count_df) <- c("Driver_Year", "Is_Winner", "Count")

#View(count_df)



# Pivot the dataframe -----------------------------------------------------

count_df <-
  pivot_wider(count_df, names_from = "Is_Winner", values_from = "Count")

names(count_df) <- c("Driver_Year", "Is_Winner_false", "Is_Winner_true")

#View(count_df)




# Merging dataframes ------------------------------------------------------

merged_df <-
  merge(x = count_df,
        y = df_year,
        by = "Driver_Year",
        all.x = TRUE)

View(merged_df)


# Saving File -------------------------------------------------------------

write.csv(merged_df,
          "./Clean_Files/count_wins_year.csv", row.names = FALSE)
