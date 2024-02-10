
# Setting the files paths -------------------------------------------------
getwd()

df_races_2018_2023_appended <-
  read.csv("./Raw_Files/races_2018_2023_appended.csv")

View(df_races_2018_2023_appended)



# Selecting the column Circuit --------------------------------------------


df_races_2018_2023 <- select(df_races_2018_2023_appended, Driver)

View(df_races_2018_2023)



# Dropping duplicates -----------------------------------------------------


df_races_2018_2023 <- unique(df_races_2018_2023)

View(df_races_2018_2023)



# Saving the file ---------------------------------------------------------


write.csv(df_races_2018_2023,
          "./Clean_Files/Drivers_2018_2023.csv",
          row.names = FALSE)
