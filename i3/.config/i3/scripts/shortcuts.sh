#!/bin/bash

# i3 Keyboard Shortcuts Cheat Sheet
MOD="Alt"

# Create a temporary rofi theme for shortcuts
THEME_FILE="/tmp/shortcuts.rasi"
cat > "$THEME_FILE" << 'EOF'
* {
    background-color: #1e1e2e;
    text-color: #cdd6f4;
    font: "JetBrains Mono 14";
}

window {
    width: 1200px;
    height: 600px;
    border: 2px;
    border-color: #89b4fa;
    border-radius: 10px;
}

mainbox {
    children: [ "message", "listview" ];
    spacing: 10px;
    padding: 20px;
}

message {
    background-color: #313244;
    border-radius: 5px;
    padding: 10px;
    text-color: #f9e2af;
}

listview {
    columns: 3;
    lines: 8;
    cycle: false;
    scrollbar: false;
    spacing: 15px;
}

element {
    padding: 8px;
    border-radius: 5px;
    background-color: transparent;
}

element selected {
    background-color: #45475a;
}

element-text {
    horizontal-align: 0;
    font: "JetBrains Mono 12";
}
EOF

# Create shortcuts content - using rofi's message feature for title
rofi -dmenu -p "" -no-custom \
     -theme "$THEME_FILE" \
     -mesg "i3 Window Manager - Keyboard Shortcuts" << EOF
${MOD}+Enter → Terminal
${MOD}+d → App launcher
${MOD}+Shift+q → Kill window
${MOD}+f → Fullscreen
${MOD}+Shift+Space → Float
${MOD}+r → Resize mode
${MOD}+j/k/l/; → Focus windows
${MOD}+1-0 → Switch workspace
${MOD}+Shift+1-0 → Move to workspace
${MOD}+Tab → Next workspace
${MOD}+Shift+Tab → Prev workspace
${MOD}+e → Split horizontal
${MOD}+v → Split vertical
${MOD}+s → Stacking layout
${MOD}+w → Tabbed layout
${MOD}+space → Toggle split
${MOD}+Shift+c → Reload config
${MOD}+Shift+r → Restart i3
${MOD}+Shift+e → Exit i3
${MOD}+l → Lock screen
${MOD}+/ → This menu
${MOD}+n → Quick note
${MOD}+minus → Scratchpad
${MOD}+Shift+minus → To scratchpad
EOF

# Clean up
rm -f "$THEME_FILE"
