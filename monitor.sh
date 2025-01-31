#!/bin/bash

THRESHOLD=80

REPORT="system_monitor.log"

email="hebamaher25@gmail.com"
echo "System Resource Report - $(date)" > "$REPORT"
echo "----------------------------------" >> "$REPORT"

echo "Checking Disk Usage.." >> "$REPORT"

check_disk_usage() {
    disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    
    if [ "$disk_usage" -gt "$THRESHOLD" ]; then
        echo "Warning: Disk usage is at $disk_usage% (threshold is $THRESHOLD%)" >> "$REPORT"
	echo "Warning: Disk usage is at $disk_usage% (threshold is $THRESHOLD%)" | mail -s "Disk Alert" "$email"
    else
        echo "Disk usage is under control: $disk_usage%" >> "$REPORT"
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

while read -r usage partition; do
	usage=${usage%\%}

	echo "Partition: $partition Usage: $usage%" >> "$REPORT"

	if [ "$usage" -ge "$THRESHOLD" ]; then
		echo "WARNING: Partition $partition is above ${THRESHOLD}% usage!" >> "$REPORT"
	fi
done < <(df -h | awk 'NR>1 {print $5, $6}')

echo "----------------------------------" >> "$REPORT"

cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
echo "Current CPU Usage: $cpu_usage%" >> "$REPORT"

echo "-----------------------------------" >> "$REPORT"

memory_usage=$(free -h)
echo "Memory usage: $memory_usage" >> "$REPORT"

echo "-----------------------------------" >> "$REPORT"

processes=$(ps aux --sort=-%mem | head -n 6)
echo "Memory Consuming Processes: $processes" >> "$REPORT"

echo "Report saved to $REPORT"
