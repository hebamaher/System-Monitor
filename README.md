# System-Monitor
Requirements:
1. Check Disk Usage:
• Report the percentage of disk space used for each mounted partition.
• Warn if usage exceeds a specified threshold (e.g., 80%).
2. Check CPU Usage:
• Display the current CPU usage as a percentage.
3. Check Memory Usage:
• Show total, used, and free memory.
4. Check Running Processes:
• Display the top 5 memory-consuming processes.
5. Generate a Report:
• Save the collected information into a log file (e.g., system_monitor.log).
6. Enhancements:
• Allow the user to pass optional arguments, such as:
• -t to specify the disk usage warning threshold.
• -f to set the output file name.
 HEAD

run by command ./monitor.sh then 
to see the report file by command cat system_monitor.log 
![image](https://github.com/user-attachments/assets/daf4f30b-8527-47c3-8ea0-b09eb2c60809)
the emai sent in case of exceeding threshold
![image](https://github.com/user-attachments/assets/8dafff78-f9ab-40bd-8c19-46daa3ec5e55)

 6adc2a7 (Update README.md)

