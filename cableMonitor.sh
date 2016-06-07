#!/bin/bash

# Motorola SB6141 Modem Cable Signal Monitor v0.2
# by jimeelicious

# Set locations of downstream (ds) and upstream (us) logs
ds_log="/mnt/j4networkshare/NETWORK SHARE/Jimmy/cableSignal_ds.csv"
us_log="/mnt/j4networkshare/NETWORK SHARE/Jimmy/cableSignal_us.csv"
modem='http://192.168.100.1/cmSignalData.htm'	# Modem Signal page
sec=120	# Sleep for x seconds between readings


header_ds() {
/usr/bin/wget --output-document - -T2 --tries=1 -q $modem | /bin/sed '33!d' |
/bin/grep -Eoh '[0-9]+' | sed -e 's/\ //' | /usr/bin/awk -vORS=, '{ print $1 }'|
/usr/bin/ts Frequency\(Hz\),, | /bin/sed -e 's/,$/\n/' -e 's/\ //' >> "$ds_log"

/usr/bin/wget --output-document - -T2 --tries=1 -q $modem | /bin/sed '32!d' |
/bin/grep -Eoh '[0-9]+' | ts Ch | sed -e 's/\ //' | /usr/bin/awk -vORS=, '{ print $1 }'|
/usr/bin/ts Date,Time, | /bin/sed -e 's/,$/\n/' -e 's/\ //' >> "$ds_log"
}

monitor_ds() {
/usr/bin/wget --output-document - -T2 --tries=1 -q $modem |
 /bin/sed -n 36,43p | /bin/grep -Eoh '[0-9]+ dBmV' |
 /usr/bin/awk -vORS=, '{ print $1 }'|
 /usr/bin/ts %F,%T,| /bin/sed -e 's/,$/\n/' -e 's/\ //' >> "$ds_log"
}

header_us() {
/usr/bin/wget --output-document - -T2 --tries=1 -q $modem | /bin/sed '56!d' |
/bin/grep -Eoh '[0-9][0-9]' | ts Ch | sed -e 's/\ //' | /usr/bin/awk -vORS=, '{ print $1 }'|
/usr/bin/ts Date,Time, | /bin/sed -e 's/,$/\n/' -e 's/\ //' >> "$us_log"
}

monitor_us() {
/usr/bin/wget --output-document - -T2 --tries=1 -q $modem | /bin/sed '60!d' |
/bin/grep -Eoh '[0-9][0-9] dBmV' | /usr/bin/awk -vORS=, '{ print $1 }' | /usr/bin/ts %F,%T,|
/bin/sed -e 's/,$/\n/' -e 's/\ //' >> "$us_log"
}



header_ds; header_us

while :
do
 monitor_ds; monitor_us
 sleep $sec
done
