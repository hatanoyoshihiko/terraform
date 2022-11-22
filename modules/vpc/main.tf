# Module VPC

## Create VPC
resource "aws_vpc" "example" {
  cidr_block           = "var.vpc.cidr"
  enable_dns_support   = "var.vpc.dns_support"
  enable_dns_hostnames = "var.vpc.dns_hostname"

  tags = {
    Name = "var.vpc.env"
  }
}

## Subnet for Public Network
### Create Subnet for public a
resource "aws_subnet" "public_a" {
  vpc_id                 = aws_vpc.example.id
  cidr_block             = "var.vpc.subnet.public_a.cidr"
  map_public_ip_on_launc = true
  availability_zone      = "ap-northeast-1a"
}

### Create Subnet for public c
resource "aws_subnet" "public_c" {
  vpc_id                 = aws_vpc.example.id
  cidr_block             = "var.vpc.subnet.public_c.cidr"
  map_public_ip_on_launc = true
  availability_zone      = "ap-northeast-1c"
}

## Internet Gateway
### Create Internet Gateway for VPC
resource "aws_internet_gateway" "example" {
  vpc_id = "aws_vpc.exapmple.id"

}

## Route Table for Public Network
### Create Route Table for Public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
}

### Create Routing For Public Network
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

### Associetion Route Table for public subnets
resource "aws_route_table_association" "public" {
  subnet_id = [
    aws_subnet.public_a.id,
    aws_subnet.public_c.id
  ]
  route_table_id = aws_route.public.id
}

## Subnet for Protected Network
### Create Subnet for protected a
resource "aws_subnet" "protected_a" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "var.vpc.subnet.protected_a.cidr"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
}

### Create Subnet for protected c
resource "aws_subnet" "protected_c" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "var.vpc.subnet.protected_c.cidr"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
}

### Create Route Table for Protected Network
resource "aws_route_table" "protected" {
  vpc_id = aws_vpc.example.id
}

#### Case of separate routing a and c, using a 2 NAT Gateways
# resource "aws_route_table" "protected_a" {
#   vpc_id = aws_vpc.example.id
# }

# resource "aws_route_table" "protected_c" {
#   vpc_id = aws_vpc.example.id
# }

### Associetion Route Table for public subnets
resource "aws_route_table_association" "protected" {
  subnet_id = [
    aws_vpc_subnet.protected_a.id,
    aws_vpc_subnet.protected_c.id
  ]
  route_table_id = aws_route_table.protected.id
}

### Create EIP for NAT Gateway
resource "aws_eip" "nat_gateway_a" {
  vpc = true
  depends_on = [
    aws_internet_gateway.example
  ]
}

# resource "aws_eip" "nat_gateway_c" {
#   vpc = true
#   depends_on = [
#     aws_internet_gateway.example
#   ]
# }

### Create NAT Gateway in AZ a
resource "aws_nat_gateway" "example_a" {
  allocation_id = aws_eip.nat_gateway_a.id
  subnet_id     = aws_subnet.public_a.id
  depends_on = [
    aws_internet_gateway.example
  ]
}

####  Create NAT Gateway in AZ c
# resource "aws_nat_gateway" "example_c" {
#   allocation_id = aws_eip.nat_gateway_c.id
#   subnet_id     = aws_subnet.public_c.id
#   depends_on = [
#     aws_internet_gateway.example
#   ]
# }

### Create Routing For Protected Network using a NAT Gateway
resource "aws_route" "protected" {
  route_table_id         = aws_route_table.protected.id
  nat_gateway_id         = aws_nat_gateway.example_a.id
  destination_cidr_block = "0.0.0.0/0"
}

#### Case of separate route table a and c
# resource "aws_route" "protected_a" {
#   route_table_id         = aws_route_table.protected_a.id
#   nat_gateway_id         = aws_nat_gateway.example_a.id
#   destination_cidr_block = "0.0.0.0/0"
# }

# resource "aws_route" "protected_c" {
#   route_table_id         = aws_route_table.protected_c.id
#   nat_gateway_id         = aws_nat_gateway.example_c.id
#   destination_cidr_block = "0.0.0.0/0"
# }
