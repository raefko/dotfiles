#!/bin/sh

CPU=$(top -l 1 -s 0 | grep "CPU usage" | awk '{print $3}' | cut -d% -f1)

sketchybar --set "$NAME" label="${CPU}%"
