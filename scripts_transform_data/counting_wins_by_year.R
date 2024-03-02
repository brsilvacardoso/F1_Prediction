# Setting File ------------------------------------------------------------

races <- read.csv("./clean_files/races_2018_2023_appended.csv")

print(colnames(races))



# Counting Wins -----------------------------------------------------------
df_winner <- select(races, driver, driver_year, is_winner)

#View(df_winner)

count_df <-
  as.data.frame(table(df_winner$driver_year, df_winner$is_winner))

View(count_df)

names(count_df) <- c("driver_year", "is_winner", "count_wins")

filtered_df <- filter(count_df, is_winner == TRUE)

View(filtered_df)



# Selecting columns -------------------------------------------------------

filtered_df <- select(filtered_df, driver_year, count_wins)

View(filtered_df)


# Saving File -------------------------------------------------------------

write.csv(filtered_df,
          "./clean_files/count_wins_year.csv", row.names = FALSE)
