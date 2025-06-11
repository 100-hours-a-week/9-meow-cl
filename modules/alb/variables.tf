variable "subnet_ids" {
  description = "Subnets for the ALB"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group for the ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB and target groups"
  type        = string
}

variable "frontend_port" {
  description = "Port for the frontend target group"
  type        = number
  default     = 3000
}

variable "backend_port" {
  description = "Port for the backend target group"
  type        = number
  default     = 8080
}

variable "ai_port" {
  description = "Port for the AI target group"
  type        = number
  default     = 8000
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "common_tags" {
  description = "Common tags for resources"
  type        = map(string)
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
  type        = string
}