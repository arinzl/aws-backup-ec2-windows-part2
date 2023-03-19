
#------------------------------------------------------------------------------
# IAM Roles
#------------------------------------------------------------------------------

resource "aws_iam_policy" "vpc_flow_logging_boundary_role_policy" {
  name   = "vpc-flow-logging-boundary-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.vpc_flow_logging_boundary_role_doc.json

}


resource "random_id" "random_id" {
  byte_length = 5

}


module "tutorial_backup_ec2_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.9.0"

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]

  role_requires_mfa       = false
  create_role             = true
  create_instance_profile = true

  role_name = "${var.ec2_app_name}-ec2-assumable-role-${random_id.random_id.hex}"

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",

  ]

}




resource "aws_iam_policy" "ec2_backup_policy" {
  name   = "${var.ec2_app_name}-ec2-backup-install-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.ec2_backup_doc.json

}

resource "aws_iam_role_policy_attachment" "ec2_backup_policy_attachement" {
  role       = module.tutorial_backup_ec2_assumable_role.iam_role_name
  policy_arn = aws_iam_policy.ec2_backup_policy.arn
}
