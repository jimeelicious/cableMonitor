#!/bin/bash
# Motorola SB6141 Modem Cable Signal Monitor v0.1

logfile="/mnt/j4networkshare/NETWORK SHARE/Jimmy/cableSignal.csv"
modem='http://192.168.100.1/cmSignalData.htm'

fileheader() {
/usr/bin/wget --output-document - -T2 --tries=1 -q $modem | /bin/sed '56!d' |
/bin/grep -Eoh '[0-9][0-9]' | ts Ch | sed -e 's/\ //' | /usr/bin/awk -vORS=, '{ print $1 }'|
/usr/bin/ts Date,Time, | /bin/sed -e 's/,$/\n/' -e 's/\ //' >> "$logfile"
}

monitor() {
/usr/bin/wget --output-document - -T2 --tries=1 -q $modem | /bin/sed '60!d' |
/bin/grep -Eoh '[0-9][0-9] dBmV' | /usr/bin/awk -vORS=, '{ print $1 }' | /usr/bin/ts %F,%T,|
/bin/sed -e 's/,$/\n/' -e 's/\ //' >> "$logfile"
}


fileheader
while :
do
 monitor
 sleep 120
done
