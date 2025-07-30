#!/bin/bash
# Auto video wallpaper - Always use background.mp4

# Set the path to the video file
VIDEO_PATH="/home/[UserName]/Pictures/Wallpapers/1.mp4"

# Check if the video file exists
if [ ! -f "$VIDEO_PATH" ]; then
    echo "❌ Not found: $VIDEO_PATH"
    exit 1
fi

# Output a message indicating the start of the video wallpaper
echo "🎬 Starting video wallpaper: background.mp4"

# Kill any previous instances of mpvpaper to avoid conflicts
pkill mpvpaper 2>/dev/null

# Start mpvpaper with options for fullscreen, no audio, and infinite loop
mpvpaper -f -o "no-audio --loop-file=yes" HDMI-A-1 "$VIDEO_PATH"
