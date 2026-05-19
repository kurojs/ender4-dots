#!/bin/bash
# OCR Japanese text from screen → clipboard + translation notification
# Dependencies: slurp, spectacle, imagemagick, manga-ocr-shot, translate-shell, wl-clipboard, libnotify

set -euo pipefail

TMP_FULL="/tmp/ocr_full_$$.png"
TMP_IMG="/tmp/ocr_$$.png"

# 1. Select area with mouse (instant — no Enter needed)
AREA=$(slurp -b "#00000011" -c "#66666666" -w 2 2>/dev/null) || { notify-send -u critical "OCR-JP Error" "Selection cancelled."; exit 1; }

# 2. Capture full screen (background, no UI) and crop to selection
spectacle -b -n -f -o "$TMP_FULL" 2>/dev/null
GEOM=$(echo "$AREA" | sed 's/\([0-9]*\),\([0-9]*\) \([0-9]*\)x\([0-9]*\)/\3x\4+\1+\2/')
magick "$TMP_FULL" -crop "$GEOM" "$TMP_IMG" 2>/dev/null
rm -f "$TMP_FULL"

# Verify image exists and has content
if [ ! -s "$TMP_IMG" ]; then
    notify-send -u critical "OCR-JP Error" "No image captured."
    exit 1
fi

# 2. OCR — Manga OCR on cropped image
JAPANESE_TEXT=$(manga-ocr-shot "$TMP_IMG")

if [ -z "$JAPANESE_TEXT" ]; then
    notify-send -u critical "OCR-JP Error" "No Japanese text detected."
    rm -f "$TMP_IMG"
    exit 1
fi

# 3. Clip original Japanese text
echo -n "$JAPANESE_TEXT" | wl-copy

# 4. Translate
TRANSLATED=$(trans -b -s ja -t es "$JAPANESE_TEXT" 2>/dev/null) || TRANSLATED=""

if [ -n "$TRANSLATED" ]; then
    notify-send "OCR-JP: $JAPANESE_TEXT" "$TRANSLATED"
else
    notify-send "OCR-JP" "Copied: $JAPANESE_TEXT (translation unavailable)"
fi

rm -f "$TMP_IMG"
