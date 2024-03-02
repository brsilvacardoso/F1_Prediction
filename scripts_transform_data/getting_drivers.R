
# Setting the files paths -------------------------------------------------
getwd()

df_races_2018_2023_appended <-
  read.csv("./clean_files/races_2018_2023_appended.csv")

View(df_races_2018_2023_appended)



# Selecting the column Circuit --------------------------------------------


df_races_2018_2023 <- select(df_races_2018_2023_appended, driver, season, driver_year)

View(df_races_2018_2023)



# Dropping duplicates -----------------------------------------------------


df_races_2018_2023 <- unique(df_races_2018_2023)

View(df_races_2018_2023)




# Saving the file ---------------------------------------------------------


write.csv(df_races_2018_2023,
          "./clean_files/drivers_2018_2023.csv",
          row.names = FALSE)
