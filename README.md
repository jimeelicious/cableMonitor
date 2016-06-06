# cableMonitor
Monitors signal levels of the Motorola SB6141 Modem and logs it to a CSV file for plotting

Requires moreutils installed. Install by
  sudo apt-get install moreutils


# Running

1) Edit the shell script ("cableMonitor.sh") in the editor of choice and set your desired
logfile destination

2) Run the script by entering the directory and typing "./cableMonitor.sh &> /dev/null &"


# Stopping

The process can be stopped by entering "top" and finding the process and killing it.
