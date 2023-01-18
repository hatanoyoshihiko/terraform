locals {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
  region                   = "ap-northeast-1"
  account_id               = data.aws_caller_identity.current.account_id

  # Names
}

variable "name" {}
variable "vpc_id" {}
variable "port" {}
variable "cidr_blocks" {
  type = list(string)
}