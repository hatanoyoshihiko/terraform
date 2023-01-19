locals {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
  region                   = "ap-northeast-1"
  account_id               = data.aws_caller_identity.current.account_id

  # Names
}

variable "name" {}
variable "vpc_id" {}
variable "ingress_from_port" {}
variable "ingress_to_port" {}
variable "ingress_protocol" {}
variable "ingress_ipv4_cidr_blocks" {
  type = list(string)
}
variable "ingress_ipv6_cidr_blocks" {
  type = list(string)
}
variable "ingress_security_groups" {
  default = null
}
variable "egress_from_port" {}
variable "egress_to_port" {}
variable "egress_protocol" {}
variable "egress_ipv4_cidr_blocks" {
  type = list(string)
}
variable "egress_ipv6_cidr_blocks" {
  type = list(string)
}
variable "egress_security_groups" {
  default = null
}