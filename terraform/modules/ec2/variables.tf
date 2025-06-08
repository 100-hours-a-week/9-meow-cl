variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "stage" {
  type = string
}

variable "servicename" {
  type = string
}

variable "tags" {
  description = "Tags for EC2 instances"
  type        = map(string)
}

variable "instance_config" {
  description = "Configuration for each EC2 instance"
  type = map(object({
    ami           = string
    instance_type = string
  }))
  # default = {
  #   0 = { ami = "ami-12345678", instance_type = "t3.micro" }  # OpenVPN
  #   1 = { ami = "ami-23456789", instance_type = "t3.small" }  # Grafana
  #   2 = { ami = "ami-34567890", instance_type = "t3.medium" } # Frontend
  #   3 = { ami = "ami-45678901", instance_type = "t3.medium" }  # Backend
  #   4 = { ami = "ami-56789012", instance_type = "t3.medium" } # Database
  # }
}

variable "subnet_mapping" {
  description = "Mapping of EC2 instances to subnets"
  type        = map(string)
  default = {
    0 = aws_subnet.public[0].id # OpenVPN
    1 = aws_subnet.public[0].id # Grafana
    2 = aws_subnet.app[0].id    # Frontend
    3 = aws_subnet.app[0].id    # Backend
    4 = aws_subnet.db[0].id     # Database
  }
}

variable "public_ip_mapping" {
  description = "Mapping of EC2 instances to public IP association"
  type        = map(bool)
  default = {
    0 = true  # OpenVPN
    1 = true  # Grafana
    2 = false # Frontend
    3 = false # Backend
    4 = false # Database
  }
}

variable "user_data_mapping" {
  description = "Mapping of EC2 instances to user data scripts"
  type        = map(string)
  default = {
    0 = "openvpn-user-data.sh"
    1 = "grafana-user-data.sh"
    2 = "frontend-user-data.sh"
    3 = "backend-user-data.sh"
    4 = "db-user-data.sh"
  }
}

variable "instance_names" {
  description = "Names for EC2 instances"
  type        = map(string)
  default = {
    0 = "openvpn"
    1 = "grafana"
    2 = "frontend"
    3 = "backend"
    4 = "database"
  }
}

variable "ec2_iam_role_profile_name" {
  description = "IAM role profile name for EC2 instances"
  type        = string
}

variable "sg_ec2_ids" {
  description = "Security group IDs for EC2 instances"
  type        = list(string)
}

variable "key_name" {
  description = "Key pair name for EC2 instances"
  type        = string
}

variable "userdata" {
  type = string
}

variable "userdata_vars" {
  type = map(any)
}

variable "subnet_id" {
  type = string
}

variable "ebs_volume" {
  type = string
}