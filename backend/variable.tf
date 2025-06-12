variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "stage" {
  description = "Deployment stage (e.g. dev, prod)"
  type        = string
}

variable "name_prefix" {
  description = "Name prefix for all resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of AZs to operate in, in order (e.g. [\"ap-northeast-2a\",\"ap-northeast-2c\"])"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (same order as azs)"
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks for app (private) subnets (same order as azs)"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for db (private) subnets (same order as azs)"
  type        = list(string)
}

variable "tags" {
  description = "Common tags to apply"
  type        = map(string)
  default     = {}
}
