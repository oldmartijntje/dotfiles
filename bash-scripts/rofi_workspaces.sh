#!/usr/bin/env bash
workspace_list=$(hyprctl workspaces -j | jq -r '.[] | "Workspace \(.id): \(.name) (Windows: \(.windows))"')

selected=$(echo "$workspace_list" | rofi -dmenu -p "Switch Workspace")

if [[ -n "$selected" ]]; then
    ws_name=$(echo "$selected" | awk '{print $3}' | tr -d ':')
    hyprctl dispatch "hl.dsp.focus({workspace=\"name:$ws_name\"})"
fi
