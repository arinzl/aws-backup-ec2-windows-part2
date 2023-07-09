
#------------------------------------------------------------------------------
# KMS Key for Backup Vault - Primary location
#------------------------------------------------------------------------------

resource "aws_kms_key" "backup_kms_key" {
  #checkov:skip=CKV_AWS_33: Ensure KMS key policy does not contain wildcard (*) principal 
  description         = "KMS Keys for Backup Encryption"
  is_enabled          = true
  enable_key_rotation = true

  tags = merge(local.tags_generic, local.tag_backup)


  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "primary-region-backup",
    "Statement": [
        {
            "Sid": "Enable IAM User Administration Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow access through Backup for all principals in the account that are authorized to use Backup Storage",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "kms:CreateGrant",
                "kms:Decrypt",
                "kms:GenerateDataKey*"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "backup.ap-southeast-2.amazonaws.com",
                    "kms:CallerAccount": "${data.aws_caller_identity.current.account_id}"
                }
            }
        },
        {
            "Sid": "Allow direct access to key metadata to the account",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": [
                "kms:Describe*",
                "kms:Get*",
                "kms:List*",
                "kms:RevokeGrant"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_kms_alias" "backup_kms_alias" {
  target_key_id = aws_kms_key.backup_kms_key.key_id
  name          = "alias/tutorial-backup-primary-vault-key"
}


#------------------------------------------------------------------------------
# KMS Key for Backup Vault - DR location
#------------------------------------------------------------------------------

resource "aws_kms_key" "backup_dr_kms_key" {
  #checkov:skip=CKV_AWS_33: Ensure KMS key policy does not contain wildcard (*) principal 
  provider = aws.dr-region

  description         = "KMS Keys for DR Backup Vault Encryption"
  is_enabled          = true
  enable_key_rotation = true

  tags = merge(local.tags_generic, local.tag_backup)

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "dr-region-backup",
    "Statement": [
        {
            "Sid": "Enable IAM User Administration Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow access through Backup for all principals in the account that are authorized to use Backup Storage",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "kms:CreateGrant",
                "kms:Decrypt",
                "kms:GenerateDataKey*"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "backup.ap-southeast-2.amazonaws.com",
                    "kms:CallerAccount": "${data.aws_caller_identity.current.account_id}"
                }
            }
        },
        {
            "Sid": "Allow direct access to key metadata to the account",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": [
                "kms:Describe*",
                "kms:Get*",
                "kms:List*",
                "kms:RevokeGrant"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_kms_alias" "backup_dr_kms_alias" {
  provider = aws.dr-region

  target_key_id = aws_kms_key.backup_dr_kms_key.key_id
  name          = "alias/tutorial-backup-dr-vault-key"
}



