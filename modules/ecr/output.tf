output "repository_url" {
    description = "The URL of the ECR repository"
    value       = aws_ecr_repository.ecr_repository.repository_url
}

output "repository_arn" {
    description = "The ARN of the ECR repository"
    value       = aws_ecr_repository.ecr_repository.arn
}

output "repository_name" {
    description = "The name of the ECR repository"
    value       = aws_ecr_repository.ecr_repository.name
}