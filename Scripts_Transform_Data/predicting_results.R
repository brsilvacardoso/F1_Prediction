

# Importing libraries -----------------------------------------------------


library(Lahman)
library(dplyr)
library(ggplot2)
library(caret)
library(magrittr)


# Setting file ------------------------------------------------------------


df_drivers <- read.csv("./clean_files/drivers_2018_2023.csv")
df_drivers


df_points <- read.csv("./clean_files/sum_points_driver_year.csv")
df_points


df_wins <- read.csv("./clean_files/count_wins_year.csv")
df_wins


df_podiums <- read.csv("./clean_files/count_podiums_year.csv")
df_podiums



# Merging files -----------------------------------------------------------

dfs <- list(df_drivers, df_points, df_wins, df_podiums)


merged_df <-
  Reduce(function(x, y)
    merge(x, y, by = "driver_year"), dfs)

#merged_df <- merge(df_drivers, df_points, by = "driver_year")

View(merged_df)

# Selecting Columns -------------------------------------------------------

print(colnames(merged_df))

# Races

merged_df <-
  select(merged_df,
         driver.x,
         driver_year,
         season.x,
         Total_Points,
         count_wins,
         count)


merged_df

merged_df <- merged_df %>%
  rename(
    driver = driver.x,
    season = season.x,
    total_points = Total_Points,
    count_podiums = count
  )

merged_df


# Creating model ----------------------------------------------------------

lm <-
  lm (total_points ~ count_wins + count_podiums, data = merged_df)


summary(lm)

preds <- predict(lm, merged_df)
preds

merged_df$preds <- preds
View(merged_df)



# Plots -------------------------------------------------------------------

merged_df %>%
  ggplot(aes(preds, total_points)) +
  geom_point() +
  geom_smooth() +
  ggtitle('Predicted Total Points versus Acual')

