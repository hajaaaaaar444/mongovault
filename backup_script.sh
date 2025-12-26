#!/bin/bash

# --- CONFIGURATION ---
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
BACKUP_NAME="backup-$(date +%F-%H%M).gz"
BUCKET_NAME="mongodb-backup-bucket"
R2_ENDPOINT="https://73207ffe52633eda4f9d15dd9f00753a.r2.cloudflarestorage.com"
LOG_FILE="/home/ubuntu/backup_metrics.json"

# --- EXECUTION ---
START_TIME=$(date +%s)
echo "Starting Backup Job at $TIMESTAMP"

# ---------------------------------------------------------
# PHASE 1: SMART RETRY BACKUP (The "Resilient" Part)
# ---------------------------------------------------------
MAX_RETRIES=3
RETRY_COUNT=0
DUMP_SUCCESS=false

# Try to dump database 3 times before giving up
while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    echo "Attempting Database Dump ($((RETRY_COUNT+1))/$MAX_RETRIES)..."
    
    # Run the dump
    mongodump --archive=$BACKUP_NAME --gzip
    
    # Check if it worked (Exit code 0 = Success)
    if [ $? -eq 0 ]; then
        echo " Dump Successful!"
        DUMP_SUCCESS=true
        break
    else
        echo " Dump failed. Waiting 5 seconds before retrying..."
        sleep 5
        RETRY_COUNT=$((RETRY_COUNT+1))
    fi
done

# ---------------------------------------------------------
# PHASE 2: UPLOAD (Only if Phase 1 worked)
# ---------------------------------------------------------
UPLOAD_STATUS=1 # Default to failure

if [ "$DUMP_SUCCESS" = true ]; then
    echo "2. Uploading to Cloudflare R2..."
    aws s3 cp $BACKUP_NAME s3://$BUCKET_NAME/ --endpoint-url $R2_ENDPOINT
    UPLOAD_STATUS=$?
else
    echo " Skipping Upload because Dump failed."
    # TRIGGER THE ALERT HERE
    python3 alert.py "CRITICAL: Backup failed after $MAX_RETRIES attempts. Check MongoDB container."
fi

# ---------------------------------------------------------
# PHASE 3: METRICS & LOGGING (Observability)
# ---------------------------------------------------------
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

# Check file size (0 if file doesn't exist)
if [ -f "$BACKUP_NAME" ]; then
    FILE_SIZE=$(stat -c%s "$BACKUP_NAME")
else
    FILE_SIZE=0
fi

# Determine Final Status for Dashboard
if [ "$DUMP_SUCCESS" = true ] && [ $UPLOAD_STATUS -eq 0 ]; then
    FINAL_STATUS="Success"
else
    FINAL_STATUS="Failed"
    # If upload specifically failed, send an alert for that too
    if [ "$DUMP_SUCCESS" = true ]; then
         python3 alert.py "Backup succeeded, but S3 Upload failed. Check network/keys."
    fi
fi

# Save to JSON for your Dashboard
echo "{\"timestamp\": \"$TIMESTAMP\", \"status\": \"$FINAL_STATUS\", \"size_bytes\": $FILE_SIZE, \"duration_seconds\": $DURATION}" >> $LOG_FILE

# Cleanup local file
rm -f $BACKUP_NAME

echo "Job finished. Final Status: $FINAL_STATUS"
