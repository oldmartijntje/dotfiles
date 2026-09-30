#!/usr/bin/env bash
# ~/.config/bash-scripts/rofi_monitor_layout.sh

set -euo pipefail

MACHINE="${XDG_SESSION_OPT:-laptop}"

case "$MACHINE" in
    desktop)
        CONFIG_FILE="$HOME/.config/hypr/machines/desktop.lua"
        PRIMARY="DP-4"
        DEFAULT_LAYOUT=(
            "DP-4|1920x1080@144|0x0|1"
            "DP-6|1920x1080@144|-1920x0|1"
            "HDMI-A-2|1440x900@60|1920x0|1"
        )
        DUPLICATE_LAYOUT=(
            "DP-4|1920x1080@144|0x0|1"
            "DP-6|1920x1080@144|0x0|1"
            "HDMI-A-2|1440x900@60|0x0|1"
        )
        FLIPPED_LAYOUT=(
            "DP-4|1920x1080@144|0x0|1"
            "DP-6|1920x1080@144|1920x0|1"
            "HDMI-A-2|1440x900@60|-1920x0|1"
        )
        ;;
    laptop|*)
        CONFIG_FILE="$HOME/.config/hypr/machines/laptop.lua"
        PRIMARY="eDP-1"
        DEFAULT_LAYOUT=(
            "eDP-1|1920x1080@144|0x0|1"
            "DVI-I-2|1920x1080@144|-1920x0|1"
            "DP-1|1920x1080@60|1920x0|1"
            "DVI-I-1|1920x1080@60|1920x0|1"
            "HDMI-A-1|1920x1080@60|1920x0|1"
        )
        DUPLICATE_LAYOUT=(
            "eDP-1|1920x1080@144|0x0|1"
            "DVI-I-2|1920x1080@144|0x0|1"
            "DP-1|1920x1080@144|0x0|1"
            "DVI-I-1|1920x1080@60|0x0|1"
            "HDMI-A-1|1920x1080@60|0x0|1"
        )
        FLIPPED_LAYOUT=(
            "eDP-1|1920x1080@144|0x0|1"
            "DVI-I-2|1920x1080@144|1920x0|1"
            "DP-1|1920x1080@144|1920x0|1"
            "DVI-I-1|1920x1080@60|-1920x0|1"
            "HDMI-A-1|1920x1080@60|-1920x0|1"
        )
        ;;
esac

options=("Default" "Duplicate" "Primary only" "Default-flipped")
selected=$(printf '%s\n' "${options[@]}" | rofi -dmenu -p "Monitor Layout" || true)

if [[ -z "$selected" ]]; then
    exit 0
fi

case "$selected" in
    "Default")
        layout=("${DEFAULT_LAYOUT[@]}")
        ;;
    "Duplicate")
        layout=("${DUPLICATE_LAYOUT[@]}")
        ;;
    "Primary only")
        layout=("${DEFAULT_LAYOUT[@]}")
        ;;
    "Default-flipped")
        layout=("${FLIPPED_LAYOUT[@]}")
        ;;
    *)
        exit 0
        ;;
esac

python3 - "$CONFIG_FILE" "$PRIMARY" "$selected" "${layout[@]}" <<'PY'
import json
import subprocess
import sys
from pathlib import Path

config_path = Path(sys.argv[1])
primary = sys.argv[2]
selected = sys.argv[3]
layout = sys.argv[4:]

connected = set()
try:
    result = subprocess.run(["hyprctl", "monitors", "-j"], capture_output=True, text=True, check=True)
    monitors = json.loads(result.stdout or "[]")
    connected = {
        m["name"]
        for m in monitors
        if isinstance(m, dict) and m.get("enabled") is True and "name" in m
    }
except Exception:
    connected = set()

mirror_enabled = selected in ("Duplicate")
primary_only = selected == "Primary only"

lines = []
for entry in layout:
    output, mode, position, scale = entry.split("|", 3)
    if connected and output not in connected:
        continue
    lines.extend([
        "hl.monitor({",
        f'    output   = "{output}",',
        f'    mode     = "{mode}",',
        f'    position = "{position}",',
    ])
    if primary_only and position != "0x0":
        lines.append('    disabled = true,')
    lines.append(f'    scale    = "{scale}",')
    if mirror_enabled and output != primary:
        lines.append(f'    mirror   = "{primary}",')
    lines.append("})")

content = config_path.read_text(encoding="utf-8")
start = content.index("-- Monitor Config Start")
end = content.index("-- Monitor Config End") + len("-- Monitor Config End")
replacement = "-- Monitor Config Start\n" + "\n".join(lines) + "\n-- Monitor Config End"
updated = content[:start] + replacement + content[end:]
config_path.write_text(updated, encoding="utf-8")
PY

hyprctl reload