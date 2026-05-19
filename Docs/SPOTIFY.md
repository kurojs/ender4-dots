
# 🎧 Spotify Integration for VoxAI.Dots

![Shell Script](https://img.shields.io/badge/Shell-121011?style=for-the-badge&logo=gnu-bash&logoColor=white&labelColor=4CAF50)
![Python](https://img.shields.io/badge/Python-20232A?style=for-the-badge&logo=python&logoColor=F7DF1E&labelColor=9C27B0)
![Spotify API](https://img.shields.io/badge/Spotify%20API-1DB954?style=for-the-badge&logo=spotify&logoColor=white&labelColor=4CAF50)
![Antigravity CLI](https://img.shields.io/badge/Antigravity%20CLI-6200EA?style=for-the-badge&labelColor=9C27B0&logo=google)

This guide explains how to configure and use Spotify integration within **VoxAI.Dots**.  
You'll be able to fetch and play tracks from your playlists using simple commands or voice triggers via Antigravity CLI.

---

## 👾 What You Can Do

- Play playlists from your Spotify account  
- Search and play tracks using pattern matching  
- Shuffle songs from a playlist  
- Get voice feedback announcing the current track (optional)  

---

## 🔐 Step 1: Get Your Spotify OAuth Token

To access your Spotify data, you'll need an OAuth token with the following scopes:

- `playlist-read-private`  
- `user-follow-read`  
- `user-library-read`

### Follow These Steps:

1. Go to the [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)  
2. Click **“Create App”**
3. Fill in the app name and description (anything is fine)  
4. Add this **Redirect URI**:

   ```
   http://localhost:8888/callback
   ```

5. When asked “Which API/SDKs are you planning to use?”, select:  
   ✅ Web API  
   ✅ Web Playback SDK  

6. Accept the terms and click **Save**  
7. Copy your **Client ID** and **Client Secret** — you’ll need these soon.

---

## 🧪 Generating Your Access Token

Inside the `/bin/` folder, you'll find `get_spotify_token.py`, a Python script that handles authentication and token refresh.

> ⚙️ Before running the script, edit the following lines with your actual credentials:

```python
# Inside get_spotify_token.py (lines 8–10)
CLIENT_ID = "your_client_id"
CLIENT_SECRET = "your_client_secret"
REDIRECT_URI = "http://localhost:8888/callback"
```

Make sure Python is installed, then run the script in your terminal:

```bash
python3 ~/VoxAI.Dots/bin/get_spotify_token.py
```

- A browser window will open — log in and authorize the app  
- If successful, the script will return your token and create a file called `spotify_token.json` in the same directory

> ✅ That means everything worked!


---

## 📁 Where Your Token Is Saved

After authorization, the script creates a file at:

```
~/.local/bin/spotify_token.json
```

This file includes the access token and refresh token.  
⚠️ **Do not delete this file — the playback scripts depend on it.**

---

## 🔧 Token Integration

The scripts `my_playlist.sh` and `my_spotify.sh` are designed to automatically read the token from `spotify_token.json`. 
No manual token editing is required.

However make sure both scripts include the correct path to `get_spotify_token.py`, like this:

```bash
TOKEN=$(~/.local/bin/get_spotify_token.py) || exit 1
```

> 🎙️ If you’d like to **disable voice output**, simply remove or comment out the call to `speech_wrapper.sh` in those scripts.

---

> ⚠️ **Note:** The access token expires after 1 hour.  
> Don’t worry — the Python script handles **automatic token refreshing** for you.  
> Just keep the script in place and it’ll do its thing silently in the background.  
> So smooth you might even forget it’s there.

---

## 🛠️ Step 2: Install the Scripts

Install the scripts to your `~/.local/bin/` directory:

```bash
mkdir -p ~/.local/bin
cp bin/my_playlist.sh ~/.local/bin/
cp bin/my_spotify.sh ~/.local/bin/
cp bin/speech_wrapper.sh ~/.local/bin/
cp bin/get_spotify_token.py ~/.local/bin/
chmod +x ~/.local/bin/*.sh
```

> 📝 `get_spotify_token.py` doesn’t need to be executable, just present.

---

## ▶ 📼 How to Use It  
_(No need to memorize this — Antigravity CLI will handle it!)_

### Play a Full Playlist by URL

```bash
my_playlist.sh "https://open.spotify.com/playlist/6YSIX1cHVEv28R6iTVHbWZ"
```

### Play a Specific Track Matching a Keyword

```bash
my_playlist.sh "https://open.spotify.com/playlist/6YSIX1cHVEv28R6iTVHbWZ" "Footloose"
```

Matches the first track that includes “Footloose”.

### Play a Random Track from a Random Playlist

```bash
my_playlist.sh
```

---

## 🗣️ Optional: Voice Feedback

If `speech_wrapper.sh` is installed and executable in `~/.local/bin/`,  
you’ll hear the track name announced before playback begins.

Make sure it has execute permission:

```bash
chmod +x ~/.local/bin/speech_wrapper.sh
```

---

## ❗Troubleshooting

- **Playlist not found** → Check if the access token is valid and has correct scopes.  
- **No playback** → The search pattern may not match any track.  
- **Token expired** → Re-run `get_spotify_token.py` or check if it’s properly refreshing.

---

## 📌 Notes

- The scripts use `curl` and `jq` to query Spotify’s Web API  
- `get_spotify_token.py` handles both access and refresh tokens  
- Fully compatible with Antigravity CLI

---

## ✅ Requirements Checklist

- Spotify token generated  
- Scripts installed in `~/.local/bin/`  
- `curl` and `jq` installed  
- Optional: `speech_wrapper.sh` installed and executable  

---

## 📦 Install Dependencies

```bash
sudo pacman -S python-pipx jq curl
pipx ensurepath
```

---

## 💬 Need Help?

Open an issue and we’ll be happy to help. Contributions welcome!

---

> © VoxAI.Dots Project — MIT License — 2025
