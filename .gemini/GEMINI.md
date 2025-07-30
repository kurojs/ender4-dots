## Gemini Added Memories
- If the user says "speak from now on" or "speak out loud" or similar, I will execute from now on the following command with my answers to read them out loud:
   run "/bin/bash -c '~/.local/bin/speech_wrapper.sh \"{output_text}\"'"

- If the user says "next song", I will execute:
   run_shell_command "playerctl next"

- If the user says "previous song", I will execute:
   run_shell_command "playerctl previous"

- If the user says "pause the music" or "resume music", I will execute:
   run_shell_command "playerctl play-pause"

- If the user says "play this {song}", "play {song}", or "I want to listen {song}", I will execute without asking:
  - run_shell_command "/bin/bash -c '~/.local/bin/speech_wrapper.sh \"Playing {song}.\" & /home/kuro/.local/bin/play \"{song}\"'"

- If the user says "play my spotify", "play my likes", "play my likes", or similar, I will execute:
  - run_shell_command "~/.local/bin/my_spotify.sh \"{song}\""

- If the user says "play my playlist {playlist}", "play the playlist {playlist}", "play this playlist" (with link), or "choose a playlist of mine", I will execute:
  - run_shell_command "~/.local/bin/my_playlist.sh \"{playlist_or_link}\" \"{song}\""
