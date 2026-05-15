#!/bin/bash
# OCR Japanese text → clipboard + translation notification + ElevenLabs TTS
# Dependencies: slurp, spectacle, imagemagick, tesseract (jpn), translate-shell, wl-clipboard, libnotify, curl, jq, paplay
# Config: ~/.config/ocr-jp/config — set ELEVENLABS_API_KEY there

set -euo pipefail

# ── Config ──────────────────────────────────
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/ocr-jp/config"
JAPANESE_VOICE_ID="GxhGYQesaQaYKePCZDEC"
SPANISH_VOICE_ID="h3KZVBOooxHZiKRxnsdE"
MODEL_ID="eleven_multilingual_v2"

# Load API key from config
ELEVENLABS_API_KEY=""
if [ -f "$CONFIG_FILE" ]; then
    # shellcheck source=/dev/null
    source "$CONFIG_FILE"
fi

# ── Temp files ──────────────────────────────
TMP_FULL="/tmp/ocr_full_$$.png"
TMP_IMG="/tmp/ocr_$$.png"
TMP_AUDIO_JP="/tmp/tts_jp_$$.mp3"
TMP_AUDIO_ES="/tmp/tts_es_$$.mp3"

cleanup() {
    rm -f "$TMP_FULL" "$TMP_IMG" "$TMP_AUDIO_JP" "$TMP_AUDIO_ES"
}
trap cleanup EXIT

# ── Capture ─────────────────────────────────
AREA=$(slurp -b "#00000011" -c "#66666666" -w 2 2>/dev/null) || { notify-send -u critical "OCR-JP Error" "Selection cancelled."; exit 1; }
spectacle -b -n -f -o "$TMP_FULL" 2>/dev/null
GEOM=$(echo "$AREA" | sed 's/\([0-9]*\),\([0-9]*\) \([0-9]*\)x\([0-9]*\)/\3x\4+\1+\2/')
magick "$TMP_FULL" -crop "$GEOM" "$TMP_IMG" 2>/dev/null
rm -f "$TMP_FULL"

if [ ! -s "$TMP_IMG" ]; then
    notify-send -u critical "OCR-JP Error" "No image captured."
    exit 1
fi

# ── OCR ─────────────────────────────────────
JAPANESE_TEXT=$(tesseract "$TMP_IMG" stdout -l jpn --psm 6 2>/dev/null | sed '/^$/d' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | sed 's/ //g')

if [ -z "$JAPANESE_TEXT" ]; then
    notify-send -u critical "OCR-JP Error" "No Japanese text detected."
    exit 1
fi

# ── Clipboard ───────────────────────────────
echo -n "$JAPANESE_TEXT" | wl-copy

# ── Translation ─────────────────────────────
TRANSLATED=$(trans -b -s ja -t es "$JAPANESE_TEXT" 2>/dev/null) || TRANSLATED=""

if [ -n "$TRANSLATED" ]; then
    notify-send "OCR-JP: $JAPANESE_TEXT" "$TRANSLATED"
else
    notify-send "OCR-JP" "Copied: $JAPANESE_TEXT (translation unavailable)"
fi

# ── TTS background ──────────────────────────
if [ -n "$ELEVENLABS_API_KEY" ] && [ -n "$TRANSLATED" ]; then
    (
        # Japanese audio
        curl -sf -X POST "https://api.elevenlabs.io/v1/text-to-speech/${JAPANESE_VOICE_ID}" \
            -H "xi-api-key: ${ELEVENLABS_API_KEY}" \
            -H "Content-Type: application/json" \
            -d "$(jq -n --arg text "$JAPANESE_TEXT" --arg model "$MODEL_ID" '{text: $text, model_id: $model}')" \
            --output "$TMP_AUDIO_JP" 2>/dev/null

        if [ -s "$TMP_AUDIO_JP" ]; then
            paplay "$TMP_AUDIO_JP" 2>/dev/null
            sleep 0.3
        fi

        # Spanish audio
        curl -sf -X POST "https://api.elevenlabs.io/v1/text-to-speech/${SPANISH_VOICE_ID}" \
            -H "xi-api-key: ${ELEVENLABS_API_KEY}" \
            -H "Content-Type: application/json" \
            -d "$(jq -n --arg text "$TRANSLATED" --arg model "$MODEL_ID" '{text: $text, model_id: $model}')" \
            --output "$TMP_AUDIO_ES" 2>/dev/null

        if [ -s "$TMP_AUDIO_ES" ]; then
            paplay "$TMP_AUDIO_ES" 2>/dev/null
        fi

        rm -f "$TMP_AUDIO_JP" "$TMP_AUDIO_ES"
    ) &
fi
