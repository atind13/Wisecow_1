#!/bin/bash

# ----------------------------

# System Health Monitoring Script

# ----------------------------

# Thresholds

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=90
PROCESS_THRESHOLD=300

# Log file

LOG_FILE="$HOME/system_health.log"  # Easier access in home directory

# Function to log messages

log_message() {
local message="$1"
echo "$(date '+%Y-%m-%d %H:%M:%S') $message" | tee -a "$LOG_FILE"
}

# 1. Check CPU usage

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{usage=100-$8} END {print usage}')
CPU_USAGE_INT=${CPU_USAGE%.*}
if [ "$CPU_USAGE_INT" -gt "$CPU_THRESHOLD" ]; then
log_message "ALERT: CPU usage is high: ${CPU_USAGE}%"
else
log_message "CPU usage: ${CPU_USAGE}%"
fi

# 2. Check Memory usage

MEMORY_USAGE=$(free | awk '/Mem:/ {print $3/$2 * 100.0}')
MEMORY_USAGE_INT=${MEMORY_USAGE%.*}
if [ "$MEMORY_USAGE_INT" -gt "$MEMORY_THRESHOLD" ]; then
log_message "ALERT: Memory usage is high: ${MEMORY_USAGE}%"
else
log_message "Memory usage: ${MEMORY_USAGE}%"
fi

# 3. Check Disk usage

DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
log_message "ALERT: Disk usage is high: ${DISK_USAGE}%"
else
log_message "Disk usage: ${DISK_USAGE}%"
fi

# 4. Check number of running processes

PROCESS_COUNT=$(ps aux | wc -l)
if [ "$PROCESS_COUNT" -gt "$PROCESS_THRESHOLD" ]; then
log_message "ALERT: Number of processes is high: ${PROCESS_COUNT}"
else
log_message "Number of processes: ${PROCESS_COUNT}"
fi