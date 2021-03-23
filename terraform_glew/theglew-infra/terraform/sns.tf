resource "aws_sns_topic" "ses_bounces_topic" {
  name     = "ses_bounces_topic"
}

resource "aws_sns_topic_subscription" "ses_bounces_subscription" {
  topic_arn = aws_sns_topic.ses_bounces_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.ses_bounces_queue.arn
}