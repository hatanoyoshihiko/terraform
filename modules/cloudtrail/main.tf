provider "aws" {
  shared_config_files      = local.shared_config_files
  shared_credentials_files = local.shared_credentials_files
  profile                  = local.profile
  region                   = local.region
}

data "aws_caller_identity" "current" {}

# resource "aws_kms_key" "kms_key" {
#   #   deletion_window_in_days = 10
#   description  = ""
#   is_enabled   = true
#   key_usage    = "ENCRYPT_DECRYPT"
#   multi_region = false

#   tags = {
#     Name = local.key_name
#     env  = local.env
#   }
# }

# resource "aws_kms_alias" "kms_key_alias" {
#   name          = "alias/${local.key_name}"
#   target_key_id = aws_kms_key.kms_key.id
# }

module "kms" {
  source = "../kms/"

  kms_key_name = local.kms_key_name
}

module "s3_bucket" {
  source = "../../modules/s3"

  s3_bucket_name = "${local.s3_bucket_name}-${local.account_id}"
}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = local.trail_name
  s3_bucket_name                = "${local.s3_bucket_name}-${local.account_id}"
  s3_key_prefix                 = module.kms.kms_arn
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  enable_logging                = true
  # event_selector {
  #   read_write_type           = ALL
  #   include_management_events = true

  #   # data_resource {
  #   #   type = "AWS::S3::Object"
  #   #   values = ["arn:aws:s3"]
  #   # }
  # }

  tags = {
    "env" = local.env
  }
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = module.s3_bucket.s3_bucket_id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${module.s3_bucket.s3_bucket_arn}"
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudtrail:ap-northeast-1:244573972125:trail/events_hatano_verification"
                }
            }            
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${module.s3_bucket.s3_bucket_arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}