#!/bin/sh
MODE="1440x900_60.00"
OUTPUT=$(xrandr --current | awk '/ connected/{print $1; exit}')

if [ -n "${OUTPUT}" ]; then
    xrandr --newmode "${MODE}" 106.50 1440 1528 1672 1904 900 903 909 934 -hsync +vsync
    xrandr --addmode "${OUTPUT}" "${MODE}"
    xrandr --output "${OUTPUT}" --mode "${MODE}"
fi
