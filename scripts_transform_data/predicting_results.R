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
head(df_drivers)


# df_points <- read.csv("./clean_files/sum_points_races_with_sprints.csv")
# View(df_points)


df_wins <- read.csv("./clean_files/count_wins_year.csv")
head(df_wins)


df_podiums <- read.csv("./clean_files/count_podiums_year.csv")
head(df_podiums)

df_laps <- read.csv("./clean_files/sum_drivers_laps_year.csv")
head(df_laps)

df_standings <-
  read.csv("./clean_files/computing_position_by_year.csv")
head(df_standings,n=10)



# Merging files -----------------------------------------------------------

dfs <-
  list(df_drivers,
       df_wins,
       df_podiums,
       df_laps,
       df_standings)
#head(dfs)

merged_df <-
  Reduce(function(x, y)
    merge(x, y, by = "driver_year"), dfs)


head(merged_df, n=10)

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
  rename(season = season.x,
         count_podiums = count)


#View(merged_df)


# Preliminary analyses ----------------------------------------------------

#Descriptive statistics
summary(merged_df)


# Creating correlation matrix
merged_df_numeric <-
  subset(merged_df, select = sapply(merged_df, is.numeric))

correlation_matrix <- round(cor(merged_df_numeric), 4)

print(correlation_matrix)

# Checking the correlations visual ------------------------------------------------

# Checking position and laps year
ggplot(data = merged_df, aes(x = position, y = total_points)) +
  geom_point() +
  scale_x_continuous(breaks = seq(0, 22, by = 1), labels = seq(0, 22, by = 1))


# Selecting columns to check the correlation using corrplot (colorful)
df_cor_matrix <-
  select(merged_df,
         total_points,
         count_wins,
         count_podiums,
         laps_year,
         position)


# merged_df[] <- lapply(merged_df, as.numeric)
# cor_matrix <- cor(df_cor_matrix)
# corrplot(cor_matrix)
# 
# 
# ggpairs(merged_df, cardinality_threshold = 130)



# Testing and fit model to predict points -------------------------------------------------------

# Renaming the dataframe to train and test

merged_df_test_points <- merged_df
head(merged_df_test_points)

set.seed(128)

# Split the data into predictors (X) and response (y)
x <-
  merged_df_test_points[, c('position', 'count_podiums', 'count_wins', 'laps_year')]
y <- merged_df_test_position$total_points

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


# Creating model total points----------------------------------------------------------


linear_model <-
  lm(total_points ~ -1 +position + count_wins + count_podiums + laps_year,
     data = merged_df)


# Adding the pred as a columns
prediction_points <- predict(linear_model, merged_df)


merged_df$prediction_points <- prediction_points


filtered_with_prediction <-
  filter(merged_df, season == 2023)

filtered_with_prediction


# Selecting the columns to check the difference
filtered_with_prediction <-
  select(filtered_with_prediction,
         driver,
         total_points,
         position,
         prediction_points)

filtered_with_prediction

View(filtered_with_prediction)



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



# Saving prediction based on points -------------------------------------

# write.csv(
#   filtered_with_prediction,
#   "./clean_files/prediction_results/prediction_points.csv",
#   row.names = FALSE
# )
