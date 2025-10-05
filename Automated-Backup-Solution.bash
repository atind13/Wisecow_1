#!/bin/bash

# =========================

# Configuration

# =========================

SOURCE_DIR="/path/to/source"          # Directory to back up
REMOTE_USER="username"                # Remote server username
REMOTE_HOST="[remote.server.com](http://remote.server.com/)"       # Remote server IP or hostname
REMOTE_DIR="/path/to/backup"          # Destination directory on remote server
LOG_FILE="/var/log/backup_report.log" # Backup log file

# Date for reporting

DATE=$(date +"%Y-%m-%d %H:%M:%S")

# =========================

# Function to log messages

# =========================

log_message() {
echo "[$DATE] $1" | tee -a "$LOG_FILE"
}

# =========================

# Start Backup

# =========================

log_message "Backup started."

# Perform the backup using rsync over SSH

rsync -avz --delete "$SOURCE_DIR/" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR" &>/tmp/rsync_output.log

# Check if rsync succeeded

if [ $? -eq 0 ]; then
log_message "Backup completed successfully."
else
log_message "Backup failed. Check details below:"
cat /tmp/rsync_output.log | tee -a "$LOG_FILE"
fi

# =========================

# Cleanup

# =========================

rm -f /tmp/rsync_output.log