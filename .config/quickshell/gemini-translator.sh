#!/bin/bash

# Gemini-based translator
SOURCE_LANG="$1"
TARGET_LANG="$2"
TEXT="$3"

if [ $# -ne 3 ]; then
    echo "Translation failed"
    exit 1
fi

# Language mapping
case "$SOURCE_LANG" in
    "ja") SOURCE_NAME="Japanese";;
    "es") SOURCE_NAME="Spanish";;
    "en") SOURCE_NAME="English";;
    "fr") SOURCE_NAME="French";;
    "de") SOURCE_NAME="German";;
    "it") SOURCE_NAME="Italian";;
    "pt") SOURCE_NAME="Portuguese";;
    "ru") SOURCE_NAME="Russian";;
    "zh") SOURCE_NAME="Chinese";;
    "ko") SOURCE_NAME="Korean";;
    *) SOURCE_NAME="auto-detect";;
esac

case "$TARGET_LANG" in
    "ja") TARGET_NAME="Japanese";;
    "es") TARGET_NAME="Spanish";;
    "en") TARGET_NAME="English";;
    "fr") TARGET_NAME="French";;
    "de") TARGET_NAME="German";;
    "it") TARGET_NAME="Italian";;
    "pt") TARGET_NAME="Portuguese";;
    "ru") TARGET_NAME="Russian";;
    "zh") TARGET_NAME="Chinese";;
    "ko") TARGET_NAME="Korean";;
    *) TARGET_NAME="Spanish";;
esac

# Create prompt for Gemini
PROMPT="Translate this text from $SOURCE_NAME to $TARGET_NAME. Only respond with the translation, no explanations: $TEXT"

# Use Gemini CLI to translate
RESULT=$(echo "$PROMPT" | gemini 2>/dev/null | grep -v "Loaded cached credentials" | grep -v "^$" | head -1 | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')

if [ -n "$RESULT" ] && [ "$RESULT" != "" ]; then
    echo "$RESULT"
else
    echo "Translation failed"
fi