# Libraries and functions
library(tidyverse)

# Read in the data----------------------------------------------------------------
sportsbet_team_votes <- read_csv("Data/sportsbet_team_votes.csv")
tab_team_votes <- read_csv("Data/tab_team_votes.csv")

#==============================================================================
# Compare for each team-----------------------------------------------------------
#==============================================================================

# Adelaide-----------------------------------------------------------------------
sb <- 
sportsbet_team_votes |>
filter(str_detect(team, "^Adelaide")) |>
select(-team) |>
arrange(most_votes_price) |>
rename(price = most_votes_price) |>
mutate(agency = "Sportsbet")

tab <-
tab_team_votes |>
filter(str_detect(market_name, "^Adelaide")) |>
select(-market_name) |>
arrange(most_votes_price) |>
rename(price = most_votes_price) |>
mutate(agency = "TAB")

# Combine
adelaide_team_votes <-
 bind_rows(sb, tab) |>
 arrange(price, player_name) |>
 mutate(market_name = "Adelaide Team Votes")

# Brisbane (without Neale)------------------------------------------------------
sb <-
sportsbet_team_votes |>
filter(str_detect(team, "^Brisbane Most Votes -")) |>
select(-team) |>
arrange(most_votes_price) |>
rename(price = most_votes_price) |>
mutate(agency = "Sportsbet")

tab <-
tab_team_votes |>
filter(str_detect(market_name, "^Brisbane")) |>
select(-market_name) |>
arrange(most_votes_price) |>
rename(price = most_votes_price) |>
mutate(agency = "TAB")

# Combine
brisbane_team_votes <-
 bind_rows(sb, tab) |>
 arrange(price, player_name) |>
 mutate(market_name = "Brisbane Team Votes (Without Neale)")

# Gold Coast---------------------------------------------------------------------
sb <-
sportsbet_team_votes |>
filter(str_detect(team, "^Gold Coast")) |>
select(-team) |>
arrange(most_votes_price) |>
rename(price = most_votes_price) |>
mutate(agency = "Sportsbet")

tab <-
tab_team_votes |>
filter(str_detect(market_name, "^Gold Coast")) |>
select(-market_name) |>
arrange(most_votes_price) |>
rename(price = most_votes_price) |>
mutate(agency = "TAB")

# Combine
gold_coast_team_votes <-
 bind_rows(sb, tab) |>
 arrange(price, player_name) |>
 mutate(market_name = "Gold Coast Team Votes")
