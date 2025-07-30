#!/usr/bin/env python3
import os
import json
import time
from spotipy import SpotifyOAuth, Spotify

# Set up your Spotify Developer credentials here
CLIENT_ID = ""
CLIENT_SECRET = ""
REDIRECT_URI = "http://localhost:8888/callback"

TOKEN_PATH = os.path.join(os.path.dirname(__file__), "spotify_token.json")

SCOPE = "playlist-read-private user-follow-read user-library-read"

def save_token(token_info):
    with open(TOKEN_PATH, "w") as f:
        json.dump(token_info, f)

def load_token():
    if os.path.exists(TOKEN_PATH):
        with open(TOKEN_PATH, "r") as f:
            return json.load(f)
    return None

def is_token_expired(token_info):
    return token_info.get("expires_at", 0) - int(time.time()) < 60  

def main():
    token_info = load_token()

    if token_info is None:
      
        sp_oauth = SpotifyOAuth(client_id=CLIENT_ID,
                                client_secret=CLIENT_SECRET,
                                redirect_uri=REDIRECT_URI,
                                scope=SCOPE,
                                cache_path=TOKEN_PATH)
        token_info = sp_oauth.get_access_token(as_dict=True)
        if token_info is None:
            print("❌ Error getting token, check credentials and login.")
            exit(1)
        save_token(token_info)
    else:
  
        if is_token_expired(token_info):
            # Refresh_token
            sp_oauth = SpotifyOAuth(client_id=CLIENT_ID,
                                    client_secret=CLIENT_SECRET,
                                    redirect_uri=REDIRECT_URI,
                                    scope=SCOPE,
                                    cache_path=TOKEN_PATH)
            token_info = sp_oauth.refresh_access_token(token_info["refresh_token"])
            save_token(token_info)

    
    print(token_info["access_token"])

if __name__ == "__main__":
    main()
