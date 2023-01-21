# Module KMS

resource "aws_kms_key" "kms_key" {
  #   deletion_window_in_days = 10
  description  = ""
  is_enabled   = true
  key_usage    = "ENCRYPT_DECRYPT"
  multi_region = false
  policy       = var.policy

  tags = {
    Name = var.kms_key_name
  }
}

resource "aws_kms_alias" "kms_key_alias" {
  name          = var.kms_key_name
  target_key_id = aws_kms_key.kms_key.id
}