variable "stage" {
    description = "deployment stage (e.g., dev, release, prod)"
    type        = string
    default     = "dev"
}
variable "service_name" {
    description = "name of the service"
    type        = string
    default     = "meowng"
}
variable "vpc_id" {
    description = "VPC ID where the NAT Gateway will be deployed"
    type        = string
}
variable "subnet_id" {
    description = ""
    type        = string
}
# when allocated_eip is true, a new Elastic IP address will be allocated for the NAT Gateway
# when allocated_eip is false, the NAT Gateway will use an existing Elastic IP address
variable "allocate_eip" {
    description = "whether to allocate a new Elastic IP address for the NAT Gateway"
    type        = bool
    default     = true
}
# when allocated_eip is false, this variable should be set to the ID of the existing Elastic IP address
variable "allocated_eip_id" {
    description = "ID of the Elastic IP address to associate with the NAT Gateway (when allocated_eip is false)"
    type        = string
    default     = ""
}