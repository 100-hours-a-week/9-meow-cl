output "instance_ids" {
  description = "IDs of the created EC2 instances"
  value       = aws_instance.this[*].id
}

output "public_ips" {
  description = "Public IP addresses of instances"
  value       = aws_instance.this[*].public_ip
}

output "private_ips" {
  description = "Private IP addresses of instances"
  value       = aws_instance.this[*].private_ip
}