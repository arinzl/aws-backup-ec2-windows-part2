#-------------------------------------------------------------------
# Tutorial Backup Server Configuration
#-------------------------------------------------------------------
module "tutorial_backup_server01" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.5.0"

  #checkov:skip=CKV_AWS_8: "Ensure all data stored in the Launch configuration or instance Elastic Blocks Store is securely encrypted"
  #checkov:skip=CKV_AWS_126: "Ensure that detailed Backup is enabled for EC2 instances"
  #checkov:skip=CKV_AWS_79: "Ensure Instance Metadata Service Version 1 is not enabled"


  name = "${var.ec2_app_name}-${var.environment}-01"

  ami                         = data.aws_ami.windows-server-2022.id
  instance_type               = "t3.medium"
  subnet_id                   = module.tutorial_backup_vpc.private_subnets[0]
  availability_zone           = module.tutorial_backup_vpc.azs[0]
  associate_public_ip_address = false
  vpc_security_group_ids      = [module.tutorial_server_sg.security_group_id]
  iam_instance_profile        = module.tutorial_backup_ec2_assumable_role.iam_instance_profile_id
  user_data_base64            = base64encode(local.user_data_prod)

  disable_api_termination = false




  enable_volume_tags = false
  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = 80
      encrypted   = true
      kms_key_id  = aws_kms_key.tutorial_backup_ec2_kms_key.arn

      tags = {
        Name = "Tutorial-Backup-C-Drive"
      }
    },
  ]

  tags = merge(local.tags_generic, local.tags_ec2)

}

resource "aws_ebs_volume" "tutorial_backup_d_drive" {

  size              = 30
  type              = "gp3"
  availability_zone = module.tutorial_backup_vpc.azs[0]
  encrypted         = true
  kms_key_id        = aws_kms_key.tutorial_backup_ec2_kms_key.arn

  tags = {
    Name = "tutorial-backup-D-Drive"
  }

}

resource "aws_volume_attachment" "tutorial_backup_d_drive_attachment" {

  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.tutorial_backup_d_drive.id
  instance_id = module.tutorial_backup_server01.id

}
