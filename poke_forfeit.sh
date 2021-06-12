windowid=$(xdotool getwindowfocus)
sleep 0.5 && xdotool windowactivate --sync $windowid type '/forfeit'
sleep 0.5 && xdotool windowactivate --sync $windowid key Return
