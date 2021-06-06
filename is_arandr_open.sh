#!/bin/bash
. /home/jarrod/.bashrc

# Shut down the computer if Chromium is open!

xwininfo -root -children | grep -q '"Arandr")'

is_arandr_open=$(($? == 0))

if [ $is_arandr_open = 1 ]
then
	echo arandr is open
else
	echo arandr is not open
fi
