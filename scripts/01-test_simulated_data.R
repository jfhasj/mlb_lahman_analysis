#### Preamble ####
# Purpose: Tests the structure and validity of the simulated Lahman dataset 
# Author: Sean Eugene Chua
# Date: 26 November 2024
# Contact: seaneugene.chua@mail.utoronto.ca
# License: None
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the `lahman-analysis` rproj


#### Workspace setup ####
# Load necessary libraries
library(testthat)
library(dplyr)
library(readr)
library(here)

# Load the simulated dataset
simulated_data <- read_csv(here("data", "00-simulated_data", "simulated_data.csv"))

# Define the test suite
test_that("Simulated MLB Team Statistics Validation", {
  
  # Check if the dataset was successfully loaded
  expect_true(exists("simulated_data"), 
              info = "Test Failed: The dataset could not be loaded.")
  
  # Check that the dataset is not empty
  expect_false(nrow(simulated_data) == 0, info = "The dataset should not be empty.")
  
  # Check that all expected columns are present
  expected_columns <- c("yearID", "team_abbrev", "W", "L", "win_pct", "run_diff", 
                        "runs_per_game", "ERA", "HA_9", "SB")
  expect_true(all(expected_columns %in% colnames(simulated_data)), 
              info = "All expected columns should be present in the dataset.")
  
  # Check that yearID is either 2014, 2017, 2022, or 2023
  valid_years <- c(2014, 2017, 2022, 2023)
  expect_true(all(simulated_data$yearID %in% valid_years), 
              info = "yearID should be either 2014, 2017, 2022, or 2023.")
  
  # Check that there are exactly 30 instances for each valid year
  for (year in valid_years) {
    year_count <- sum(simulated_data$yearID == year)
    expect_equal(year_count, 30, 
                 info = paste("There should be exactly 30 instances for the year:", year))
  }
  
  # Check value ranges for Wins and Losses
  expect_true(all(simulated_data$W >= 50 & simulated_data$W <= 111), 
              info = "Wins (W) should be between 50 and 111")
  
  expect_true(all(simulated_data$L >= 51 & simulated_data$L <= 112), 
              info = "Losses (L) should be between 51 and 112")
  
  # Check win percentage calculation
  calculated_win_pct <- round(simulated_data$W / (simulated_data$W + simulated_data$L), digits = 3)
  expect_equal(simulated_data$win_pct, calculated_win_pct, 
               info = "Win percentage (win_pct) should be correctly calculated.")
  
  # Check run differential to be integers
  expect_true(all(simulated_data$run_diff %% 1 == 0),
              info = "Run differential (run_diff) should be integers.")
  
  # Validate runs per game: check for non-negativity and realistic bounds
  expect_true(all(simulated_data$runs_per_game >= 0),
              info = "Runs per game should be non-negative.")
  
  # Validate ERA values: check for non-negativity and realistic bounds
  expect_true(all(simulated_data$ERA >= 0),
              info = "ERA values should be non-negative.")
  
  # Validate Hits Allowed per Game (HA/9): check for non-negativity and realistic bounds
  expect_true(all(simulated_data$HA_9 >= 0),
              info = "Hits allowed per game (HA/9) should be non-negative.")
  
  # Validate Stolen Bases (SB): check for non-negativity
  expect_true(all(simulated_data$SB >= 0),
              info = "Stolen bases (SB) should be non-negative.")
  
  expect_true(all(simulated_data$SB %% 1 == 0),
              info = "Stolen bases (SB) should be integers.")
  
  # Check that yearID is either 2014, 2017, or 2022
  expect_true(all(simulated_data$yearID %in% c(2014, 2017, 2022, 2023)), 
              info = "yearID should be either '2014', 2017', '2022', or 2023.")
  
  # Check for unique team abbreviations within each yearID
  duplicates <- simulated_data |>
    group_by(yearID, team_abbrev) |>
    summarize(count = n(), .groups = 'drop') |>
    filter(count > 1)
  
  expect_equal(nrow(duplicates), 0,
               info = "Team abbreviations (team_abbrev) must be unique within each year.")
  
})