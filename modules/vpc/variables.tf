locals {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
  region                   = "ap-northeast-1"
  account_id               = data.aws_caller_identity.current.account_id

  # Names
  vpc_name                     = "VPC01"
  ig_name                      = "IG01"
  nat_gw_name_a                = "ng01"
  nat_gw_name_c                = "ng02"
  subnet_public_name_a         = "public_subnet_a"
  subnet_public_name_c         = "public_subnet_c"
  subnet_protected_name_a      = "protected_subnet_a"
  subnet_protected_name_c      = "protected_subnet_c"
  subnet_private_name_a        = "private_subnet_a"
  subnet_private_name_c        = "private_subnet_c"
  route_table_public_name      = "public_route_table"
  route_table_protected_name_a = "protected_route_table_a"
  route_table_protected_name_c = "protected_route_table_c"
  route_table_private_name     = "private_route_table"

  vpc_cidr                = "172.16.0.0/16"
  vpc_dns_support         = true
  vpc_dns_hostname        = true
  subnet_public_a_cidr    = "172.16.0.0/24"
  subnet_public_c_cidr    = "172.16.1.0/24"
  subnet_protected_a_cidr = "172.16.2.0/24"
  subnet_protected_c_cidr = "172.16.3.0/24"
  subnet_private_a_cidr   = "172.16.4.0/24"
  subnet_private_c_cidr   = "172.16.5.0/24"
  subnet_a_az             = "ap-northeast-1a"
  subnet_c_az             = "ap-northeast-1c"
  route_table_public      = "puclic"
  route_table_protected   = "protected"
  route_table_private     = "private"
  env                     = "dev"
}