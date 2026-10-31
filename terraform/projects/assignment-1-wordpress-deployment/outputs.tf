output "instance_id" {
  description = "The ID of the EC2 instance"
  value = aws_instance.wordpress_instance.id
}

output "instance_public_IPv4_address" {
  description = "The public IPv4 address of the EC2 instance"
  value = aws_instance.wordpress_instance.public_ip
}

output "instance_public_DNS" {
  description = "The public DNS of the EC2 instance"
  value = aws_instance.wordpress_instance.public_dns
}
