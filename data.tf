data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "backuprestore_passrole_doc" {
  statement {
    sid    = "BackupRestorePermissions1"
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*",
    ]
  }
}

#------------------------------------------------------------------------------
# ========= Part 2 Resources =========
#------------------------------------------------------------------------------

data "aws_ami" "windows-server-2022" {
  most_recent = true
  owners      = ["amazon"]
  name_regex  = "Windows_Server-2022-English-Full-Base*"
}

data "aws_iam_policy_document" "vpc_flow_logging_boundary_role_doc" {
  statement {
    sid    = "ServiceBoundaries"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/vpc-flow-log/${module.tutorial_backup_vpc.vpc_id}:*"]
  }
}



data "aws_iam_policy_document" "ec2_backup_doc" {
  statement {
    sid    = "BackupPermissions1"
    effect = "Allow"
    actions = [
      "ec2:CreateTags"
    ]
    resources = ["arn:aws:ec2:*::snapshot/*",
      "arn:aws:ec2:*::image/*"
    ]
  }

  statement {
    sid    = "BackupPermissions2"
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:CreateSnapshot",
      "ec2:CreateImage",
      "ec2:DescribeImages"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "BackupPermissions3InstallAgent"
    effect = "Allow"
    actions = [
      "ssm:SendCommand"
    ]
    resources = ["arn:aws:ssm:*:*:document/AWS-ConfigureAWSPackage"]
  }

  statement {
    sid    = "BackupPermissions4InstallAgent"
    effect = "Allow"
    actions = [
      "ssm:SendCommand"
    ]
    resources = ["arn:aws:ec2:*:*:instance/*"]
  }

}


