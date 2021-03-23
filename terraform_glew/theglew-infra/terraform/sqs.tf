resource "aws_sqs_queue" "ses_bounces_queue" {
  name                      = "ses_bounces_queue"
  message_retention_seconds = 1209600
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.ses_dead_letter_queue.arn}\",\"maxReceiveCount\":4}"
}

resource "aws_sqs_queue" "ses_dead_letter_queue" {
  name = "ses_dead_letter_queue"
}
