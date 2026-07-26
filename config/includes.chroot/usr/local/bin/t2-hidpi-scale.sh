#!/bin/sh
OUTPUT=$(xrandr --current | awk '/ connected/{print $1; exit}')

if [ -n "${OUTPUT}" ]; then
  # I3 desktop resolution is way to large for me, and as I primary run it
  # on Macbook Pro without external screen, I want to scale it to something
  # that is more readable on small screens.
  xrandr --output "${OUTPUT}" --scale 0.5x0.5
fi
