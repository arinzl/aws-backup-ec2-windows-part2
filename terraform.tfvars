region            = "ap-southeast-2"
environment       = "prod"
ManagedByLocation = "https://github.com"

backup-dr-vault-name = "tutorial-backup-vault-dr"
dr-region            = "ap-southeast-1"

vpc_cidr_range       = "172.17.0.0/20"
private_subnets_list = ["172.17.0.0/24"]
public_subnets_list  = ["172.17.3.0/24"]

ec2_app_name = "tutorial-backup"

region_dr               = "ap-southeast-1"
vpc_cidr_range_dr       = "172.17.16.0/20"
private_subnets_dr_list = ["172.17.16.0/24"]
public_subnets_dr_list  = ["172.17.19.0/24"]
