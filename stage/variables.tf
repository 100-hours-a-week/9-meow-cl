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

variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16" 
}

variable "azs" {
    description = "List of availability zones for the deployment"
    type        = list(string)
    default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "app_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "db_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.21.0./24", "10.0.22.0/24"]
}

variable "map_public_ip_on_launch" {
  description = "Whether to map public IPs on launch for public subnets"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all subnets"
  type        = map(string)
  default     = {
    Stage = "stage"
  }
}
#### OPENVPN ####
variable "key_name" {
  description = "Name of the key pair for the OpenVPN instance"
  type        = string
  default = "keypair-meowng-master"
}

##### PORT_NUMBERS #####
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

#########EKS#########
variable "sg_eks_cluster_ingress_list" {
  description = "List of security group IDs for EKS cluster ingress"
  type        = list(string)
  default    =  ["10.0.0.0/24"]
}

variable "sg_allow_comm_ing" {
  description = "List of security group IDs to allow communication between EKS nodes"
  type        = list(string)
  default     = []
}

variable "service_ipv4_cidr" {
  type    = string
  default = "172.16.0.0/12"
}

variable "desired_size" {
  description = "Desired number of worker nodes in the EKS cluster"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of worker nodes in the EKS cluster"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of worker nodes in the EKS cluster"
  type        = number
  default     = 1
}

variable "max_unavailable" {
  description = "Maximum number of unavailable worker nodes during updates"
  type        = number
  default     = 1
}

variable "ami_type" {
  description = "AMI type for the EKS worker nodes"
  type        = string
  default     = "AL2_x86_64"
}

