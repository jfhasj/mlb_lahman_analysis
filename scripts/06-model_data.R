#### Preamble ####
# Purpose: This script models win percentage using team performance metrics from historical data using multiple regression.
# Author: Sean Eugene Chua
# Date: 30 November 2024
# Contact: seaneugene.chua@mail.utoronto.ca
# License: None
# Pre-requisites: Ensure required packages are installed (tidyverse, arrow, here, modelsummary, rvest, dplyr, tidymodels, stringr)

#### Workspace setup ####
library(tidyverse)
library(arrow)
library(here)
library(modelsummary)
library(rvest)
library(dplyr)
library(tidymodels)
library(stringr)

#### Read data ####
clean_data <- read_parquet(here("data", "02-analysis_data", "cleaned_lahman_team_data.parquet"))

# Fit the linear regression model using tidymodels
model_tidymodels <- linear_reg() |>
  set_engine("lm") |>
  fit(win_pct ~ runs_per_game + ERA + HA_9 + SB, data = clean_data)

# Display the model summary
modelsummary(model_tidymodels)

# Define the URLs for batting and pitching tables
batting_url <- "https://www.baseball-reference.com/leagues/majors/2024.shtml"
pitching_url <- "https://www.baseball-reference.com/leagues/majors/2024-standard-pitching.shtml"

# Function to extract tables from a given URL
extract_table <- function(url, table_index) {
  page <- read_html(url)
  tables <- html_nodes(page, "table")
  table_data <- html_table(tables[[table_index]], fill = TRUE)
  return(table_data)
}

# Extract Team Standard Batting (first table)
team_standard_batting <- extract_table(batting_url, 1)

# Extract Team Standard Pitching (first table)
team_standard_pitching <- extract_table(pitching_url, 1)

# Filter relevant columns from batting and pitching data
filtered_batting <- team_standard_batting |>
  select(Tm, "R/G", SB) |>
  rename(teamID = Tm, runs_per_game = "R/G")

filtered_pitching <- team_standard_pitching |>
  select(Tm, ERA = "ERA", win_pct = "W-L%", H9) |>
  rename(teamID = Tm, HA_9 = H9)

# Merge batting and pitching data by team abbreviation
teams_2024 <- merge(filtered_pitching, filtered_batting, by = "teamID")
teams_2024_no_top <- teams_2024 |> slice(-1)

# Clean and filter the merged dataset
teams_2024_cleaned <- teams_2024_no_top |>
  filter(str_detect(SB, "^\\d+$")) |>
  mutate(SB = as.numeric(SB)) |>
  filter(!is.na(SB)) |> # Remove rows where SB is not numeric
  filter(teamID != "League Average") |>
  mutate(
    runs_per_game = as.numeric(runs_per_game),
    ERA = as.numeric(ERA),
    HA_9 = as.numeric(HA_9),
    SB = as.numeric(SB),
    win_pct = as.numeric(win_pct)
  )

# Write the cleaned data to a parquet file
write_parquet(teams_2024_cleaned, sink = here("data", "2024-data-and-model-predictions", "teams_2024_data.parquet"))

predictions_2024 <- predict(model_tidymodels, new_data = teams_2024_cleaned)

# Add predictions as a new column in teams_2024_cleaned
team_data_2024_predictions <- teams_2024_cleaned |>
  mutate(predicted_win_pct = round(predictions_2024$.pred, 5) * 100)

teams_final <- data.frame(
  teamID = team_data_2024_predictions$teamID,
  ERA = team_data_2024_predictions$ERA,
  HA_9 = team_data_2024_predictions$HA_9,
  runs_per_game = team_data_2024_predictions$runs_per_game,
  SB = team_data_2024_predictions$SB,
  win_pct = team_data_2024_predictions$win_pct * 100,
  predicted_win_pct = team_data_2024_predictions$predicted_win_pct
)

write_parquet(teams_final, sink = here("data", "2024-data-and-model-predictions", "teams_2024_predictions.parquet"))

### Save model ####
saveRDS(
  model_tidymodels,
  file = here("models", "win_pct_model.rds")
)
