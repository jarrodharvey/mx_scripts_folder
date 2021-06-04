#!/bin/bash
. /home/jarrod/.bashrc

# Shut down the computer if Chromium is open!

xwininfo -root -children | grep -q '"Chromium")'

is_chromium_open=$(($? == 0))

if [ $is_chromium_open = 1 ]
then
	poweroff
else
	echo Chromium is not open
fi

echo $is_chromium_open
