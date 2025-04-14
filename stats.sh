#!/bin/bash

# Set variables for email
TO_EMAIL="mikecozier@hotmail.com"
SUBJECT="Linux Server System Report"

# Date
DATE=$(date | awk '{print $1 " " $2 $3 " " $7 "," $4 $5}')

# Internet Connection
INTERNET_UP=$(ping -c 4 8.8.8.8 > /dev/null 2>&1 && echo "Available." || echo "No internet connection.")

# Interface Connections
WIFI=$(ip link show | grep "enp3s0" | awk '{print $2 $8":" $9}')
DOCKER=$(ip link show | grep "docker0" | awk '{print $2 $8 ":" $9}' | grep "state:UP")

# Bandwidth
BANDWIDTH=$(ifstat -i enp3s0 1 1)

# Get CPU temperature using sensors
CPU_TEMP=$(sensors | grep 'Package' | awk '{print $4}')
SSD1_TEMP=$(sensors | grep 'Sensor 1' | awk '{print $3}')
SSD2_TEMP=$(sensors | grep 'Sensor 2' | awk '{print $3}')
SYSTEM_TEMP=$(sensors | grep 'temp1' | awk '{print $2}')

#cpu usage
CPU_USAGE=$(top -bn1 | grep "%Cpu(s)" | awk '{print "CPU Usage: " 100 - $8 "%\n"}')

#memory usage
MEM_USAGE=$(free -m | awk 'NR==2{printf "Memory Usage: \nUsed: %dMB / Total: %dMB (%.2f%% used)\n\n", $3, $2, $3/$2*100}')

#disk usage
DISK_USAGE=$(df -h | grep -E '(ubuntu|mirage)' | awk '{print $1 " Total:" $2 " Used:" $3 " Percent:" $5}')

#top 5 cpu processes - I used ps istead of top because of clean formatting and more script freindly.
TOP5_CPU=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6)

#top 5 memory processes - I used ps istead of top because of clean formatting and more script freindly.
TOP5_MEM=$(ps -eo pid,comm,%mem --sort=%mem |head -n 6)

#Server Uptime
SERVER_UPTIME=$(uptime -p)

#load avg
LOAD_AVG=$(uptime | awk -F 'load average:' '{print $2}' | xargs)

# Inodes over 10%
INODE=$(df -i | awk 'NR>1 && $5+0 > 10 {print "Filesystem: "$1"\nInode Usage: "$5"\n-----------------------------------"}')

#Users logged in
USERS=$(who | awk '{print$1 $5}')

#Failed Login
FAILED_LOGINS=$(journalctl -u ssh --since "5 days ago" | grep "Failed" | while read -r line; do
    # Extract username, IP, and any other useful info
    USERNAME=$(echo "$line" | grep -oP 'for \K(\w+)')
    IP_ADDRESS=$(echo "$line" | grep -oP 'from \K(\S+)')
    TIMESTAMP=$(echo "$line" | awk '{print $1, $2, $3}')

# Display the information for each failed login attempt
    echo "Timestamp: $TIMESTAMP"
    echo "Username: $USERNAME"
    echo "IP Address: $IP_ADDRESS"
    echo "................................."
done)

# Compiles all the data into BODY
BODY="=================================\nLive Server Stats Report\n=================================\nGenerated on: $DATE\n=================================\n\nInternet Status: $INTERNET_UP\n\nInterface Status:\n$WIFI\n$DOCKER\n\nBandwidth on main interface:\n$BANDWIDTH\n\nSystem Temp: $SYSTEM_TEMP\nCPU Temperature: $CPU_TEMP\nSSD Temp1: $SSD1_TEMP\nSSD Temp2: $SSD2_TEMP\n\n$CPU_USAGE\n\n$MEM_USAGE\n\nDisk Usage:\n$DISK_USAGE\n\nTop 5 CPU Processes:\n$TOP5_CPU\n\n Top 5 Memory Processes:\n$TOP5_MEM\n\nServer Uptime:\n$SERVER_UPTIME\n\nLoad Average: $LOAD_AVG\n\nInodes over 10%:\n $INODE\n\nLogged in Users: $USERS\n\nFailed Login Attempts:\n$FAILED_LOGINS\n=========================="

# Send the email
echo -e "$BODY" | mutt -F /home/mirage/.muttrc -s "$SUBJECT" -- "$TO_EMAIL"

# End of script
