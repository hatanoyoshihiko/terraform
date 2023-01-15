locals {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
  region                   = "ap-northeast-1"
  s3_bucket_name           = "aws-config-logs"
  account_id               = data.aws_caller_identity.current.account_id
  config_name              = "aws_config"
  role_name                = "AWS_ConfigRole"
  policy_name              = "AWSConfigS3FullAccess"
  lifecycle_rule_days      = 2557
  life_cycle_rule_name     = "life_cycle_2557days"
  env                      = "dev"
}