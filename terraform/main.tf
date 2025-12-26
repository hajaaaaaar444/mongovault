provider "aws" {
  region = "eu-west-3"
}

# 1. Create the Notification System
resource "aws_sns_topic" "backup_alerts" {
  name = "backup-alerts-topic"
}

# 2. Add your Email to the list
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.backup_alerts.arn
  protocol  = "email"
  endpoint  = "ezzahraouihajar123@gmail.com"
}

# 3. Show us the ID (ARN) at the end
output "sns_topic_arn" {
  value = aws_sns_topic.backup_alerts.arn
}
