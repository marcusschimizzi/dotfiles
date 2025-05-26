#!/bin/bash

# Quick note script for Obsidian
OBSIDIAN_VAULT="$HOME/Documents/ObsidianVault"
NOTES_DIR="$OBSIDIAN_VAULT/Quick Notes"

# Create notes directory if it doesn't exist
mkdir -p "$NOTES_DIR"

# Get note content via rofi
note_content=$(rofi -dmenu -p "Quick Note" -width 50 -lines 10)

if [[ -n "$note_content" ]]; then
    # Generate filename with timestamp
    timestamp=$(date +"%Y%m%d_%H%M%S")
    filename="quick_note_$timestamp.md"
    
    # Create the note file
    cat > "$NOTES_DIR/$filename" << EOF
# Quick Note - $(date +"%Y-%m-%d %H:%M")

$note_content

---
*Created via i3 quick note*
EOF
    
    # Show confirmation
    notify-send "Quick Note" "Saved to $filename"
fi
