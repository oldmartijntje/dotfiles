#!/usr/bin/env bash
# ~/.config/bash-scripts/rofi_monitor_layout.sh

set -euo pipefail

CONFIG_FILE="$HOME/.config/hypr/machines/laptop.lua"

options=("Default" "Duplicate" "Default-flipped")
selected=$(printf '%s\n' "${options[@]}" | rofi -dmenu -p "Monitor Layout" || true)

if [[ -z "$selected" ]]; then
    exit 0
fi

python3 - "$CONFIG_FILE" "$selected" <<'PY'
import json
import subprocess
import sys
from pathlib import Path

config_path = Path(sys.argv[1])
selected = sys.argv[2]

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

PRIMARY = "eDP-1"

layout_map = {
    "Default": {
        "eDP-1": "0x0",
        "DVI-I-2": "-1920x0",
        "DVI-I-1": "1920x0",
        "HDMI-A-1": "1920x0",
    },
    "Duplicate": {
        "eDP-1": "0x0",
        "DVI-I-2": "0x0",
        "DVI-I-1": "0x0",
        "HDMI-A-1": "0x0",
    },
    "Default-flipped": {
        "eDP-1": "0x0",
        "DVI-I-2": "1920x0",
        "DVI-I-1": "-1920x0",
        "HDMI-A-1": "-1920x0",
    },
}

base = [
    ("eDP-1", "1920x1080@144"),
    ("DVI-I-2", "1920x1080@144"),
    ("DVI-I-1", "1920x1080@60"),
    ("HDMI-A-1", "1920x1080@60"),
]

lines = []
for output, mode in base:
    if connected and output not in connected:
        continue
    pos = layout_map.get(selected, {}).get(output, "0x0")
    lines.extend([
        "hl.monitor({",
        f'    output   = "{output}",',
        f'    mode     = "{mode}",',
        f'    position = "{pos}",',
        '    scale    = "1",',
    ])
    if selected == "Duplicate" and output != PRIMARY:
        lines.append(f'    mirror   = "{PRIMARY}",')
    lines.append("})")

content = config_path.read_text(encoding="utf-8")
start = content.index("-- Monitor Config Start")
end = content.index("-- Monitor Config End") + len("-- Monitor Config End")
replacement = "-- Monitor Config Start\n" + "\n".join(lines) + "\n-- Monitor Config End"
updated = content[:start] + replacement + content[end:]
config_path.write_text(updated, encoding="utf-8")
PY

hyprctl reload