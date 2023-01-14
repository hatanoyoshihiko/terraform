locals {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
  region                   = "ap-northeast-1"
  account_id               = data.aws_caller_identity.current.account_id
  env                      = ""
}

variable "kms_key_name" {}
variable "policy" {}