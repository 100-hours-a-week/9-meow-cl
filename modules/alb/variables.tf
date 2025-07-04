 variable "region" { 
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-northeast-2" 
}

variable "stage" {
  description = "Deployment stage (e.g., dev, stage, prod)"
  type        = string
  default     = "stage"
}

variable "service_name" {
  description = "Name of the service being deployed"
  type        = string
  default     = "meowng"
}

variable "frontend_subnet_ids" {
  description = "Subnets for the frontend ALB"
  type        = list(string)
}

variable "backend_subnet_ids" {
  description = "Subnets for the backend ALB"
  type        = list(string)
}

variable "frontend_security_group_id" {
  description = "Security group for the frontend ALB"
  type        = string
}

variable "backend_security_group_id" {
  description = "Security group for the backend ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALBs and target groups"
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

variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string
  default = "alb-an2"
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listeners"
  type        = string
}
