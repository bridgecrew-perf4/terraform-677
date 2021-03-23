
data "aws_iam_policy_document" "ses_bounces_queue_iam_policy" {
  policy_id = "SESBouncesQueueTopic"
  statement {
    sid       = "SESBouncesQueueTopic"
    effect    = "Allow"
    actions   = ["SQS:SendMessage"]
    resources = ["${aws_sqs_queue.ses_bounces_queue.arn}"]
    principals {
      identifiers = ["*"]
      type        = "*"
    }
    condition {
      test     = "ArnEquals"
      values   = ["${aws_sns_topic.ses_bounces_topic.arn}"]
      variable = "aws:SourceArn"
    }
  }
}

resource "aws_sqs_queue_policy" "ses_queue_policy" {
  queue_url = aws_sqs_queue.ses_bounces_queue.id
  policy    = data.aws_iam_policy_document.ses_bounces_queue_iam_policy.json
}
