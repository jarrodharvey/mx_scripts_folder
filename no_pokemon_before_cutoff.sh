#!/bin/bash

# The following should be in the ROOT crontab:
# */5 * * * 0-6 /bin/bash -c /home/jarrod/scripts/no_pokemon_before_cutoff.sh >/dev/null 2>&1

# If chromium is not installed, exit script
if [ $(dpkg-query -W -f='${Status}' chromium 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	echo Chromium not installed, exiting...
	exit 0
fi

# The script's directory
DIR=$( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )

current_unix_epoch_time=$( date '+%s' )

# Get the timestamp from the cutoff.call file in /var/spool/asterisk/outgoing_done/cutoff.call
# Remember that outgoing_done only stores COMPLETED calls (previous cutoffs) and
# it does not store pending calls!!!!
previous_callfile_timestamp=$( date -d @$( ssh root@raspbx.local stat -c %Y /var/spool/asterisk/outgoing_done/cutoff.call ) )

# Want to test with a phony timestamp
# previous_callfile_timestamp=$( date -d "10:23 PM yesterday" )

# To make my code make sense, let's say cutoff was at 1AM and the current time
# is 2AM

# If the timestamp is TODAY and AFTER 6AM then exit the script 
# In our example,
# as the timestamp was at 1AM and it is currently 2AM, do NOT exit the script here
# The reason the script won't exit here is because it is still before 6AM (day_start)
day_start=$( date -d "6:00 AM today" '+%s' )
day_end=$( date -d "11:59 PM today" '+%s'  )
previous_callfile_timestamp_unix_epoch=$( date -d "$previous_callfile_timestamp" '+%s' )
if [[ (  $previous_callfile_timestamp_unix_epoch > $day_start) && ( $previous_callfile_timestamp_unix_epoch < $day_end) ]]; then
	echo Cutoff was $previous_callfile_timestamp and this time is after 6AM today...
	echo You are free! 
	exit 0
fi

# If the timestamp is less than six hours in the past then exit the script
twelve_hours_past_cutoff=$( date -d "$previous_callfile_timestamp + 12 hours" '+%s' ) 
# As our imaginary cutoff was at 1AM, then this means that six_hours_past_cutoff
# is 7AM. 2AM the current time is before 7AM, so the script will cleanly exit here
echo Twelve hours past cutoff: $twelve_hours_past_cutoff
if (( current_unix_epoch_time <= twelve_hours_past_cutoff )); then
	echo Cutoff was $previous_callfile_timestamp and this was less than twelve hours ago
	echo You are free! 
	exit 0
fi

# Need to find out if you got the day off today (day_off_token)
# A day_off_token gives you fifteen hours off
# Let's say token was generated at 4PM
# This means that fifteen_hours_after_token becomes 7AM
tokenvalue=$( cat $DIR/day_off_token.txt )
tokenvalue=$( date -d @"$tokenvalue" )
fifteen_hours_after_token=$( date -d "$tokenvalue + 15 hours" '+%s' )
# So if the current time is 10PM, you will be good still until 7AM
if (( current_unix_epoch_time <= fifteen_hours_after_token  )); then
	echo You have the day off!
	exit 0
fi

# Quit and uninstall chromium
echo Cutoff was $previous_callfile_timestamp which means that todays cutoff has not been reached yet since the script picked up an older one that was not from today
echo Uninstalling chromium...
pkill chromium
sudo apt remove chromium -y
