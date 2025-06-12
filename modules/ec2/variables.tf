variable "name_prefix" {
  description = "Prefix for resource names (e.g. \"prod-app\")"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type (e.g. t3.micro)"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where to launch the instance"
  type        = string
}

variable "key_name" {
  description = "Key Pair name for SSH access"
  type        = string
  default     = ""
}

variable "security_group_ids" {
  description = "List of security group IDs to assign to the instance"
  type        = list(string)
  default     = []
}

variable "associate_public_ip" {
  description = "Whether to assign a public IP (for public subnets)"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "User data script to configure the instance"
  type        = string
  default     = ""
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Additional tags to apply to the instance(s)"
  type        = map(string)
  default     = {}
}