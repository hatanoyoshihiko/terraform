provider "aws" {
  shared_config_files      = local.shared_config_files
  shared_credentials_files = local.shared_credentials_files
  profile                  = local.profile
  region                   = local.region
}

data "aws_caller_identity" "current" {}

module "kms" {
  source = "../kms/"

  kms_key_name = local.kms_key_name
  policy = <<EOF
    {
        "Version": "2012-10-17",
        "Id": "Key policy created by CloudTrail",
        "Statement": [
            {
                "Sid": "Enable IAM User Permissions",
                "Effect": "Allow",
                "Principal": {
                    "AWS": [
                        "arn:aws:iam::${local.account_id }:root",
                        "arn:aws:iam::${local.account_id }:user/administrator"
                    ]
                },
                "Action": "kms:*",
                "Resource": "*"
            },
            {
                "Sid": "Allow CloudTrail to encrypt logs",
                "Effect": "Allow",
                "Principal": {
                    "Service": "cloudtrail.amazonaws.com"
                },
                "Action": "kms:GenerateDataKey*",
                "Resource": "*",
                "Condition": {
                    "StringEquals": {
                        "AWS:SourceArn": "arn:aws:cloudtrail:${local.region}:${local.account_id }:trail/${local.trail_name}"
                    },
                    "StringLike": {
                        "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${local.account_id }:trail/*"
                    }
                }
            },
            {
                "Sid": "Allow CloudTrail to describe key",
                "Effect": "Allow",
                "Principal": {
                    "Service": "cloudtrail.amazonaws.com"
                },
                "Action": "kms:DescribeKey",
                "Resource": "*"
            },
            {
                "Sid": "Allow principals in the account to decrypt log files",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "*"
                },
                "Action": [
                    "kms:Decrypt",
                    "kms:ReEncryptFrom"
                ],
                "Resource": "*",
                "Condition": {
                    "StringEquals": {
                        "kms:CallerAccount": "${local.account_id }"
                    },
                    "StringLike": {
                        "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${local.account_id }:trail/*"
                    }
                }
            },
            {
                "Sid": "Allow alias creation during setup",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "*"
                },
                "Action": "kms:CreateAlias",
                "Resource": "*",
                "Condition": {
                    "StringEquals": {
                        "kms:CallerAccount": "${local.account_id }",
                        "kms:ViaService": "ec2.${local.region}.amazonaws.com"
                    }
                }
            },
            {
                "Sid": "Enable cross account log decryption",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "*"
                },
                "Action": [
                    "kms:Decrypt",
                    "kms:ReEncryptFrom"
                ],
                "Resource": "*",
                "Condition": {
                    "StringEquals": {
                        "kms:CallerAccount": "${local.account_id }"
                    },
                    "StringLike": {
                        "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${local.account_id }:trail/*"
                    }
                }
            }
        ]
    }  
   EOF
}

module "s3_bucket" {
  source = "../../modules/s3"

  s3_bucket_name = "${local.s3_bucket_name}-${local.account_id}"
  lifecycle_rule_days = local.lifecycle_rule_days
  life_cycle_rule_name = local.life_cycle_rule_name
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = module.s3_bucket.s3_bucket_id
  policy = <<EOF
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
                "Resource": "arn:aws:s3:::${local.s3_bucket_name}-${local.account_id}",
                "Condition": {
                    "StringEquals": {
                        "AWS:SourceArn": "arn:aws:cloudtrail:${local.region}:${local.account_id}:trail/${local.trail_name}"
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
                "Resource": "arn:aws:s3:::${local.s3_bucket_name}-${local.account_id}/AWSLogs/${local.account_id}/*",
                "Condition": {
                    "StringEquals": {
                        "AWS:SourceArn": "arn:aws:cloudtrail:${local.region}:${local.account_id}:trail/${local.trail_name}",
                        "s3:x-amz-acl": "bucket-owner-full-control"
                    }
                }
            }
        ]
    }
  EOF
}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = local.trail_name
  s3_bucket_name                = "${local.s3_bucket_name}-${local.account_id}"
  s3_key_prefix                 = ""
  kms_key_id                    = module.kms.key_arn
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  enable_logging                = true

  tags = {
    "env" = local.env
  }
}