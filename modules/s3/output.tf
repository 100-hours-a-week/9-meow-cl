output "log_bucket_name" {
  description = "The name of the log bucket"
  value       = aws_s3_bucket.log_bucket.bucket
}

output "log_bucket_arn" {
  description = "The ARN of the log bucket"
  value       = aws_s3_bucket.log_bucket.arn
}

output "image_bucket_name" {
  description = "The name of the image bucket"
  value       = aws_s3_bucket.image_bucket.bucket
}

output "image_bucket_arn" {
  description = "The ARN of the image bucket"
  value       = aws_s3_bucket.image_bucket.arn
}

output "mysql_backup_bucket_name" {
  description = "The name of the MySQL backup bucket"
  value       = aws_s3_bucket.mysql_backup_bucket.bucket
}

output "mysql_backup_bucket_arn" {
  description = "The ARN of the MySQL backup bucket"
  value       = aws_s3_bucket.mysql_backup_bucket.arn
}