#!/bin/bash

# If a cutoff.call file exists in outgoing, identify the timestamp
if ssh -q root@raspbx.local [[ -f "/var/spool/asterisk/outgoing/cutoff.call" ]]; then
	last_cutoff_timestamp=$( date -d @$( ssh root@raspbx.local stat -c %Y /var/spool/asterisk/outgoing/cutoff.call ) '+%s' )
	# If the last cutoff was before 6AM today, AND the current time is AFTER 6AM today...
	if [[ $last_cutoff_timestamp -lt $( date -d "6AM today" '+%s' ) && $(date '+%s') -gt $( date -d "6AM today" '+%s' ) ]]; then
		echo Cleaning detritus... please re-run script when done.
		ssh root@raspbx.local "mv /var/spool/asterisk/outgoing/cutoff.call /var/spool/asterisk/outgoing_done.call" 
		exit 0
	fi 
fi

# Check if a cutoff.call file already exists in outgoing, if so read the cutoff time and exit the script
ssh -q root@raspbx.local [[ -f /var/spool/asterisk/outgoing/cutoff.call ]] && echo Cutoff tonight is $( date -d @$( ssh root@raspbx.local stat -c %Y /var/spool/asterisk/outgoing/cutoff.call ) '+%r' ) && ssh root@raspbx.local "cat meds_reminder.txt" && exit 0

# The script's directory. cutoff.call, the asterisk callfile, MUST be in the same dir as the script.
DIR=$( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )

echo What are your current energy levels?
echo This covers both your emotional AND physical energy.
echo If you have been drinking socially then pick 2
echo 1: I am exhausted and could not possibly do more work tonight!
echo 2: I have less energy than normal.
echo 3: I feel normal.
echo 4: I have more energy than normal.

read energy_level

if [ $energy_level = 1 ]
then
	echo Whoa! You get the rest of the night off!
	echo BUUUUUUT since you are really that tired - no Pokemon! Anything else but that.
	exit 0
fi

if [ $energy_level = 2 ]
then
	# 1 in 5 chance of having the day/night off to chill
	day_off_chance=26213	
fi

if [ $energy_level = 3 ]
then
	# 1 in 10 chance of having the day/night off to chill
	day_off_chance=29490	
fi

if [ $energy_level = 4 ]
then
	# 1 in 15 chance of having the day/night off to chill
	day_off_chance=30582
fi

# Variable chance of getting the day/night off to chill
# Likelihood depends on energy levels
if [ $RANDOM -gt $day_off_chance ]
then
	echo Make a plan to catch up with friends/family at some point in the future.
	echo Once thats done, take the rest of the day/night off - no cutoff tonight.
	# Evidence that I ran this today
	echo $( date "+%s" $date ) > $DIR/day_off_token.txt
	exit 0
fi

echo What time is your alarm set for tomorrow morning?
echo If you do not have an alarm set for tomorrow, type N

read alarm_time

if [ $alarm_time == "N" ]
then
	seconds_to_remove=$(($RANDOM * 2 / $energy_level))
	cutoff=$(date -d "10:00 PM today + $energy_level hours -$seconds_to_remove seconds")
else
	let bedtime_modifier="($energy_level - 2) * 30" 
	bedtime=$(date -d "$alarm_time tomorrow -9 hours + $bedtime_modifier minutes")	
	seconds_to_remove=$(expr $RANDOM / $energy_level)	
	cutoff=$(date -d "$bedtime today -$seconds_to_remove seconds")
fi

# What is or is not a late night will vary depending on whether
# I am going in to the office tomorrow and this is determined
# by what time cutoff was last night
echo Are you going in to the office tomorrow?
echo Enter Y or N 

read going_in_to_office 

if [ $going_in_to_office == "N" ]
then
	late_night="11:00 PM"
else
	late_night="9:30 PM"
fi

# If yesterday's cutoff was a late night, subtract one hour from tonight's to give yourself a break
if [[ $( date -d @$( ssh root@raspbx.local stat -c %Y /var/spool/asterisk/outgoing_done/cutoff.call ) '+%s' ) -gt $( date -d "$late_night yesterday" '+%s' ) ]] 
then
	cutoff=$( date -d "$cutoff - 1 hour" )
fi

echo Did you take your ADHD meds today?
echo Enter Y or N

read took_adhd_meds

if [ $took_adhd_meds == "Y" ]
then
	meds_message[0]='Due to your meds giving you extra energy, cutoff has been set at bedtime.'
	meds_message[1]='Due to your meds giving you extra energy, rewards will be replaced with one episode of Red vs Blue: https://anneapocalypse.tumblr.com/rvborder'
	
	random_choice=$[ $RANDOM % 2 ]
	meds_boosted_action=${meds_message[$random_choice]}	
else
	meds_boosted_action='You did not take meds today, so all rewards remain standard with a non-bedtime cutoff.'
fi

if [[ "$meds_boosted_action" == *"cutoff has been set at bedtime"* ]]; then
	cutoff=$bedtime
fi

# I will want to do SOME work today...
if [ $( date -d "$cutoff" '+%s' ) -lt $( date '+%s' ) ]
then
	let minutes_to_work="$energy_level * 25"
	# I am going REALLY easy on myself if I am going in to the office
	# tomorrow and subtracting 30 minutes from cutoff potentially
	if [ $going_in_to_office == "Y" ]
	then
		let minutes_to_work="$minutes_to_work - 30"
	fi
	cutoff=$(date -d "today + $minutes_to_work minutes")
fi


# Modified time in asterisk is the time that the call gets made
touch -d "$cutoff" $DIR/cutoff.call

scp -pq $DIR/cutoff.call root@raspbx.local:/tmp/cutoff.call
ssh root@raspbx.local "mv /tmp/cutoff.call /var/spool/asterisk/outgoing/"

echo Tonight cutoff is $( date -d "$cutoff" '+%r' ) - you will receive a phone call at this time to remind you.
echo $meds_boosted_action
ssh root@raspbx.local "echo $meds_boosted_action > meds_reminder.txt"
