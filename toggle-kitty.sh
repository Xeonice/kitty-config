#!/bin/bash
# toggle-kitty.sh - Quake-style toggle for kitty terminal
# Features: sticky (all spaces) + topmost (above fullscreen apps)

KITTY_APP="/Applications/kitty.app/Contents/MacOS/kitty"

# Check if kitty is running
if pgrep -x "kitty" > /dev/null; then
    # Get kitty visibility status
    KITTY_VISIBLE=$(osascript -e 'tell application "System Events" to get visible of process "kitty"' 2>/dev/null)

    if [ "$KITTY_VISIBLE" = "true" ]; then
        # kitty is visible, hide it
        osascript -e 'tell application "System Events" to set visible of process "kitty" to false'
    else
        # kitty is hidden, show it
        osascript -e 'tell application "System Events" to set visible of process "kitty" to true'
        osascript -e 'tell application "kitty" to activate'

        # Make kitty sticky (all spaces) and topmost using yabai
        sleep 0.2
        /opt/homebrew/bin/yabai -m window --focus "$(/opt/homebrew/bin/yabai -m query --windows | grep -i kitty | head -1 | grep -o '"id":[0-9]*' | grep -o '[0-9]*')" 2>/dev/null
        /opt/homebrew/bin/yabai -m window --toggle sticky 2>/dev/null
        /opt/homebrew/bin/yabai -m window --toggle topmost 2>/dev/null
    fi
else
    # kitty is not running, start it
    "$KITTY_APP" --single-instance --start-as=fullscreen &

    # Wait for kitty to start and set properties
    sleep 1
    osascript -e 'tell application "kitty" to activate'
    sleep 0.3
    /opt/homebrew/bin/yabai -m window --toggle sticky 2>/dev/null
    /opt/homebrew/bin/yabai -m window --toggle topmost 2>/dev/null
fi
