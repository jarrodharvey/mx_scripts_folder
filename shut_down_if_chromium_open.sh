#!/bin/bash
. /home/jarrod/.bashrc

# Shut down the computer if Chromium is open!
# This can only be run from the user crontab because root cannot access display
# The command in cron will need to be prefixed with display information eg DISPLAY:=0
# You will need to set up passwordless shutdown since non-root users cannot use
# poweroff by default

xwininfo -root -children | grep -q '"Chromium")'

is_chromium_open=$(($? == 0))

if [ $is_chromium_open = 1 ]
then
	sudo poweroff
else
	echo Chromium is not open
fi

echo $is_chromium_open
