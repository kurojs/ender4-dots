#!/bin/bash
TOKEN=$(/home/kuro/.local/bin/.venv/bin/python ~/.local/bin/get_spotify_token.py) || exit 1
PATTERN="$1"

limit=50; offset=0; songs=()
while :; do
  rsp=$(curl -s -H "Authorization: Bearer $TOKEN" \
        "https://api.spotify.com/v1/me/tracks?limit=$limit&offset=$offset")
  cnt=$(echo "$rsp" | jq '.items | length')
  (( cnt == 0 )) && break
  mapfile -t page < <(echo "$rsp" | jq -r '.items[].track | "\(.name) - \(.artists | map(.name) | join(", "))"')
  songs+=("${page[@]}")
  offset=$((offset + limit))
done

(( ${#songs[@]} )) || { echo "No liked songs found."; exit 1; }

if [[ -n $PATTERN ]]; then
  song=$(printf '%s\n' "${songs[@]}" | grep -i -- "$PATTERN" | head -n1)
  [[ -z $song ]] && song=${songs[RANDOM % ${#songs[@]}]}
else
  song=${songs[RANDOM % ${#songs[@]}]}
fi

printf '%s\n' "$song" > ~/.cache/spotify_selected_track.txt
~/.local/bin/speech_wrapper.sh "Playing $song." &
~/.local/bin/play "$song"
