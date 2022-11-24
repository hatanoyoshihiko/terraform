# provider variables

env      = "dev"
vpc_name = "vpc-dev"
vpc_cidr = "10.0.0.0/16"
subet_public_a = {
  cidr              = "10.0.0.0/24"
  availability_zone = "ap-northeast-a"
}
subet_public_c = {
  cidr              = "10.0.1.0/24"
  availability_zone = "ap-northeast-c"
}
subet_protected_a = {
  cidr              = "10.0.2.0/24"
  availability_zone = "ap-northeast-a"
}
subet_protected_c = {
  cidr              = "10.0.3.0/24"
  availability_zone = "ap-northeast-c"
}
subet_private_a = {
  cidr              = "10.0.4.0/24"
  availability_zone = "ap-northeast-a"
}
subet_private_c = {
  cidr              = "10.0.5.0/24"
  availability_zone = "ap-northeast-c"
}


variable "vpc_name" {
  type = list(string)
  default = [
    "prd",
    "stg",
    "dev"
  ]
}

variable "vpc_subnet" {
  description = ""
  type        = list(string)
  default = [
    "172.31.30.0/24",
    "172.31.31.0/24"
  ]
}
