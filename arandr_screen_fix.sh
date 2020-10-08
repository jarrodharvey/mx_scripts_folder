#!/bin/sh
xrandr --output VIRTUAL2 --off --output VIRTUAL1 --mode VIRTUAL1.446-1920x1080 --pos 1984x0 --rotate normal --output DP1 --off --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
sleep 3
killall wmalauncher 
arandr
flatpak run com.getferdi.Ferdi
firefox --new-window https://app.simplenote.com/
firefox --new-window https://to-do.office.com/tasks/
echo Run the script "arrange" to clean everything up
