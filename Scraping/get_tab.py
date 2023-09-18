import json
import requests
import pandas as pd

#==============================================================================
# Outright Winner
#==============================================================================

# Get JSON from api website
url = 'https://api.beta.tab.com.au/v1/tab-info-service/sports/AFL%20Football/competitions/Brownlow%20Medal?jurisdiction=SA&numTopMarkets=5'
response = requests.get(url)
data = response.json()

# get lists to store data
market_name = []
proposition_name = []
market_price = []

# Get the data from the JSON
for match in data['matches']:
    for player in match['markets']:
        for proposition in player['propositions']:
            proposition_name.append(proposition['name'])
            market_name.append(player['name'])
            market_price.append(proposition['returnWin'])
            
# Create a dataframe
df_outright = pd.DataFrame({'market_name': market_name, 'proposition_name': proposition_name, 'market_price': market_price})

#============================================================================== 
# Team Votes
#==============================================================================

url = "https://api.beta.tab.com.au/v1/tab-info-service/sports/AFL%20Football/competitions/Brownlow%20Medal%20Team%20Votes?jurisdiction=SA&numTopMarkets=5"
response = requests.get(url)
data = response.json()

# get lists to store data
market_name = []
player_name = []
most_votes_price = []

# Get the data from the JSON
for match in data['matches']:
    for market in match['markets']:
        for proposition in market['propositions']:
            market_name.append(match['name'])
            player_name.append(proposition['name'])
            most_votes_price.append(proposition['returnWin'])
            
# Create a dataframe
df_team_votes = pd.DataFrame({'market_name': market_name, 'player_name': player_name, 'most_votes_price': most_votes_price})

#==============================================================================
# Write out to CSV
#==============================================================================

# Main Markets
df_outright.to_csv('Data/tab_outright.csv', index=False)

# Team Votes
df_team_votes.to_csv('Data/tab_team_votes.csv', index=False)