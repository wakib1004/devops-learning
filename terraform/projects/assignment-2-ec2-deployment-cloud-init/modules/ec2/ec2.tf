resource "aws_instance" "a2_ec2_instance" {
    ami = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = var.vpc_security_group_ids
    user_data = file(var.user_data)
}
