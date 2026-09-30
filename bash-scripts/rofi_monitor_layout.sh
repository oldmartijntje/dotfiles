#!/usr/bin/env bash
# ~/.config/bash-scripts/rofi_monitor_layout.sh

set -euo pipefail

MACHINE="${XDG_SESSION_OPT:-laptop}"

case "$MACHINE" in
    desktop)
        CONFIG_FILE="$HOME/.config/hypr/generated/monitor.lua"
        ;;
    laptop|*)
        CONFIG_FILE="$HOME/.config/hypr/generated/monitor.lua"
        ;;
esac

LAYOUTS_JSON=$(cat <<'JSON'
{
  "desktop": {
    "options": ["Default", "Duplicate", "Primary only", "Default-flipped", "empty-config"],
    "layouts": {
      "Default": [
        {"output": "DP-4", "mode": "1920x1080@144", "position": "0x0", "scale": "1", "disabled": false},
        {"output": "DP-6", "mode": "1920x1080@144", "position": "-1920x0", "scale": "1", "disabled": false},
        {"output": "HDMI-A-2", "mode": "1440x900@60", "position": "1920x0", "scale": "1", "disabled": false}
      ],
      "Primary only": [
        {"output": "DP-4", "mode": "1920x1080@144", "position": "0x0", "scale": "1", "disabled": false},
        {"output": "DP-6", "mode": "1920x1080@144", "position": "-1920x0", "scale": "1", "disabled": true},
        {"output": "HDMI-A-2", "mode": "1440x900@60", "position": "1920x0", "scale": "1", "disabled": true}
      ],
      "Duplicate": [
        {"output": "DP-4", "mode": "1920x1080@144", "position": "0x0", "scale": "1", "disabled": false},
        {"output": "DP-6", "mode": "1920x1080@144", "position": "0x0", "scale": "1", "disabled": false, "mirror": "DP-4"},
        {"output": "HDMI-A-2", "mode": "1440x900@60", "position": "0x0", "scale": "1", "disabled": false, "mirror": "DP-4"}
      ],
      "Default-flipped": [
        {"output": "DP-4", "mode": "1920x1080@144", "position": "0x0", "scale": "1", "disabled": false},
        {"output": "DP-6", "mode": "1920x1080@144", "position": "1920x0", "scale": "1", "disabled": false},
        {"output": "HDMI-A-2", "mode": "1440x900@60", "position": "-1440x0", "scale": "1", "disabled": false}
      ],
      "empty-config": []
    }
  },
  "laptop": {
    "options": ["Default", "Duplicate", "Primary only", "Default-flipped", "Testing", "empty-config"],
    "layouts": {
      "Default": [
        {"output": "eDP-1", "mode": "1920x1080@144", "position": "0x0", "scale": "1", "disabled": false},
        {"output": "DVI-I-2", "mode": "1920x1080@144", "position": "-1920x0", "scale": "1", "disabled": false},
        {"output": "DP-1", "mode": "1920x1080@60", "position": "1920x0", "scale": "1", "disabled": false},
        {"output": "DVI-I-1", "mode": "1920x1080@60", "position": "1920x0", "scale": "1", "disabled": false},
        {"output": "HDMI-A-1", "mode": "1920x1080@60", "position": "1920x0", "scale": "1", "disabled": false}
      ],
      "Primary only": [
        {"output": "eDP-1", "mode": "1920x1080@144", "position": "0x0", "scale": "1", "disabled": false},
        {"output": "DVI-I-2", "mode": "1920x1080@144", "position": "-1920x0", "scale": "1", "disabled": true},
        {"output": "DP-1", "mode": "1920x1080@60", "position": "1920x0", "scale": "1", "disabled": true},
        {"output": "DVI-I-1", "mode": "1920x1080@60", "position": "1920x0", "scale": "1", "disabled": true},
        {"output": "HDMI-A-1", "mode": "1920x1080@60", "position": "1920x0", "scale": "1", "disabled": true}
      ],
      "Duplicate": [
        {"output": "eDP-1", "mode": "1920x1080@144", "position": "0x0", "scale": "1", "disabled": false},
        {"output": "DVI-I-2", "mode": "1920x1080@144", "position": "0x0", "scale": "1", "disabled": false, "mirror": "eDP-1"},
        {"output": "DP-1", "mode": "1920x1080@144", "position": "0x0", "scale": "1", "disabled": false, "mirror": "eDP-1"},
        {"output": "DVI-I-1", "mode": "1920x1080@60", "position": "0x0", "scale": "1", "disabled": false, "mirror": "eDP-1"},
        {"output": "HDMI-A-1", "mode": "1920x1080@60", "position": "0x0", "scale": "1", "disabled": false, "mirror": "eDP-1"}
      ],
      "Default-flipped": [
        {"output": "eDP-1", "mode": "1920x1080@144", "position": "0x0", "scale": "1", "disabled": false},
        {"output": "DVI-I-2", "mode": "1920x1080@144", "position": "1920x0", "scale": "1", "disabled": false},
        {"output": "DP-1", "mode": "1920x1080@144", "position": "1920x0", "scale": "1", "disabled": false},
        {"output": "DVI-I-1", "mode": "1920x1080@60", "position": "-1920x0", "scale": "1", "disabled": false},
        {"output": "HDMI-A-1", "mode": "1920x1080@60", "position": "-1920x0", "scale": "1", "disabled": false}
      ],
      "Testing": [
        {"output": "eDP-1", "mode": "1920x1080@144", "position": "1920x0", "scale": "1", "disabled": false},
        {"output": "DVI-I-2", "mode": "1920x1080@144", "position": "0x0", "scale": "1", "disabled": false},
        {"output": "DP-1", "mode": "1920x1080@60", "position": "-1920x0", "scale": "1", "disabled": false},
        {"output": "DVI-I-1", "mode": "1920x1080@60", "position": "3840x0", "scale": "1", "disabled": false},
        {"output": "HDMI-A-1", "mode": "1920x1080@60", "position": "-3840x0", "scale": "1", "disabled": false}
      ],
      "empty-config": []
    }
  }
}
JSON
)

