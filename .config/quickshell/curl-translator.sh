#!/bin/bash

# Simple web translator using curl instead of Python requests
SOURCE_LANG="$1"
TARGET_LANG="$2" 
TEXT="$3"

if [ $# -ne 3 ]; then
    echo "Usage: $0 <source_lang> <target_lang> <text>"
    exit 1
fi

# URL encode the text
ENCODED_TEXT=$(echo "$TEXT" | sed 's/ /%20/g' | sed 's/&/%26/g' | sed 's/=/%3D/g')

# MyMemory API call using curl
URL="https://api.mymemory.translated.net/get?q=${ENCODED_TEXT}&langpair=${SOURCE_LANG}%7C${TARGET_LANG}"

RESULT=$(curl -s --connect-timeout 10 "$URL" | grep -o '"translatedText":"[^"]*"' | sed 's/"translatedText":"//g' | sed 's/"$//g')

if [ -n "$RESULT" ] && [ "$RESULT" != "null" ]; then
    echo "$RESULT"
else
    echo "Translation failed"
fi