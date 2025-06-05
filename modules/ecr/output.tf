output "repository_urls" {
    description = "Map of component -> ECR repository URL"
    value       = {
        for comp, repo in aws_ecr_repository.ecr_repository :
        comp => repo.repository_url
    }
}

output "repository_names" {
    description = "Map of component -> ECR repository name"
    value     = {
        for comp, repo in aws_ecr_repository.ecr_repository :
        comp => repo.name
    }
}

output "repository_arns" {
    description = "Map of component -> ECR repository ARN"
    value       = {
        for comp, repo in aws_ecr_repository.ecr_repository :
        comp => repo.arn
    }
}