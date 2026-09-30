#!/usr/bin/env bash
# ~/.config/bash-scripts/rofi_monitor_layout.sh

set -euo pipefail

MACHINE="${XDG_SESSION_OPT:-laptop}"

# screen | resolution | location | scale | disabled | mirror
case "$MACHINE" in
    desktop)
        CONFIG_FILE="$HOME/.config/hypr/generated/monitor.lua"
        PRIMARY="DP-4"
        DEFAULT_LAYOUT=(
            "DP-4|1920x1080@144|0x0|1|false|false"
            "DP-6|1920x1080@144|-1920x0|1|false|false"
            "HDMI-A-2|1440x900@60|1920x0|1|false|false"
        )
        PRIMARY_ONLY_LAYOUT=(
            "DP-4|1920x1080@144|0x0|1|false|false"
            "DP-6|1920x1080@144|-1920x0|1|true|false"
            "HDMI-A-2|1440x900@60|1920x0|1|true|false"
        )
        DUPLICATE_LAYOUT=(
            "DP-4|1920x1080@144|0x0|1|false|false"
            "DP-6|1920x1080@144|0x0|1|false|DP-4"
            "HDMI-A-2|1440x900@60|0x0|1|false|DP-4"
        )
        FLIPPED_LAYOUT=(
            "DP-4|1920x1080@144|0x0|1|false|false"
            "DP-6|1920x1080@144|1920x0|1|false|false"
            "HDMI-A-2|1440x900@60|-1440x0|1|false|false"
        )
        OPTIONS=("Default" "Duplicate" "Primary only" "Default-flipped")
        ;;
    laptop|*)
        CONFIG_FILE="$HOME/.config/hypr/generated/monitor.lua"
        PRIMARY="eDP-1"
        DEFAULT_LAYOUT=(
            "eDP-1|1920x1080@144|0x0|1|false|false"
            "DVI-I-2|1920x1080@144|-1920x0|1|false|false"
            "DP-1|1920x1080@60|1920x0|1|false|false"
            "DVI-I-1|1920x1080@60|1920x0|1|false|false"
            "HDMI-A-1|1920x1080@60|1920x0|1|false|false"
        )
        PRIMARY_ONLY_LAYOUT=(
            "eDP-1|1920x1080@144|0x0|1|false|false"
            "DVI-I-2|1920x1080@144|-1920x0|1|true|false"
            "DP-1|1920x1080@60|1920x0|1|true|false"
            "DVI-I-1|1920x1080@60|1920x0|1|true|false"
            "HDMI-A-1|1920x1080@60|1920x0|1|true|false"
        )
        DUPLICATE_LAYOUT=(
            "eDP-1|1920x1080@144|0x0|1|false|false"
            "DVI-I-2|1920x1080@144|0x0|1|false|eDP-1"
            "DP-1|1920x1080@144|0x0|1|false|eDP-1"
            "DVI-I-1|1920x1080@60|0x0|1|false|eDP-1"
            "HDMI-A-1|1920x1080@60|0x0|1|false|eDP-1"
        )
        FLIPPED_LAYOUT=(
            "eDP-1|1920x1080@144|0x0|1|false|false"
            "DVI-I-2|1920x1080@144|1920x0|1|false|false"
            "DP-1|1920x1080@144|1920x0|1|false|false"
            "DVI-I-1|1920x1080@60|-1920x0|1|false|false"
            "HDMI-A-1|1920x1080@60|-1920x0|1|false|false"
        )
        TESTING_LAYOUT=(
            "eDP-1|1920x1080@144|1920x0|1|false|false"
            "DVI-I-2|1920x1080@144|0x0|1|false|false"
            "DP-1|1920x1080@60|-1920x0|1|false|false"
            "DVI-I-1|1920x1080@60|3840x0|1|false|false"
            "HDMI-A-1|1920x1080@60|-3840x0|1|false|false"
        )
        OPTIONS=("Default" "Duplicate" "Primary only" "Default-flipped" "Testing")
        ;;
esac

selected=$(printf '%s\n' "${OPTIONS[@]}" | rofi -dmenu -p "Monitor Layout" || true)

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
        layout=("${PRIMARY_ONLY_LAYOUT[@]}")
        ;;
    "Default-flipped")
        layout=("${FLIPPED_LAYOUT[@]}")
        ;;
    "Testing")
        layout=("${TESTING_LAYOUT[@]}")
        ;;
    *)
        exit 0
        ;;
esac

python3 - "$CONFIG_FILE" "$MACHINE" "$PRIMARY" "$selected" "${layout[@]}" <<'PY'
import subprocess
import sys
from pathlib import Path
from textwrap import dedent

config_path = Path(sys.argv[1])
primary = sys.argv[3]
layout = sys.argv[5:]

monitor_lines = []
for entry in layout:
    output, mode, position, scale, disabled, mirror = entry.split("|", 5)
    monitor_lines.extend([
        "hl.monitor({",
        f'    output   = "{output}",',
        f'    mode     = "{mode}",',
        f'    position = "{position}",',
        f'    disabled = {disabled},',
    ])
    if mirror != "" and mirror != "false":
        monitor_lines.append(f'    mirror    = "{mirror}",')  
    monitor_lines.append(f'    scale    = "{scale}",')
    monitor_lines.append("})")

monitor_block = "\n".join(monitor_lines)
content = dedent("""
    -- This is the archinstall of 07/06/2026

    -- This get's automatically replaced by alt+p
    -- Monitor Config Start
    __MONITOR_BLOCK__
    -- Monitor Config End
""").replace("__MONITOR_BLOCK__", monitor_block).lstrip().rstrip() + "\n"

config_path.parent.mkdir(parents=True, exist_ok=True)
config_path.write_text(content, encoding="utf-8")
PY

hyprctl reload