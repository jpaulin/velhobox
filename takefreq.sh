#!/bin/bash

# Calculate number of occurrences of bruteforce-towards-single-username from log 
#
# Format
#
#     takefreq name
# 

logfile=brute_invalid_users.txt
usern=$1
signtr='Failed password'
echo "Searching log for the username $1"
echo "Below is the number of occurrences for the username:"
grep -i "$signtr" $logfile > intermed.txt
grep $1 ./intermed.txt | wc -l
rm -f intermed.txt
