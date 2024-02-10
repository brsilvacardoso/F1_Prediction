
# Installing libraries ----------------------------------------------------
library(dplyr)


# Setting file path -------------------------------------------------------

#Get the working directory
getwd()

folder_path <- "./Raw_Files"

file_name <- "races_2018_2023_appended.csv"

file_path <- file.path(folder_path, file_name)

races_2018_2023_appended <- read.csv(file_path, sep=",")

View(races_2018_2023_appended)



# Manipulating the file ---------------------------------------------------


races_2018_2023_winners <- mutate(races_2018_2023_appended, Is_Winner = Pos == 1)

View(races_2018_2023_winners)



