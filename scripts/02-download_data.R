#### Preamble ####
# Purpose: Downloads and saves the data from the Lahman library
# Author: Sean Eugene Chua
# Date: 26 November 2024
# Contact: seaneugene.chua@mail.utoronto.ca
# License: None
# Pre-requisites: Load the Lahman library
# Any other information needed? None


#### Workspace setup ####
# Install and load necessary library
if (!requireNamespace("Lahman", quietly = TRUE)) {
  install.packages("Lahman")
}
library(Lahman)

dest_dir <- "data/01-raw_data/raw_data_folder"  # Replace with your actual path

# Create the destination directory if it doesn't exist
if (!dir.exists(dest_dir)) {
  dir.create(dest_dir, recursive = TRUE)
}

# List of tables to save as CSV
tables_to_save <- c(
  "AllstarFull","Appearances","AwardsManagers","AwardsPlayers","AwardsShareManagers","AwardsSharePlayers","Batting",
  "BattingPost","CollegePlaying","Fielding","FieldingOF","FieldingOFsplit","FieldingPost","HallOfFame","HomeGames",
  "Managers","ManagersHalf","Parks","People","Pitching","PitchingPost","Salaries","Schools","SeriesPost","Teams",
  "TeamsFranchises","TeamsHalf")

# Loop through each table and save it as a CSV file
for (table_name in tables_to_save) {
  # Get the table data
  table_data <- get(table_name)
  
  # Construct the full path for saving the downloaded file
  dest_file <- file.path(dest_dir, paste0(table_name, ".csv"))  # Full path for saving
  
  # Save the table as a CSV file
  write.csv(table_data, dest_file, row.names = FALSE)
  
  cat("Saved:", table_name, "to", dest_file, "\n")  # Indicate where the file was saved
}