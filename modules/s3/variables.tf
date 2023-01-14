locals {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
  region                   = "ap-northeast-1"
  account_id               = ""
  # s3_bucket_name             = ""
  lifecycle_rule_days = 365
  env                 = ""
}

variable "s3_bucket_name" {}
# variable "s3_bucket_name_id" {}