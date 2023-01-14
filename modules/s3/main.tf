provider "aws" {
  shared_config_files      = local.shared_config_files
  shared_credentials_files = local.shared_credentials_files
  profile                  = local.profile
  region                   = local.region
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "cloud_trail_bucket" {
  bucket = "${local.s3_bucket_name_cloud_trail}-${local.account_id}"

  tags = {
    Name = "${local.s3_bucket_name_cloud_trail}-${local.account_id}"
    env  = local.env
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloud_trail_bucket" {
  bucket = aws_s3_bucket.cloud_trail_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cloud_trail_bucket" {
  bucket                  = aws_s3_bucket.cloud_trail_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "cloud_trail_bucket" {
  bucket = aws_s3_bucket.cloud_trail_bucket.id
  rule {
    id = "life_cycle_365days"
    expiration {
      days = local.lifecycle_rule_days
    }
    # noncurrent_version_expiration {
    #   noncurrent_days = local.lifecycle_rule_days
    # }
    status = "Enabled"
  }
}
