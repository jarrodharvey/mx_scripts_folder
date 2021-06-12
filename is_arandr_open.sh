#!/bin/bash
. /home/jarrod/.bashrc

# Display a message if arandr is open!
# This exists for testing to figure out why
# crontab won't work properly

echo The script can do this at least right?

# Getting warmer! Cron cannot find xwininfo
echo $( xwininfo -root -children )

xwininfo -root -children | grep -q '"Arandr")'

is_arandr_open=$(($? == 0))

if [ $is_arandr_open = 1 ]
then
	sudo shutdown now
else
	echo arandr is not open 
fi
