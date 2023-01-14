locals {
  shared_config_files        = ["~/.aws/config"]
  shared_credentials_files   = ["~/.aws/credentials"]
  profile                    = "default"
  region                     = "ap-northeast-1"
  s3_bucket_name_cloud_trail = "aws-cloudtrail-logs"
  account_id                 = data.aws_caller_identity.current.account_id
  lifecycle_rule_days        = 365
  env                        = "dev"
}