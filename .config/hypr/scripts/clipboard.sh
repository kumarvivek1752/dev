#!/usr/bin/env bash
# ~/.config/hypr/scripts/clipboard.sh
# Clean clipboard manager: 10,000 capacity, Enter to copy, Alt+d to delete

MAX_ITEMS=10000

# Fetch list from cliphist
list=$(cliphist -max-items "$MAX_ITEMS" list)
if [ -z "$list" ]; then
    notify-send -t 1500 -u low "📋 Clipboard" "Clipboard is empty."
    exit 0
fi

# Display clean list in rofi
# Alt+d (exit code 10) -> Delete highlighted item
idx=$(echo "$list" | awk -F'\t' '{print NR ". " $2}' | rofi -dmenu -format i \
    -p "Clipboard" \
    -kb-custom-1 "Alt+d")

rofi_status=$?

# If user cancelled or pressed Esc (exit code 1 or empty index)
[ -z "$idx" ] && exit 0
[ $rofi_status -ne 0 ] && [ $rofi_status -ne 10 ] && exit 0

# Extract selected item (1-indexed)
selected_item=$(echo "$list" | sed -n "$((idx + 1))p")
[ -z "$selected_item" ] && exit 0

if [ $rofi_status -eq 10 ]; then
    # Action: Delete highlighted item on Alt+d
    echo "$selected_item" | cliphist delete
    notify-send -t 1000 -u low "🗑️ Deleted" "$(echo "$selected_item" | cut -f2 | cut -c 1-35)..."
    # Reopen clipboard immediately with the item removed
    exec "$0"
else
    # Action: Normal Enter -> Copy cleanly to clipboard
    echo "$selected_item" | cliphist decode | wl-copy
fi
