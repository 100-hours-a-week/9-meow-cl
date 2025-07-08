###Comm###
variable "region" {
  type = string
  default = "ap-northeast-2"
}
variable "stage"{
  type = string
  default = "stage"
}
variable "service_name"{
  type = string
  default = "meowng"
}
variable "tags" {
  type =map(string)
}

###Network###
variable "subnet_ids" {
  type = list(any)
}
variable "sg_eks_cluster_ingress_list" {
  type = list(any)
}
variable "vpc_id" {
  type = string
}
# virtual private IP address range for EKS cluster
variable "service_ipv4_cidr" {
  type    = string
  default = "172.16.0.0/12"
}

###EKS###
variable "desired_size" {
  type = number
  default  = 2
}
variable "max_size" {
  type = number
  default = 2
}
variable "min_size"{
  type = number
  default = 1
}
variable "max_unavailable" {
  type = number
  default = 1
}
variable "ami_type" {
  type = string
  default = "AL2_x86_64" #AL2_ARM_64
}
variable "ami_is_eks_optimized"{
  type = bool
  default = true
}
variable "capacity_type" {
  type = string
  default = "ON_DEMAND"
}
variable "disk_size"{
  type = number
  default = 20
}
variable "force_update_version" {
  type = bool
  default = true
}
variable "instance_types" {
  type = list(string)
  default  = ["t3.xlarge"]
}
variable "labels" {
  type = map(string)
  default = {}
}

########prod 환경일 경우 암호화 필요########
# variable "disk_kms_key_id"{
#   type = string
# }
# variable "s3_kms_key_id"{
#   type = string
# }
# variable "rds_data_kms_arn"{
#   type = string
# }
# variable "sqs_kms_arn"{
#   type = string
# }

# variable "smoke_test_repository_arn"{
#   type = string
# }
#########################################


###NodeGroup###

#variable "namespace" {
#  type = list(any)
#}
#variable "security_account" {
#  type = string
#}
#variable "cargo_secret_name" {
#  type = string
#}
#variable "kld_secret_name" {
#  type = string
#}
#variable "kms_secret_key" {
#  type = string
#}
#
variable "sg_allow_comm_ing" {
  type = list
}
