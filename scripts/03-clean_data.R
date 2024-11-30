#### Preamble ####
# Purpose: Cleans the observed data from MLB seasons in 2014, 2017, 2022, and 2023.
# Author: Sean Eugene Chua
# Date: 30 November 2024
# Contact: seaneugene.chua@mail.utoronto.ca
# License: None
# Pre-requisites: The "arrow" library must be installed and loaded.
# Any other information needed? None

# #### Workspace setup ####
library(tidyverse)
library(dplyr)
library(arrow)

teams_raw <- read_csv("data/01-raw_data/raw_data_folder/Teams.csv")
cleaned_team_data <- teams_raw |>
  filter(yearID %in% c(2014, 2017, 2022, 2023)) |>
  mutate(franchID = recode(franchID,
    "KCR" = "KC", "WSN" = "WAS", "ANA" = "LAA",
    "TBD" = "TB", "FLA" = "MIA", "SDP" = "SD"
  )) |>
  mutate(win_pct = round(W / G, 3)) |> # Adding win percentage column
  mutate(runs_per_game = round(R / G, 2)) |> # Adding runs per game column
  mutate(run_diff = R - RA) %>% # Adding run differential column
  mutate(HA_9 = (HA / (IPouts / 3)) * 9) |> # Adding hits against per 9 innings column
  rename(team_abbrev = franchID) |> # Renaming franchID to team_abbrev (team name abbreviation)
  select(yearID, team_abbrev, win_pct, W, L, run_diff, runs_per_game, ERA, HA_9, SB) # Selecting relevant columns

# Write the cleaned team data to a Parquet file
write_parquet(cleaned_team_data, "data/02-analysis_data/cleaned_lahman_team_data.parquet")
