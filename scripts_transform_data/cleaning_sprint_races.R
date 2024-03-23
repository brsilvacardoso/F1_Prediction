# Setting libraries -------------------------------------------------------

library(lubridate)
library(dplyr)

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

df_sprint_races <-
  read.csv("./raw_files/sprint_races_results_2021_to_2023.csv")
df_sprint_races


# Transform nc to order position ---------------------------

# Converting the Pos column to numeric
df_sprint_races$Pos <-
  as.integer(as.numeric(df_sprint_races$Pos))

View(df_sprint_races)


#Checking missing values in Pos column
nc_indices <- which(is.na(df_sprint_races$Pos))


for (idx in nc_indices) {
  if (idx > 1) {
    df_sprint_races$Pos[idx] <-
      df_sprint_races$Pos[idx - 1] + 1
  }
}


df_sprint_races$Pos <-
  ifelse(df_sprint_races$Pos == 'NC',
         NA,
         df_sprint_races$Pos)

df_sprint_races$Pos <-
  zoo::na.locf(df_sprint_races$Pos, fromLast = FALSE)


#View(df_sprint_races)


# Creating a column to year -----------------------------------------------

#Converting the column date from char to Date

df_sprint_races$Date <-
  as.Date(df_sprint_races$Date, format = "%Y-%m-%d")
print(class(df_sprint_races$Date))

##View(df_sprint_races)

df_sprint_races$Season <-
  year(df_sprint_races$Date)

View(df_sprint_races)



# Cleaning the Driver column ----------------------------------------------

df_sprint_races$Driver <-
  substr(df_sprint_races$Driver,
         1,
         nchar(df_sprint_races$Driver) - 4)


View(df_sprint_races)


# Creating ID with Name Abbreviation and Year -----------------------------

# Converting Year to character to concatenate
df_sprint_races$Season = as.character(df_sprint_races$Season)


df_sprint_races$Driver_Year <-
  paste(df_sprint_races$Driver_Name_Abbreviation,
        df_sprint_races$Season,
        sep = "_")

View(df_sprint_races)

print(colnames(df_sprint_races))


# Formating columns -------------------------------------------------------

df_sprint_races <- df_sprint_races %>%
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
    driver_year = Driver_Year
    
  )

View(df_sprint_races)

# Saving the dataframe ----------------------------------------------------

write.csv(df_sprint_races,
          "./clean_files/sprint_races_2021_202.csv",
          row.names = FALSE)
