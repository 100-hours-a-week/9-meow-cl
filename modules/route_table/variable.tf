variable "vpc_id" {
    description = "VPC ID for route tables"
    type = string
}
variable "name_prefix" {
    description = "Prefix for resource names"
    type = string
}
variable "public_subnet_ids" {
    description = "List of public subnet IDs to associate with IGW route table"
    type = list(string)
}
variable "private_subnet_ids" {
    description = "List of private subnet IDs to associate with NAT route table"
    type = list(string)
}
variable "igw_id" {
    description = "Internet Gateway ID for public route table"
    type = string
}
variable "nat_gateway_ids" {
    description = "NAT Gateway ID for private route table"
    type = string
    default = []
}
variable "tags" {
    description = "Common tags to apply to all route tables"
    type = map(string)
    default = {}
}