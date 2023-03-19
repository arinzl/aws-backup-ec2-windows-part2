provider "aws" {
  region = var.region

  default_tags {
    tags = local.tags_generic
  }
}


provider "aws" {
  alias  = "dr-region"
  region = var.region_dr


}

