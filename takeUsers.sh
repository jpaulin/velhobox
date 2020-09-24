#!/bin/bash

# Script that extracts from a access.log
# the usernames that were attempted on logon, which were
# not found on the system (from which log was acquired)


function banner() {
  echo "Produced by takeUsers v0.1"
}


# ======================================================
# Log Filename
# ======================================================
#
# Override with cmd parm if such is given
#
fn=brute_invalid_users.txt

echo no. lines to be processed from log is
#
wc -l $fn
#

rm -f ./only_invalids.txt
# Take the lines that have to do with brute force attacks against users
grep 'invalid user' ./brute_invalid_users.txt > only_invalids.txt

if [ -f only_invalids.txt ]; then 
    echo "Success parsed first phase!"
else 
    echo "Could not parse first phase, ie the file only_invalids.txt not created..."
    exit 0
fi

echo "=== Phase 2 begins ==="
rm -f ./only_passwordInvalids.txt
# Next we take from the user name -conserning lines only those that actually
# tried using a password to brute in.

grep -i 'failed password' ./only_invalids.txt > only_passwordInvalids.txt

if [ -f ./only_passwordInvalids.txt ]; then 
    echo "Success 2nd phase: now have only lines with user and password"
else
    echo "Could not parse 2nd phase, ie the final data file finalnames.txt is NOT created..."
    exit 0
fi

echo "Now AWKing"
#
# Log format is assumed here to be so that 11th word is username
awk '{print $11;}' ./only_passwordInvalids.txt > usernames.txt

#
# Purify the names by sorting, and then using 'uniq' Linux command
cat usernames.txt | sort > sortedusernames.txt
rm usernames.txt
cat sortedusernames.txt | uniq > finalnames.txt
rm sortedusernames.txt

echo "Now you have file finalnames.txt"
echo "This file contains just the unique usernames that were used in brute forcing"
banner
