#!/bin/sh
# Matches the 2560x1600 @ 166% scaling used on Ubuntu: 166% is GNOME's
# rounded display of the exact 5:3 factor, so the effective/logical
# resolution is 2560/1.667=1536 x 1600/1.667=960.
MODE="1536x960_60.00"
OUTPUT=$(xrandr --current | awk '/ connected/{print $1; exit}')

if [ -n "${OUTPUT}" ]; then
    xrandr --newmode "${MODE}" 121.25 1536 1624 1784 2032 960 963 969 996 -hsync +vsync
    xrandr --addmode "${OUTPUT}" "${MODE}"
    xrandr --output "${OUTPUT}" --mode "${MODE}"
fi
