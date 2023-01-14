# Define Providers
terraform {
  required_version = "~>0.14.7"
  backend "s3" {
    key = "components/database/terraform.tfstate"
    region = var.region
  }

  },
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  profile = var.provider_profile
  region  = var.provider_region
}

# place tfstate backend

# Common Valiables
module "common" {
  source = "../common/variables/"
}

# VPC
module "module_vpc" {
  for_each = var.
  source = "./modules/vpc/"
  public_subnets = var.vpc_subnet
}
