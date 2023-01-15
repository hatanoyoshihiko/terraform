locals {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
  region                   = "ap-northeast-1"
  trail_name               = "trails"
  s3_bucket_name           = "aws-cloudtrail-logs"
  account_id               = data.aws_caller_identity.current.account_id
  lifecycle_rule_days      = 365
  life_cycle_rule_name     = "life_cycle_365days"
  kms_key_name             = "alias/cloudtrail"
  env                      = "dev"
}