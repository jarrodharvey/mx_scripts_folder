#!/bin/bash

ssh -q root@raspbx.local [[ -f /var/spool/asterisk/outgoing/cutoff.call ]] && echo Cutoff tonight is $( date -d @$( ssh root@raspbx.local stat -c %Y /var/spool/asterisk/outgoing/cutoff.call ) '+%r' ) && exit 0

echo What time is your alarm set for tomorrow morning?
echo If you do not have an alarm set for tomorrow, type N

read alarm_time

if [ $alarm_time == "N" ]
then
	seconds_to_remove=$(($RANDOM * 2 / 3))
	cutoff=$(date -d "2:00 AM tomorrow -$seconds_to_remove seconds")
else
	bedtime=$(date -d "$alarm_time tomorrow -8 hours -30 minutes")	
	seconds_to_remove=$(expr $RANDOM / 3)	
	cutoff=$(date -d "$bedtime today -$seconds_to_remove seconds")
fi

# I will want to do SOME work today...
if [ $( date -d "$cutoff" '+%s' ) -lt $( date '+%s' ) ]
then
	cutoff=$(date -d "today + 1 hour")
fi

# The script's directory. cutoff.call (the asterisk callfile) MUST be in the same dir as the script.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Modified time in asterisk is the time that the call gets made
touch -d "$cutoff" $DIR/cutoff.call

scp -pq $DIR/cutoff.call root@raspbx.local:/tmp/cutoff.call
ssh root@raspbx.local "mv /tmp/cutoff.call /var/spool/asterisk/outgoing/"

echo Tonight cutoff is $( date -d "$cutoff" '+%r' ) - an alarm has been set in asterisk to call your phone.
