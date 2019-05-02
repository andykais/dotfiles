#!/bin/bash

current_all="$HOME/bin/data/installed_currently.txt"

# Get all currently installed programs
dpkg --get-selections > "$current_all"


output="bigolcommand.txt"
rm "$output"
while IFS= read line 
do
	echo -n "| grep -v $line " >> "$output"

done < "$input"

oldinput="command_that_took_it_all.txt"
oldoutput="leaveout.txt"
rm "$oldoutput"
cat "$oldinput" >> "$oldoutput"
cat "$output" >> "$oldoutput"
