#### Preamble ####
# Purpose: Tests the validity and structure of the cleaned dataset
# Author: Sean Eugene Chua
# Date: 30 November 2024
# Contact: seaneugene.chua@mail.utoronto.ca
# License: None
# Pre-requisites: The "testthat", "tidyverse", "arrow", and "here" libraries must be installed and loaded.
# Any other information needed? None


#### Workspace setup ####
# Load necessary libraries
library(tidyverse)
library(testthat)
library(arrow)
library(here)

# Load the cleaned team data from a Parquet file
team_data <- read_parquet(here("data", "02-analysis_data", "cleaned_lahman_team_data.parquet"))

# Define the test suite
test_that("Team Data Validation Tests", {
  # Check that the dataset was successfully loaded
  expect_true(exists("team_data"),
    info = "Test Failed: The dataset could not be loaded."
  )

  al_teams <- c(
    "BAL", "BOS", "CHW", "CLE", "DET",
    "HOU", "KC", "LAA", "MIN",
    "NYY", "OAK", "SEA", "TB",
    "TEX", "TOR"
  )

  nl_teams <- c(
    "ARI", "ATL", "CHC", "CIN",
    "COL", "LAD", "MIA", "MIL",
    "NYM", "PHI", "PIT", "SD",
    "SFG", "STL", "WAS"
  )
  # Check that yearID is either 2014, 2017, 2022, or 2023
  valid_years <- c(2014, 2017, 2022, 2023)
  expect_true(all(team_data$yearID %in% valid_years),
    info = "yearID should be either 2014, 2017, 2022, or 2023."
  )

  # Check that there are exactly 30 instances for each valid year
  for (year in valid_years) {
    year_count <- sum(team_data$yearID == year)
    expect_equal(year_count, 30,
      info = paste("There should be exactly 30 instances for the year:", year)
    )
  }

  # Check that win_pct is between [0-1] and equals W/162 rounded to three decimal places
  expect_true(all(team_data$win_pct >= 0 & team_data$win_pct <= 1),
    info = "win_pct should be between 0 and 1 inclusive"
  )

  expect_equal(round(team_data$W / (162), digits = 3), round(team_data$win_pct, digits = 3),
    info = "win_pct should equal W/162 rounded to three decimal places"
  )

  # Check that W + L equals to games played (162)
  expect_equal(team_data$W + team_data$L,
    rep(162, nrow(team_data)),
    info = "The sum of W and L should equal 162"
  )

  # Check that W and L are non-negative integers
  expect_true(all(team_data$W >= 0 & team_data$L >= 0),
    info = "Wins (W) and Losses (L) should be non-negative integers"
  )

  # Check that run_diff is any integer
  expect_true(all(team_data$run_diff %% 1 == 0),
    info = "run_diff should be a whole number (integer)"
  )

  # Check that SB is any non-negative integer
  expect_true(all(team_data$SB >= 0 & team_data$SB %% 1 == 0),
    info = "SB should be a non-negative integer"
  )

  # Check that runs_per_game and ERA are both non-negative
  expect_true(all(team_data$runs_per_game >= 0),
    info = "runs_per_game should be non-negative"
  )

  expect_true(all(team_data$ERA >= 0),
    info = "ERA should be non-negative"
  )
})
