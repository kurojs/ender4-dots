#!/bin/bash

# QuickShell Translator Script
# Usage: ./translator.sh <source_lang> <target_lang> "<text>"

SOURCE_LANG="$1"
TARGET_LANG="$2"
TEXT="$3"
OUTPUT_FILE="/tmp/quickshell_translation_result.txt"

# Clear previous results
rm -f "$OUTPUT_FILE"

# Perform translation
if [ -n "$TEXT" ] && [ "$TEXT" != "" ]; then
    # Use trans command to translate
    RESULT=$(trans -no-theme -no-bidi -source "$SOURCE_LANG" -target "$TARGET_LANG" -no-ansi "$TEXT" 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
        # Get the 4th line (index 4), which is typically the clean translation
        TRANSLATION=$(echo "$RESULT" | sed -n '4p' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
        
        # If 4th line is empty, try 3rd line
        if [ -z "$TRANSLATION" ]; then
            TRANSLATION=$(echo "$RESULT" | sed -n '3p' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
        fi
        
        # If still empty, find first non-empty line after line 1 that doesn't contain parentheses
        if [ -z "$TRANSLATION" ]; then
            TRANSLATION=$(echo "$RESULT" | tail -n +2 | grep -v "(" | grep -v "^$" | head -n 1 | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
        fi
        
        echo "$TRANSLATION" > "$OUTPUT_FILE"
    else
        echo "Translation failed" > "$OUTPUT_FILE"
    fi
else
    echo "" > "$OUTPUT_FILE"
fi

exit 0