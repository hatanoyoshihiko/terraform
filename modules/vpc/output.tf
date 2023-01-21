output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_arn" {
  value = aws_vpc.vpc.arn
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
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