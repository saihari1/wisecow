#!/bin/bash

CPU_THRESHOLD=80       
MEM_THRESHOLD=80        
DISK_THRESHOLD=90      
PROC_THRESHOLD=100      
LOG_FILE="/var/log/system_health.log"  

echo "[$(date)] System Health Check Started" | tee -a "$LOG_FILE"

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2 + $4)}')
if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    echo "[$(date)] ALERT: CPU usage is high: ${CPU_USAGE}%" | tee -a "$LOG_FILE"
fi

USED_MEM=$(free -m | awk '/Mem/ {print $3}')
TOTAL_MEM=$(free -m | awk '/Mem/ {print $2}')
MEM_USAGE=$(( USED_MEM * 100 / TOTAL_MEM ))
if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
    echo "[$(date)] ALERT: Memory usage is high: ${MEM_USAGE}%" | tee -a "$LOG_FILE"
fi

DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo "[$(date)] ALERT: Disk usage is high: ${DISK_USAGE}%" | tee -a "$LOG_FILE"
fi

PROC_COUNT=$(ps -e --no-headers | wc -l)
if [ "$PROC_COUNT" -gt "$PROC_THRESHOLD" ]; then
    echo "[$(date)] ALERT: Number of running processes is high: ${PROC_COUNT}" | tee -a "$LOG_FILE"
fi

echo "[$(date)] System Health Check Completed" | tee -a "$LOG_FILE"

