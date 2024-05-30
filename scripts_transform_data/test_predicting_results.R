# Goal --------------------------------------------------------------------

# The goal of this file is to test the linear model. It is trying to predict the F1 result based on the points from 2018 to 2022.

# Importing libraries -----------------------------------------------------

library(dplyr)
library(ggplot2)
library(tidyverse)
library(caret)
library(GGally)
library(magrittr)
library(corrplot)
library(DescTools)

# Setting file ------------------------------------------------------------


df_drivers <- read.csv("./clean_files/drivers_2018_2023.csv")
#df_drivers


# df_points <- read.csv("./clean_files/sum_points_races_with_sprints.csv")
# View(df_points)


df_wins <- read.csv("./clean_files/count_wins_year.csv")
#df_wins


df_podiums <- read.csv("./clean_files/count_podiums_year.csv")
#df_podiums

df_laps <- read.csv("./clean_files/sum_drivers_laps_year.csv")
#df_laps

df_standings <-
  read.csv("./clean_files/computing_position_by_year.csv")
#df_standings



# Merging files -----------------------------------------------------------

dfs <-
  list(df_drivers, df_wins, df_podiums, df_laps, df_standings)

#head(dfs)

merged_df <-
  Reduce(function(x, y)
    merge(x, y, by = "driver_year"), dfs)


head (merged_df, n = 5L)


# Selecting Columns in dataframe -------------------------------------------------------

#print(colnames(merged_df))

# Races

merged_df <-
  select(
    merged_df,
    driver,
    driver_year,
    season.x,
    total_points,
    count_wins,
    count,
    laps_year,
    position
  )


merged_df <- merged_df %>%
  rename(season = season.x, count_podiums = count)


head(merged_df, n = 10L)



# Splitting dataframes ----------------------------------------------------

# Spiting dataframes: one to predict 2023, other to compare results in 2023.

# Filtering results equal 2023


df_results_2023 <- merged_df %>%
  filter(season == 2023)

# Selecting columns in df_results_2023
df_results_2023 <-
  select(df_results_2023,
         driver,
         driver_year,
         season,
         total_points,
         position)

head(df_results_2023, n = 5L)

# Renaming coluns in df_results_2023

df_results_2023 <- df_results_2023 %>%
  rename(
    season_2023 = season,
    total_points_2023 = total_points,
    position_2023 = position
  )



head(df_results_2023, n = 10L)


merged_df <- merged_df %>%
  filter(season >= 2018 & season <= 2022)

head(merged_df, n = 10L)

# Preliminary analyses ----------------------------------------------------

#Descriptive statistics
summary(merged_df)
summary(df_results_2023)


# Creating correlation matrix
merged_df_numeric <-
  subset(merged_df, select = sapply(merged_df, is.numeric))

correlation_matrix <- round(cor(merged_df_numeric), 4)

print(correlation_matrix)

# Checking the correlations visual ------------------------------------------------

#Checking position and laps year
# ggplot(data = merged_df, aes(x = position, y = total_points)) +
#   geom_point() +
#   scale_x_continuous(breaks = seq(0, 22, by = 1), labels = seq(0, 22, by = 1))


# Selecting columns to check the correlation using corrplot (colorful)
df_cor_matrix <-
  select(merged_df,
         total_points,
         count_wins,
         count_podiums,
         laps_year,
         position)


#merged_df[] <- lapply(merged_df, as.numeric)
cor_matrix <- cor(df_cor_matrix)
#corrplot(cor_matrix)


#ggpairs(merged_df, cardinality_threshold = 130)


# Testing and fit model to predict points -------------------------------------------------------

# Renaming the dataframe to train and test

merged_df_test_points <- merged_df
head(merged_df_test_points, n = 5L)

set.seed(128)

# Split the data into predictors (X) and response (y)
x <-
  merged_df_test_points[, c('position', 'count_podiums', 'count_wins', 'laps_year')]
y <- merged_df_test_points$total_points

# Split the data into train and test sets
split <- createDataPartition(y, p = 0.8, list = FALSE)
x_train <- x[split, ]
x_test <- x[-split, ]
y_train <- y[split]
y_test <- y[-split]


# Creating the model
linear_regression <-
  lm(y_train ~ position + count_wins + count_podiums + laps_year, data = x_train)
linear_regression



r_squared <- summary(linear_regression)$r.squared

# Print the rounded R-squared value
cat("R² =", round(r_squared, 2), "\n")

# Prediction using model
prediction_test <- predict(linear_regression, x_test)

# Comparing the actual results with the prediction
compare_actual_test <-
  data.frame(actual = y_test, predicted = prediction_test)
compare_actual_test

# Checking the root mean squared error
root_mean_squared_error <- RMSE(prediction_test, y_test)
root_mean_squared_error



# Creating model ----------------------------------------------------------


linear_model <-
  lm(total_points ~ position + count_wins + count_podiums + laps_year,
     data = merged_df)



# Adding the pred as a columns
prediction_points_next_season <- predict(linear_model, merged_df)
prediction_points_next_season


merged_df$prediction_points_next_season <- prediction_points_next_season
head(merged_df, n = 15L)


# Filtering to get just the 2022 result

df_results_2022 <- merged_df %>%
  filter(season == 2022)

head(df_results_2022, n = 15L)


# If prediction_points_next_season is negative, change to 0
df_results_2022$prediction_points_next_season[df_results_2022$prediction_points_next_season < 0] <-
  0

head(df_results_2022, n = 15L)


# Rounding the prediction points
df_results_2022$prediction_points_next_season <-
  format(round(df_results_2022$prediction_points_next_season , 0),
         nsmall = 0)

head(df_results_2022, n = 15L)



# Convert a character column to numeric
df_results_2022$prediction_points_next_season <-
  as.numeric(df_results_2022$prediction_points_next_season)

head(df_results_2022, n = 15L)


# Checking projection and realization 2023 --------------------------------

compared_df <- merge(df_results_2022, df_results_2023, by = "driver")
print(compared_df)

compared_df <-
  select(compared_df,
         driver,
         prediction_points_next_season,
         total_points_2023,
         position_2023
         )

head(compared_df, n = 15L)


# Adding difference column
compared_df$difference_points <-
  compared_df$prediction_points_next_season - compared_df$total_points_2023

head(compared_df, n = 15L)


# Creating column position based on points
compared_df$position_based_points <-
  rank(-compared_df$prediction_points_next_season,
       ties.method = "min")

head(compared_df, n = 15L)


# Adding difference position based on points
compared_df$difference_position_based_points <-
  compared_df$position_2023 - compared_df$position_based_points

head(compared_df, n = 15L)


# Saving prediction based on position -------------------------------------

write.csv(
  compared_df,
  "./clean_files/prediction_results/test_prediction_based_points.csv",
  row.names = FALSE
)
