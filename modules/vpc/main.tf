# Module VPC

## Credential information
provider "aws" {
  shared_config_files      = local.shared_config_files
  shared_credentials_files = local.shared_credentials_files
  profile                  = local.profile
  region                   = local.region
  default_tags {
    tags = {
      env = local.env
    }
  }
}

data "aws_caller_identity" "current" {}

## VPC
resource "aws_vpc" "vpc" {
  cidr_block           = local.vpc_cidr
  enable_dns_support   = local.vpc_dns_support
  enable_dns_hostnames = local.vpc_dns_hostname

  tags = {
    Name = local.vpc_name
  }
}

## Internet Gateway
### Internet Gateway for VPC
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = local.ig_name
  }
}

## Subnet for Public Network
### Subnet for public a
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.subnet_public_a_cidr
  map_public_ip_on_launch = true
  availability_zone       = local.subnet_a_az

  tags = {
    Name = local.subnet_public_name_a
  }
}

### Subnet for public c
resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.subnet_public_c_cidr
  map_public_ip_on_launch = true
  availability_zone       = local.subnet_c_az

  tags = {
    Name = local.subnet_public_name_c
  }
}

### Subnet for protected a
resource "aws_subnet" "protected_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.subnet_protected_a_cidr
  availability_zone       = local.subnet_a_az
  map_public_ip_on_launch = false

  tags = {
    Name = local.subnet_protected_name_a
  }
}

### Subnet for protected c
resource "aws_subnet" "protected_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.subnet_protected_c_cidr
  availability_zone       = local.subnet_c_az
  map_public_ip_on_launch = false

  tags = {
    Name = local.subnet_protected_name_c
  }
}

### Subnet for private a
resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.subnet_private_a_cidr
  availability_zone       = local.subnet_a_az
  map_public_ip_on_launch = false

  tags = {
    Name = local.subnet_private_name_a
  }
}

### Subnet for private c
resource "aws_subnet" "private_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.subnet_private_c_cidr
  availability_zone       = local.subnet_c_az
  map_public_ip_on_launch = false

  tags = {
    Name = local.subnet_private_name_c
  }
}

## Route Table
### Route Table for Public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = local.route_table_public_name
  }
}

### Route Table for Protected using a 2 NAT Gateways
resource "aws_route_table" "protected_a" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = local.route_table_protected_name_a
  }
}

resource "aws_route_table" "protected_c" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = local.route_table_protected_name_c
  }
}

### Route Table for Private
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = local.route_table_private_name
  }
}

## Associetion Route Table
### public a 
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

### public c
resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

### protected
resource "aws_route_table_association" "protected_a" {
  subnet_id      = aws_subnet.protected_a.id
  route_table_id = aws_route_table.protected_a.id
}

resource "aws_route_table_association" "protected_c" {
  subnet_id      = aws_subnet.protected_c.id
  route_table_id = aws_route_table.protected_c.id
}

## NAT GW
### EIP for NAT Gateway
resource "aws_eip" "nat_gateway_a" {
  vpc = true
  depends_on = [
    aws_internet_gateway.ig
  ]
  tags = {
    Name = local.nat_gw_name_a
  }
}

resource "aws_eip" "nat_gateway_c" {
  vpc = true
  depends_on = [
    aws_internet_gateway.ig
  ]
  tags = {
    Name = local.nat_gw_name_c
  }
}

### NAT Gateway in AZ a
resource "aws_nat_gateway" "nat_gw_a" {
  allocation_id = aws_eip.nat_gateway_a.id
  subnet_id     = aws_subnet.public_a.id
  depends_on = [
    aws_internet_gateway.ig
  ]
}

###  NAT Gateway in AZ c
resource "aws_nat_gateway" "nat_gw_c" {
  allocation_id = aws_eip.nat_gateway_c.id
  subnet_id     = aws_subnet.public_c.id
  depends_on = [
    aws_internet_gateway.ig
  ]
}

## Routing
### Routing For Public Network
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.ig.id
  destination_cidr_block = "0.0.0.0/0"
}

### Routing For Protected Network using a NAT Gateway
resource "aws_route" "protected_a" {
  route_table_id         = aws_route_table.protected_a.id
  nat_gateway_id         = aws_nat_gateway.nat_gw_a.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "protected_c" {
  route_table_id         = aws_route_table.protected_c.id
  nat_gateway_id         = aws_nat_gateway.nat_gw_c.id
  destination_cidr_block = "0.0.0.0/0"
}

### Routing For Private Network
# Noting to do, only initial route table.

## Security Group

module "http_sg" {
  source                   = "../security_group"
  name                     = "http_sg"
  vpc_id                   = aws_vpc.vpc.id
  ingress_from_port        = 80
  ingress_to_port          = 80
  ingress_protocol         = "tcp"
  ingress_ipv4_cidr_blocks = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = ["::/0"]
  egress_from_port         = 0
  egress_to_port           = 0
  egress_protocol          = "-1"
  egress_ipv4_cidr_blocks  = ["0.0.0.0/0"]
  egress_ipv6_cidr_blocks  = ["::/0"]
}

module "https_sg" {
  source                   = "../security_group"
  name                     = "https_sg"
  vpc_id                   = aws_vpc.vpc.id
  ingress_from_port        = 443
  ingress_to_port          = 443
  ingress_protocol         = "tcp"
  ingress_ipv4_cidr_blocks = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = ["::/0"]
  egress_from_port         = 0
  egress_to_port           = 0
  egress_protocol          = "-1"
  egress_ipv4_cidr_blocks  = ["0.0.0.0/0"]
  egress_ipv6_cidr_blocks  = ["::/0"]
}

module "mysql_sg" {
  source                   = "../security_group"
  name                     = "mysql_sg"
  vpc_id                   = aws_vpc.vpc.id
  ingress_from_port        = 3306
  ingress_to_port          = 3306
  ingress_protocol         = "tcp"
  ingress_ipv4_cidr_blocks = [module.http_sg.security_group_id]
  ingress_ipv6_cidr_blocks = ["::/0"]
  egress_from_port         = 0
  egress_to_port           = 0
  egress_protocol          = "-1"
  egress_ipv4_cidr_blocks  = ["0.0.0.0/0"]
  egress_ipv6_cidr_blocks  = ["::/0"]
}