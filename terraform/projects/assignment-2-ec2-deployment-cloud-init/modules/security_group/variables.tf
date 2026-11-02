variable "security_group_description" {
  type = string
}

variable "security_group_name" {
  type = string
}

variable "security_group_tags" {
  type = map(string)
}

variable "ingress_cidr_ipv4" {
  type = string
}

variable "ingress_from_port" {
  type = number
}

variable "ingress_to_port" {
  type = number
}

variable "ingress_ip_protocol" {
  type = string
}

variable "egress_cidr_ipv4" {
  type = string
}

variable "egress_ip_protocol" {
  type = string
}
