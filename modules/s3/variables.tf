locals {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
  region                   = "ap-northeast-1"
  account_id               = ""
  # s3_bucket_name             = ""
  env                 = ""
}

variable "s3_bucket_name" {}
variable "lifecycle_rule_days" {}
variable "life_cycle_rule_name" {}
# variable "s3_bucket_name_id" {}