# Common variables

terraform {
  required_version = "~> 1.3.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.40.0"
    }
    region = "var.env.region"
    alias  = "var.env.aws_alias"
  }
  backend "s3" {
    bucket = "var.env.tfstate.bucket"
    key    = "var.env.tfstate.s3_key"
    region = "var.env.region"
  }
}

provider "aws" {
  region = var.region
}

resource_tags = {
  project     = "dev-project"
  environment = "dev"
  owner       = "myname@exaple.com"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-northeast-1"
}
