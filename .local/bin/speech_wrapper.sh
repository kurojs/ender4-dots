#!/bin/bash
TEXT="$1"
LOGFILE="$HOME/.local/share/speech_wrapper.log"
echo "$(date): Text to read: $TEXT" >> "$LOGFILE"
flatpak run net.mkiol.SpeechNote --action start-reading-text --text "$TEXT" &>> "$LOGFILE" &
