# Setting libraries -------------------------------------------------------

library(lubridate)

# Setting directories -----------------------------------------------------

#Checking the directory
getwd()

read_folder_path <- "./raw_files"

file_names <-
  list.files(path = read_folder_path,
             pattern = "\\.csv$",
             full.names = TRUE)

print(file_names)

# Manipulating the files --------------------------------------------------


#Creating a empty list
all_files <- list()

# Loop through each file
for (file_name in file_names) {
  # Read the CSV file
  data <- read.csv(file_name, sep = ",")
  
  # Send the data frame to the list
  all_files[[file_name]] <- data
}

# Combine all data frames into a single data frame
races_2018_2023_appended <- do.call(rbind, all_files)

###View(races_2018_2023_appended)


# Transform nc to order position ---------------------------

# Converting the Pos column to numeric
races_2018_2023_appended$Pos <-
  as.integer(as.numeric(races_2018_2023_appended$Pos))

#Checking missing values in Pos column
nc_indices <- which(is.na(races_2018_2023_appended$Pos))


for (idx in nc_indices) {
  if (idx > 1) {
    races_2018_2023_appended$Pos[idx] <-
      races_2018_2023_appended$Pos[idx - 1] + 1
  }
}
races_2018_2023_appended$Pos <-
  ifelse(races_2018_2023_appended$Pos == 'NC',
         NA,
         races_2018_2023_appended$Pos)

races_2018_2023_appended$Pos <-
  zoo::na.locf(races_2018_2023_appended$Pos, fromLast = FALSE)


##View(races_2018_2023_appended)


# Creating a column to year -----------------------------------------------

#Converting the column date from char to Date

races_2018_2023_appended$Date <-
  as.Date(races_2018_2023_appended$Date, format = "%Y-%m-%d")
print(class(races_2018_2023_appended$Date))

##View(races_2018_2023_appended)

races_2018_2023_appended$Season <-
  year(races_2018_2023_appended$Date)

##View(races_2018_2023_appended)


# #Creating a column to driver name abbreviation --------------------------

races_2018_2023_appended$Driver_Name_Abbreviation <-
  substr(
    races_2018_2023_appended$Driver,
    nchar(races_2018_2023_appended$Driver) - 2,
    nchar(races_2018_2023_appended$Driver)
  )

##View(races_2018_2023_appended)



# Cleaning the Driver column ----------------------------------------------

races_2018_2023_appended$Driver <-
  substr(races_2018_2023_appended$Driver,
         1,
         nchar(races_2018_2023_appended$Driver) - 4)


##View(races_2018_2023_appended)



# Adding True or False winner column  -------------------------------------

races_2018_2023_appended <-
  mutate(races_2018_2023_appended, is_winner = Pos == 1)


View(races_2018_2023_appended)


# Adding True or False Podium column ----------------------------------------------------

# Add a new column for Podium
races_2018_2023_appended <- races_2018_2023_appended %>%
  mutate(Is_Podium = (Pos %in% 1:3))



# Creating ID with Name Abbreviation and Year -----------------------------

# Converting Year to character to concatenate
races_2018_2023_appended$Season = as.character(races_2018_2023_appended$Season)


races_2018_2023_appended$Driver_Year <-
  paste(
    races_2018_2023_appended$Driver_Name_Abbreviation,
    races_2018_2023_appended$Season,
    sep = "_"
  )

View(races_2018_2023_appended)

print(colnames(races_2018_2023_appended))

# Formating columns -------------------------------------------------------

races_2018_2023_appended <- races_2018_2023_appended %>%
  rename(
    circuit = Circuit,
    date = Date,
    pos = Pos,
    no = No,
    driver = Driver,
    car = Car,
    laps = Laps ,
    time.retired = Time.Retired,
    pts = PTS,
    season = Season ,
    driver_name_abbreviation = Driver_Name_Abbreviation,
    is_podium = Is_Podium,
    driver_year = Driver_Year
    
  )

# Saving the dataframe ----------------------------------------------------

write.csv(
  races_2018_2023_appended,
  "./clean_files/races_2018_2023_appended.csv",
  row.names = FALSE
)
