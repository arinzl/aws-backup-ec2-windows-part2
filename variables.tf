
#------------------------------------------------------------------------------
# General
#------------------------------------------------------------------------------
variable "region" {
  description = "Primary region for deployment"
  type        = string
}

variable "environment" {
  description = "Organisation environment"
  type        = string
}

variable "ManagedByLocation" {
  description = "Location of Infrastructure of Code"
  type        = string
}

#------------------------------------------------------------------------------
# Backup Vault - DR
#------------------------------------------------------------------------------

variable "backup-dr-vault-name" {
  description = "DR vault name"
  type        = string
}

variable "dr-region" {
  description = "DR region name"
  type        = string
}

#------------------------------------------------------------------------------
# VPC
#------------------------------------------------------------------------------

variable "vpc_cidr_range" {
  type = string

}

variable "private_subnets_list" {
  description = "Private subnet list for infrastructure"
  type        = list(string)

}

variable "public_subnets_list" {
  description = "Public subnet list for infrastructure"
  type        = list(string)

}

variable "region_dr" {
  description = "DR region for deployment"
  type        = string
}

variable "vpc_cidr_range_dr" {
  type = string

}


variable "private_subnets_dr_list" {
  description = "Private subnet list for DR infrastructure"
  type        = list(string)

}

variable "public_subnets_dr_list" {
  description = "Private subnet list for DR infrastructure"
  type        = list(string)

}

#------------------------------------------------------------------------------
# EC2
#------------------------------------------------------------------------------

variable "ec2_app_name" {
  description = "Application running on EC2 instance"
  type        = string

}
