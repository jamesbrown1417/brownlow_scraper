library(tidyverse)
library(rvest)

#==============================================================================
# Outright Winner
#==============================================================================

url_outright <- "https://www.sportsbet.com.au/betting/australian-rules/afl-brownlow-medal/2023-afl-brownlow-medal-6812951"
url_h2h <- "https://www.sportsbet.com.au/betting/australian-rules/afl-brownlow-h2hs"
url_ou <- "https://www.sportsbet.com.au/betting/australian-rules/afl-brownlow-player-votes"

#==============================================================================
# Team Votes
#==============================================================================

# Get url of landing page
brownlow_teams_url = "https://www.sportsbet.com.au/betting/australian-rules/afl-brownlow-teams/"

# Read in the landing page
brownlow_teams_page <- read_html(brownlow_teams_url)

# Get all the team urls
brownlow_teams_hrefs <-
  brownlow_teams_page |>
  html_nodes("a") |>
  html_attr("href")

# Get market titles
titles <-
 brownlow_teams_page |>
  html_nodes("a") |>
  html_text() |>
  str_subset("Most Votes")

# Get only text after 'Market' using a lookahead
titles <-
  titles |>
  str_extract("(?<=Market).*")

# Filter to only those containing "most-votes"
brownlow_teams_hrefs <-
  brownlow_teams_hrefs |>
  str_subset("most-votes")

# Append "https://www.sportsbet.com.au" to the start of each url
brownlow_teams_hrefs <-
  paste0("https://www.sportsbet.com.au", brownlow_teams_hrefs)

# map read_html() to each url
brownlow_teams_pages <-
  brownlow_teams_hrefs |>
  map(read_html)

# Get the names of the players and prices into a tibble------------------------------------------------

# Function to get data into a tibble
get_team_votes <- function(page) {
  page |>
    html_nodes(".outcomeContainer_f1wc7xgg ") |>
    html_text() |>
    tibble() |>
    rename(value = 1) |>
    mutate(player_name = str_extract(value, "[A-Za-z ]*"),
           price = str_extract(value, "\\d+\\.\\d+")) |>
    mutate(price = as.numeric(price)) |>
    select(-value)
}

# Get list of pages
pages <- brownlow_teams_pages |> set_names(titles)

# Apply function to each page
team_votes <- pages |>
  map(get_team_votes) |>
  set_names(names(pages)) |>
    bind_rows(.id = "team") |>
    rename(most_votes_price = price)

#==============================================================================
# Write out as csv
#==============================================================================

# Main Markets

# Team Votes
write_csv(team_votes, "Data/sportsbet_team_votes.csv")
