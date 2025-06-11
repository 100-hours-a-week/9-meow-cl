output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}
output "app_subnet_ids" {
  description = "List of application subnet IDs"
  value       = aws_subnet.app[*].id
}
output "db_subnet_ids" {
  description = "List of database subnet IDs"
  value       = aws_subnet.db[*].id
}

