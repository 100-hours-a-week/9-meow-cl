variable "stage" {
    description = "deployment stage (e.g. dev, release, prod)"
    type        = string
}

variable "service_name" {
    description = "name of the service"
    type        = string
    default     = "meowng"
}

variable "s3_results_bucket" {
    description = "name of the S3 bucket to store Athena query results"
    type        = string
}

variable "s3_results_prefix" {
    description = "path to s3 bucket to store Athena query results (e.g. athena/results)"
    type        = string
    default     = ""
}

variable "database_name" {
    description = "name of the database to create"
    type        = string
    default     = "athena_db_meowng"
}

variable "workgroup_name" {
    description = "name of the workgroup to create"
    type        = string
}

variable "encryption_option" {
    description = "encryption option for query results"
    type        = string
    default     = "SSE_S3"
}

variable "kms_key_arn" {
    description = "ARN of the KMS key to use for encryption"
    type        = string
    default     = ""
}

