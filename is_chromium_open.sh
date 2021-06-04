xwininfo -root -children | grep -q '"Chromium")'

is_chromium_open=$(($? == 0))

echo $is_chromium_open
