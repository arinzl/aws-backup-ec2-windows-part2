terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      version = ">= 3.74.0"
      source  = "hashicorp/aws"
    }
  }
}
