#!/bin/bash
# OCR Japanese text → clipboard + translation notification + ElevenLabs TTS
# Dependencies: slurp, spectacle, imagemagick, manga-ocr-shot, translate-shell, wl-clipboard, libnotify, curl, jq, paplay
# Config: ~/.config/ocr-jp/config — set ELEVENLABS_API_KEY there

set -euo pipefail

# ── Config ──────────────────────────────────
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/ocr-jp/config"
JAPANESE_VOICE_ID="QsAQbwLjj42cienasfhu"
SPANISH_VOICE_ID="Vt0Vg2uCO8fyNxSNCHTb"
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
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/ocr-jp"

cleanup() {
    rm -f "$TMP_FULL" "$TMP_IMG"
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
JAPANESE_TEXT=$(manga-ocr-shot "$TMP_IMG")

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

# ── TTS background (cached) ─────────────────
if [ -n "$ELEVENLABS_API_KEY" ] && [ -n "$TRANSLATED" ]; then
    mkdir -p "$CACHE_DIR"

    _tts() {
        local text="$1"
        local voice_id="$2"
        local hash
        hash=$(echo -n "$text" | md5sum | cut -d' ' -f1)
        local cache_file="$CACHE_DIR/${hash}_${voice_id}.mp3"

        # Cache hit
        if [ -s "$cache_file" ] && file "$cache_file" | grep -qi audio; then
            mpv --no-video --really-quiet "$cache_file"
            return
        fi

        # Cache miss
        curl -s -X POST "https://api.elevenlabs.io/v1/text-to-speech/${voice_id}" \
            -H "xi-api-key: ${ELEVENLABS_API_KEY}" \
            -H "Content-Type: application/json" \
            -d "$(jq -n --arg text "$text" --arg model "$MODEL_ID" '{text: $text, model_id: $model}')" \
            --output "$cache_file" 2>/dev/null || { rm -f "$cache_file"; return; }

        if [ -s "$cache_file" ] && file "$cache_file" | grep -qi audio; then
            mpv --no-video --really-quiet "$cache_file"
        else
            rm -f "$cache_file"
        fi
    }

    (
        _tts "$JAPANESE_TEXT" "$JAPANESE_VOICE_ID"
        sleep 0.5
        _tts "$TRANSLATED" "$SPANISH_VOICE_ID"
    ) &
fi
