#!/bin/sh
# Set capslock to escape
setxkbmap -option caps:escape
xrandr --output VIRTUAL2 --off --output VIRTUAL1 --mode VIRTUAL1.446-1920x1080 --pos 1984x0 --rotate normal --output DP1 --off --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
sleep 3
killall wmalauncher 
echo fix arandr primary monitor and close arandr to continue
arandr
fluxbox-remote restart
nohup flatpak run com.getferdi.Ferdi > /dev/null 2>&1 &
nohup firefox --new-window https://to-do.office.com/tasks/ > /dev/null 2>&1 &
nohup firefox --new-window https://app.simplenote.com/ > /dev/null 2>&1 &
sleep 10
nohup devilspie2 --folder ~/scripts/arrange_windows/ > /dev/null 2>&1 &
sleep 20
pkill devilspie2
# rm /home/jarrod/.config/mps-youtube/cache_py_3.7.3 
# nohup mpsyt /rain sounds, shuffle, 1- > /dev/null 2>&1 &

