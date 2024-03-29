
#------------------------------------------------------------------------------
# Security Groups - SSM
#------------------------------------------------------------------------------
module "https_443_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/https-443"
  version = "4.16.2"
  # Ignoring Checkov secret_name false positive detection
  #checkov:skip=CKV2_AWS_5: "Ensure that Security Groups are attached to another resource"

  name        = "https-443-sg"
  description = "Allow https 443"
  vpc_id      = module.tutorial_backup_vpc.vpc_id

  # Allow ingress rules to be accessed only within current VPC
  ingress_cidr_blocks = [module.tutorial_backup_vpc.vpc_cidr_block]

  # Allow all rules for all protocols
  egress_rules = ["https-443-tcp"]

  tags = local.tags_generic
}

#------------------------------------------------------------------------------
# Restrict default VPC Security Group - Check: CKV2_AWS_12
#------------------------------------------------------------------------------

resource "aws_default_security_group" "default" {
  depends_on = [module.tutorial_backup_vpc]

  vpc_id = module.tutorial_backup_vpc.vpc_id

  ingress = []
  egress  = []

}


module "tutorial_server_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${var.environment}-${var.ec2_app_name}-sg"
  description = "Security group for ${var.environment} ${var.ec2_app_name} Server"
  vpc_id      = module.tutorial_backup_vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      description = "RDP accdess of VPC"
      cidr_blocks = var.vpc_cidr_range
    },

  ]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["https-443-tcp", "http-80-tcp"]


  egress_with_cidr_blocks = [
    {
      rule        = "all-tcp"
      cidr_blocks = var.vpc_cidr_range
      description = "VPC Access"
    },
  ]

  tags = merge(local.tags_generic)
}

#------------------------------------------------------------------------------
# DR Security Groups
#------------------------------------------------------------------------------

module "https_443_security_group_dr" {
  source  = "terraform-aws-modules/security-group/aws//modules/https-443"
  version = "4.16.2"

  providers = {
    aws = aws.dr-region
  }


  # Ignoring Checkov secret_name false positive detection
  #checkov:skip=CKV2_AWS_5: "Ensure that Security Groups are attached to another resource"

  name        = "https-443-sg-dr"
  description = "Allow https 443"
  vpc_id      = module.tutorial_backup_dr_vpc.vpc_id

  # Allow ingress rules to be accessed only within current VPC
  ingress_cidr_blocks = [module.tutorial_backup_vpc.vpc_cidr_block]

  # Allow all rules for all protocols
  egress_rules = ["https-443-tcp"]

  tags = local.tags_generic
}





resource "aws_default_security_group" "default_dr" {
  depends_on = [module.tutorial_backup_dr_vpc]
  provider   = aws.dr-region

  vpc_id = module.tutorial_backup_dr_vpc.vpc_id

  ingress = []
  egress  = []

}
