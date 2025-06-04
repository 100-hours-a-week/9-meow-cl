variable "stage" {
    description = "The stage of the openvpn"
    type        = string
    default     = "dev"
}

variable "service_name" {
    description = "The name of the service"
    type        = string
    default     = "meowng"
}

variable "vpc_id" {
    description = "The ID of the VPC"
    type        = string
}

variable "subnet_id" {
    description = "The ID of the subnet"
    type        = string
}

variable "ami_id" {
    description = "The ID of the AMI"
    type        = string
}

variable "instance_type" {
    description = "The type of the instance"
    type        = string
    default     = "t3.micro"
}

variable "openvpn_udp_port" {
    description = "The UDP port for OpenVPN"
    type        = number
    default     = 1194
}

variable "openvpn_tcp_port" {
    description = "The TCP port for OpenVPN"
    type        = number
    default     = 443
}

variable "key_name" {
  description = "name of the key pair for the instance"
  type        = string
  default     = "keypair-meowng-master"
}