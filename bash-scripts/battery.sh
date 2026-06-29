#!/bin/bash
while true; do
  bat_lvl=$(cat /sys/class/power_supply/BAT0/capacity)
  bat_status=$(cat /sys/class/power_supply/BAT0/status)
  if [ "$bat_lvl" -le 15 ]; then
    notify-send --urgency=critical "Battery Low" "Level: ${bat_lvl}%"
    sleep 1200
  elif [ "$bat_lvl" -ge 90 ] && [ "$bat_status" = "Charging" ]; then
    notify-send --urgency=normal "Battery Full" "Level: ${bat_lvl}%"
    sleep 1200
  else
    sleep 120
  fi
done