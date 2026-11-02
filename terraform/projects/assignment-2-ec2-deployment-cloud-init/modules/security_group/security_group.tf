resource "aws_security_group" "a2_ec2_instance_sg" {
  name        = var.security_group_name
  description = var.security_group_description
  tags = var.security_group_tags
}

resource "aws_vpc_security_group_ingress_rule" "sg_ingress_rule" {
  security_group_id = aws_security_group.a2_ec2_instance_sg.id
  cidr_ipv4         = var.ingress_cidr_ipv4
  from_port         = var.ingress_from_port
  ip_protocol       = var.ingress_ip_protocol
  to_port           = var.ingress_to_port
}

resource "aws_vpc_security_group_egress_rule" "sg_egress_rule" {
  security_group_id = aws_security_group.a2_ec2_instance_sg.id
  cidr_ipv4         = var.egress_cidr_ipv4
  ip_protocol       = var.egress_ip_protocol 
}
