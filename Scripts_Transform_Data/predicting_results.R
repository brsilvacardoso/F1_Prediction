# Importing libraries -----------------------------------------------------

library(dplyr)
library(ggplot2)
library(caret)
library(GGally)
library(magrittr)



# Setting file ------------------------------------------------------------


df_drivers <- read.csv("./clean_files/drivers_2018_2023.csv")
#df_drivers


df_points <- read.csv("./clean_files/sum_points_driver_year.csv")
#df_points


df_wins <- read.csv("./clean_files/count_wins_year.csv")
#df_wins


df_podiums <- read.csv("./clean_files/count_podiums_year.csv")
#df_podiums

df_laps <- read.csv("./clean_files/sum_drivers_laps_year.csv")
#df_laps

df_standings <-
  read.csv("./clean_files/computing _position_by_year.csv")
#df_standings


# Merging files -----------------------------------------------------------

dfs <-
  list(df_drivers,
       df_points,
       df_wins,
       df_podiums,
       df_laps,
       df_standings)


merged_df <-
  Reduce(function(x, y)
    merge(x, y, by = "driver_year"), dfs)


merged_df

# Selecting Columns -------------------------------------------------------

#print(colnames(merged_df))

# Races

merged_df <-
  select(
    merged_df,
    driver.x,
    driver_year,
    season.x,
    Total_Points,
    count_wins,
    count,
    laps_year,
    position
  )


merged_df

merged_df <- merged_df %>%
  rename(
    driver = driver.x,
    season = season.x,
    total_points = Total_Points,
    count_podiums = count
  )

#View(merged_df)

filtered_seasons <-
  filter(merged_df, season >= 2018 & season <= 2022)

#View(filtered_seasons)




# Creating model ----------------------------------------------------------


ggpairs(filtered_seasons, cardinality_threshold = 130)


lm <-
  lm (position ~ count_wins + laps_year + count_podiums, data = filtered_seasons)

summary(lm)

plot(lm)

test <- predict(lm,filtered_seasons)

filtered_seasons$pred <- test
View(filtered_seasons)


# filtered_seasons$count_wins = as.factor(filtered_seasons$count_wins) #converting the column to a factor.
# filtered_seasons$count_podiums = as.factor(filtered_seasons$count_podiums)
# filtered_seasons$laps_year = as.factor(filtered_seasons$laps_year)
#
# lm <-
#   lm (total_points ~ position, data = filtered_seasons)










lm <-
  lm (total_points ~ count_wins + laps_year + position, data = filtered_seasons)

# lm <-
#   lm (total_points ~ count_wins + count_podiums + laps_year + position, data = filtered_seasons)


summary(lm)

preds <- predict(lm, filtered_seasons)
preds

filtered_seasons$preds <- preds
View(filtered_seasons)

RMSE(filtered_seasons$preds, filtered_seasons$total_points)

# Plots -------------------------------------------------------------------
#
# merged_df %>%
#   ggplot(aes(preds, total_points)) +
#   geom_point() +
#   geom_smooth() +
#   ggtitle('Predicted Total Points versus Acual')
# hist(filtered_seasons$position)


# Tests -------------------------------------------------------------------

correlation <-
  cor(filtered_seasons$position, filtered_seasons$count_podiums)

print(correlation)

t.test(filtered_seasons$total_points)$conf.int
