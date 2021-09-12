#!/bin/sh

xrandr --newmode "2560x1080_60.00"  230.76  2560 2728 3000 3440  1080 1081 1084 1118  -HSync +Vsync

xrandr --addmode HDMI-2 "2560x1080_60.00"

# xrandr --output eDP-1 --off --output DP-1 --off --output HDMI-1 --off --output HDMI-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal

#xrandr --output eDP-1 --off --output DP-1 --off --output HDMI-1 --off --output HDMI-2 --primary --mode  "2560x1080_60.00" --pos 0x0 --rotate normal



