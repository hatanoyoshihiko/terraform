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