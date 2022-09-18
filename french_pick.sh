windowid=$(xdotool getwindowfocus)
sleep 0.5 && xdotool windowactivate --sync $windowid type '/pickrandom Suicune, Kangaskhan, Weavile'
sleep 0.5 && xdotool windowactivate --sync $windowid key Return
