#!/bin/bash

echo What time is your alarm set for tomorrow morning?
echo If you do not have an alarm set for tomorrow, type N

read alarm_time

if [ $alarm_time == "N" ]
then
	seconds_to_remove=$RANDOM
	cutoff=$(date -d "2:00 AM tomorrow -$seconds_to_remove seconds" +'%r')
else
	bedtime=$(date -d "$alarm_time tomorrow -8 hours" +'%r')	
	seconds_to_remove=$(expr $RANDOM / 3)	
	cutoff=$(date -d "$bedtime today -$seconds_to_remove seconds" +'%r')
fi

echo Tonight cutoff is $cutoff - set your alarm!
