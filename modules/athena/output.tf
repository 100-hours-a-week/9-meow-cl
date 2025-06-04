output "database_arn" {
    description = "ARN of the created Athena(Glue) database"
    value = aws_athena_database.main.arn
}

output "workgroup_arn" {
    description = "ARN of the created Athena workgroup"
    value = aws_athena_workgroup.main.arn
}

output "query_result_location" {
    description = "S3 location for query results"
    value = local.full_result_location
}