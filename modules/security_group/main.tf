# Module Security Group

## Security Group
resource "aws_security_group" "default" {
  name   = var.name
  vpc_id = var.vpc_id

  ingress {
    from_port        = var.ingress_from_port
    to_port          = var.ingress_to_port
    protocol         = var.ingress_protocol
    cidr_blocks      = var.ingress_ipv4_cidr_blocks
    ipv6_cidr_blocks = var.ingress_ipv6_cidr_blocks
    security_groups  = var.ingress_security_groups
  }

  egress {
    from_port        = var.egress_from_port
    to_port          = var.egress_to_port
    protocol         = var.egress_protocol
    cidr_blocks      = var.egress_ipv4_cidr_blocks
    ipv6_cidr_blocks = var.egress_ipv6_cidr_blocks
    security_groups  = var.egress_security_groups
  }
}

# resource "aws_security_group_rule" "ingress" {
#   type              = "ingress"
#   from_port         = var.port
#   to_port           = var.port
#   protocol          = "tcp"
#   cidr_blocks       = var.cidr_blocks
#   security_group_id = aws.security_group_id.default.id
# }

# resource "aws_security_group_rule" "egress" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws.security_group_id.default.id
# }