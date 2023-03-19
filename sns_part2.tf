
#------------------------------------------------------------------------------
# SNS
#------------------------------------------------------------------------------

resource "aws_sns_topic" "backup_sns_topic" {
  name = "backup-alerts"
}

resource "aws_sns_topic_policy" "sns_backup_policy" {
  arn    = aws_sns_topic.backup_sns_topic.arn
  policy = data.aws_iam_policy_document.backup_sns_topic_policy.json
}


data "aws_iam_policy_document" "backup_sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.backup_sns_topic.arn]
  }
}
