xwininfo -root -children | grep -q '"Firefox")'

is_firefox_open=$(($? == 0))

echo $is_firefox_open
