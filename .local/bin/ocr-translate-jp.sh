#!/bin/bash
# Script for Japanese OCR and translation on Wayland

# 1. Define temporary file for screenshot
TMP_IMG="/tmp/ocr_screenshot_$(date +%s).png"

# 2. Select area and take screenshot with spectacle (for KDE)
# -n disables the "saved as..." notification
spectacle -b -n -r -o "$TMP_IMG"

# 3. Verify that the screenshot was created and is not empty
if [ ! -s "$TMP_IMG" ]; then
    notify-send -u critical "Capture Error" "Capture cancelled or failed. File was not created."
    # Clean up in case an empty file was created
    [ -f "$TMP_IMG" ] && rm "$TMP_IMG"
    exit 1
fi

# 4. Perform OCR on Japanese text with Tesseract
JAPANESE_TEXT=$(tesseract "$TMP_IMG" stdout -l jpn)

# Check if OCR extracted text
if [ -z "$JAPANESE_TEXT" ]; then
    notify-send "OCR Error" "Could not extract Japanese text from selected area."
    rm "$TMP_IMG"
    exit 1
fi

# 4. Translate text from Japanese to Spanish with translate-shell
TRANSLATED_TEXT=$(trans -b -s ja -t es "$JAPANESE_TEXT")

# Check if translation worked
if [ -z "$TRANSLATED_TEXT" ]; then
    notify-send "Translation Error" "Failed to translate text. Copying original."
    # If translation fails, still copy the original text
    echo -n "$JAPANESE_TEXT" | wl-copy
    rm "$TMP_IMG"
    exit 1
fi

# 5. Copy original Japanese text to clipboard
echo -n "$JAPANESE_TEXT" | wl-copy

# 6. Show notification with Spanish translation
notify-send "Translation" "$TRANSLATED_TEXT"

# 7. Delete temporary file
rm "$TMP_IMG"

exit 0
