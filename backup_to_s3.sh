#!/bin/bash

# === Configuration ===
SOURCE_DIR="/etc/letsencrypt/live/harinadh.xyz"   # Directory to back up
BUCKET_NAME="skillzverse-main"                   # S3 bucket name
LOG_FILE="/var/log/incremental_backup.log"       # Log file for reports

# === Step 1: Perform Incremental Sync to S3 ===
echo "[$(date)] Starting incremental backup..." >> "$LOG_FILE"

aws s3 sync "$SOURCE_DIR" "s3://$BUCKET_NAME/harinadh-backups/" \
    --exact-timestamps --delete

if [ $? -eq 0 ]; then
  echo "[$(date)]  Incremental backup successful!" >> "$LOG_FILE" 
else
  echo "[$(date)]  Incremental backup failed." >> "$LOG_FILE" 
  exit 1
fi

