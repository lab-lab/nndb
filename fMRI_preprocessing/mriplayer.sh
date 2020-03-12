trap "kill 0" SIGINT
#!/bin/sh
#************************************************************************
# Object name: mriplay	 		type: bourne shell               *
# unix file: mriplay                                                    *
# Author: Abbas Heydari			Date: July 2017                 *
# Description: Plays file (video audio) controlled by mri sync          *
#                                                                       *
# Modification log:                                                     *
# Name       yy.mm.dd    ver.   Description                             *
# A.Heydari (55208) 17.7.24     1.00   Created                                 *
#                                                                       *
#************************************************************************

touch /tmp/mriplay.tmp
name=`dmesg | grep 'ttyUSB0' | tail -n 1 | awk '{for (I=1;I<=NF;I++) if ($I == "to") {print $(I+1)};}'`

if [ "$name" = "" ]; then
	echo " "
	echo  "`tput smso` `tput setf 6`"  USB device not connected!!"\
 	`tput rmso``tput setf 0`"
	echo  "\033[33;39m"
	exit 1
fi

stty -F /dev/$name 38400;
(cat /dev/$name > /tmp/mriplay.tmp)&

participant=$(zenity --entry);
testdate=$(zenity --calendar | tr / -);

mkfifo  /tmp/doo
(mplayer -noautosub -nosub -fs -slave -input file=/tmp/doo "$1")& 

# Tells mplayer to read the command from doo
echo "pause" > /tmp/doo

# Gets the duration of the video from an external file and parses to get the full duration in seconds
duration_string=$( head -n 1 duration_file.txt );
hours=$(echo $duration_string | cut -d':' -f 1)
hours=$(( $hours * 3600));
minutes=$(echo $duration_string | cut -d':' -f 2);
minutes=$(( $minutes * 60))
seconds=$(echo $duration_string | cut -d':' -f 3);
seconds=$( printf "%.0f" $seconds );


duration=$(( $hours + $minutes + $seconds));
a=1; b=1; i=1;first=false;ended=false;

while true
do
	tmp1=`md5sum /tmp/mriplay.tmp | awk '{ print $1}'`

	if [ "$tmp0" != "$tmp1" ]; then
		clear
		
		# Triggers to change the state of mplayer
		a=0;
	
		# Tells mplayer  to output current time position in movie
		echo "pausing_keep_force get_time_pos" > /tmp/doo;
				
		# echo 'signal ON';

		# We get the last line where we have the current video position and get only the numbers
		current_time_string=$(tail -n 1 out.txt);
	
		echo $(($(date +'%s%3N')))  "$current_time_string" >> "$testdate"_"$participant"_current_time_real.txt;	

		current_time=$(echo $current_time_string | cut -d'=' -f 2 | xargs printf "%.0f");
		
		# Stores the difference between the length of the video and the current position
		diff=$(($duration - $current_time));
		# echo "$diff"
		
		# Write the time to the txt to show when the movie ended
		if [ "$diff" -lt 1 ] && [ "$ended" = false ]; then
			echo $(($(date +'%s%3N'))) "ended" >> "$testdate"_"$participant".txt;
			ended=true;
		fi

		sleep 0.05
	else
		clear
		a=2;
		# echo $(($(date +'%s%3N'))) "no TTL" >> "$testdate"_"$participant".txt;	
		# echo 'signal OFF';
	fi

	tmp0=$tmp1
	sleep 0.05;

	# Starting to play
	if [ $a = "0" ] && [ $b = "1" ]; then

		# Added this if not to play right at the start of the movie
		if [ "$first" = true ]; then
			sleep 8.0s;
			echo "pause" > /tmp/doo
			echo $(($(date +'%s%3N'))) "start" >> "$testdate"_"$participant".txt;
			b=2;
		else
		# Send the seconds relative to epoch and the last 3 digits are the miliseconds from the last second
			echo $(($(date +'%s%3N'))) > "$testdate"_"$participant".txt;
			first=true;
		fi
	fi

	# The pause
	if [ $a = "2" ] && [ $b = "2" ]; then
		echo "pause" > /tmp/doo
		echo $(($(date +'%s%3N'))) "pause" $i >> "$testdate"_"$participant".txt;
		i=$(($i+1));
		b=1;
	fi

done

rm /tmp/mriplay.tmp
exit 0
