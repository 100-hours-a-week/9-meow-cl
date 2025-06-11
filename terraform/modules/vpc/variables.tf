variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  # default     = ["10.0.1.0/24"]
}

variable "app_subnet_cidrs" {
  description = "List of CIDR blocks for application subnets"
  type        = list(string)
  # default     = ["10.0.2.0/24"]
}

variable "db_subnet_cidrs" {
  description = "List of CIDR blocks for database subnets"
  type        = list(string)
  # default     = ["10.0.3.0/24"]
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  # default     = ["asia-northeast-2"]
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
}

variable "nat_gateway_enabled" {
  description = "Enable NAT Gateway for private routing"
  type        = bool
}