#
terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.50.0"
    }
  }  
  # backend "s3" {
  #   bucket = null
  #   key    = null
  #   region = null
  #   encrypt = true
  # }
}

provider "aws" {
  shared_config_files      = local.shared_config_files
  shared_credentials_files = local.shared_credentials_files
  profile                  = local.profile
  region                   = local.region
  default_tags {
    tags = {
      env = local.env
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}