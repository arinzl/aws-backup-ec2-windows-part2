
#------------------------------------------------------------------------------
# IAM Roles
#------------------------------------------------------------------------------

module "backup_iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 4.5"

  trusted_role_services = [
    "backup.amazonaws.com"
  ]

  role_requires_mfa       = false
  create_role             = true
  create_instance_profile = true

  role_name = "tutorial-aws-backup-role-service"

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup",
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
  ]
}

resource "aws_iam_policy" "backuprestore_passrole_policy" {
  name   = "${var.ec2_app_name}-ec2-restore-passrole-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.backuprestore_passrole_doc.json

}

resource "aws_iam_role_policy_attachment" "backuprestore_passrole_policy_attachement" {
  role       = module.backup_iam_assumable_role.iam_role_name
  policy_arn = aws_iam_policy.backuprestore_passrole_policy.arn
}
