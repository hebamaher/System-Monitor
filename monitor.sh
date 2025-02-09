#!/bin/bash

THRESHOLD=70

REPORT="system_monitor.log"

email="hebamaher25@gmail.com"
echo "System Resource Report - $(date)" > "$REPORT"
echo "----------------------------------" >> "$REPORT"

echo "Checking Disk Usage.." >> "$REPORT"

check_disk_usage() {
    disk_usage=$(df -h / | awk 'NR==1 {print $1, $2, $3} NR==2 {print "", $1, $2, $3}' )
    echo " $disk_usage%" >> "$REPORT"

    disk_usage_percentage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    
    if [ "$disk_usage_percentage" -gt "$THRESHOLD" ]; then
        msg="Warning: Disk usage is at $disk_usage_percentage% (threshold is $THRESHOLD%)"
	echo "$msg" >> "$REPORT"
	echo "$msg" | mail -s "System Monitoring" "$email"
    fi
}

while getopts "t:f:" opt; do
    case $opt in
        t) THRESHOLD=$OPTARG ;;
        f) REPORT=$OPTARG ;;
        *) echo "Usage: $0 [-t THRESHOLD] [-f REPORT]" ;;
    esac
done

check_disk_usage

echo "----------------------------------" >> "$REPORT"

cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
echo "Current CPU Usage: $cpu_usage%" >> "$REPORT"

echo "-----------------------------------" >> "$REPORT"

memory_usage=$(free -h | awk 'NR==1 {print "Memory:\n", $1, $2, $3} NR==2 {print "", $2, $3, $4}')
echo -e "$memory_usage" >> "$REPORT"


echo "-----------------------------------" >> "$REPORT"

echo "Top 5 Memory-Consuming Processes:" >> "$REPORT"
echo "PID USER %MEM COMMAND" >> "$REPORT"
processes=$(ps aux --sort=-%mem | awk 'NR<=6 {printf "%-6s %-10s %-5s %s\n", $2, $1, $4, $11}')
echo "$processes" >> "$REPORT"

echo "Report saved to $REPORT"
