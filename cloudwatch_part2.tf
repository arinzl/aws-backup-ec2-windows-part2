#------------------------------------------------------------------------------
# Cloudwatch Events
#------------------------------------------------------------------------------
resource "aws_cloudwatch_event_rule" "backup_completed_event_rule" {
  name        = "backup-event-backup-job-completed"
  description = "Completed backup events - testing only otherwise too much noise"

  event_pattern = <<PATTERN
{
  "source": ["aws.backup"],
  "detail-type": ["Backup Job State Change"],
  "detail": {
    "state": ["COMPLETED"]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "sns_backup_completed" {
  rule = aws_cloudwatch_event_rule.backup_completed_event_rule.name
  arn  = aws_sns_topic.backup_sns_topic.arn
}

resource "aws_cloudwatch_event_rule" "backup_failed_event_rule" {
  name        = "backup-event-backup-job-failed"
  description = "failed backup events"

  event_pattern = <<PATTERN
{
  "source": ["aws.backup"],
  "detail-type": ["Backup Job State Change"],
  "detail": {
    "state": ["FAILED"]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "sns_backup_failed" {
  rule = aws_cloudwatch_event_rule.backup_failed_event_rule.name
  arn  = aws_sns_topic.backup_sns_topic.arn
}

resource "aws_cloudwatch_event_rule" "restored_completed_event_rule" {
  name        = "backup-event-restor-completed"
  description = "Restore completed event"

  event_pattern = <<PATTERN
{
  "source": ["aws.backup"],
  "detail-type": ["Restore Job State Change"],
  "detail": {
    "state": ["COMPLETED"]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "sns_restore_completed" {
  rule = aws_cloudwatch_event_rule.restored_completed_event_rule.name
  arn  = aws_sns_topic.backup_sns_topic.arn
}