OPTIONS=$(python3 - "$MACHINE" "$LAYOUTS_JSON" <<'PY'
import json
import sys

machine = sys.argv[1]
data = json.loads(sys.argv[2])
print("\n".join(data[machine]["options"]))
PY
)

selected=$(printf '%s\n' "$OPTIONS" | rofi -dmenu -p "Monitor Layout" || true)

if [[ -z "$selected" ]]; then
    exit 0
fi

case "$selected" in
    "Default"|"Duplicate"|"Primary only"|"Default-flipped"|"Testing"|"empty-config")
        ;;
    *)
        exit 0
        ;;
esac

python3 - "$CONFIG_FILE" "$MACHINE" "$selected" "$LAYOUTS_JSON" <<'PY'
import json
import sys
from pathlib import Path
from textwrap import dedent

config_path = Path(sys.argv[1])
machine = sys.argv[2]
selected = sys.argv[3]
data = json.loads(sys.argv[4])
layout = data[machine]["layouts"][selected]

monitor_lines = []
for monitor in layout:
    output = monitor["output"]
    mode = monitor["mode"]
    position = monitor["position"]
    scale = str(monitor.get("scale", "1"))
    disabled = str(bool(monitor.get("disabled", False))).lower()
    mirror = monitor.get("mirror", False)

    monitor_lines.extend([
        "hl.monitor({",
        f'    output   = "{output}",',
        f'    mode     = "{mode}",',
        f'    position = "{position}",',
        f'    disabled = {disabled},',
    ])
    if mirror not in (None, False, "false", ""):
        monitor_lines.append(f'    mirror   = "{mirror}",')
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