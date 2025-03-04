library(tidyverse)
library(janitor)
library(RPostgres)
library(DBI)
rm(list=ls())
# Establish connection to PostgreSQL database
con <- dbConnect(
  RPostgres::Postgres(),
  dbname = "our_world",
  host = "localhost",     # e.g., "localhost" or "your-server.com"
  port = 5432,           # Default PostgreSQL port
  user = "postgres",
  password = "dJj135790"
)

# Check if connection is successful
if (!dbIsValid(con)) {
  stop("Failed to connect to the database!")
} else {
  print("Connected to PostgreSQL successfully!")
}

# Load Data
# Long Beach Animal Shelter Data
animal_shelter <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-03-04/longbeach.csv') |> clean_names()
dbWriteTable(con, "animal_shelter",animal_shelter, overwrite=TRUE,append=FALSE)
dbListTables(con)

# Agencies from the FBI Crime Data API
# This week we're exploring data from the FBI Crime Data API! Specifically, 
# we’re looking at agency-level data across all 50 states in the USA. 
# This dataset provides details on law enforcement agencies that have submitted data to the 
# FBI’s Uniform Crime Reporting (UCR) Program and are displayed on the Crime Data Explorer (CDE).
library(tidytuesdayR)
tuesdata <- tidytuesdayR::tt_load('2025-02-18')
FBI <- tuesdata$agencies
dbWriteTable(con, "FBI",FBI, overwrite=TRUE,append=FALSE)

dbListTables(con)

## Our World In Data
## Energy Data
energy_data <- readxl::read_xlsx('energy-data.xlsx')

dbWriteTable(con, "energy_data",energy_data, overwrite=TRUE,append=FALSE)

# Pull Columns that contain "Biofuel"

biofuel <- energy_data|> select(country,year,gdp,matches("biofuel"))
coal <- energy_data|> select(country,year,gdp,matches("coal"))

dbWriteTable(con, "biofuel",biofuel, overwrite=TRUE,append=FALSE)
dbWriteTable(con, "coalfuel",coal, overwrite=TRUE,append=FALSE)
dbListTables(con)
