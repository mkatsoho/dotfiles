#!/bin/sh

## NOTE: run this once before changing diaplays

## add a new mode, which support 21:9 resolution
xrandr --newmode "2560x1080_60.00"  230.76  2560 2728 3000 3440  1080 1081 1084 1118  -HSync +Vsync

## map the new mode to a display port/device
xrandr --addmode HDMI-2 "2560x1080_60.00"

