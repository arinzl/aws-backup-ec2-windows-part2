#------------------------------------------------------------------------------
# Backup Vault - Primary region
#------------------------------------------------------------------------------

resource "aws_backup_vault" "backup_vault" {
  name        = "tutorial-backup-vault"
  kms_key_arn = aws_kms_key.backup_kms_key.arn

}

#------------------------------------------------------------------------------
# Backup Plans - VSS enabled
#------------------------------------------------------------------------------

resource "aws_backup_plan" "tier2-vss" {
  depends_on = [aws_backup_vault.backup_vault_dr]
  name       = "tier2-vss"

  rule {
    rule_name         = "daily-vss"
    target_vault_name = aws_backup_vault.backup_vault.id
    schedule          = "cron(0 14 * * ? *)"
    start_window      = "60"
    completion_window = "600"

    lifecycle {
      delete_after = 32
    }
    recovery_point_tags = {
      tier = "2VSS"
      rule = "daily-vss"
    }
  }

  rule {
    rule_name         = "weekly-vss"
    target_vault_name = aws_backup_vault.backup_vault.id
    schedule          = "cron(0 15 ? * SAT *)"
    start_window      = "60"
    completion_window = "600"

    lifecycle {
      delete_after = 57
    }
    recovery_point_tags = {
      tier = "2VSS"
      rule = "weekly-vss"
    }

    copy_action {
      lifecycle {
        delete_after = 8
      }
      destination_vault_arn = "arn:aws:backup:${var.dr-region}:${data.aws_caller_identity.current.account_id}:backup-vault:${aws_backup_vault.backup_vault_dr.id}"
    }
  }

  rule {
    rule_name         = "monthly-vss"
    target_vault_name = aws_backup_vault.backup_vault.id
    schedule          = "cron(0 16 3 * ? *)"
    start_window      = "60"
    completion_window = "600"

    lifecycle {
      delete_after = 365
    }
    recovery_point_tags = {
      tier = "2VSS"
      rule = "monthly-vss"
    }
  }

  rule {
    rule_name         = "quarterly-vss"
    target_vault_name = aws_backup_vault.backup_vault.id
    schedule          = "cron(0 17 3 JAN,APR,JUL,OCT ? *)"
    start_window      = "60"
    completion_window = "600"

    lifecycle {
      delete_after = 2555
    }
    recovery_point_tags = {
      tier = "2"
      rule = "quarterly-vss"
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }
}


resource "aws_backup_plan" "tier3-vss" {
  name = "tier3-vss"

  rule {
    rule_name         = "daily-vss"
    target_vault_name = aws_backup_vault.backup_vault.id
    schedule          = "cron(0 14 * * ? *)"
    start_window      = "60"
    completion_window = "600"

    lifecycle {
      delete_after = 8
    }
    recovery_point_tags = {
      tier = "3VSS"
      rule = "daily-vss"
    }
  }

  rule {
    rule_name         = "weekly-vss"
    target_vault_name = aws_backup_vault.backup_vault.id
    schedule          = "cron(0 15 ? * SAT *)"
    start_window      = "60"
    completion_window = "600"

    lifecycle {
      delete_after = 32
    }
    recovery_point_tags = {
      tier = "3VSS"
      rule = "weekly-vss"
    }
  }

  rule {
    rule_name         = "monthly-vss"
    target_vault_name = aws_backup_vault.backup_vault.id
    schedule          = "cron(0 16 3 * ? *)"
    start_window      = "60"
    completion_window = "600"

    lifecycle {
      delete_after = 93
    }
    recovery_point_tags = {
      tier = "3VSS"
      rule = "monthly-vss"
    }
  }

  rule {
    rule_name         = "quarterly-vss"
    target_vault_name = aws_backup_vault.backup_vault.id
    schedule          = "cron(0 17 3 JAN,APR,JUL,OCT ? *)"
    start_window      = "60"
    completion_window = "600"

    lifecycle {
      delete_after = 365
    }
    recovery_point_tags = {
      tier = "3VSS"
      rule = "quarterly-vss"
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }
}


#------------------------------------------------------------------------------
# Backup Selection - VSS
#------------------------------------------------------------------------------

resource "aws_backup_selection" "tier2-vss" {
  iam_role_arn = module.backup_iam_assumable_role.iam_role_arn
  name         = "tier2-vss-selection"
  plan_id      = aws_backup_plan.tier2-vss.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backuptier"
    value = "2VSS"
  }

}

resource "aws_backup_selection" "tier3-vss" {
  iam_role_arn = module.backup_iam_assumable_role.iam_role_arn
  name         = "tier3-vss-selection"
  plan_id      = aws_backup_plan.tier3-vss.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backuptier"
    value = "3VSS"
  }

}

#------------------------------------------------------------------------------
# DR Region Resources
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Backup Vault - DR Region
#------------------------------------------------------------------------------
resource "aws_backup_vault" "backup_vault_dr" {
  provider = aws.dr-region

  name        = "tutorial-backup-vault-dr"
  kms_key_arn = aws_kms_key.backup_dr_kms_key.arn

}
