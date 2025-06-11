variable "vpc_id" {
    description = "VPC ID where the subnets will be created"
    type        = string
    default     = ""
}

variable "name_prefix" {
    description = "Prefix for resource names"
    type        = string
}

variable "azs" {
    description = "List of Availability Zones to create subnets in"
    type        = list(string)
}

variable "public_subnet_cidrs" {
    description = "List of CIDRs for public subnets"
    type        = list(string)
}

variable "app_subnet_cidrs" {
    description = "List of CIDRs for application subnets"
    type        = list(string)
}

variable "db_subnet_cidrs" {
    description = "List of CIDRs for database subnets"
    type        = list(string)
}

variable "map_public_ip_on_launch" {
    description = "Whether to map public IPs on launch for public subnets"
    type        = bool
    default     = false
}

variable "tags" {
    description = "Common tags to apply to all subnets"
    type        = map(string)
    default = {}
}
