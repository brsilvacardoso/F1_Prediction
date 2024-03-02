# Setting File ------------------------------------------------------------

races <- read.csv("./Clean_Files/races_2018_2023_appended.csv")

print(colnames(races))


# Counting podiums -----------------------------------------------------------
df_podiums <-
  select(races, driver_year, is_podium)

View(df_podiums)

count_df <-
  as.data.frame(
    table(
      df_podiums$driver_year,
      df_podiums$is_podium
    )
  )

View(count_df)

names(count_df) <-
  c("driver_year", "is_podium", "count")


# Filtering just TRUE values
filtered_df <- filter(count_df, is_podium == TRUE)

View(filtered_df)




# Saving File -------------------------------------------------------------

write.csv(filtered_df,
          "./clean_files/count_podiums_year.csv", row.names = FALSE)
