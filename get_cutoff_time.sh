#!/bin/bash

echo What time is your alarm set for tomorrow morning?
echo If you do not have an alarm set for tomorrow, type N

read alarm_time

if [ $alarm_time == "N" ]
then
	seconds_to_remove=$(($RANDOM * 2 / 3))
	cutoff=$(date -d "2:00 AM tomorrow -$seconds_to_remove seconds" +'%r')
else
	bedtime=$(date -d "$alarm_time tomorrow -8 hours" +'%r')	
	seconds_to_remove=$(expr $RANDOM / 3)	
	cutoff=$(date -d "$bedtime today -$seconds_to_remove seconds" +'%r')
fi

if [ $( date -d "$cutoff" '+%s' ) -lt $( date '+%s' ) ]
then
	cutoff=$(date -d "today + 1 hour" +'%r')
	echo Set your alarm for the cutoff time of $cutoff
else
	echo Tonight cutoff is $cutoff - set your alarm!
fi
