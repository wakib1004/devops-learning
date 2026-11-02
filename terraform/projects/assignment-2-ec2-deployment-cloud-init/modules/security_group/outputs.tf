output "a2_ec2_security_group_id" {
  description = "The ID of the security group"
  value = aws_security_group.a2_ec2_instance_sg.id
}
