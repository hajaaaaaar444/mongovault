import boto3
import sys
import os

# --- CONFIGURATION ---
TOPIC_ARN = "arn:aws:sns:eu-west-3:671005332398:backup-alerts-topic"
REGION = "eu-west-3"
# ---------------------

def send_alert(message_body, subject_line):
    print(f"Attempting to send alert to: {TOPIC_ARN}")
    sns = boto3.client('sns', region_name=REGION)

    try:
        response = sns.publish(
            TopicArn=TOPIC_ARN,
            Subject=subject_line,
            Message=message_body
        )
        print(" Alert email sent successfully!")
    except Exception as e:
        print(f" Failed to send alert: {e}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        input_msg = sys.argv[1]
    else:
        input_msg = "Unknown status."

    # SMART LOGIC: specific subject based on the message content
    if "success" in input_msg.lower():
        subject = " MongoDB Backup Success"
        body = f"Great news! Your backup process completed successfully.\n\nDetails: {input_msg}"
    else:
        subject = " MongoDB Backup FAILURE"
        body = f"URGENT: Your MongoDB Backup process failed.\n\nError Details:\n{input_msg}"

    send_alert(body, subject)
