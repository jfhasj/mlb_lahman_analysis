#### Preamble ####
# Purpose: Simulate a dataset similar to MLB team statistics
# Author: Sean Eugene Chua
# Date: 30 November 2024
# Contact: seaneugene.chua@mail.utoronto.ca
# License: None
# Pre-requisites: The `dplyr` and `readr` packages must be installed and loaded
# Make sure you are in the `lahman-analysis` rproj

#### Workspace setup ####
# Load necessary libraries
library(dplyr)
library(readr)

# Set seed for reproducibility
set.seed(123)

# Define parameters for simulation
num_teams <- 30 # Total number of teams
years <- c(2014, 2017, 2022, 2023) # Years to simulate

# Define team abbreviations and their respective league IDs
teams_info <- data.frame(
  team_abbrev = c(
    "BAL", "BOS", "CHW", "CLE", "DET",
    "HOU", "KC", "LAA", "MIN",
    "NYY", "OAK", "SEA", "TB",
    "TEX", "TOR",
    "ARI", "ATL", "CHC", "CIN",
    "COL", "LAD", "MIA", "MIL",
    "NYM", "PHI", "PIT", "SD",
    "SFG", "STL", "WAS"
  )
)

# Create a data frame for all teams with years and league IDs
team_data <- expand.grid(yearID = years, team_abbrev = teams_info$team_abbrev)

# Merge to add league IDs to the team_data
team_data <- team_data |>
  left_join(teams_info, by = "team_abbrev")

# Simulate the dataset by adding performance metrics
simulated_data <- team_data |>
  mutate(
    W = sample(50:111, nrow(team_data), replace = TRUE),
    L = 162 - W,
    win_pct = round(W / (W + L), digits = 3),
    run_diff = ifelse(win_pct < 0.45,
      sample(-200:-10, nrow(team_data), replace = TRUE), # Negative run differential for low win_pct
      sample(0:200, nrow(team_data), replace = TRUE)
    ), # Positive run differential for higher win_pct

    # Runs per game sampled from a normal distribution centered around realistic averages
    runs_per_game = round(rnorm(nrow(team_data), mean = ifelse(win_pct < 0.45, 3.5, 4.5 + win_pct * 2), sd = 0.5), 2),

    # ERA sampled from a normal distribution with higher values for lower win_pct teams
    ERA = round(rnorm(nrow(team_data), mean = ifelse(win_pct < 0.45, runif(1, min = 4.5, max = 6.0), runif(1, min = 3.0, max = 4.5)), sd = 0.5), 2),

    # Hits allowed per game (HA/9) sampled similarly; higher HA/9 for lower win_pct teams
    HA_9 = round(rnorm(nrow(team_data), mean = ifelse(win_pct < 0.45, runif(1, min = 10.0, max = 12.0), runif(1, min = 7.0, max = 9.5)), sd = 0.5), 2),

    # Stolen bases can vary; sample from a distribution based on performance levels
    SB = round(runif(nrow(team_data), min = 30, max = 200))
  )

#### Save data ####
# Exporting the simulated data to a CSV file
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
