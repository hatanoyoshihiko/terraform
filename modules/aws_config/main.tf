provider "aws" {
  shared_config_files      = local.shared_config_files
  shared_credentials_files = local.shared_credentials_files
  profile                  = local.profile
  region                   = local.region
}

data "aws_caller_identity" "current" {}

module "s3_bucket" {
  source = "../../modules/s3"

  s3_bucket_name       = "${local.s3_bucket_name}-${local.account_id}"
  lifecycle_rule_days  = local.lifecycle_rule_days
  life_cycle_rule_name = local.life_cycle_rule_name
}

resource "aws_s3_bucket_policy" "aws_confg" {
  bucket = module.s3_bucket.s3_bucket_id
  policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AWSConfigBucketPermissionsCheck",
                "Effect": "Allow",
                "Principal": {
                    "Service": "config.amazonaws.com"
                },
                "Action": "s3:GetBucketAcl",
                "Resource": "arn:aws:s3:::${local.s3_bucket_name}-${local.account_id}",
                "Condition": {
                    "StringEquals": {
                        "AWS:SourceAccount": "${local.account_id}"
                    }
                }
            },
            {
                "Sid": "AWSConfigBucketExistenceCheck",
                "Effect": "Allow",
                "Principal": {
                    "Service": "config.amazonaws.com"
                },
                "Action": "s3:ListBucket",
                "Resource": "arn:aws:s3:::${local.s3_bucket_name}-${local.account_id}",
                "Condition": {
                    "StringEquals": {
                        "AWS:SourceAccount": "${local.account_id}"
                    }
                }
            },
            {
                "Sid": "AWSConfigBucketDelivery",
                "Effect": "Allow",
                "Principal": {
                    "Service": "config.amazonaws.com"
                },
                "Action": "s3:PutObject",
                "Resource": "arn:aws:s3:::${local.s3_bucket_name}-${local.account_id}/AWSLogs/${local.account_id}/Config/*",
                "Condition": {
                    "StringEquals": {
                        "s3:x-amz-acl": "bucket-owner-full-control",
                        "AWS:SourceAccount": "${local.account_id}"
                    }
                }
            }
        ]
    }
  EOF
}

resource "aws_config_configuration_recorder_status" "aws_config" {
  name       = local.config_name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.aws_config]
}

resource "aws_config_delivery_channel" "aws_config" {
  name           = local.config_name
  s3_bucket_name = module.s3_bucket.s3_bucket_id
}

resource "aws_iam_role" "aws_confg" {
  name = local.role_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "aws_confg" {
  name = local.policy_name
  role = aws_iam_role.aws_confg.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${module.s3_bucket.s3_bucket_arn}",
        "${module.s3_bucket.s3_bucket_arn}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "aws_confg" {
  role       = aws_iam_role.aws_confg.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_config_configuration_recorder" "aws_confg" {
  name     = local.config_name
  role_arn = aws_iam_role.aws_confg.arn
  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}