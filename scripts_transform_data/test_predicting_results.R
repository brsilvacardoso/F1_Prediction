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


#merged_df

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


#merged_df

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


# Preliminary analyses ----------------------------------------------------

#Descriptive statistics
summary(filtered_seasons)


# Creating correlation matrix
filtered_seasons_numeric <-
  subset(filtered_seasons, select = sapply(filtered_seasons, is.numeric))

correlation_matrix <- round(cor(filtered_seasons_numeric), 4)

print(correlation_matrix)

# Checking the correlations visual ------------------------------------------------

# Checking position and laps year
# ggplot(data = filtered_seasons, aes(x = position, y = total_points)) +
#   geom_point() +
#   scale_x_continuous(breaks = seq(0, 22, by = 1), labels = seq(0, 22, by = 1))


# Selecting columns to check the correlation using corrplot (colorful)
df_cor_matrix <-
  select(filtered_seasons,
         total_points,
         count_wins,
         count_podiums,
         laps_year,
         position)


#filtered_seasons[] <- lapply(filtered_seasons, as.numeric)
cor_matrix <- cor(df_cor_matrix)
#corrplot(cor_matrix)


# ggpairs(filtered_seasons, cardinality_threshold = 130)


error

# Testing and fit model to predict position -------------------------------------------------------

# Renaming the dataframe to train and test

filtered_seasons_test_position <- filtered_seasons

set.seed(106)

# Split the data into predictors (X) and response (y)
x <-
  filtered_seasons_test_position[, c('total_points', 'count_wins', 'count_podiums', 'laps_year')]
y <- filtered_seasons_test_position$position

# Split the data into train and test sets
split <- createDataPartition(y, p = 0.8, list = FALSE)
x_train <- x[split,]
x_test <- x[-split,]
y_train <- y[split]
y_test <- y[-split]


# Creating the model
linear_regression <-
  lm(y_train ~ total_points + count_wins + count_podiums + laps_year,
     data = x_train)
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



# Creating model position ----------------------------------------------------------


linear_model <-
  lm (position ~ total_points + count_wins + count_podiums + laps_year,
      data = filtered_seasons)


# Adding the pred as a columns
prediction_position <- predict(linear_model, filtered_seasons)


filtered_seasons$prediction_position <- prediction_position

filtered_with_prediction <-
  filter(filtered_seasons, season == 2022)

filtered_with_prediction


# Selecting the columns to check the difference
filtered_with_prediction <-
  select(filtered_with_prediction,
         driver,
         position,
         prediction_position)

filtered_with_prediction

# Converting prediction_position to numerical
filtered_with_prediction$prediction_position <-
  as.numeric(filtered_with_prediction$prediction_position)

# If prediction_position is negative, change to 1
filtered_with_prediction$prediction_position[filtered_with_prediction$prediction_position < 0] <-
  1


# Round each position up
filtered_with_prediction$prediction_position <-
  ceiling(filtered_with_prediction$prediction_position)
filtered_with_prediction


# Adding difference column
filtered_with_prediction$difference_true_prediction <-
  filtered_with_prediction$position - filtered_with_prediction$prediction_position


filtered_with_prediction

# Saving prediction based on position -------------------------------------

write.csv(
  filtered_with_prediction,
  "./clean_files/prediction_results/test_prediction_position.csv",
  row.names = FALSE
)

# Testing and fit model to predict points -------------------------------------------------------

# Renaming the dataframe to train and test

filtered_seasons_test_points <- filtered_seasons
filtered_seasons_test_points

set.seed(106)

# Split the data into predictors (X) and response (y)
x <-
  filtered_seasons_test_points[, c('position', 'count_podiums', 'count_wins', 'laps_year')]
y <- filtered_seasons_test_position$total_points

# Split the data into train and test sets
split <- createDataPartition(y, p = 0.8, list = FALSE)
x_train <- x[split,]
x_test <- x[-split,]
y_train <- y[split]
y_test <- y[-split]


# Creating the model HERE
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
     data = filtered_seasons)


# Adding the pred as a columns
prediction_points <- predict(linear_model, filtered_seasons)


filtered_seasons$prediction_points <- prediction_points


filtered_with_prediction <-
  filter(filtered_seasons, season == 2022)

filtered_with_prediction


# Selecting the columns to check the difference
filtered_with_prediction <-
  select(filtered_with_prediction,
         driver,
         total_points,
         position,
         prediction_points)

filtered_with_prediction



# If prediction_points is negative, change to 0
filtered_with_prediction$prediction_points[filtered_with_prediction$prediction_points < 0] <-
  0


# Rounding the prediction points
filtered_with_prediction$prediction_points <-
  format(round(filtered_with_prediction$prediction_points , 0),
         nsmall = 0)


# Convert a character column to numeric
filtered_with_prediction$prediction_points <-
  as.numeric(filtered_with_prediction$prediction_points)

# Adding difference column
filtered_with_prediction$difference_true_prediction_points <-
  filtered_with_prediction$total_points - filtered_with_prediction$prediction_points

filtered_with_prediction


# Creating column position based on points
filtered_with_prediction$position_based_points <-
  rank(-filtered_with_prediction$prediction_points,
       ties.method = "min")


# Adding difference position based on points
filtered_with_prediction$difference_position_based_points <-
  filtered_with_prediction$position - filtered_with_prediction$position_based_points

filtered_with_prediction

# Saving prediction based on position -------------------------------------

write.csv(
  filtered_with_prediction,
  "./clean_files/prediction_results/test_prediction_based_points.csv",
  row.names = FALSE
)




# Predict the position based on the total points
predict(lm, data.frame(total_points = 100, count_podiums = 0))