#!/bin/bash

# --- CONFIGURATION ---
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
BACKUP_NAME="backup-$(date +%F-%H%M).gz"
BUCKET_NAME="mongodb-backup-bucket"
R2_ENDPOINT="https://73207ffe52633eda4f9d15dd9f00753a.r2.cloudflarestorage.com"
# THIS IS THE KEY PART: The file where we save the data
LOG_FILE="/home/ubuntu/backup_metrics.json"

# --- EXECUTION ---
START_TIME=$(date +%s)

echo "1. Dumping Database..."
mongodump --archive=$BACKUP_NAME --gzip
DUMP_STATUS=$?

echo "2. Uploading to Cloudflare..."
aws s3 cp $BACKUP_NAME s3://$BUCKET_NAME/ --endpoint-url $R2_ENDPOINT
UPLOAD_STATUS=$?

# --- CALCULATE METRICS ---
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

if [ -f "$BACKUP_NAME" ]; then
    FILE_SIZE=$(stat -c%s "$BACKUP_NAME")
else
    FILE_SIZE=0
fi

# Determine Status
if [ $DUMP_STATUS -eq 0 ] && [ $UPLOAD_STATUS -eq 0 ]; then
    FINAL_STATUS="Success"
else
    FINAL_STATUS="Failed"
fi

# --- SAVE DATA TO JSON FILE ---
echo "{\"timestamp\": \"$TIMESTAMP\", \"status\": \"$FINAL_STATUS\", \"size_bytes\": $FILE_SIZE, \"duration_seconds\": $DURATION, \"filename\": \"$BACKUP_NAME\"}" >> $LOG_FILE

# Cleanup
rm -f $BACKUP_NAME

echo "Job finished. Status: $FINAL_STATUS"
echo "Starting backup..."

# Try to backup. If it fails (||), run the alert script and stop.
mongodump --uri="$MONGO_URI" --archive="$BACKUP_FILE" --gzip || {
    echo " Backup failed! Sending alert..."
    python3 alert.py "Mongodump command failed. "
    exit 1
}
