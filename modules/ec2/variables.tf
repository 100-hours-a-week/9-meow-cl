variable "name_prefix" {
  description = "Base prefix for resource names"
  type        = string
}

variable "app_type" {
  description = "Application type (e.g. frontend, backend, db, openvpn)"
  type        = string
}

variable "stage" {
  description = "Deployment stage (e.g. dev, prod)"
  type        = string
}

variable "service_name" {
  description = "Service or project name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type (e.g. t3.micro, c5.xlarge)"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name to use for the instance"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Subnet ID where to launch the instance"
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone for the instance"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to attach"
  type        = list(string)
  default     = []
}

variable "associate_public_ip" {
  description = "Whether to assign a public IP address"
  type        = bool
  default     = false
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile name or ARN to attach"
  type        = string
  default     = ""
}

variable "credit_specification" {
  description = "CPU credit mode for T2/T3 instances"
  type = object({
    cpu_credits = string
  })
  default = null
}

variable "root_block_device" {
  description = "Configuration for the root block device"
  type = object({
    delete_on_termination = bool
    encrypted             = bool
    volume_size           = number
    volume_type           = string
    kms_key_id            = optional(string)
  })
  default = {
    delete_on_termination = true
    encrypted             = false
    volume_size           = 8
    volume_type           = "gp3"
    kms_key_id            = null
  }
}

variable "ebs_block_devices" {
  description = "Additional EBS block devices configurations"
  type = list(object({
    device_name           = string
    delete_on_termination = bool
    encrypted             = bool
    volume_size           = number
    volume_type           = string
    kms_key_id            = optional(string)
  }))
  default = []
}

variable "user_data_template" {
  description = "Path to userdata script template (without .tpl)"
  type        = string
  default     = ""
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Additional tags to apply"
  type        = map(string)
  default     = {}
}