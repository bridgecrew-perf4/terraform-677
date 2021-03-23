resource "aws_ses_identity_notification_topic" "ses_bounces" {
  topic_arn                = aws_sns_topic.ses_bounces_topic.arn
  notification_type        = "Bounce"
  identity                 = var.email_domain
  include_original_headers = true
}