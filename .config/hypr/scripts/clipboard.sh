#!/usr/bin/env bash

list=$(cliphist list)
[ -z "$list" ] && exit 0

idx=$(echo "$list" | awk -F'\t' '{print NR ". " $2}' | rofi -dmenu -format i -p "Clipboard")

if [ -n "$idx" ]; then
    echo "$list" | sed -n "$((idx + 1))p" | cliphist decode | wl-copy
fi

