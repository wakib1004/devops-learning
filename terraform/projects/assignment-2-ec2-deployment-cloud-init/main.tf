module "security_group" {
  source = "./modules/security_group"

  security_group_name = "a2-ec2-sg"
  security_group_description = "Allow inbound HTTP and all outbound traffic"
  security_group_tags = {
    Name = "a2-ec2-sg"
  }

  ingress_cidr_ipv4 = "0.0.0.0/0"
  ingress_from_port = 80
  ingress_to_port = 80
  ingress_ip_protocol = "tcp"

  egress_cidr_ipv4 = "0.0.0.0/0"
  egress_ip_protocol = "-1" # semantically equivalent to all ports
}
