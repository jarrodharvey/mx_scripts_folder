#!/bin/sh
optirun intel-virtual-output
sleep 5
xrandr --output VIRTUAL2 --off --output VIRTUAL1 --primary --mode VIRTUAL1.446-1920x1080 --pos 1984x0 --rotate normal --output DP1 --off --output eDP1 --mode 1920x1080 --pos 0x0 --rotate normal
sleep 5
fluxbox-remote restart; idesktoggle idesk refresh
