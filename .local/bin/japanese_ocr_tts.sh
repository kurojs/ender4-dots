#!/bin/bash
# Script for Japanese OCR, translation and TTS on Wayland
# Requires: tesseract, translate-shell, spectacle, wl-clipboard, curl, pipewire, pulseaudio-utils

# ========== ENVIRONMENT CONFIGURATION ==========
# Ensure we have access to audio server
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export PULSE_SERVER=unix:/run/user/$(id -u)/pulse/native

# ========== CONFIGURATION ==========
# ElevenLabs API key (set your own key here)
ELEVENLABS_API_KEY="YOUR_ELEVENLABS_API_KEY"

# Custom Voice IDs
JAPANESE_VOICE_ID="GxhGYQesaQaYKePCZDEC"
SPANISH_VOICE_ID="h3KZVBOooxHZiKRxnsdE"

# Voice model
MODEL_ID="eleven_multilingual_v2"

# ========== SCRIPT START ==========

# 1. Define temporary files
TMP_IMG="/tmp/ocr_screenshot_$(date +%s).png"
TMP_AUDIO_JP="/tmp/tts_japanese_$(date +%s).mp3"
TMP_AUDIO_ES="/tmp/tts_spanish_$(date +%s).mp3"

# Function to clean temporary files
cleanup() {
    [ -f "$TMP_IMG" ] && rm "$TMP_IMG"
    [ -f "$TMP_AUDIO_JP" ] && rm "$TMP_AUDIO_JP"
    [ -f "$TMP_AUDIO_ES" ] && rm "$TMP_AUDIO_ES"
}

# Ensure cleanup on exit
trap cleanup EXIT

# 2. Select area and take screenshot with spectacle
spectacle -b -n -r -o "$TMP_IMG"

# 3. Verify screenshot was created and is not empty
if [ ! -s "$TMP_IMG" ]; then
    notify-send -u critical "Capture Error" "Capture cancelled or failed."
    exit 1
fi

# 4. Perform OCR on Japanese text
# Using PSM 6 for uniform block of text and removing extra spaces
JAPANESE_TEXT=$(tesseract "$TMP_IMG" stdout -l jpn --psm 6 | sed 's/ //g')

# Check if OCR extracted text
if [ -z "$JAPANESE_TEXT" ]; then
    notify-send "OCR Error" "Could not extract Japanese text from selected area."
    exit 1
fi

# 5. Translate text from Japanese to Spanish
TRANSLATED_TEXT=$(trans -b -s ja -t es "$JAPANESE_TEXT")

# Check if translation worked
if [ -z "$TRANSLATED_TEXT" ]; then
    notify-send "Translation Error" "Failed to translate text. Copying original."
    echo -n "$JAPANESE_TEXT" | wl-copy
    exit 1
fi

# 6. Copy original Japanese text to clipboard
echo -n "$JAPANESE_TEXT" | wl-copy

# 7. Show notification with Spanish translation
notify-send "Translation" "$TRANSLATED_TEXT"

# 8. Generate and play TTS in BACKGROUND (non-blocking)
(
    # Generate Japanese audio
    curl -s -X POST "https://api.elevenlabs.io/v1/text-to-speech/${JAPANESE_VOICE_ID}" \
        -H "xi-api-key: ${ELEVENLABS_API_KEY}" \
        -H "Content-Type: application/json" \
        -d "{
            \"text\": $(echo "$JAPANESE_TEXT" | jq -Rs .),
            \"model_id\": \"${MODEL_ID}\"
        }" \
        --output "$TMP_AUDIO_JP" 2>/dev/null

    # Play Japanese audio and WAIT for it to finish
    if [ -s "$TMP_AUDIO_JP" ]; then
        paplay "$TMP_AUDIO_JP" 2>/dev/null
        # Small pause between audios
        sleep 0.3
    fi

    # Generate Spanish audio
    curl -s -X POST "https://api.elevenlabs.io/v1/text-to-speech/${SPANISH_VOICE_ID}" \
        -H "xi-api-key: ${ELEVENLABS_API_KEY}" \
        -H "Content-Type: application/json" \
        -d "{
            \"text\": $(echo "$TRANSLATED_TEXT" | jq -Rs .),
            \"model_id\": \"${MODEL_ID}\"
        }" \
        --output "$TMP_AUDIO_ES" 2>/dev/null

    # Play Spanish audio and WAIT for it to finish
    if [ -s "$TMP_AUDIO_ES" ]; then
        paplay "$TMP_AUDIO_ES" 2>/dev/null
    fi
    
    # Clean audio files after playback
    rm -f "$TMP_AUDIO_JP" "$TMP_AUDIO_ES"
) &

# DO NOT do automatic cleanup - let background process handle it
trap - EXIT
rm -f "$TMP_IMG"

exit 0
