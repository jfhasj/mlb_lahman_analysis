# Predicting MLB Team Winning Percentage in 2024 using Key Performance Metrics

## Overview

This repository contains an end-to-end analysis for predicting MLB teams' winning percentages in 2024 using a multiple regression model. This analysis aims to provide estimates of winning percentages based on team statistics for the 2024 season, ultimately informing an aggregated evaluation of team success. This analysis is primarily conducted in R, with the final report highlighting the data, results, and other key findings that may help understand key factors in determining team winning percentage better.

## File Structure

The repo is structured as:

-   `data` contains all data (simulation, raw, analysis, as well as external data) relevant to the research.
-   `models` contains the model used in this analysis. 
-   `other` contains details about LLM chat interactions, sketches, and a datasheet on the dataset used in this analysis.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.

## Statement on LLM usage

Aspects of the code were developed with the assistance of ChatGPT and Perplexity AI. The **simulation** and **analysis tests** as well as parts of the **data modeling** were generated using these chatbots, and the complete chat history is available in `other/llm_usage/usage.txt`.

## Installation Instructions

To replicate the analysis and run the code in this repository, you'll need to install several R packages. You can install them directly from CRAN using the following command in your R console:

```R
install.packages(c("tidyverse", "kableExtra", "arrow", "ggpubr", "modelsummary", "tidymodels", ggplot2", "dplyr", "readr", "here", "reshape2", "rvest", "stringr", "DiagrammeR", "rsvg", "DiagrammeRsvg", "png"))
```

## Data Source

The primary data source for this analysis is the Lahman Database, which can be downloaded from Sean Lahman's [website](http://www.seanlahman.com/) and choosing the desired database format. Alternatively, the database is also available in the `Lahman` R package, which can be installed by running `install.packages("Lahman")` and loading the `library(Lahman)`. The raw data for this analysis can be obtained by performing the necessary installations, then running `scripts/02-download_data.R`.