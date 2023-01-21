output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_arn" {
  value = aws_vpc.vpc.arn
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "public_a_az" {
  value = aws_subnet.public_a.id
}

output "public_c_az" {
  value = aws_subnet.public_c.id
}

output "protected_a_az" {
  value = aws_subnet.protected_a.id
}

output "protected_c_az" {
  value = aws_subnet.protected_c.id
}

output "private_a_az" {
  value = aws_subnet.private_a.id
}

output "private_c_az" {
  value = aws_subnet.private_c.id
}

output "http_sg_id" {
  value = module.http_sg.id
}

output "https_sg_id" {
  value = module.https_sg.id
}

output "mysql_sg" {
  value = module.mysql_sg.id
}