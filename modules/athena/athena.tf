locals {
    common_tags = {
        Stage = var.stage
        ServiceName = var.service_name
    }

    full_result_location = (
        var.s3_results_prefix == "" 
        ? "s3://${var.s3_results_bucket}"
        : "s3://${var.s3_results_bucket}/${trim(var.s3_results_prefix, "/")}"
    )
}

# 1) create Athena database (regist to Glue Catalog)
resource "aws_athena_database" "main" {
    name = var.database_name
    bucket = var.s3_results_bucket
    force_destroy = true
}

# 2) create Athena workgroup
resource "aws_athena_workgroup" "main" {
    name = var.workgroup_name
    force_destroy = true

    configuration {
        result_configuration {
            output_location = local.full_result_location

            # setting KMS key for encryption
            encryption_configuration {
                encryption_option = var.encryption_option == "SSE_S3" ? "SSE_S3" : (
                    var.encryption_option == "SSE_KMS" ? "SSE_KMS" : (
                    var.encryption_option == "CSE_KMS" ? "CSE_KMS" : "UNENCRYPTED"
                ))
                kms_key_arn = contains(["SSE_KMS", "CSE_KMS"], var.encryption_option) ? var.kms_key_arn : null
            }
        }
        enforce_workgroup_configuration = true
    }

    tags = local.common_tags
}