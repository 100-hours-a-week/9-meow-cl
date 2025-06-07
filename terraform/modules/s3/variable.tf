variable "bucket_name" {
  type = string
}
variable "servicename" {
  description = "The name of the service"
  type        = string
}
variable "stage" {
  description = "The stage of the environment (e.g., dev, prod)"
  type        = string
}
variable "region" {
  type = string
}
variable "zone" {
  type = string
}
variable "tags" {
  description = "A map of tags to assign to the S3 buckets"
  type        = map(string)
}
variable "key_name" {
  type = string
}

