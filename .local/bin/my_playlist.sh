#!/bin/bash
TOKEN=$(~/.local/bin/get_spotify_token.py) || exit 1

PL_SPEC="$1"   # playlist URL, name, or blank for random
MODE="$2"      # 'random' / 'aleatorio' / pattern to start from / blank = full list

# ── Get ID playlist ──
if [[ "$PL_SPEC" =~ playlist/([a-zA-Z0-9]+) ]]; then
  pl_id="${BASH_REMATCH[1]}"
elif [[ -n "$PL_SPEC" ]]; then
  name_lc=$(echo "$PL_SPEC" | tr '[:upper:]' '[:lower:]')
  url="https://api.spotify.com/v1/me/playlists?limit=50"
  while [[ -n "$url" && "$url" != "null" ]]; do
    rsp=$(curl -s -H "Authorization: Bearer $TOKEN" "$url")
    pl_id=$(echo "$rsp" | jq -r --arg n "$name_lc" '.items[] | select(.name|ascii_downcase==$n) | .id' | head -n1)
    [[ -n "$pl_id" ]] && break
    url=$(echo "$rsp" | jq -r '.next')
  done
else
  rsp=$(curl -s -H "Authorization: Bearer $TOKEN" "https://api.spotify.com/v1/me/playlists?limit=50")
  mapfile -t ids < <(echo "$rsp" | jq -r '.items[].id')
  (( ${#ids[@]} )) || { echo "No playlists found."; exit 1; }
  pl_id=${ids[RANDOM % ${#ids[@]}]}
fi

[[ -z $pl_id ]] && { echo "Playlist not found."; exit 1; }

# ── Get tracks ──
tracks_url="https://api.spotify.com/v1/playlists/$pl_id/tracks?limit=100"
songs=()
while [[ -n $tracks_url && $tracks_url != "null" ]]; do
  rsp=$(curl -s -H "Authorization: Bearer $TOKEN" "$tracks_url")
  mapfile -t page < <(echo "$rsp" | jq -r '.items[].track | "\(.name) - \(.artists | map(.name) | join(", "))"')
  songs+=("${page[@]}")
  tracks_url=$(echo "$rsp" | jq -r '.next')
done

# ── shuffle if random ──
if [[ $MODE == "random" || $MODE == "aleatorio" ]]; then
  for i in "${!songs[@]}"; do
    j=$((RANDOM % (${#songs[@]})))
    tmp=${songs[i]} ; songs[i]=${songs[j]} ; songs[j]=$tmp
  done
elif [[ -n $MODE ]]; then
  # find a pattern and reproduce from there
  idx=-1
  for i in "${!songs[@]}"; do
    echo "${songs[i]}" | grep -iq -- "$MODE" && { idx=$i; break; }
  done
  (( idx >= 0 )) || { echo "Track matching '$MODE' not found."; exit 1; }
  songs=("${songs[@]:idx}")
fi

# ── play final list ──
for song in "${songs[@]}"; do
  printf '%s\n' "$song" > ~/.cache/spotify_selected_track.txt
  ~/.local/bin/speech_wrapper.sh "Playing $song." &
  ~/.local/bin/play "$song"
done
