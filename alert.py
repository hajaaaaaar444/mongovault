import boto3
import sys
import os

# --- CONFIGURATION ---
# PASTE YOUR ARN BELOW inside the quotes!
TOPIC_ARN = "arn:aws:sns:eu-west-3:671005332398:backup-alerts-topic:f6bdeb08-d7c6-4565-b1a8-91413df34ccb"
REGION = "eu-west-3"
# ---------------------

def send_alert(error_message):
    print(f"Attempting to send alert to: {TOPIC_ARN}")
    sns = boto3.client('sns', region_name=REGION)
    
    try:
        response = sns.publish(
            TopicArn=TOPIC_ARN,
            Subject="🚨 FAILURE: MongoDB Backup Crashed",
            Message=f"URGENT: Your MongoDB Backup process failed.\n\nError Details:\n{error_message}"
        )
        print("✅ Alert email sent successfully!")
    except Exception as e:
        print(f"❌ Failed to send alert: {e}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        msg = sys.argv[1]
    else:
        msg = "Unknown error occurred."
    
    send_alert(msg)
